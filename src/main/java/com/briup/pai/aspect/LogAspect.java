package com.briup.pai.aspect;

import cn.hutool.core.util.DesensitizedUtil;
import cn.hutool.core.util.ObjectUtil;
import com.alibaba.fastjson2.JSON;
import com.briup.pai.common.enums.LogTypeEnum;
import com.briup.pai.common.enums.RequestStatusEnum;
import com.briup.pai.common.result.Result;
import com.briup.pai.common.utils.IpUtil;
import com.briup.pai.common.utils.SecurityUtil;
import com.briup.pai.entity.dto.LoginWithPhoneDTO;
import com.briup.pai.entity.dto.LoginWithUsernameDTO;
import com.briup.pai.entity.po.Log;
import com.briup.pai.service.ILogService;
import com.briup.pai.service.IUserService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Date;

/**
 * 添加操作日志的切面类
 */
@Component
@Aspect
@Slf4j
public class LogAspect {

    @Resource
    private ILogService logService;
    @Resource
    private IUserService userService;
    @Resource
    private HttpServletRequest request;

    // 定义切入点(要求除去所有的查询方法，其余方法都需要添加日志)
    // 优化：以后所有的操作都列入到日志里，可以使用AI或者大数据分析操作行为，然后做优化
    @Pointcut("execution(* com.briup.pai.controller.*.*(..)) && !execution( * com.briup.pai.controller.*.get*(..))")
    public void pointCut() {
    }
    // 定义环绕通知
    @Around("pointCut()")
    public Result around(ProceedingJoinPoint joinPoint) {
        Result result;
        // 记录日志信息
        Log saveLog = new Log();
        // 开始时间
        Long startTime = System.currentTimeMillis();
        // 设置请求时间
        saveLog.setOperateTime(new Date());
        // 设置请求URI
        String requestURI = request.getRequestURI();
        saveLog.setRequestUri(requestURI);
        // 设置请求方式
        saveLog.setRequestMethod(request.getMethod());
        // 设置请求IP地址
        saveLog.setRequestIp(IpUtil.getIpAddress(request));
        // 被代理的方法名称
        String methodName = joinPoint.getSignature().getName();
        log.info("【日志模块】：本次请求的URI为：{}，请求的方法名称为：{}", requestURI, methodName);
        saveLog.setMethodName(methodName);
        // 判断是登录日志还是操作日志
        if (requestURI.contains("/login")) {
            // 登录日志
            saveLog.setType(LogTypeEnum.LOGIN.getType());
            // 判断是账密登录还是验证码登录(从参数中进行判断)
            // 设从方法中获取参数
            Object[] args = joinPoint.getArgs();
            // 判断args是否为空
            if (ObjectUtil.isNotEmpty(args)) {
                // 获取其中的第一个参数
                Object arg = joinPoint.getArgs()[0];
                // 判断arg的类型
                if (arg instanceof LoginWithUsernameDTO dto) {
                    // 用户名密码登录：需要对密码脱敏
                    // 准备一个新的对密码脱敏后的对象
                    LoginWithUsernameDTO loginWithUsernameDTO = new LoginWithUsernameDTO();
                    loginWithUsernameDTO.setUsername(dto.getUsername());
                    loginWithUsernameDTO.setPassword(DesensitizedUtil.password(dto.getPassword()));
                    // 添加json后的参数和用户名
                    saveLog.setRequestParams(JSON.toJSONString(loginWithUsernameDTO));
                    saveLog.setOperateUser(loginWithUsernameDTO.getUsername());
                    // 添加日志
                    log.info("【日志模块-登录日志-用户名密码登录】：本次请求的参数为：{},用户名为：{}", JSON.toJSONString(loginWithUsernameDTO), loginWithUsernameDTO.getUsername());
                } else if (arg instanceof LoginWithPhoneDTO dto) {
                    // 手机号登录：需要对手机号脱敏
                    LoginWithPhoneDTO loginWithPhoneDTO = new LoginWithPhoneDTO();
                    loginWithPhoneDTO.setTelephone(DesensitizedUtil.mobilePhone(dto.getTelephone()));
                    loginWithPhoneDTO.setCode(dto.getCode());
                    // 添加json后的参数和用户名
                    saveLog.setRequestParams(JSON.toJSONString(loginWithPhoneDTO));
                    saveLog.setOperateUser(loginWithPhoneDTO.getTelephone());
                    // 添加日志
                    log.info("【日志模块-登录日志-手机验证码登录】：本次请求的参数为：{},手机号为：{}", JSON.toJSONString(loginWithPhoneDTO), loginWithPhoneDTO.getTelephone());
                } else {
                    // 判断发送短信验证码：设置操作的用户为手机号（需要信息脱敏）
                    String telephone = (String) arg;
                    saveLog.setOperateUser(DesensitizedUtil.mobilePhone(telephone));
                    // 设置请求参数
                    saveLog.setRequestParams(JSON.toJSONString(telephone));
                    log.info("【日志模块-登录日志-发送手机验证码】：本次请求的参数为：{}，手机号为：{}", JSON.toJSONString(telephone), telephone);
                }
            } else {
                // 退出登录的逻辑: 只需要记录谁操作的即可
                saveLog.setOperateUser(userService.getUsernameById(SecurityUtil.getUserId()));
                log.info("【日志模块-登录日志-退出登录】");
            }
        } else {
            // 操作日志
            saveLog.setType(LogTypeEnum.OPERATION.getType());
            // 设置操作的用户名
            saveLog.setOperateUser(userService.getUsernameById(SecurityUtil.getUserId()));
            // 设置请求参数
            ArrayList<Object> validArgs = new ArrayList<>();
            for (Object arg : joinPoint.getArgs()) {
                // 1.需要过滤掉HttpServletResponse对象（否则导出excel时会报错）
                if(arg instanceof HttpServletResponse) continue;
                // 2.如果参数是MultipartFile类型，无法使用FastJSON序列化，请求参数就设置为文件类型名称
                if (arg instanceof MultipartFile file){
                    validArgs.add(file.getClass().getName());
                    continue;
                }
                validArgs.add(arg);
            }
            if (ObjectUtil.isNotEmpty(validArgs)){
                log.info("【日志模块-操作日志】：本次请求的参数为：{}", validArgs);
                saveLog.setRequestParams(JSON.toJSONString(validArgs));
            }
        }

        try {
            // 设置响应数据
            result = (Result) joinPoint.proceed();
            saveLog.setResponseData(JSON.toJSONString(result));
            // 设置是否成功
            saveLog.setIsSuccess(RequestStatusEnum.SUCCESS.getStatus());
        } catch (Throwable e) {
            // 设置失败
            saveLog.setIsSuccess(RequestStatusEnum.FAIL.getStatus());
            // 设置异常信息
            saveLog.setResponseData(e.getMessage());
            // 抛出异常（交给全局异常捕获）
            throw new RuntimeException(e);
        } finally {
            // 设置请求时间
            Long endTime = System.currentTimeMillis();
            saveLog.setRequestTime(endTime - startTime);
            saveLog.setOperateTime(new Date());
            // 保存日志
            logService.save(saveLog);
        }
        return result;
    }
}
