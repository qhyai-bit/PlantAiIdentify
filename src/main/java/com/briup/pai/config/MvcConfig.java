package com.briup.pai.config;

import com.briup.pai.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfig implements WebMvcConfigurer {
    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 配置拦截器，对登录相关接口、Swagger文档接口和静态资源等路径进行放行
        String[] excludePaths = {
                "/login/withUsername",          // 用户名登录接口
                "/login/withTelephone",         // 手机号登录接口
                "/login/sendMessageCode",       // 发送短信验证码接口
                "/doc.html",                    // API文档页面
                "/swagger-resources/**",        // Swagger资源
                "/webjars/**",                  // Swagger静态资源
                "/v3/api-docs/**",              // OpenAPI 3文档
                "/icons/icon_zh_48.png",        // 网站图标
                "/favicon.ico"                  // 网站图标
        };
        // 将登录拦截器添加到拦截器链中，拦截所有请求路径，但排除上面定义的路径
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")         // 拦截所有请求
                .excludePathPatterns(excludePaths); // 排除不需要拦截的路径
    }
}