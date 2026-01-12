package com.briup.pai.service.impl;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.TrainingStatusEnum;
import com.briup.pai.entity.po.Model;
import com.briup.pai.entity.po.Training;
import com.briup.pai.entity.vo.IndexVO;
import com.briup.pai.entity.vo.ModelChartVO;
import com.briup.pai.entity.vo.ModelCountVO;
import com.briup.pai.service.IIndexService;
import com.briup.pai.service.IModelService;
import com.briup.pai.service.ITrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class IndexServiceImpl implements IIndexService {

    @Autowired
    private IModelService modelService;
    @Autowired
    private ITrainingService trainingService;

    @Override
    public IndexVO getModelChartData() {
        IndexVO indexVO = new IndexVO();
        // 构建模型统计信息 - 包括总数和其他状态的数量
        // 封装模型数量VO
        List<ModelCountVO> modelCountVOS = new ArrayList<>();
        // 添加模型总数统计
        ModelCountVO modelCountVO = new ModelCountVO(ModelConstant.MODEL_TOTAL_COUNT_INDEX, modelService.count());
        modelCountVOS.add(modelCountVO);
        // 封装未训练、训练中、优化中、评估中、训练完成的模型数量
        modelCountVOS.addAll(
                Arrays.stream(TrainingStatusEnum.values())
                        .filter(trainingStatusEnum ->
                                ObjectUtil.notEqual(trainingStatusEnum.getStatus(),
                                        TrainingStatusEnum.ERROR.getStatus()))
                        .map(trainingStatusEnum -> new
                                ModelCountVO(trainingStatusEnum.getStatus(), getModelCount(trainingStatusEnum.getStatus())))
                        .toList());
        indexVO.setModelCounts(modelCountVOS);
        // 封装本周训练数据
        List<ModelChartVO> modelChartVOS = getThisWeekDates()
                .stream()
                .map(this::getEverydayModelTrainingData)
                .toList();
        indexVO.setModelCharts(modelChartVOS);
        return indexVO;
    }

    /**
     * 获取每个训练状态的模型数量
     * @param trainingStatus 训练状态
     * @return 指定训练状态的模型数量
     */
    private long getModelCount(Integer trainingStatus) {
        LambdaQueryWrapper<Model> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Model::getTrainingStatus, trainingStatus);
        return modelService.count(queryWrapper);
    }

    /**
     * 获取每天模型训练情况
     * @param date 日期
     * @return 模型训练情况
     */
    private ModelChartVO getEverydayModelTrainingData(Date date) {
        ModelChartVO modelChartVO = new ModelChartVO();
        
        // 查询当天初始化训练数量（版本号为1的训练记录）
        LambdaQueryWrapper<Training> trainingWrapper = new LambdaQueryWrapper<>();
        trainingWrapper
                .eq(Training::getModelVersion, 1)
                .between(Training::getCreateTime, DateUtil.beginOfDay(date),
                        DateUtil.endOfDay(date));
        long initCount = trainingService.count(trainingWrapper);
        modelChartVO.setInitCount(initCount);
        
        // 查询当天优化训练数量（版本号非1的训练记录）
        trainingWrapper.clear();
        trainingWrapper
                .ne(Training::getModelVersion, 1)
                .between(Training::getCreateTime, DateUtil.beginOfDay(date),
                        DateUtil.endOfDay(date));
        long optimizeCount = trainingService.count(trainingWrapper);
        modelChartVO.setOptimizeCount(optimizeCount);
        return modelChartVO;
    }

    /**
     * 获取本周的日期列表
     * @return 本周的日期列表
     */
    public List<Date> getThisWeekDates() {
        // 获取当前日期
        Date now = new Date();
        // 获取本周周一的日期
        Date monday = DateUtil.beginOfWeek(now, true);
        List<Date> weekDates = new ArrayList<>();
        
        // 循环生成本周七天的日期
        for (int i = 0; i < 7; i++) {
            // 依次获取本周每一天的日期
            Date currentDate = DateUtil.offsetDay(monday, i);
            weekDates.add(currentDate);
        }
        return weekDates;
    }
}