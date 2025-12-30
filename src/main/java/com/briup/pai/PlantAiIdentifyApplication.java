package com.briup.pai;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@SpringBootApplication
// 暴露代理对象
@EnableAspectJAutoProxy(exposeProxy = true)
public class PlantAiIdentifyApplication {
    public static void main(String[] args) {
        SpringApplication.run(PlantAiIdentifyApplication.class, args);
    }
}