package com.briup.pai.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.DictionaryConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.convert.DictionaryConvert;
import com.briup.pai.dao.DictionaryMapper;
import com.briup.pai.entity.dto.DictionarySaveDTO;
import com.briup.pai.entity.po.Dictionary;
import com.briup.pai.entity.vo.DictionaryEchoVO;
import com.briup.pai.entity.vo.DictionaryPageVO;
import com.briup.pai.entity.vo.DropDownVO;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.service.IDictionaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class DictionaryServiceImpl extends ServiceImpl<DictionaryMapper, Dictionary> implements IDictionaryService {
    @Autowired
    DictionaryMapper dictionaryMapper;
    @Autowired
    DictionaryConvert dictionaryConvert;
    @Override
    public DictionaryEchoVO addOrModifyDictionary(DictionarySaveDTO dto) {
        // 从dto中获取信息
        Integer dictId = dto.getDictId();
        String dictCode = dto.getDictCode();
        String dictValue = dto.getDictValue();
        Integer parentId = dto.getParentId();
        // 准备返回的数据
        Dictionary dictionary = null;
        // 判断新增还有修改
        if (ObjectUtil.isNull(dictId)){
            // 新增
            // 字典编码不能重复(dictCode)
            BriupAssert.requireNull(
                    this,
                    Dictionary::getDictCode,
                    dictCode,
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            // 要求父id符合条件，如果是二级字典，需要添加到已有的一级字典
            if (!Objects.equals(parentId, DictionaryConstant.PARENT_DICTIONARY_ID)) {
                BriupAssert.requireIn(
                        parentId,
                        getParentDictIdList(),
                        ResultCodeEnum.PARAM_IS_ERROR
                );
                // dtp -> po
                dictionary = dictionaryConvert.dictionarySaveDTO2PO(dto);
                dictionaryMapper.insert(dictionary);
            }
        }else {
            // 修改
            // 要修改的字典必须存在
            Dictionary tmp = BriupAssert.requireNotNull(
                    this,
                    Dictionary::getId,
                    dictId,
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            // code不能改变，要求与数据库里保持的必须一样
            BriupAssert.requireEqual(
                    tmp.getDictCode(),
                    dictCode,
                    ResultCodeEnum.PARAM_IS_ERROR
            );

            dictionary = dictionaryConvert.dictionarySaveDTO2PO(dto);
            dictionaryMapper.updateById(dictionary);
        }
        // 返回数据 po -> echoVo
        return dictionaryConvert.po2DictionaryEchoVO(dictionary);
    }

    @Override
    public DictionaryEchoVO getDictionaryById(Integer dictionaryId) {
        // 验证一下该dictionary一定存在
        // 根据id查询信息
        return dictionaryConvert.po2DictionaryEchoVO(
                BriupAssert.requireNotNull(
                this,
                Dictionary::getId,
                dictionaryId,
                ResultCodeEnum.DATA_NOT_EXIST
        ));
    }

    @Override
    public void removeDictionaryById(Integer dictionaryId) {
        // 验证一下该dictionary一定存在
        Dictionary dictionary = BriupAssert.requireNotNull(
                this,
                Dictionary::getId,
                dictionaryId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 获取该dictionary的parentId
        Integer parentId = dictionary.getParentId();
        LambdaQueryWrapper<Dictionary> lqw = new LambdaQueryWrapper<>();
        if (Objects.equals(parentId, DictionaryConstant.PARENT_DICTIONARY_ID)) {
            // 一级字典
            // 要级联删除下面的二级字典
            dictionaryMapper.deleteById(dictionaryId);
            lqw.eq(Dictionary::getParentId, dictionaryId);
            dictionaryMapper.delete(lqw);
        }else {
            // 二级字典
            // 删除之后，判断该一级字典下是否有数据，如果没有，删除一级字典
            this.removeById(dictionaryId);
            lqw.clear();
            lqw.eq(Dictionary::getParentId, parentId);
            if (this.count(lqw) == 0L) {
                this.removeById(parentId);
            }
        }
    }

    @Override
    public PageVO<DictionaryPageVO> getDictionaryByPage(Long pageNum, Long pageSize) {
        PageVO<DictionaryPageVO> pageVO = new PageVO<>();
        // 开始分页
        Page<Dictionary> page = new Page<>(pageNum, pageSize);
        // 查询所有的一级字典，做分页
        LambdaQueryWrapper<Dictionary> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Dictionary::getParentId, DictionaryConstant.PARENT_DICTIONARY_ID);
        Page<Dictionary> first = this.page(page, lqw);
        pageVO.setTotal(first.getTotal());
        // 根据一级字典，查询其中的二级字典
        List<DictionaryPageVO> list = dictionaryConvert.po2DictionaryPageVOList(first.getRecords())
                .stream().peek(dictionaryPageVO -> {
                    lqw.clear();// 清空查询条件
                    lqw.eq(Dictionary::getParentId, dictionaryPageVO.getDictId());
                    dictionaryPageVO.setChildren(
                            dictionaryConvert.po2DictionaryPageVOList(
                                    this.list(lqw))
                    );
                }).toList();
        pageVO.setData(list);
        return pageVO;
    }

    @Override
    public List<DropDownVO> getDropDownList(String dictCode) {
        // 验证dictionary必须存在
        Dictionary dictionary = BriupAssert.requireNotNull(
                this,
                Dictionary::getDictCode,
                dictCode,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 必须是一级数据字典，和getParentDictIdList进行比对
        BriupAssert.requireIn(
                dictionary.getId(),
                getParentDictIdList(),
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 查询该一级字典下所有的二级字典用于返回
        LambdaQueryWrapper<Dictionary> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Dictionary::getParentId, dictionary.getId());
        List<Dictionary> list = this.list(lqw);
        return dictionaryConvert.po2DictionaryDropDownVOList(list);
    }

    @Override
    public String getDictionaryValueById(Integer dictionaryId) {
        return "";
    }

    // --------------- 以下方法为完善逻辑的私有方法

    /**
     * 获取所有的parentId列表
     * @return
     */
    private List<Integer> getParentDictIdList() {
        // select * from sys_dictionary where parent_id = 0
        LambdaQueryWrapper<Dictionary> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Dictionary::getParentId, DictionaryConstant.PARENT_DICTIONARY_ID);
        return dictionaryMapper.selectList(lqw)
                .stream().map(Dictionary::getId).toList();
    }
}