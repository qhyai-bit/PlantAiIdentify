package com.briup.pai.service.impl;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.DatasetConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.convert.ClassifyConvert;
import com.briup.pai.dao.ClassifyMapper;
import com.briup.pai.entity.dto.ClassifySaveDTO;
import com.briup.pai.entity.po.Classify;
import com.briup.pai.entity.vo.ClassifyEchoVO;
import com.briup.pai.entity.vo.ClassifyInDatasetVO;
import com.briup.pai.entity.vo.EntityInClassifyVO;
import com.briup.pai.service.IClassifyService;
import com.briup.pai.service.IEntityService;
import com.briup.pai.service.IModelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.List;

@Service
@CacheConfig(cacheNames = DatasetConstant.DATASET_CACHE_PREFIX)
public class ClassifyServiceImpl extends ServiceImpl<ClassifyMapper, Classify> implements IClassifyService {

    @Autowired
    private ClassifyConvert classifyConvert;
    @Autowired
    private IEntityService entityService;
    @Autowired
    private IModelService modelService;

    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;

    @Override
    public List<ClassifyInDatasetVO> getClassifiesByDatasetId(Integer datasetId) {
        // 构建查询条件，根据数据集ID查询所有分类
        LambdaQueryWrapper<Classify> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Classify::getDatasetId, datasetId);
        
        // 查询数据集下的所有分类，并转换为ClassifyInDatasetVO列表
        // 然后遍历每个分类对象，设置其包含的实体数量
        return classifyConvert.po2ClassifyInDatasetVOList(this.list(lqw)).stream().peek(
                classifyInDatasetVO -> {
                    // 根据分类ID获取实体列表，并设置实体数量
                    classifyInDatasetVO.setEntityNum((long)entityService.getEntityByClassifyId(
                            classifyInDatasetVO.getClassifyId()).size());
                }
        ).toList();
    }

    @Override
    @Transactional
    @CachePut(key = "T(com.briup.pai.common.constant.DatasetConstant).DATASET_CLASSIFY_CACHE_PREFIX+':'+#result.classifyId")
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#dto.getDatasetId()")
    public ClassifyEchoVO addOrModifyClassify(ClassifySaveDTO dto) {
        // 获取分类信息参数
        Integer classifyId = dto.getClassifyId();
        String classifyName = dto.getClassifyName();
        Integer datasetId = dto.getDatasetId();
        Classify classify = null;
        
        if (ObjectUtil.isNull(classifyId)) {
            // 新增分类
            // 同一个数据集下的分类名称不能重复
            LambdaQueryWrapper<Classify> lqw = new LambdaQueryWrapper<>();
            lqw.eq(Classify::getDatasetId, datasetId)
                    .eq(Classify::getClassifyName, classifyName);
            BriupAssert.requireNull(
                    this.getOne(lqw),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            // 保存分类信息到数据库
            this.save(classifyConvert.classifySaveDTO2Po(dto));
            // 在nginx服务器指定位置创建文件夹，路径为 datasetId/classifyName
            String path = nginxFilePath + "/" + datasetId + "/" + classifyName;
            FileUtil.mkdir(path);
        } else {
            // 修改分类
            // 数据校验: 分类必须存在、分类名称必须唯一、数据集id不可修改
            Classify temp = BriupAssert.requireNotNull(
                    this,
                    Classify::getId,
                    classifyId,
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            // 验证分类名称在当前数据集中是否唯一
            LambdaQueryWrapper<Classify> lqw = new LambdaQueryWrapper<>();
            lqw.eq(Classify::getClassifyName, classifyName)
                    .eq(Classify::getDatasetId, datasetId)
                    .eq(Classify::getId, classifyId);
            BriupAssert.requireNull(this.getOne(lqw), ResultCodeEnum.DATA_ALREADY_EXIST);
            // 验证数据集ID没有被修改
            BriupAssert.requireEqual(
                    temp.getDatasetId(),
                    datasetId,
                    ResultCodeEnum.PARAM_IS_ERROR
            );
            // 更新数据库中的分类信息
            classify = classifyConvert.classifySaveDTO2Po(dto);
            this.updateById(classify);
            // 同步更新文件夹名称
            // 获取原来的文件夹路径
            String path = nginxFilePath + "/" + datasetId + "/" + temp.getClassifyName();
            File file = new File(path);
            // 重命名文件夹
            FileUtil.rename(file, classify.getClassifyName(), true);
        }
        // 返回分类信息
        return classifyConvert.po2ClassifyEchoVO(classify);
    }

    @Override
    @Transactional
    @Caching(evict ={
        @CacheEvict(key = "T(com.briup.pai.common.constant.DatasetConstant).DATASET_CLASSIFY_CACHE_PREFIX+':'+#result.classifyId"),
        @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    })
    public void removeClassifyById(Integer datasetId, Integer classifyId) {
        // 数据校验： 分类必须存在，数据集id必须一致
        Classify classify = BriupAssert.requireNotNull(
                this,
                Classify::getId,
                classifyId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        BriupAssert.requireEqual(
                classify.getDatasetId(),
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 检查数据集是否正在被模型使用，如果正在使用则不允许删除分类
        BriupAssert.requireNotIn(
                datasetId,
                modelService.getDatasetIdsUsed(),
                ResultCodeEnum.DATA_CAN_NOT_DELETE
        );
        // 删除实体及实体下的分类信息
        this.removeById(classifyId);
        // 获取该分类下的所有实体ID并批量删除实体
        List<Integer> entityIds = entityService.getEntityByClassifyId(classifyId)
                .stream().map(EntityInClassifyVO::getEntityId).toList();
        entityService.removeBatchByIds(entityIds);
        // 删除对应的文件夹
        File file = new File(nginxFilePath + "/" + classify.getDatasetId() + "/" + classify.getClassifyName());
        FileUtil.del(file);
    }

    @Override
    @Cacheable(key = "T(com.briup.pai.common.constant.DatasetConstant).DATASET_CLASSIFY_CACHE_PREFIX+':'+#classifyId")
    public ClassifyEchoVO getClassifyById(Integer classifyId) {
        // 根据分类ID查询分类信息，如果不存在则抛出异常
        return classifyConvert.po2ClassifyEchoVO(BriupAssert.requireNotNull(
                this,  // 传入当前服务实例用于查询
                Classify::getId,  // 指定查询条件为ID字段
                classifyId,  // 查询的目标ID
                ResultCodeEnum.DATA_NOT_EXIST  // 如果未找到数据则抛出此异常
        ));
    }
}