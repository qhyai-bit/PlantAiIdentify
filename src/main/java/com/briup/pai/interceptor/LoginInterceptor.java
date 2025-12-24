package com.briup.pai.interceptor;

import com.briup.pai.common.constant.LoginConstant;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.utils.JwtUtil;
import com.briup.pai.common.utils.SecurityUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登陆拦截器
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        // 放行预检请求
        if (request.getMethod().equals("OPTIONS")) return true;
        // 从请求头中获取JWT令牌
        String token = request.getHeader(LoginConstant.TOKEN_NAME);
        // 验证token是否为空
        BriupAssert.requireNotNull(token, ResultCodeEnum.USER_NOT_LOGIN);

        // 验证token是否有效
        Integer userId = JwtUtil.getUserId(token);
        // 解析token中的userId存入到session里（后面会优化）
//        HttpSession session = request.getSession();
//        session.setAttribute("userId", userId);

        // 优化：放到ThreadLocal里
        SecurityUtil.setUserId(userId);
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) throws Exception {
        // 视图渲染完成之后，删除ThreadLocal中的数据
        SecurityUtil.removeUserId();
    }
}