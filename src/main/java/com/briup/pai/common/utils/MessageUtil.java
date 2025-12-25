package com.briup.pai.common.utils;

import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.teaopenapi.models.Config;
import com.aliyun.teautil.models.RuntimeOptions;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.exception.CustomException;
import lombok.Data;
import org.springframework.stereotype.Component;

@Component
@Data
public class MessageUtil {

    private static final String SIGN_NAME = "阿里云短信测试";
    private static final String TEMPLATE_CODE = "SMS_329385080";
    private static final String ACCESS_KEY_ID = "LTAI5tRtLa9RMfvpcH9foex5";
    private static final String ACCESS_KEY_SECRET = "KgYRDKo7Pym05USPLS0D21TBBQauc5";
    private static final String ENDPOINT = "dysmsapi.aliyuncs.com";

    public static void sendMessage(String telephone, int code) {
        try {
            // 创建配置信息
            Config config = new Config()
                    .setAccessKeyId(ACCESS_KEY_ID)
                    .setAccessKeySecret(ACCESS_KEY_SECRET)
                    .setEndpoint(ENDPOINT);
            // 创建客户端对象
            Client client = new Client(config);
            // 创建发送消息请求对象
            SendSmsRequest sendSmsRequest = new SendSmsRequest()
                    .setSignName(SIGN_NAME)
                    .setTemplateCode(TEMPLATE_CODE)
                    .setPhoneNumbers(telephone)
                    .setTemplateParam("{\"code\":" + code + "}");
            RuntimeOptions runtimeOptions = new RuntimeOptions();
            // 发送消息
            client.sendSmsWithOptions(sendSmsRequest, runtimeOptions);
        } catch (Exception e) {
            throw new CustomException(ResultCodeEnum.MESSAGE_SEND_ERROR);
        }
    }
}