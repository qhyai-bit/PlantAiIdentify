package com.briup.pai.common.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 封装Redis相关操作
 */
@Component
public class RedisUtil {
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    /* key 的相关操作 */
    public   boolean exists(String key){
        return redisTemplate.hasKey(key);
    }

    public void delete(String key){
        redisTemplate.delete(key);
    }

    /* String类型数据的操作 */
    public void set(String key, Object value, int expireTime) {
        redisTemplate.opsForValue().set(key, value, expireTime, TimeUnit.SECONDS);
    }

    public Object get(String key){
        return redisTemplate.opsForValue().get(key);
    }
}
