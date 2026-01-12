package com.briup.pai.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.ModelStatusEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.TrainingStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.convert.EvaluateLabelConvert;
import com.briup.pai.convert.ModelConvert;
import com.briup.pai.convert.TrainingLabelConvert;
import com.briup.pai.dao.ModelMapper;
import com.briup.pai.entity.dto.ModelSaveDTO;
import com.briup.pai.entity.po.*;
import com.briup.pai.entity.vo.*;
import com.briup.pai.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.*;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@CacheConfig(cacheNames = ModelConstant.MODEL_CACHE_PREFIX)
public class ModelServiceImpl extends ServiceImpl<ModelMapper, Model> implements IModelService {

    @Autowired
    private ModelConvert modelConvert;
    @Autowired
    private TrainingLabelConvert trainingLabelConvert;
    @Autowired
    private EvaluateLabelConvert evaluateLabelConvert;

    @Autowired
    private ITrainingService trainingService;
    @Autowired
    private ITrainingDatasetService trainingDatasetService;
    @Autowired
    @Lazy
    private IDatasetService datasetService;
    @Autowired
    private ITrainingLabelService trainingLabelService;
    @Autowired
    private IEvaluateService evaluateService;
    @Autowired
    private IEvaluateLabelService evaluateLabelService;
    @Autowired
    private IEvaluateErrorService evaluateErrorService;

    @Override
    public PageVO<ModelPageVO> getModelByPageAndCondition(Integer pageNum, Integer modelType) {
        // 创建分页结果对象，用于封装分页查询结果
        PageVO<ModelPageVO> pageResult = new PageVO<>();
        // 创建分页查询对象，指定当前页码和每页大小（从常量中获取）
        Page<Model> page = new Page<>(pageNum, ModelConstant.MODEL_PAGE_SIZE);
        // 构建Lambda查询条件包装器
        LambdaQueryWrapper<Model> lqw = new LambdaQueryWrapper<>();
        // 如果modelType不为空，则按模型类型进行等值查询；按创建时间降序排列
        lqw.eq(ObjectUtil.isNotNull(modelType), Model::getModelType, modelType)
           .orderByDesc(Model::getCreateTime);
        // 执行分页查询操作
        Page<Model> modelPage = this.page(page, lqw);
        // 设置总记录数到结果对象
        pageResult.setTotal(modelPage.getTotal());
        // 将查询结果的记录列表转换为ModelPageVO列表并设置到结果对象
        pageResult.setData(modelConvert.po2ModelPageVOList(modelPage.getRecords()));
        return pageResult;
    }

