package com.briup.pai.listener;

import cn.hutool.core.util.ObjectUtil;
import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.ModelStatusEnum;
import com.briup.pai.convert.ReleaseConvert;
import com.briup.pai.entity.message.ModelReleaseResultMessage;
import com.briup.pai.entity.po.Model;
import com.briup.pai.entity.po.Release;
import com.briup.pai.service.IModelService;
import com.briup.pai.service.IReleaseService;
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

import java.util.Date;

@Component
@CacheConfig(cacheNames = ModelConstant.MODEL_CACHE_PREFIX)
public class ModelReleaseRabbitListener {

    @Autowired
    private IReleaseService releaseService;
    @Autowired
    private IModelService modelService;

    @Autowired
    private ReleaseConvert releaseConvert;

    /**
     * 接收发布结果消息
     * 从RabbitMQ队列接收模型发布结果消息，并委托给processReleaseResult方法进行处理
     * @param message 消息体，包含模型发布结果信息
     */
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "${mq.release.result-queue}"),
            exchange = @Exchange(
                    name = "${mq.release.exchange}"),
            key = "${mq.release.result-routing-key}")
    )
    public void receiveReleaseMessage(String message) {
        // 将JSON字符串转换为ModelReleaseResultMessage对象
        ModelReleaseResultMessage modelEvaluateResultMessage = JSON.parseObject(message, ModelReleaseResultMessage.class);
        // 获取当前代理对象以确保事务正常执行
        ModelReleaseRabbitListener listener= (ModelReleaseRabbitListener) AopContext.currentProxy();
        listener.processReleaseResult(modelEvaluateResultMessage);
    }
    
    /**
     * 处理模型发布结果
     * 根据模型发布状态，决定是保存发布记录还是删除发布记录，同时更新模型状态
     * @param resultMessage 包含模型发布结果的消息对象
     */
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#resultMessage.modelId")
    public void processReleaseResult(ModelReleaseResultMessage resultMessage) {
        // 判断结果中的状态是否为已发布(Published)
        if(ObjectUtil.equal(resultMessage.getModelStatus(), ModelStatusEnum.Published.getStatus())){
            // 如果是已发布状态，则保存或更新发布记录
            Release release = releaseConvert.modelReleaseResultMessage2Po(resultMessage);
            release.setCreateTime(new Date());
            releaseService.saveOrUpdate(release);
        }else {
            // 如果不是已发布状态，则删除对应的发布记录
            LambdaQueryWrapper<Release> lqw = new LambdaQueryWrapper<>();
            lqw.eq(Release::getModelId, resultMessage.getModelId());
            releaseService.remove(lqw);
        }
        // 更新模型表中的状态
        Model model = modelService.getById(resultMessage.getModelId());
        model.setModelStatus(resultMessage.getModelStatus());
        modelService.updateById(model);
    }
}