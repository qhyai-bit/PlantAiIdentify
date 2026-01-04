package com.briup.pai.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.convert.EntityConvert;
import com.briup.pai.dao.EntityMapper;
import com.briup.pai.entity.po.Entity;
import com.briup.pai.entity.vo.EntityInClassifyVO;
import com.briup.pai.entity.vo.EntityPageVO;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.service.IEntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EntityServiceImpl extends ServiceImpl<EntityMapper, Entity> implements IEntityService {

    @Autowired
    private EntityConvert entityConvert;

    @Override
    public List<EntityInClassifyVO> getEntityByClassifyId(Integer classifyId) {
        return entityConvert.po2EntityInClassifyVOList(
                this.list(
                        new LambdaQueryWrapper<Entity>()
                                .eq(Entity::getClassifyId, classifyId)));
    }

    @Override
    public PageVO<EntityPageVO> getEntityByPage(Integer classifyId, Long pageNum) {
        return null;
    }

    @Override
    public void removeEntityByBatch(Integer datasetId, Integer classifyId, List<Integer> entityIds) {

    }
}