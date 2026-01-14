package com.briup.pai.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.AuthConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.convert.RoleConvert;
import com.briup.pai.dao.RoleMapper;
import com.briup.pai.entity.dto.RoleSaveDTO;
import com.briup.pai.entity.po.Role;
import com.briup.pai.entity.po.RolePermission;
import com.briup.pai.entity.po.UserRole;
import com.briup.pai.entity.vo.RoleQueryVO;
import com.briup.pai.service.IRolePermissionService;
import com.briup.pai.service.IRoleService;
import com.briup.pai.service.IUserRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = AuthConstant.USER_CACHE_PREFIX)
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    @Autowired
    private IRolePermissionService rolePermissionService;
    @Autowired
    private IUserRoleService userRoleService;

    @Autowired
    private RoleConvert roleConvert;

    @Override
    @Cacheable(key = "T(com.briup.pai.common.constant.CommonConstant).LIST_CACHE_PREFIX")
    public List<RoleQueryVO> getAllRoles() {
        // 查询所有角色并转换为查询视图对象列表
        return roleConvert.po2RoleQueryVOList(this.list());
    }

    @Override
    @Caching(put = @CachePut(key = "#result.roleId"),
            evict = {
            @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).LIST_CACHE_PREFIX"),
            @CacheEvict(cacheNames = AuthConstant.AUTH_CACHE_PREFIX,
                            key = "T(com.briup.pai.common.constant.AuthConstant).GET_ALL_ROLES_CACHE_KEY")
    })
    public RoleQueryVO addOrModifyRole(RoleSaveDTO roleSaveDTO) {
        Integer roleId = roleSaveDTO.getRoleId();
        Role role;
        if (ObjectUtil.isNull(roleId)){
            // 新增角色 - 检查角色名称是否已存在
            BriupAssert.requireNull(
                    this,
                    Role::getRoleName,
                    roleSaveDTO.getRoleName(),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            role = roleConvert.roleSaveDTO2Po(roleSaveDTO);
            this.save(role);
        } else {
            // 修改角色 - 首先验证角色是否存在
            Role temp = BriupAssert.requireNotNull(
                    this,
                    Role::getId,
                    roleId,
                    ResultCodeEnum.DATA_NOT_EXIST
            );
            // 检查新角色名称是否与其他已有角色冲突
            BriupAssert.requireNull(
                    this,
                    Role::getRoleName,
                    roleSaveDTO.getRoleName(),
                    Role::getId,
                    temp.getId(),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            role = roleConvert.roleSaveDTO2Po(roleSaveDTO);
            this.updateById(role);
        }
        return roleConvert.po2RoleQueryVO(role);
    }

    @Override
    @Cacheable(key = "#roleId")
    public RoleQueryVO getRoleById(Integer roleId) {
        // 根据角色ID查询角色信息，如果不存在则抛出异常
        Role role = BriupAssert.requireNotNull(
                this,
                Role::getId,
                roleId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 将查询到的角色实体转换为查询视图对象并返回
        return roleConvert.po2RoleQueryVO(role);
    }

    @Override
    @Caching(evict = {
            @CacheEvict(key = "#roleId"),
            @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).LIST_CACHE_PREFIX"),
            @CacheEvict(cacheNames = AuthConstant.AUTH_CACHE_PREFIX, allEntries = true)
    })
    public void removeRoleById(Integer roleId) {
        // 验证角色是否存在
        BriupAssert.requireNotNull(
                this,
                Role::getId,
                roleId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        
        // 删除用户-角色关联关系
        LambdaQueryWrapper<UserRole> userRoleQueryWrapper = new LambdaQueryWrapper<>();
        userRoleQueryWrapper.eq(UserRole::getRoleId, roleId);
        userRoleService.remove(userRoleQueryWrapper);

        // 删除角色-权限关联关系
        LambdaQueryWrapper<RolePermission> rolePermissionQueryWrapper = new LambdaQueryWrapper<>();
        rolePermissionQueryWrapper.eq(RolePermission::getRoleId, roleId);
        rolePermissionService.remove(rolePermissionQueryWrapper);
        
        // 删除角色本身
        this.removeById(roleId);
    }
}