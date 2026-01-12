package com.briup.pai.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.briup.pai.common.constant.CommonConstant;
import com.briup.pai.common.constant.ModelConstant;
import com.briup.pai.common.enums.DatasetStatusEnum;
import com.briup.pai.common.enums.ModelOperationTypeEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.TrainingStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.convert.DatasetConvert;
import com.briup.pai.convert.ModelConfigConvert;
import com.briup.pai.convert.ModelConvert;
import com.briup.pai.entity.dto.ModelOperationDTO;
import com.briup.pai.entity.message.ModelEvaluateMessage;
import com.briup.pai.entity.message.ModelInitTrainMessage;
import com.briup.pai.entity.message.ModelOptimizeTrainMessage;
import com.briup.pai.entity.message.ModelReleaseMessage;
import com.briup.pai.entity.po.*;
import com.briup.pai.entity.vo.ReleaseModelVO;
import com.briup.pai.entity.vo.TrainingDatasetQueryVO;
import com.briup.pai.service.*;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

@Service
public class ModelOperationServiceImpl implements IModelOperationService {

    @Autowired
    private IModelService modelService;
    @Autowired
    private IDatasetService datasetService;
    @Autowired
    private IModelConfigService modelConfigService;
    @Autowired
    private ITrainingService trainingService;
    @Autowired
    private ITrainingDatasetService trainingDatasetService;
    @Autowired
    private IClassifyService classifyService;
    @Autowired
    private IEntityService entityService;
    @Autowired
    private IEvaluateService evaluateService;
    @Autowired
    private  IReleaseService releaseService;

    @Autowired
    private DatasetConvert datasetConvert;
    @Autowired
    private ModelConfigConvert modelConfigConvert;
    @Autowired
    private ModelConvert modelConvert;

    @Autowired
    private RabbitTemplate rabbitTemplate;
    @Autowired
    private RestTemplate restTemplate;

    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;
    @Value("${mq.init.exchange}")
    private String initExchange;
    @Value("${mq.init.send-routing-key}")
    private String initSendRoutingKey;
    @Value("${mq.optimize.exchange}")
    private String optimizeExchange;
    @Value("${mq.optimize.send-routing-key}")
    private String optimizeSendRoutingKey;
    @Value("${mq.evaluate.exchange}")
    private String evaluateExchange;
    @Value("${mq.evaluate.send-routing-key}")
    private String evaluateSendRoutingKey;
    @Value("${mq.release.exchange}")
    private String releaseExchange;
    @Value("${mq.release.send-routing-key}")
    private String releaseSendRoutingKey;

    @Override
    public List<TrainingDatasetQueryVO> getTrainingDatasets(Integer modelId, Integer datasetUsage) {
        // 根据模型ID获取模型信息，确保模型存在
        Model model = BriupAssert.requireNotNull(
                modelService,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 构建查询条件：查找已处理完成、指定用途和模型类型的训练数据集
        LambdaQueryWrapper<Dataset> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Dataset::getDatasetUsage, datasetUsage)  // 指定数据集用途
                   .eq(Dataset::getDatasetType, model.getModelType())  // 与模型类型匹配
                   .eq(Dataset::getDatasetStatus, DatasetStatusEnum.DONE.getStatus()); // 状态为已完成
        // 查询符合条件的数据集列表
        List<Dataset> datasets = datasetService.list(queryWrapper);
        // 将查询结果转换为VO对象列表并返回
        return datasetConvert.po2TrainingDatasetQueryVOList(datasets);
    }

