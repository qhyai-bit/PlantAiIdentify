package com.briup.pai.listener;

import com.alibaba.fastjson2.JSON;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.TrainingStatusEnum;
import com.briup.pai.convert.EvaluateErrorConvert;
import com.briup.pai.convert.EvaluateLabelConvert;
import com.briup.pai.entity.message.ModelEvaluateResultMessage;
import com.briup.pai.entity.po.Evaluate;
import com.briup.pai.entity.po.EvaluateError;
import com.briup.pai.entity.po.EvaluateLabel;
import com.briup.pai.entity.po.Model;
import com.briup.pai.service.IEvaluateErrorService;
import com.briup.pai.service.IEvaluateLabelService;
import com.briup.pai.service.IEvaluateService;
import com.briup.pai.service.IModelService;
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
public class ModelEvaluateRabbitListener {
    @Autowired
    private IEvaluateService evaluateService;
    @Autowired
    private IEvaluateLabelService evaluateLabelService;
    @Autowired
    private IEvaluateErrorService evaluateErrorService;
    @Autowired
    private IModelService modelService;

    @Autowired
    private EvaluateLabelConvert evaluateLabelConvert;
    @Autowired
    private EvaluateErrorConvert evaluateErrorConvert;

    /**
     * 监听模型评估结果消息队列，接收评估结果消息
     * 使用 RabbitMQ 队列绑定配置，从指定的交换机和路由键获取消息
     * @param message 接收到的消息字符串，包含模型评估结果信息
     */
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "${mq.evaluate.result-queue}"),
            exchange = @Exchange(name = "${mq.evaluate.exchange}"),
            key = "${mq.evaluate.result-routing-key}"
    ))
    public void receiveEvaluateMessage(String message) {
        // 将JSON消息解析为ModelEvaluateResultMessage对象
        ModelEvaluateResultMessage modelEvaluateResultMessage = JSON.parseObject(message, ModelEvaluateResultMessage.class);
        // 获取当前代理对象，以便调用带事务注解的方法
        ModelEvaluateRabbitListener listener = (ModelEvaluateRabbitListener) AopContext.currentProxy();
        // 调用处理评估结果的方法
        listener.processEvaluateResult(modelEvaluateResultMessage);
    }

    /**
     * 处理模型评估结果
     * 该方法执行数据库更新操作，包括：
     * 1. 更新评估记录的准确率
     * 2. 保存评估标签结果
     * 3. 保存评估错误记录
     * 4. 更新模型状态为完成
     * 
     * @param resultMessage 模型评估结果消息对象
     */
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#resultMessage.modelId")
    public void processEvaluateResult(ModelEvaluateResultMessage resultMessage) {
        // 获取评估ID和模型ID
        Integer evaluateId = resultMessage.getEvaluateId();
        Integer modelId = resultMessage.getModelId();
        
        // 更新评估记录中的准确率
        Evaluate evaluate = evaluateService.getById(evaluateId);
        evaluate.setAccuracyRate(resultMessage.getAccuracyRate());
        evaluateService.updateById(evaluate);
        
        // 批量保存评估标签结果
        List<EvaluateLabel> evaluateLabelList = resultMessage.getLabelResults().stream()
                .map(labelResultMessage -> {
                    EvaluateLabel evaluateLabel = evaluateLabelConvert.labelResultMessage2Po(labelResultMessage);
                    evaluateLabel.setEvaluateId(evaluateId);
                    return evaluateLabel;
                }).toList();
        evaluateLabelService.saveBatch(evaluateLabelList);
        
        // 批量保存评估错误记录
        List<EvaluateError> evaluateErrorList = resultMessage.getEvaluateErrors().stream()
                .map(evaluateErrorMessage -> {
                    EvaluateError evaluateError = evaluateErrorConvert.evaluateErrorMessage2Po(evaluateErrorMessage);
                    evaluateError.setEvaluateId(evaluateId);
                    return evaluateError;
                })
                .toList();
        evaluateErrorService.saveBatch(evaluateErrorList);
        
        // 更新模型状态为已完成
        Model model = modelService.getById(modelId);
        model.setTrainingStatus(TrainingStatusEnum.DONE.getStatus());
        modelService.updateById(model);
    }
}