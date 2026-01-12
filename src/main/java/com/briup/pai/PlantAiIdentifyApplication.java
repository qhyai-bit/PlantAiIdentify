package com.briup.pai;

import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@SpringBootApplication
// 暴露代理对象
@EnableAspectJAutoProxy(exposeProxy = true)
public class PlantAiIdentifyApplication {
    public static void main(String[] args) {
        SpringApplication.run(PlantAiIdentifyApplication.class, args);
    }

    @Bean
    public MessageConverter jsonMessageConverter(){
        return new Jackson2JsonMessageConverter();
    }
}