    @Override
    public ModelConfig getModelConfig(Integer modelId) {
        // 验证模型是否存在
        Model model = BriupAssert.requireNotNull(
                modelService,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 验证模型训练状态是否已完成，只有训练完成的模型才会有配置信息
        BriupAssert.requireEqual(
                model.getTrainingStatus(),
                TrainingStatusEnum.DONE.getStatus(),
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 根据模型ID查询对应的模型配置
        LambdaQueryWrapper<ModelConfig> lqw = new LambdaQueryWrapper<>();
        lqw.eq(ModelConfig::getModelId, modelId);
        // 返回查询到的模型配置，如果不存在则返回null
        return modelConfigService.getOne(lqw);
    }

    @Override
    @Transactional
    public void operationModel(ModelOperationDTO modelOperationDTO) {
        // 提取操作所需参数
        Integer modelId = modelOperationDTO.getModelId();
        Integer operationType = modelOperationDTO.getOperationType();
        List<Integer> datasetIds = modelOperationDTO.getDatasetIds();

        // 验证模型是否存在
        Model model = BriupAssert.requireNotNull(
                modelService,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );

        // 获取当前模型版本号
        Integer modelVersion = model.getLastModelVersion();
        // 查询当前版本对应的训练记录
        LambdaQueryWrapper<Training> trainingLambdaQueryWrapper = new LambdaQueryWrapper<>();
        trainingLambdaQueryWrapper.eq(Training::getModelId,modelId)
                .eq(Training::getModelVersion,modelVersion);
        Training training = trainingService.getOne(trainingLambdaQueryWrapper);

        // 根据操作类型执行相应业务逻辑
        if (ObjectUtil.equal(operationType, ModelOperationTypeEnum.INIT.getType())) {
            // 初始化训练：模型必须未训练，且无训练记录
            BriupAssert.requireEqual(
                    model.getTrainingStatus(),
                    TrainingStatusEnum.NO_TRAINING.getStatus(),
                    ResultCodeEnum.PARAM_IS_ERROR
            );
            BriupAssert.requireNull(training, ResultCodeEnum.DATA_ALREADY_EXIST);
            // 保存模型配置到数据库（获取当前的代理对象）
            ModelConfig modelConfig = modelConfigConvert.modelOperationDTO2Po(modelOperationDTO);
            modelConfigService.save(modelConfig);

            // 保存训练记录（使用AOP代理调用事务方法）
            ModelOperationServiceImpl operationService = (ModelOperationServiceImpl) AopContext.currentProxy();
            Integer trainingId = operationService.saveTrainingRecord(modelId, modelVersion + 1, datasetIds);

            // 整合训练数据集中的图片资源
            Map<String, List<String>> trainingData = mergeDatasets(datasetIds);

            // 构建并发送初始化训练消息至消息队列
            ModelInitTrainMessage modelInitTrainMessage = modelConvert.modelOperationDTO2InitMessage(modelOperationDTO);
            modelInitTrainMessage.setData(trainingData);
            modelInitTrainMessage.setTrainingId(trainingId);
            modelInitTrainMessage.setModelVersion(modelVersion+1);
            // 使用RabbitMQ发送消息
            rabbitTemplate.convertAndSend(initExchange, initSendRoutingKey, modelInitTrainMessage);

            // 更新模型状态为训练中
            model.setTrainingStatus(TrainingStatusEnum.TRAINING.getStatus());
            modelService.updateById(model);
        } else if(ObjectUtil.equal(operationType, ModelOperationTypeEnum.OPTIMIZE.getType())) {
            // 优化训练
            // 和初始化训练不同的地方：参数校验、发送的消息不同、优化训练不要再保存一遍模型配置
            BriupAssert.requireEqual(
                    model.getTrainingStatus(),
                    TrainingStatusEnum.DONE.getStatus(),
                    ResultCodeEnum.PARAM_IS_ERROR
            );

            // 保存优化训练记录
            ModelOperationServiceImpl modelOperationService = (ModelOperationServiceImpl) AopContext.currentProxy();
            Integer trainingId = modelOperationService.saveTrainingRecord(modelId, modelVersion + 1, datasetIds);

            // 整合训练数据集中的图片资源
            Map<String, List<String>> trainingData = mergeDatasets(datasetIds);

            // 构建并发送优化训练消息至消息队列
            ModelOptimizeTrainMessage modelOptimizeTrainMessage = modelConvert.modelOperationDTO2OptimizeMessage(modelOperationDTO);
            modelOptimizeTrainMessage.setData(trainingData);
            modelOptimizeTrainMessage.setTrainingId(trainingId);
            modelOptimizeTrainMessage.setModelVersion(modelVersion + 1);
            modelOptimizeTrainMessage.setOldModelPath(training.getModelFileAddr());
            rabbitTemplate.convertAndSend(optimizeExchange, optimizeSendRoutingKey, modelOptimizeTrainMessage);

            // 更新模型状态为优化中
            model.setTrainingStatus(TrainingStatusEnum.OPTIMIZING.getStatus());
            modelService.updateById(model);

        } else if (ObjectUtil.equal(operationType, ModelOperationTypeEnum.EVALUATE.getType())) {
            // 模型评估：模型必须已训练完成
            BriupAssert.requireEqual(
                    model.getTrainingStatus(),
                    TrainingStatusEnum.DONE.getStatus(),
                    ResultCodeEnum.PARAM_IS_ERROR
            );

            // 检查防止同一版本使用相同数据集进行多次评估
            LambdaQueryWrapper<Evaluate> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(Evaluate::getTrainingId, training.getId());
            List<Integer> evaluateDatasetIds = evaluateService.list(queryWrapper).stream()
                    .map(Evaluate::getDatasetId)
                    .toList();

            // 评估数据集ID不能与之前评估使用的数据集重复
            Integer datasetId = datasetIds.get(0);
            BriupAssert.requireNotIn(
                    datasetId,
                    evaluateDatasetIds,
                    ResultCodeEnum.MODEL_CAN_NOT_EVALUATE);
            // 保存训练-数据集数据
            Evaluate evaluate = new Evaluate();
            evaluate.setDatasetId(datasetId);
            evaluate.setTrainingId(training.getId());
            evaluateService.save(evaluate);

            // 整合评估数据集中的图片资源
            Map<String, List<String>> trainingData = mergeDatasets(datasetIds);

            // 构建并发送评估消息至消息队列（这里的消息类型没有做convert，后面可以补上）
            ModelEvaluateMessage evaluateMessage = new ModelEvaluateMessage();
            evaluateMessage.setModelId(modelId);
            evaluateMessage.setEvaluateId(evaluate.getId());
            evaluateMessage.setData(trainingData);
            evaluateMessage.setModelFileAddr(training.getModelFileAddr());
            rabbitTemplate.convertAndSend(
                    evaluateExchange,
                    evaluateSendRoutingKey,
                    evaluateMessage);
            // 修改模型的状态为评估中
            model.setTrainingStatus(TrainingStatusEnum.EVALUATING.getStatus());
            modelService.updateById(model);

        } else {
            // 不支持的操作类型
            BriupAssert.throwException(ResultCodeEnum.PARAM_IS_ERROR);
        }
    }

    @Override
    public void releaseModelOrNot(Integer modelId, Integer modelStatus) {
        // 参数校验：验证模型是否存在
        Model model = BriupAssert.requireNotNull(
                modelService,
                Model::getId,
                modelId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 验证模型当前状态与目标状态是否一致（防止重复操作）
        BriupAssert.requireEqual(
                model.getModelStatus(),
                modelStatus,
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 验证模型准确率是否达到发布阈值要求
        BriupAssert.requireTrue(
                model.getAccuracyRate() > ModelConstant.MODEL_RELEASE_THRESHOLD,
                ResultCodeEnum.MODEL_CAN_NOT_RELEASE
        );
        
        // 构建模型发布消息对象
        ModelReleaseMessage modelReleaseMessage = new ModelReleaseMessage();
        modelReleaseMessage.setModelStatus(modelStatus);       // 设置目标状态
        modelReleaseMessage.setModelId(modelId);              // 设置模型ID
        modelReleaseMessage.setUserId(SecurityUtil.getUserId()); // 设置操作用户ID
        // 查询最新版本的训练记录以获取模型文件地址
        LambdaQueryWrapper<Training> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Training::getModelId, modelId)
           .eq(Training::getModelVersion, model.getLastModelVersion());
        Training training = trainingService.getOne(lqw);
        modelReleaseMessage.setModelFileAddr(training.getModelFileAddr()); // 设置模型文件地址
        // 通过RabbitMQ发送模型发布消息
        rabbitTemplate.convertAndSend(releaseExchange, releaseSendRoutingKey, modelReleaseMessage);
    }

    @Override
    public List<ReleaseModelVO> getReleaseModel() {
        // 查询所有已发布的模型记录，并将模型信息转换为前端展示所需的VO对象
        // 通过发布记录获取模型ID，查询完整模型信息，然后转换为ReleaseModelVO对象
        return releaseService.list().stream()
                .map(release -> {
                    Integer modelId = release.getModelId();
                    return modelConvert.po2ReleaseModelVO(modelService.getById(modelId));
                }).toList();
    }

    @Override
    public String identify(Integer modelId, MultipartFile file) {
        // 根据模型ID查询已发布的模型地址
        LambdaQueryWrapper<Release> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Release::getModelId, modelId);
        Release release = releaseService.getOne(lqw);
        // 获取模型服务URL
        String modelUrl = release.getModelUrl();
        // 重新定制请求转发
        // 定义请求头，contentType为文件类型
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        // 构建请求体，封装上传的文件
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        try {
            // 将MultipartFile转换为ByteArrayResource并设置原始文件名
            body.add("file", new ByteArrayResource(file.getBytes()) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            });
        } catch (IOException e) {
            // 文件读取失败时抛出异常
            BriupAssert.throwException(ResultCodeEnum.FILE_TYPE_ERROR);
        }
        // 创建请求实体并使用restTemplate发送
        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        // 发送POST请求到Python模型服务，并获取识别结果
        ResponseEntity<String> response = restTemplate.postForEntity(modelUrl, requestEntity, String.class);
        // 返回请求python结果的响应
        return response.getBody();
    }

    /**
     * 保存训练相关记录
     * @param modelId      模型ID
     * @param modelVersion 模型版本号
     * @param datasetIds   参与训练的数据集ID列表
     * @return 训练记录ID
     */
    @Transactional
    public Integer saveTrainingRecord(Integer modelId, Integer modelVersion, List<Integer> datasetIds) {
        // 创建并保存训练记录
        Training training = new Training();
        training.setModelId(modelId);
        training.setModelVersion(modelVersion);
        training.setCreateBy(SecurityUtil.getUserId());
        training.setCreateTime(new Date());
        trainingService.save(training);

        // 创建并保存训练-数据集关联记录
        Integer trainingId = training.getId();
        List<TrainingDataset> trainingDatasets = datasetIds.stream()
                .map(datasetId -> {
                    TrainingDataset trainingDataset = new TrainingDataset();
                    trainingDataset.setTrainingId(trainingId);
                    trainingDataset.setDatasetId(datasetId);
                    return trainingDataset;
                }).toList();
        trainingDatasetService.saveBatch(trainingDatasets);
        return trainingId;
    }

    /**
     * 合并多个数据集的图片数据
     * 遍历每个数据集，查询其下的分类及分类中的图片，将相同分类的图片路径合并到一起
     * @param datasetIds 数据集ID列表
     * @return Map<String, List<String>> 返回按分类名分组的图片路径映射
     *         key为分类名称，value为该分类下所有图片的完整访问路径列表
     */
    private Map<String, List<String>> mergeDatasets(List<Integer> datasetIds) {
        // 创建Map存储合并后的训练数据，key为分类名称，value为该分类下的图片路径列表
        Map<String, List<String>> trainingData = new HashMap<>();

        // 遍历每个数据集ID
        datasetIds.forEach(datasetId -> {
            // 构建查询条件：根据数据集ID查询其下的所有分类
            LambdaQueryWrapper<Classify> classifyWrapper = new LambdaQueryWrapper<>();
            classifyWrapper.eq(Classify::getDatasetId, datasetId);
            
            // 查询数据集下的所有分类并遍历处理
            classifyService.list(classifyWrapper)
                    .forEach(classify -> {
                        // 根据分类查询该分类下的所有图片
                        String classifyName = classify.getClassifyName();
                        Integer classifyId = classify.getId();
                        
                        // 构建查询条件：根据分类ID查询该分类下的所有图片实体
                        LambdaQueryWrapper<Entity> entityWrapper = new LambdaQueryWrapper<>();
                        entityWrapper.eq(Entity::getClassifyId, classifyId);
                        
                        // 查询分类下的所有图片实体，并转换为完整的图片访问路径列表
                        List<String> entityUrls = new ArrayList<>(
                                // 注意：JDK 17中Stream流的toList()方法返回不可变列表，需要包装为ArrayList以支持后续的addAll操作
                                entityService.list(entityWrapper)
                                        .stream()
                                        .map(entity -> 
                                                // 使用通用常量工具类创建图片实体的完整访问路径
                                                CommonConstant.createEntityPath(this.nginxFilePath, datasetId, classifyName,
                                                        entity.getEntityUrl())).toList()
                        );
                        
                        // 将当前分类的图片路径合并到结果Map中
                        if (trainingData.containsKey(classifyName)) {
                            // 如果该分类已存在，将当前数据集中的图片路径追加到现有列表中
                            trainingData.get(classifyName).addAll(entityUrls);
                        } else {
                            // 如果该分类不存在，直接将图片路径列表放入Map中
                            trainingData.put(classifyName, entityUrls);
                        }
                    });
        });
        return trainingData;
    }
}