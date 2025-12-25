package com.briup.pai.service.impl;

import cn.hutool.core.util.RandomUtil;
import com.briup.pai.common.constant.LoginConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.UserStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.JwtUtil;
import com.briup.pai.common.utils.MessageUtil;
import com.briup.pai.common.utils.RedisUtil;
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
    @Autowired
    private RedisUtil redisUtil;

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
        // 设置验证码在redis存储的时间和key
        String key = LoginConstant.USER_SMS_VERIFY_CODE_PREFIX + telephone;
        int expirationTime = LoginConstant.USER_SMS_VERIFY_CODE_EXPIRATION_TIME;
        // 验证手机号有效：用户存在、用户不禁用、该手机号在redis中没有保存的验证码
        User user = BriupAssert.requireNotNull(
                userService,
                User::getTelephone,
                telephone,
                ResultCodeEnum.USER_NOT_EXIST);
        BriupAssert.requireEqual(
                UserStatusEnum.AVAILABLE.getStatus(),
                user.getStatus(),
                ResultCodeEnum.USER_IS_DISABLED);
        BriupAssert.requireFalse(
                redisUtil.exists(key),
                ResultCodeEnum.USER_VERIFY_CODE_ALREADY_EXIST);
        // 生成验证码(四位数字)
        int code = RandomUtil.randomInt(1000, 9999);
        // 发送短信
        MessageUtil.sendMessage(telephone, code);
        // 保存到Redis中
        redisUtil.set(key,code, expirationTime);
    }

    @Override
    public String loginWithTelephone(LoginWithPhoneDTO dto) {
        // 获取数据
        String telephone = dto.getTelephone();
        Integer code = dto.getCode();
        String key = LoginConstant.USER_SMS_VERIFY_CODE_PREFIX + telephone;
        // 校验数据：用户必须存在、用户不能被禁用、验证码必须存在、验证码比对有效
        User user = BriupAssert.requireNotNull(
                userService,
                User::getTelephone,
                telephone,
                ResultCodeEnum.USER_NOT_EXIST);
        BriupAssert.requireEqual(
                UserStatusEnum.AVAILABLE.getStatus(),
                user.getStatus(),
                ResultCodeEnum.USER_IS_DISABLED);
        BriupAssert.requireTrue(
                redisUtil.exists(key),
                ResultCodeEnum.USER_VERIFY_CODE_NOT_EXIST);
        BriupAssert.requireEqual(
                redisUtil.get(key),
                code,
                ResultCodeEnum.USER_VERIFY_CODE_ERROR);
        // 意味着登录成功，从redis中删除验数据
        redisUtil.delete(key);
        // 根据userId生成Jwt字符串返回
        Map<String,Object> claims = new HashMap<>();
        claims.put(LoginConstant.JWT_PAYLOAD_KEY,user.getId());
        return JwtUtil.generateJwt(claims);
    }
}