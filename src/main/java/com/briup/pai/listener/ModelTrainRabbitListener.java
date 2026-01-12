package com.briup.pai.listener;

import cn.hutool.core.util.ObjectUtil;
import com.alibaba.fastjson2.JSON;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.TrainingStatusEnum;
import com.briup.pai.convert.TrainingLabelConvert;
import com.briup.pai.entity.message.ModelTrainResultMessage;
import com.briup.pai.entity.po.Model;
import com.briup.pai.entity.po.Training;
import com.briup.pai.entity.po.TrainingLabel;
import com.briup.pai.service.IModelService;
import com.briup.pai.service.ITrainingLabelService;
import com.briup.pai.service.ITrainingService;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
@CacheConfig(cacheNames = ModelConstant.MODEL_CACHE_PREFIX)
public class ModelTrainRabbitListener {

    @Autowired
    private IModelService modelService;
    @Autowired
    private ITrainingLabelService trainingLabelService;
    @Autowired
    private ITrainingService trainingService;

    @Autowired
    private TrainingLabelConvert trainingLabelConvert;

    /**
     * 监听初始化模型训练结果消息
     * 接收来自MQ的消息，解析后调用处理方法
     * @param message 来自MQ的消息字符串
     */
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "${mq.init.result-queue}"),
            exchange = @Exchange(name = "${mq.init.exchange}"),
            key = "${mq.init.result-routing-key}"
    ))
    public void receiveInitTrainMessage(String message) {
        // 将JSON消息解析为ModelTrainResultMessage对象
        ModelTrainResultMessage modelTrainResultMessage = JSON.parseObject(message, ModelTrainResultMessage.class);
        ModelTrainRabbitListener self = (ModelTrainRabbitListener) AopContext.currentProxy();
        self.processTrainingResult(modelTrainResultMessage);
    }

    /**
     * 监听模型优化训练结果消息
     * 接收来自MQ的消息，解析后调用处理方法
     * @param message 来自MQ的消息字符串
     */
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "${mq.optimize.result-queue}"),
            exchange = @Exchange(name = "${mq.optimize.exchange}"),
            key = "${mq.optimize.result-routing-key}"
    ))
    public void receiveIOptimizeTrainMessage(String message) {
        // 将JSON消息解析为ModelTrainResultMessage对象
        ModelTrainResultMessage modelTrainResultMessage = JSON.parseObject(message, ModelTrainResultMessage.class);
        ModelTrainRabbitListener self = (ModelTrainRabbitListener) AopContext.currentProxy();
        self.processTrainingResult(modelTrainResultMessage);
    }

    /**
     * 处理模型训练结果消息
     * 根据训练是否成功更新模型和训练记录的状态及相关信息
     * @param resultMessage 模型训练结果消息对象，包含训练ID、模型ID、准确率、模型文件地址、标签结果等信息
     */
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#resultMessage.modelId")
    public void processTrainingResult(ModelTrainResultMessage resultMessage) {
        Model model = modelService.getById(resultMessage.getModelId());
        // 如果训练失败（isSuccess为1表示失败），仅更新模型的训练状态为ERROR
        if (ObjectUtil.equal(resultMessage.getIsSuccess(), 1)) {
            model.setTrainingStatus(TrainingStatusEnum.ERROR.getStatus());
            modelService.updateById(model);
            return;
        }
        // 训练成功的情况，进行以下操作：
        // 1. 保存训练标签结果到数据库
        List<TrainingLabel> trainingLabels = resultMessage.getLabelResults().stream()
            .map(labelResultMessage -> {
                TrainingLabel trainingLabel = trainingLabelConvert.labelResultMessage2Po(labelResultMessage);
                trainingLabel.setTrainingId(resultMessage.getTrainingId());
                return trainingLabel;
            }).toList();
        trainingLabelService.saveBatch(trainingLabels);
        
        // 2. 更新训练记录的准确率和模型文件地址
        Training training = trainingService.getById(resultMessage.getTrainingId());
        training.setAccuracyRate(resultMessage.getAccuracyRate());
        training.setModelFileAddr(resultMessage.getModelFileAddr());
        trainingService.updateById(training);
        
        // 3. 更新模型的相关信息：版本号递增、准确率更新、训练状态设为完成
        model.setLastModelVersion(model.getLastModelVersion() + 1);
        model.setAccuracyRate(resultMessage.getAccuracyRate());
        model.setTrainingStatus(TrainingStatusEnum.DONE.getStatus());
        modelService.updateById(model);
    }
}
