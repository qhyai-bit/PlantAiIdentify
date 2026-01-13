package com.briup.pai.service.impl;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.briup.pai.common.enums.PermissionTypeEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.convert.PermissionConvert;
import com.briup.pai.convert.RoleConvert;
import com.briup.pai.entity.dto.AssignPermissionDTO;
import com.briup.pai.entity.dto.AssignRoleDTO;
import com.briup.pai.entity.po.*;
import com.briup.pai.entity.vo.AssignPermissionVO;
import com.briup.pai.entity.vo.AssignRoleVO;
import com.briup.pai.entity.vo.MetaVO;
import com.briup.pai.entity.vo.RouterVO;
import com.briup.pai.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

@Service
public class AuthServiceImpl implements IAuthService {
    @Autowired
    private IRoleService roleService;
    @Autowired
    private IUserService userService;
    @Autowired
    private IUserRoleService userRoleService;
    @Autowired
    private IPermissionService permissionService;
    @Autowired
    private IRolePermissionService rolePermissionService;

    @Autowired
    private RoleConvert roleConvert;
    @Autowired
    private PermissionConvert permissionConvert;

    @Override
    public List<AssignRoleVO> getAllRoles() {
        // 查询所有角色并转换为AssignRoleVO列表返回
        return roleConvert.po2AssignRoleVOList(roleService.list());
    }

