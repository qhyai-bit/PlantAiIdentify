package com.briup.pai.service.impl;

import com.briup.pai.common.constant.LoginConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.UserStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.JwtUtil;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.convert.UserConvert;
import com.briup.pai.entity.dto.LoginWithPhoneDTO;
import com.briup.pai.entity.dto.LoginWithUsernameDTO;
import com.briup.pai.entity.po.User;
import com.briup.pai.entity.vo.CurrentLoginUserVO;
import com.briup.pai.service.ILoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Service
public class LoginServiceImpl implements ILoginService {

    @Autowired
    private UserServiceImpl userService;
    @Autowired
    private UserConvert userConvert;

    @Override
    public String loginWithUsername(LoginWithUsernameDTO dto) {

        // 不需要验证dto中的内容是否为空
        String password = dto.getPassword();
        String username = dto.getUsername();
        // 先通过用户名进行查询，BriupAssert
        User user = BriupAssert.requireNotNull(
                userService,
                User::getUsername,
                dto.getUsername(),
                ResultCodeEnum.USER_NOT_EXIST);
        // 接着比对密码
        BriupAssert.requireEqual(
                DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8)),
                user.getPassword(),
                ResultCodeEnum.PASSWORD_IS_WRONG);
        // 该账户是不能禁用的
        BriupAssert.requireEqual(
                UserStatusEnum.AVAILABLE.getStatus(),
                user.getStatus(),
                ResultCodeEnum.USER_LOGIN_EXPIRATION);
        // 成功之后返回JWT字符串(JwtUtil),数据仅保存UserID即可
        Map<String,Object> claims = new HashMap<>();
        claims.put(LoginConstant.JWT_PAYLOAD_KEY,user.getId());
        // 完成之后编写Login的拦截器 LoginInterceptor，配置拦截器，配置类WebMvcConfig

        return JwtUtil.generateJwt(claims);
    }

    @Override
    public CurrentLoginUserVO getCurrentUser() {
        // ThreadLocal 来获取当前登录用户的信息
        Integer userId = SecurityUtil.getUserId();// 获取当前登录用户ID
        User user = userService.getById(userId);// 查询当前登录用户
        return userConvert.po2CurrentLoginUserVO(user);// 转换对象返回（此处先不考虑路由和权限信息，只获取用户基本信息）
    }

    @Override
    public void sendMessageCode(String telephone) {

    }

    @Override
    public String loginWithTelephone(LoginWithPhoneDTO dto) {
        return "";
    }
}