    @Override
    @Cacheable(key = "#modelId")
    public ModelEchoVO getModelById(Integer modelId) {
        // 根据模型ID查询模型信息，如果不存在则抛出异常
        Model model = BriupAssert.requireNotNull(
                this,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 将查询到的模型实体转换为回显视图对象
        return modelConvert.po2ModelEchoVO(model);
    }

    @Override
    @Transactional
    @CachePut(key = "#result.getModelId()")
    public ModelEchoVO addAndModifyModel(ModelSaveDTO modelSaveDTO) {
        Integer modelId = modelSaveDTO.getModelId();
        Model model;
        if (ObjectUtil.isNull(modelId)){
            // 新增模型 - 验证模型名称不能重复
            BriupAssert.requireNull(
                    this,
                    Model::getModelName,
                    modelSaveDTO.getModelName(),
                    ResultCodeEnum.DATA_ALREADY_EXIST);
            model = modelConvert.modelSaveDTO2Po(modelSaveDTO);
            // 设置模型初始信息
            model.setAccuracyRate(0.0); // 初始化模型准确率为0
            model.setCreateBy(SecurityUtil.getUserId()); // 设置创建人ID
            model.setLastModelVersion(0); // 初始化模型版本为0
            model.setModelStatus(ModelStatusEnum.Unpublished.getStatus()); // 设置模型状态为未发布
            model.setTrainingStatus(TrainingStatusEnum.NO_TRAINING.getStatus()); // 设置训练状态为未训练
            this.save(model);
        } else {
            // 修改模型 - 验证模型名称不能重复且模型类型不能修改
            Model temp = BriupAssert.requireNotNull(
                    this,
                    Model::getId,
                    modelId,
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            BriupAssert.requireNull(
                    this,
                    Model::getModelName,
                    modelSaveDTO.getModelName(),
                    ResultCodeEnum.DATA_ALREADY_EXIST);
            // 验证模型类型未被修改
            BriupAssert.requireEqual(
                    temp.getModelType(),
                    modelSaveDTO.getModelType(),
                    ResultCodeEnum.PARAM_IS_ERROR);
            model = modelConvert.modelSaveDTO2Po(modelSaveDTO);
            this.updateById(model);
        }
        return modelConvert.po2ModelEchoVO(model);
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(key = "#modelId"),
            @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#modelId")
    })
    public void removeModelById(Integer modelId) {
        // 根据ID查询模型，如果不存在则抛出异常
        Model model = BriupAssert.requireNotNull(
                this,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 只有未训练的模型才能被删除
        BriupAssert.requireEqual(
                model.getTrainingStatus(),
                TrainingStatusEnum.NO_TRAINING.getStatus(),
                ResultCodeEnum.DATA_CAN_NOT_DELETE
        );
        // 执行删除操作
        this.removeById(modelId);
    }

    @Override
    @Transactional
    @Cacheable(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#modelId")
    public ModelDetailVO getModelDetailById(Integer modelId) {
        // 根据ID查询模型信息，如果不存在则抛出异常
        Model model = BriupAssert.requireNotNull(
                this,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 将模型实体转换为详情视图对象
        ModelDetailVO modelDetailVO = modelConvert.po2ModelDetailVO(model);
        // 判断训练状态，只有训练中的模型才能获取训练历史
        if(ObjectUtil.notEqual(model.getTrainingStatus(), TrainingStatusEnum.NO_TRAINING.getStatus())){
            // 查询与该模型相关的所有训练记录
            LambdaQueryWrapper<Training> trainingLambdaQueryWrapper = new LambdaQueryWrapper<>();
            trainingLambdaQueryWrapper.eq(Training::getModelId, modelId);
            
            // 将训练记录转换为模型历史视图对象列表
            List<ModelHistoryVO> modelHistoryVOS = trainingService.list(trainingLambdaQueryWrapper).stream().map(
                    training -> {
                        // 查询当前训练使用的数据集名称
                        LambdaQueryWrapper<TrainingDataset> trainingDatasetLambdaQueryWrapper = new LambdaQueryWrapper<>();
                        trainingDatasetLambdaQueryWrapper.eq(TrainingDataset::getTrainingId, training.getId());
                        
                        // 获取训练数据集关联的数据集名称列表
                        List<String> datasetNames = trainingDatasetService.list(trainingDatasetLambdaQueryWrapper).stream().map(
                                trainingDataset -> {
                                    // 根据数据集ID查询数据集实体并获取数据集名称
                                    LambdaQueryWrapper<Dataset> datasetLambdaQueryWrapper = new LambdaQueryWrapper<>();
                                    datasetLambdaQueryWrapper.eq(Dataset::getId, trainingDataset.getDatasetId());
                                    Dataset dataset = datasetService.getOne(datasetLambdaQueryWrapper);
                                    return dataset.getDatasetName();
                                }
                        ).toList();
                        
                        // 构建模型历史视图对象
                        ModelHistoryVO modelHistoryVO = new ModelHistoryVO();
                        modelHistoryVO.setDatasetNames(datasetNames);
                        modelHistoryVO.setModelVersion(training.getModelVersion());
                        modelHistoryVO.setTrainDate(training.getCreateTime());
                        modelHistoryVO.setAccuracyRate(training.getAccuracyRate());
                        // 封装训练结果TrainingResult => 根据Training 找 TrainingLabel
                        modelHistoryVO.setTrainResults(
                                trainingLabelConvert.po2ModelOperationResultVOList(
                                        trainingLabelService.list(
                                                new LambdaQueryWrapper<TrainingLabel>()
                                                        .eq(TrainingLabel::getTrainingId, training.getId()))));
                        // 封装评估报告EvaluateReport => 根据Training 找 Evaluate
                        LambdaQueryWrapper<Evaluate> evaluateLambdaQueryWrapper = new LambdaQueryWrapper<>();
                        evaluateLambdaQueryWrapper.eq(Evaluate::getTrainingId, training.getId());
                        List<Evaluate> list = evaluateService.list(evaluateLambdaQueryWrapper);
                        if (ObjectUtil.isNotNull(list)) {
                            // 将评估记录转换为评估报告视图对象列表
                            List<ModelEvaluateReportVO> modelEvaluateReportVOS = list.stream().map(
                                    evaluate -> {
                                        // 构建评估报告视图对象
                                        ModelEvaluateReportVO reportVO = new ModelEvaluateReportVO();
                                        reportVO.setDatasetName(datasetService.getById(evaluate.getDatasetId()).getDatasetName());
                                        reportVO.setAccuracyRate(evaluate.getAccuracyRate());
                                        // 查询评估错误数量 - 根据评估ID统计错误记录数
                                        reportVO.setErrorCount(evaluateErrorService.count(
                                                new LambdaQueryWrapper<EvaluateError>()
                                                        .eq(EvaluateError::getEvaluateId, evaluate.getId())));
                                        // 查询并封装评估结果 - 根据评估ID查询评估标签信息
                                        reportVO.setEvaluateResults(
                                                evaluateLabelConvert.po2ModelOperationResultVOList(
                                                        evaluateLabelService.list(
                                                                new LambdaQueryWrapper<EvaluateLabel>()
                                                                        .eq(EvaluateLabel::getEvaluateId, evaluate.getId()))));
                                        return reportVO;
                                    }
                            ).toList();
                            modelHistoryVO.setEvaluateReport(modelEvaluateReportVOS);
                        }
                        return modelHistoryVO;
                    }
            ).toList();
            // 将训练历史记录设置到模型详情视图对象中
            modelDetailVO.setTrainingHistory(modelHistoryVOS);
        }
        // 返回模型详情视图对象
        return modelDetailVO;
    }

    @Override
    public List<Integer> getDatasetIdsUsed() {
        // 获取所有正在使用的数据集ID，包括训练和评估过程中使用的数据集
        List<Integer> datasetIdUsedList = new ArrayList<>();
        
        // 获取训练过程中使用的数据集ID列表
        List<Integer> trainingDatasetIds = trainingDatasetService.list().stream()
                .map(TrainingDataset::getDatasetId)
                .toList();
        
        // 获取评估过程中使用的数据集ID列表
        List<Integer> evaluateDatasetIds = evaluateService.list().stream()
                .map(Evaluate::getDatasetId)
                .toList();
        
        // 合并两个列表，得到所有已使用的数据集ID
        datasetIdUsedList.addAll(trainingDatasetIds);
        datasetIdUsedList.addAll(evaluateDatasetIds);
        return datasetIdUsedList;
    }
}