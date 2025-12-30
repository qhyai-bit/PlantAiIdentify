package com.briup.pai.service.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.OperatorConstant;
import com.briup.pai.common.enums.OperatorCategoryEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.exception.CustomException;
import com.briup.pai.convert.OperatorConvert;
import com.briup.pai.dao.OperatorMapper;
import com.briup.pai.entity.dto.OperatorImportDTO;
import com.briup.pai.entity.dto.OperatorUpdateDTO;
import com.briup.pai.entity.po.Operator;
import com.briup.pai.entity.vo.DropDownVO;
import com.briup.pai.entity.vo.OperatorEchoVO;
import com.briup.pai.entity.vo.OperatorPageVO;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.service.IOperatorService;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@CacheConfig(cacheNames = OperatorConstant.OPERATOR_CACHE_PREFIX)
public class OperatorServiceImpl extends ServiceImpl<OperatorMapper, Operator> implements IOperatorService {

    @Autowired
    private OperatorConvert operatorConvert;

    @Override
    @Transactional
    public void importOperator(MultipartFile file) {
        // 校验数据 file必须是excel文件
        BriupAssert.requireExcel(file);
        // 要求算子不能重复导入
        // 查询所有算子的名称，本项目中用的是集合的流式操作
        List<String> operatorNames = new ArrayList<>(this.list().stream()
                .map(Operator::getOperatorName).toList());

        // 定义集合保存数据
        List<OperatorImportDTO> operatorImportDTOs = new ArrayList<>();
        // 读取excel的文件内容，对其中的数据进行过滤
        // 过滤完成之后入库
        try {
            EasyExcel.read(file.getInputStream(), OperatorImportDTO.class, new AnalysisEventListener<OperatorImportDTO>() {
                @Override
                public void invoke(OperatorImportDTO dto, AnalysisContext analysisContext) {
                    // 过滤
                    if (!operatorNames.contains(dto.getOperatorName())) {
                        operatorImportDTOs.add(dto);
                    }
                    // 将之前文件中存在但是数据库里不存在的名字加进去
                    operatorNames.add(dto.getOperatorName());
                }

                @Override
                public void doAfterAllAnalysed(AnalysisContext analysisContext) {
                    // 数据转换 dto -> po
                    List<Operator> operators = operatorConvert.operatorImportDto2PoList(operatorImportDTOs);
                    // 过滤错误数据，类型和分类值为-1
                    List<Operator> operatorList = operators.stream()
                            .filter(operator -> operator.getOperatorType() != -1
                                    && operator.getOperatorCategory() != -1).toList();
                    // 入库(不能直接使用saveBatch,有事务冲突)
                    // 获取当前代理类对象，手动调用
                    IOperatorService operatorService = (IOperatorService)AopContext.currentProxy();
                    operatorService.saveBatch(operatorList);
                }
            }).sheet().doRead();
        } catch (IOException e) {
            throw new CustomException(ResultCodeEnum.FILE_IMPORT_ERROR);
        }
    }

    @Override
    public PageVO<OperatorPageVO> getOperatorByPageAndCondition(Long pageNum, Long pageSize, Integer operatorType, Integer operatorCategory) {
        PageVO<OperatorPageVO> pageVO = new PageVO<>();
        // 开启分页
        Page<Operator> page = new Page<>(pageNum, pageSize);
        // 准备条件
        LambdaQueryWrapper<Operator> lqw = new LambdaQueryWrapper<>();
        lqw.eq(operatorType != -1, Operator::getOperatorType, operatorType)
                .eq(operatorCategory != -1, Operator::getOperatorCategory, operatorCategory);
        Page<Operator> page1 = this.page(page, lqw);
        // 对象分装
        pageVO.setTotal(page1.getTotal());
        pageVO.setData(operatorConvert.po2OperatorPageVOList(page1.getRecords()));
        return pageVO;
    }

    @Override
    public OperatorEchoVO getOperatorById(Integer operatorId) {
        // 验证id是否存在
        Operator operator = BriupAssert.requireNotNull(
                this,
                Operator::getId,
                operatorId,
                ResultCodeEnum.DATA_NOT_EXIST);
        // 转换数据类型
        return operatorConvert.po2OperatorEchoVO(operator);
    }

    @Override
    public OperatorEchoVO modifyOperatorById(OperatorUpdateDTO dto) {
        // 算子必须存在
        BriupAssert.requireNotNull(
                this,
                Operator::getId,
                dto.getOperatorId(),
                ResultCodeEnum.DATA_NOT_EXIST);
        // 算子名称不能重复
        BriupAssert.requireNull(
                this,
                Operator::getOperatorName, dto.getOperatorName(),
                Operator::getId,dto.getOperatorId(),
                ResultCodeEnum.DATA_ALREADY_EXIST);
        // 将DTO转换为PO实体
        Operator operatorToUpdate = operatorConvert.operatorUpdateDTO2po(dto);
        // 更新数据库记录
        this.updateById(operatorToUpdate);
        // 返回更新后的数据（PO转换为EchoVO格式）
        return operatorConvert.po2OperatorEchoVO(operatorToUpdate);
    }

    @Override
    @Transactional
    public void removeOperatorById(Integer operatorId) {
        // 验证operatorId一定存在，如果不存在则抛出异常
        BriupAssert.requireNotNull(
                this,
                Operator::getId,
                operatorId,
                ResultCodeEnum.DATA_NOT_EXIST);
        // 根据operatorId删除对应的算子记录
        this.removeById(operatorId);
    }

    @Override
    @Transactional
    public void removeOperatorByIds(List<Integer> ids) {
        // 批量删除
        this.removeBatchByIds(ids);
    }

    @Override
    public Map<Integer, List<DropDownVO>> getOperatorDropDownList() {
        Map<Integer, List<DropDownVO>> map = new HashMap<>();
        // 接口要求数据全部返回，做页面刷新用
        // 遍历出当前有哪些category，这些category已经给在了enum里
        OperatorCategoryEnum.categoryList().forEach(
                category -> {
                    // 根据category查询该分类下的所有算子名称
                    LambdaQueryWrapper<Operator> lqw = new LambdaQueryWrapper<>();
                    lqw.eq(Operator::getOperatorCategory, category);
                    List<Operator> list = this.list(lqw);
                    List<DropDownVO> dropDownVOS = operatorConvert.po2DropDownList(list);
                    map.put(category, dropDownVOS);
                }
        );
        return map;
    }
}