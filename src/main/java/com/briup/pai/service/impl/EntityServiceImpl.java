package com.briup.pai.service.impl;

import cn.hutool.core.io.FileUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.CommonConstant;
import com.briup.pai.common.constant.DatasetConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.convert.EntityConvert;
import com.briup.pai.dao.EntityMapper;
import com.briup.pai.entity.po.Classify;
import com.briup.pai.entity.po.Dataset;
import com.briup.pai.entity.po.Entity;
import com.briup.pai.entity.vo.EntityInClassifyVO;
import com.briup.pai.entity.vo.EntityPageVO;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.service.IClassifyService;
import com.briup.pai.service.IDatasetService;
import com.briup.pai.service.IEntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@CacheConfig(cacheNames = DatasetConstant.DATASET_CACHE_PREFIX)
public class EntityServiceImpl extends ServiceImpl<EntityMapper, Entity> implements IEntityService {

    @Autowired
    private EntityConvert entityConvert;
    @Autowired
    @Lazy
    private IClassifyService classifyService;
    @Autowired
    @Lazy
    private IDatasetService datasetService;

    @Value("${upload.nginx-server}")
    private String nginxServer;
    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;

    @Override
    public List<EntityInClassifyVO> getEntityByClassifyId(Integer classifyId) {
        return entityConvert.po2EntityInClassifyVOList(
                this.list(
                        new LambdaQueryWrapper<Entity>()
                                .eq(Entity::getClassifyId, classifyId)));
    }

    @Override
    public PageVO<EntityPageVO> getEntityByPage(Integer classifyId, Long pageNum) {
        PageVO<EntityPageVO> pageVO = new PageVO<>();
        // 构建分页对象，使用预设的页面大小常量
        Page<Entity> page = new Page<>(pageNum, DatasetConstant.ENTITY_PAGE_SIZE);
        // 根据分类ID获取分类信息，如果不存在则抛出数据不存在异常
        Classify classify = BriupAssert.requireNotNull(
                classifyService,
                Classify::getId,
                classifyId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 创建查询条件包装器
        LambdaQueryWrapper<Entity> lqw = new LambdaQueryWrapper<>();
        // 设置按分类ID查询的条件
        lqw.eq(Entity::getClassifyId, classifyId);
        // 执行分页查询
        Page<Entity> page1 = this.page(page, lqw);
        // 实体图片的名称要拼接成实体图片的url用于显示
        // http://localhost:89/{datasetId}/{classifyName}/{entityUrl}
        // 将查询结果转换为页面显示对象，并拼接完整的图片URL
        List<EntityPageVO> list = entityConvert.po2EntityPageVOList(page1.getRecords())
                .stream().peek(entityPageVO -> {
                    // 获取数据集ID
                    Integer datasetId = classify.getDatasetId();
                    // 获取分类名称
                    String classifyName = classify.getClassifyName();
                    // 拼接完整的图片访问URL
                    String url = nginxServer + datasetId + "/" + classifyName + "/" + entityPageVO.getEntityUrl();
                    entityPageVO.setEntityUrl(url);
                }).toList();
        // 设置分页结果的总数量
        pageVO.setTotal(page1.getTotal());
        // 设置分页结果的数据列表
        pageVO.setData(list);
        return pageVO;
    }

    @Override
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    public void removeEntityByBatch(Integer datasetId, Integer classifyId, List<Integer> entityIds) {
        // 参数校验: 数据集必须存在、分类必须存在、分类所属的数据集必须一致
        Dataset dataset = BriupAssert.requireNotNull(
                datasetService,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        Classify classify = BriupAssert.requireNotNull(
                classifyService,
                Classify::getId,
                classifyId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        BriupAssert.requireEqual(
                dataset.getId(),
                classify.getDatasetId(),
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 删除对应的文件
        // 先获取所有需要删除的文件的存储路径
        List<String> filePathList = entityIds.stream().map(entityId ->
            CommonConstant.createEntityPath(
                    nginxFilePath,
                    datasetId,
                    classify.getClassifyName(),
                    this.getById(entityId).getEntityUrl())
        ).toList();
        // 遍历删除每个文件
        filePathList.forEach(FileUtil::del);
        // 从数据库批量删除实体记录
        this.removeBatchByIds(entityIds);
    }
}