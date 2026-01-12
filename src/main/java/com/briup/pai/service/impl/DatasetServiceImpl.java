package com.briup.pai.service.impl;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.DatasetConstant;
import com.briup.pai.common.enums.DatasetStatusEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.convert.DatasetConvert;
import com.briup.pai.dao.DatasetMapper;
import com.briup.pai.entity.dto.DatasetSaveDTO;
import com.briup.pai.entity.po.Dataset;
import com.briup.pai.entity.vo.*;
import com.briup.pai.service.IClassifyService;
import com.briup.pai.service.IDatasetService;
import com.briup.pai.service.IEntityService;
import com.briup.pai.service.IModelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

@Service
@CacheConfig(cacheNames = DatasetConstant.DATASET_CACHE_PREFIX)
public class DatasetServiceImpl extends ServiceImpl<DatasetMapper, Dataset> implements IDatasetService {

    @Autowired
    private DatasetConvert datasetConvert;
    @Autowired
    private IClassifyService classifyService;
    @Autowired
    private IEntityService entityService;
    @Autowired
    private IModelService modelService;

    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;

    @Override
    public PageVO<DatasetPageVO> getDatasetByPageAndCondition(Long pageNum, Long pageSize, String datasetName, Integer datasetType) {
        PageVO<DatasetPageVO> pageVO = new PageVO<>();
        // 开启分页
        Page<Dataset> datasetPage = new Page<>(pageNum, pageSize);
        // 根据条件进行查询
        LambdaQueryWrapper<Dataset> lqw = new LambdaQueryWrapper<>();
        lqw.like(ObjectUtil.isNotNull(datasetName), Dataset::getDatasetName, datasetName)
                .eq(ObjectUtil.isNotNull(datasetType), Dataset::getDatasetType, datasetType);
        datasetPage = this.page(datasetPage, lqw);
        // 数据转换PO -> VO,还要使用peek完成num统计
        List<DatasetPageVO> list = datasetConvert.po2DatasetPageVOList(datasetPage.getRecords()).stream().peek(
                datasetPageVO -> {
                    // 获取dataSetId
                    Integer datasetId = datasetPageVO.getDatasetId();
                    // 统计classifyNum
                    List<ClassifyInDatasetVO> classifiesByDatasetId = classifyService.getClassifiesByDatasetId(datasetId);
                    datasetPageVO.setClassifyNum((long)classifiesByDatasetId.size());
                    // 统计entityNum
                    long entitiesNum = 0L;
                    for (ClassifyInDatasetVO classifyInDatasetVO : classifiesByDatasetId){
                        entitiesNum += classifyInDatasetVO.getEntityNum();
                    }
                    datasetPageVO.setEntityNum(entitiesNum);
                }
        ).toList();
        // 封装
        pageVO.setTotal(datasetPage.getTotal());
        pageVO.setData(list);
        return pageVO;
    }

    @Override
    @Transactional
    @CachePut(key = "#result.datasetId")
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#dto.getDatasetId()",
    condition = "#dto.getDatasetId() != null")
    public DatasetEchoVO addOrModifyDataset(DatasetSaveDTO dto) {
        Integer datasetId = dto.getDatasetId();
        Dataset dataset = null;
        if (ObjectUtil.isNull(datasetId)) {
            // 添加数据集
            BriupAssert.requireNull(
                    this,
                    Dataset::getDatasetName,
                    dto.getDatasetName(),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            // 类型转换 DTO -> PO
            dataset = datasetConvert.datasetSaveDTO2Po(dto);
            // 缺少数据集的状态，要手动添加为初始化状态
            dataset.setDatasetStatus(DatasetStatusEnum.INIT.getStatus());
            this.save(dataset);
        }else {
            // 修改数据集
            // 数据集编号必须存在
            Dataset temp = BriupAssert.requireNotNull(
                    this,
                    Dataset::getId,
                    datasetId,
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            // 数据集名称不能重复
            BriupAssert.requireNull(
                    this,
                    Dataset::getDatasetName,
                    dto.getDatasetName(),
                    Dataset::getId,
                    datasetId,
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            // 数据集类型不能修改
            BriupAssert.requireEqual(
                    temp.getDatasetType(),
                    dto.getDatasetType(),
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            dataset = datasetConvert.datasetSaveDTO2Po(dto);
            this.updateById(dataset);
        }
        return datasetConvert.po2DatasetEchoVO(dataset);
    }

    @Override
    @Cacheable(key = "#datasetId")
    public DatasetEchoVO modifyDatasetFeedback(Integer datasetId) {
        return datasetConvert.po2DatasetEchoVO(BriupAssert.requireNotNull(
                this,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        ));
    }

    @Override
    @Transactional
    @Caching(evict = {
        @CacheEvict(key = "#datasetId"),
        @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    })
    public void removeDatasetById(Integer datasetId) {
        Dataset dataset = BriupAssert.requireNotNull(
                this,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 当数据集用于模型的训练、评估、优化的话，不能删除
        BriupAssert.requireNotIn(
                datasetId,
                modelService.getDatasetIdsUsed(),
                ResultCodeEnum.DATA_CAN_NOT_DELETE
        );

        // 删除数据集
        this.removeById(datasetId);
        // 删除数据集下的所有分类信息
        List<Integer> classifyIds = classifyService.getClassifiesByDatasetId(datasetId)
                .stream().map(ClassifyInDatasetVO::getClassifyId).toList();
        classifyService.removeBatchByIds(classifyIds);
        // 删除数据集下的所有分类下的所有实体信息
        List<Integer>entityIds = new ArrayList<>();
        for (Integer classifyId : classifyIds){
            entityIds.addAll(entityService.getEntityByClassifyId(classifyId)
                    .stream().map(EntityInClassifyVO::getEntityId).toList());
        }
        entityService.removeBatchByIds(entityIds);
        // 同步删除文件服务器存放该数据集的文件夹
        File file = new File(nginxFilePath + "/" + datasetId);
        FileUtil.del(file);
    }

    @Override
    @Cacheable(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    public DatasetDetailVO getDatasetDetail(Integer datasetId) {
        Dataset dataset = BriupAssert.requireNotNull(
                this,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        DatasetDetailVO datasetDetailVO = datasetConvert.po2DatasetDetailVO(dataset);
        List<ClassifyInDatasetVO> classifiesByDatasetId = classifyService.getClassifiesByDatasetId(datasetId);
        datasetDetailVO.setClassifies(classifiesByDatasetId);
        datasetDetailVO.setClassifyNum((long)classifiesByDatasetId.size());
        long entityNum = 0L;
        for (ClassifyInDatasetVO classifyInDatasetVO : classifiesByDatasetId) {
            entityNum += classifyInDatasetVO.getEntityNum();
        }
        datasetDetailVO.setEntityNum(entityNum);
        return datasetDetailVO;
    }
}