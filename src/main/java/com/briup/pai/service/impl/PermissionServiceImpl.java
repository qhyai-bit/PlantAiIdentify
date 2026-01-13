package com.briup.pai.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.enums.PermissionTypeEnum;
import com.briup.pai.convert.PermissionConvert;
import com.briup.pai.dao.PermissionMapper;
import com.briup.pai.entity.po.Permission;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.entity.vo.PermissionPageVO;
import com.briup.pai.service.IPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, Permission> implements IPermissionService {

    @Autowired
    private PermissionConvert permissionConvert;

    @Override
    public PageVO<PermissionPageVO> getPermissionByPage(Long pageNum, Long pageSize) {
        // 分页查询权限数据，构建目录 -> 菜单 -> 按钮的层级结构
        Page<Permission> page = new Page<>(pageNum, pageSize);
        PageVO<PermissionPageVO> pageVO = new PageVO<>();
        
        // 首先查询所有目录类型的权限
        LambdaQueryWrapper<Permission> lqw = new LambdaQueryWrapper<>();
        lqw.eq(Permission::getType, PermissionTypeEnum.CATALOGUE.getType());
        Page<Permission> cataloguePage = this.page(page, lqw);
        
        // 将目录转换为VO，并为其添加子级菜单
        List<PermissionPageVO> dataList = permissionConvert.po2PermissionPageVOList(cataloguePage.getRecords()).stream()
            .peek(permissionPageVO -> {
                // 查询当前目录下的菜单
                LambdaQueryWrapper<Permission> menuLqw = new LambdaQueryWrapper<>();
                menuLqw.eq(Permission::getParentId, permissionPageVO.getId())
                        .eq(Permission::getType, PermissionTypeEnum.MENU.getType());
                
                // 将菜单转换为VO，并为其添加子级按钮
                List<PermissionPageVO> menuList = permissionConvert.po2PermissionPageVOList(this.list(menuLqw))
                    .stream()
                    .peek(menu -> {
                        // 查询当前菜单下的按钮
                        LambdaQueryWrapper<Permission> buttonLqw = new LambdaQueryWrapper<>();
                        buttonLqw.eq(Permission::getParentId, menu.getId())
                                .eq(Permission::getType, PermissionTypeEnum.BUTTON.getType());
                        
                        // 获取按钮列表并设置为菜单的子节点
                        List<Permission> buttonList = this.list(buttonLqw);
                        menu.setChildren(permissionConvert.po2PermissionPageVOList(buttonList));
                    })
                    .toList();
                    
                // 设置目录的子节点为菜单列表
                permissionPageVO.setChildren(menuList);
            }).toList();

        // 设置分页结果
        pageVO.setTotal(cataloguePage.getTotal());
        pageVO.setData(dataList);
        return pageVO;
    }
}