    @Override
    public List<Integer> getRoleIdsByUserId(Integer userId) {
        // 根据userId查询RoleId的list
        BriupAssert.requireNotNull(
                userService,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        LambdaQueryWrapper<UserRole> lqw = new LambdaQueryWrapper<>();
        lqw.eq(UserRole::getUserId, userId);
        List<UserRole> list = userRoleService.list(lqw);
        return new ArrayList<>(
                list.stream().map(UserRole::getRoleId).toList()
        );
    }

    @Override
    public void assignRole(AssignRoleDTO dto) {
        // 参数校验
        Integer userId = dto.getUserId();
        List<Integer> roleIds = dto.getRoleIds();
        BriupAssert.requireNotNull(
                userService,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        List<Integer> list = roleService.list().stream().map(Role::getId).toList();
        // 验证roleIds里的每个roleId在不在数据库中
        BriupAssert.requireTrue(
                CollectionUtil.containsAll(list, roleIds),
                ResultCodeEnum.DATA_NOT_EXIST
        );
        BriupAssert.requireNotEqual(
                userId,
                SecurityUtil.getUserId(),
                ResultCodeEnum.ASSIGN_ROLE_ERROR
        );
        // 删除当前用户id之前的角色关联
        LambdaQueryWrapper<UserRole> lqw = new LambdaQueryWrapper<>();
        lqw.eq(UserRole::getUserId, userId);
        userRoleService.remove(lqw);
        // 重新插入新的角色-角色关联关系
        List<UserRole> newRoleList = roleIds.stream().map(roleId -> {
            UserRole userRole = new UserRole();
            userRole.setUserId(userId);
            userRole.setRoleId(roleId);
            return userRole;
        }).toList();
        userRoleService.saveBatch(newRoleList);
    }

    @Override
    public List<AssignPermissionVO> getAllPermissions() {
        // 查询所有目录类型的权限，按排序字段升序排列
        LambdaQueryWrapper<Permission> permissionWrapper = new LambdaQueryWrapper<>();
        permissionWrapper
                .eq(Permission::getType, PermissionTypeEnum.CATALOGUE.getType())
                .orderByAsc(Permission::getSort);
        
        // 将目录权限转换为AssignPermissionVO对象，并为每个目录构建其子级结构
        List<AssignPermissionVO> list = permissionConvert.po2AssignPermissionVOList(
                permissionService.list(permissionWrapper)
        ).stream().peek(catalogue -> {
            // 查询当前目录下的所有菜单权限
            permissionWrapper.clear();
            permissionWrapper
                    .eq(Permission::getType, PermissionTypeEnum.MENU.getType())
                    .eq(Permission::getParentId, catalogue.getPermissionId())
                    .orderByAsc(Permission::getSort);
            List<AssignPermissionVO> menus = permissionConvert.po2AssignPermissionVOList(
                    permissionService.list(permissionWrapper)
            );
            
            // 为每个菜单添加其对应的按钮权限
            menus.forEach(menu -> {
                permissionWrapper.clear();
                permissionWrapper
                        .eq(Permission::getType, PermissionTypeEnum.BUTTON.getType())
                        .eq(Permission::getParentId, menu.getPermissionId())
                        .orderByAsc(Permission::getSort);
                // 查询并设置菜单下的按钮权限作为菜单的子节点
                menu.setChildren(permissionConvert.po2AssignPermissionVOList(permissionService.list(permissionWrapper)));
            });
            // 将菜单及其按钮权限设置为目录的子节点
            catalogue.setChildren(menus);
        }).toList();
        
        // 返回结果包装为ArrayList类型
        return new ArrayList<>(list);
    }

    @Override
    public List<Integer> getPermissionIdsByRoleId(Integer roleId) {
        // 根据角色ID获取该角色拥有的所有权限中，类型为按钮的权限ID列表
        BriupAssert.requireNotNull(
                roleService,
                Role::getId,
                roleId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        LambdaQueryWrapper<RolePermission> lqw = new LambdaQueryWrapper<>();
        lqw.eq(RolePermission::getRoleId, roleId);
        return rolePermissionService.list(lqw).stream()
                .map(rolePermission -> permissionService.getById(rolePermission.getPermissionId()))
                .filter(permission -> PermissionTypeEnum.BUTTON.getType().equals(permission.getType()))
                .map(Permission::getId)
                .toList();
    }

    @Override
    public void assignPermission(AssignPermissionDTO dto) {
        // 获取参数
        Integer roleId = dto.getRoleId();
        List<Integer> permissionIds = dto.getPermissionIds();
        
        // 验证角色是否存在
        Role role = BriupAssert.requireNotNull(
                roleService,
                Role::getId,
                roleId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        
        // 验证权限ID是否都存在于数据库中
        List<Integer> allPermissionIds = permissionService.list().stream().map(Permission::getId).toList();
        BriupAssert.requireTrue(
                CollectionUtil.containsAll(allPermissionIds, permissionIds),
                ResultCodeEnum.DATA_NOT_EXIST
        );
        
        // 删除该角色现有的权限分配
        LambdaQueryWrapper<RolePermission> lqw = new LambdaQueryWrapper<>();
        lqw.eq(RolePermission::getRoleId, roleId);
        rolePermissionService.remove(lqw);
        
        // 批量保存新的权限分配关系
        List<RolePermission> newPermissionList = permissionIds.stream().map(permissionId -> {
            RolePermission rolePermission = new RolePermission();
            rolePermission.setPermissionId(permissionId);
            rolePermission.setRoleId(roleId);
            return rolePermission;
        }).toList();
        rolePermissionService.saveBatch(newPermissionList);
    }

    @Override
    public List<RouterVO> getRouter(Integer userId) {
        List<RouterVO> routerVOList = new ArrayList<>();
        // 获取用户拥有的角色ID列表
        this.getRoleIdsByUserId(userId).forEach(roleId -> {
            // 查询该角色拥有的权限ID列表
            LambdaQueryWrapper<RolePermission> rolePermissionWrapper = new LambdaQueryWrapper<>();
            rolePermissionWrapper.eq(RolePermission::getRoleId, roleId);
            List<Integer> permissionIdList = rolePermissionService
                    .list(rolePermissionWrapper)
                    .stream()
                    .map(RolePermission::getPermissionId)
                    .toList();
            
            // 筛选出目录类型的权限
            List<Permission> catalogues = permissionIdList
                    .stream()
                    .map(permissionId -> permissionService.getById(permissionId))
                    .filter(permission -> ObjectUtil.equal(permission.getType(), PermissionTypeEnum.CATALOGUE.getType()))
                    .toList();
            
            // 遍历目录，构建目录路由信息
            catalogues.forEach(catalogue -> {
                // 创建目录路由对象
                RouterVO catalogueRouter = this.buildRouterVO(catalogue);
                
                // 筛选出属于当前目录的菜单类型权限
                List<Permission> menus = permissionIdList
                        .stream()
                        .map(permissionId -> permissionService.getById(permissionId))
                        .filter(permission -> 
                            ObjectUtil.equal(permission.getType(), PermissionTypeEnum.MENU.getType()) && 
                            ObjectUtil.equal(permission.getParentId(), catalogue.getId()))
                        .toList();
                
                // 将菜单转换为子路由并设置到目录路由中
                List<RouterVO> children = menus.stream()
                        .map(this::buildRouterVO)
                        .toList();
                catalogueRouter.setChildren(children);
                
                // 添加到路由列表
                routerVOList.add(catalogueRouter);
            });
        });
        return routerVOList;
    }

    @Override
    public List<String> getUserButtonPermissionList(Integer userId) {
        return List.of();
    }

    /**
     * 构建路由视图对象
     * @param permission 权限实体对象
     * @return 路由视图对象，包含路径、组件、隐藏状态和元数据等信息
     */
    private RouterVO buildRouterVO(Permission permission) {
        RouterVO routerVO = new RouterVO();
        // 设置路由的基本属性
        routerVO.setPath(permission.getPath());
        routerVO.setComponent(permission.getComponent());
        routerVO.setHidden(ObjectUtil.equal(permission.getHidden(), 1));
        
        // 如果标题或图标不为空，则设置元数据
        if (StringUtils.hasText(permission.getTitle()) || StringUtils.hasText(permission.getIcon())) {
            MetaVO metaVO = new MetaVO();
            metaVO.setTitle(permission.getTitle());
            metaVO.setIcon(permission.getIcon());
            routerVO.setMeta(metaVO);
        }
        return routerVO;
    }
}