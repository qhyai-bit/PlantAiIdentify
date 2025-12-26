package com.briup.pai.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.briup.pai.common.utils.ExcelUtils;
import com.briup.pai.convert.LogConvert;
import com.briup.pai.dao.LogMapper;
import com.briup.pai.entity.dto.LogExportDTO;
import com.briup.pai.entity.dto.LogQueryDTO;
import com.briup.pai.entity.po.Log;
import com.briup.pai.entity.vo.LogPageVO;
import com.briup.pai.entity.vo.PageVO;
import com.briup.pai.service.ILogService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class LogServiceImpl extends ServiceImpl<LogMapper, Log> implements ILogService {

    @Autowired
    private LogConvert logConvert;
    @Autowired
    private ExcelUtils excelUtils;

    @Override
    public PageVO<LogPageVO> getLogByPageAndCondition(Long pageNum, Long pageSize, LogQueryDTO logQueryDTO) {
        // 构建分页对象
        Page<Log> page = new Page<>(pageNum, pageSize);
        // 构建查询条件
        Page<Log> logPage = this.page(page, getLogQueryWrapper(logQueryDTO));
        // 封装
        PageVO<LogPageVO> result = new PageVO<>();
        result.setTotal(logPage.getTotal());
        result.setData(logConvert.po2LogQueryVOList(logPage.getRecords()));
        return result;
    }

    @Override
    public void exportExcel(LogQueryDTO logQueryDTO, HttpServletResponse response) {
        // 1.查询数据
        List<Log> list = this.list(getLogQueryWrapper(logQueryDTO));
        // 2.导出Excel
        List<LogExportDTO> logExportDTOS = logConvert.po2LogExportDTOList(list);
        excelUtils.exportExcel(response, logExportDTOS, LogExportDTO.class, "日志信息");
    }

    //封装一下日志模块的查询条件
    private LambdaQueryWrapper<Log> getLogQueryWrapper(LogQueryDTO logQueryDTO) {
        Integer type = logQueryDTO.getType();// 日志类型
        Integer isSuccess = logQueryDTO.getIsSuccess();// 是否成功
        Date startTime = logQueryDTO.getStartTime();// 开始时间
        Date endTime = logQueryDTO.getEndTime();// 结束时间
        LambdaQueryWrapper<Log> lqw = new LambdaQueryWrapper<>();
        lqw.eq(ObjectUtil.isNotNull( type),Log::getType, type)
                .eq(ObjectUtil.isNotNull( isSuccess),Log::getIsSuccess, isSuccess)
                .ge(ObjectUtil.isNotNull( startTime),Log::getOperateTime, startTime)
                .le(ObjectUtil.isNotNull( endTime),Log::getOperateTime, endTime)
                .orderByDesc(Log::getOperateTime);
        return lqw;
    }
}