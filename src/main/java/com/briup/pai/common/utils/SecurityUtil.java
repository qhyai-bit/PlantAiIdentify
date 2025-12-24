package com.briup.pai.common.utils;

/**
 * 使用ThreadLocal存储当前登录用户信息
 * 完成set、get、remove方法
 */
public class SecurityUtil {
    // 提供一个保存Integer类型的id的ThreadLocal对象
    private static final ThreadLocal<Integer> tl = new ThreadLocal<>();
    
    /**
     * 获取当前登录用户的ID
     * @return 用户ID，如果未登录则返回null
     */
    public static Integer getUserId() {
        return tl.get();
    }

    /**
     * 设置当前登录用户的ID
     * 只有在当前未设置用户ID时才进行设置
     * @param id 用户ID
     */
    public static void setUserId(Integer id) {
        if(getUserId() == null) {
            tl.set(id);
        }
    }

    /**
     * 移除当前存储的用户ID
     * 通常在用户登出时调用
     */
    public static void removeUserId() {
        tl.remove();
    }
}