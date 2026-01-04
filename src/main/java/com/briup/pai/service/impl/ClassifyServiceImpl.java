package com.briup.pai.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.convert.ClassifyConvert;
import com.briup.pai.dao.ClassifyMapper;
import com.briup.pai.entity.dto.ClassifySaveDTO;
import com.briup.pai.entity.po.Classify;
import com.briup.pai.entity.vo.ClassifyEchoVO;
import com.briup.pai.entity.vo.ClassifyInDatasetVO;
import com.briup.pai.service.IClassifyService;
import com.briup.pai.service.IEntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClassifyServiceImpl extends ServiceImpl<ClassifyMapper, Classify> implements IClassifyService {

    @Autowired
    private ClassifyConvert classifyConvert;
    @Autowired
    private IEntityService entityService;

    @Override
    public List<ClassifyInDatasetVO> getClassifiesByDatasetId(Integer datasetId) {
        LambdaQueryWrapper<Classify> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Classify::getDatasetId, datasetId);
        return classifyConvert.po2ClassifyInDatasetVOList(this.list(lqw)).stream().peek(
                classifyInDatasetVO -> {
                    classifyInDatasetVO.setEntityNum((long)entityService.getEntityByClassifyId(
                            classifyInDatasetVO.getClassifyId()).size());
                }
        ).toList();
    }

    @Override
    public ClassifyEchoVO addOrModifyClassify(ClassifySaveDTO dto) {
        return null;
    }

    @Override
    public void removeClassifyById(Integer datasetId, Integer classifyId) {

    }

    @Override
    public ClassifyEchoVO getClassifyById(Integer classifyId) {
        return null;
    }
}