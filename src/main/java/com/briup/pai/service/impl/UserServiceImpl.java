package com.briup.pai.service.impl;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.constant.AuthConstant;
import com.briup.pai.common.constant.LoginConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.UserStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.exception.CustomException;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.convert.UserConvert;
import com.briup.pai.dao.UserMapper;
import com.briup.pai.entity.dto.UserSaveDTO;
import com.briup.pai.entity.po.User;
import com.briup.pai.entity.po.UserRole;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.entity.vo.UserEchoVO;
import com.briup.pai.entity.vo.UserPageVO;
import com.briup.pai.service.IUserRoleService;
import com.briup.pai.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Objects;
import java.util.UUID;

@Service
@CacheConfig(cacheNames = AuthConstant.USER_CACHE_PREFIX)
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Autowired
    private IUserRoleService userRoleService;

    @Autowired
    private UserConvert userConvert;

    // 本地路径
    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;
    // URL server
    @Value("${upload.nginx-server}")
    private String nginxServer;

    @Override
    @Cacheable(key = "T(com.briup.pai.common.constant.AuthConstant).CREATE_USERNAME_CACHE_PREFIX+#userId")
    public String getUsernameById(Integer userId) {
        // 判断用户一定存在
        return BriupAssert.requireNotNull(
                this,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST).getUsername();
    }

    @Override
    public PageVO<UserPageVO> getUserByPageAndCondition(Long pageNum, Long pageSize, String keyword) {
        PageVO<UserPageVO> pageVO = new PageVO<>();
        Page<User> page = new Page<>(pageNum, pageSize);
        //查询的条件可以是账号、姓名或者手机号码
        LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<>();
        lqw.like(ObjectUtil.isNotNull(keyword),User::getUsername, keyword).or()
            .like(ObjectUtil.isNotNull(keyword),User::getRealName, keyword).or()
            .like(ObjectUtil.isNotNull(keyword),User::getTelephone, keyword);
        pageVO.setTotal(page(page, lqw).getTotal());
        pageVO.setData(userConvert.po2UserPageVOList(page(page,lqw).getRecords()));
        return pageVO;
    }

    @Override
    @Transactional
    @CachePut(key = "#result.userId")
    public UserEchoVO addOrModifyUser(UserSaveDTO dto) {
        Integer userId = dto.getUserId();
        User user;
        if (ObjectUtil.isNull(userId)) {
            // 新增用户
            // 验证用户名是否已存在
            BriupAssert.requireNull(
                    this,
                    User::getUsername,
                    dto.getUsername(),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            user = userConvert.userSaveDTO2Po(dto);
            user.setCreateTime(new Date());
            // 设置初始密码和头像
            user.setPassword(
                    DigestUtils.md5DigestAsHex(
                            LoginConstant.INIT_PASSWORD.getBytes(
                                    StandardCharsets.UTF_8)));
            user.setHeaderUrl(LoginConstant.INIT_HEADER_URL);
            this.save(user);
        } else {
            // 修改用户信息
            // 参数校验：用户必须存在、只能改自己的信息、用户名不能重复
            User temp = BriupAssert.requireNotNull(
                    this,
                    User::getId,
                    userId,
                    ResultCodeEnum.USER_NOT_EXIST
            );
            // 确保当前登录用户只能修改自己的信息
            BriupAssert.requireEqual(
                    SecurityUtil.getUserId(),
                    temp.getId(),
                    ResultCodeEnum.PARAM_VERIFY_ERROR
            );
            // 检查修改后的用户名是否与其他用户冲突
            BriupAssert.requireNull(
                    this,
                    User::getId,
                    temp.getId(),
                    User::getUsername,
                    dto.getUsername(),
                    ResultCodeEnum.DATA_ALREADY_EXIST
            );
            user = userConvert.userSaveDTO2Po(dto);
            this.updateById(user);
        }
        return userConvert.po2UserEchoVO(user);
    }

    @Override
    public String uploadProfilePicture(MultipartFile file) {
        // 验证文件类型
        BriupAssert.requirePic(file);
        // 修改图片的名字，以UUID的形式
        String newFileName = IdUtil.simpleUUID() + Objects.requireNonNull(file.getOriginalFilename()).substring(file.getOriginalFilename().lastIndexOf("."));
        // 转存图片
        try {
            file.transferTo(new File(nginxFilePath,newFileName));
        } catch (IOException e) {
            throw new CustomException(ResultCodeEnum.FILE_UPLOAD_ERROR);
        }
        // 返回图片的url
        return nginxServer + newFileName;
    }

    @Override
    @Cacheable(key = "#userId")
    public UserEchoVO getUserById(Integer userId) {
        // 根据用户ID查询用户信息，如果不存在则抛出异常
        User user = BriupAssert.requireNotNull(
                this,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        // 将用户实体转换为视图对象并返回
        return userConvert.po2UserEchoVO(user);
    }

    @Override
    public void resetPassword(Integer userId) {
        // 根据用户ID查找用户，若用户不存在则抛出异常
        User user = BriupAssert.requireNotNull(
                this,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        // 将用户密码重置为初始密码（MD5加密）
        user.setPassword(DigestUtils.md5DigestAsHex(LoginConstant.INIT_PASSWORD.getBytes(StandardCharsets.UTF_8)));
        // 更新用户信息
        this.updateById(user);
    }

    @Override
    @Caching(evict = {
            @CacheEvict(key = "#userId"),
    })
    public void removeUserById(Integer userId) {
        // 不能删自己，删除的用户必须存在
        BriupAssert.requireNotEqual(
                SecurityUtil.getUserId(),
                userId,
                ResultCodeEnum.DATA_CAN_NOT_DELETE
        );
        BriupAssert.requireNotNull(
                this,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        // 手动级联删除用户-角色关系表中的数据
        LambdaQueryWrapper<UserRole> lqw = new LambdaQueryWrapper<>();
        lqw.eq(UserRole::getUserId, userId);
        userRoleService.remove(lqw);
        // 删除用户
        this.removeById(userId);
    }

    @Override
    public void disableOrEnableUser(Integer userId, Integer status) {
        // 验证用户是否存在
        User user = BriupAssert.requireNotNull(
                this,
                User::getId,
                userId,
                ResultCodeEnum.USER_NOT_EXIST
        );
        // 不能操作自己的状态
        BriupAssert.requireNotEqual(
                SecurityUtil.getUserId(),
                userId,
                ResultCodeEnum.DISABLE_OR_ENABLE_ERROR
        );
        // 验证状态参数是否合法
        BriupAssert.requireIn(
                status,
                UserStatusEnum.statusList(),
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 如果目标状态与当前状态相同，则无需更新
        BriupAssert.requireNotEqual(
                user.getStatus(),
                status,
                ResultCodeEnum.PARAM_IS_ERROR
        );
        // 更新用户状态
        user.setStatus(status);
        this.updateById(user);
    }
}