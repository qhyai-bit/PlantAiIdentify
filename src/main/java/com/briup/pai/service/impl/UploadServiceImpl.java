package com.briup.pai.service.impl;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.CharsetUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.ZipUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.briup.pai.common.constant.DatasetConstant;
import com.briup.pai.common.enums.DatasetStatusEnum;
import com.briup.pai.common.enums.ResultCodeEnum;
import com.briup.pai.common.enums.UploadStatusEnum;
import com.briup.pai.common.exception.BriupAssert;
import com.briup.pai.common.exception.CustomException;
import com.briup.pai.convert.FileChunkConvert;
import com.briup.pai.convert.FileInfoConvert;
import com.briup.pai.entity.dto.UploadChunkDTO;
import com.briup.pai.entity.dto.UploadVerifyFileDTO;
import com.briup.pai.entity.po.*;
import com.briup.pai.entity.vo.UploadVerifyFileVO;
import com.briup.pai.service.*;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.*;

@Service
@CacheConfig(cacheNames = DatasetConstant.DATASET_CACHE_PREFIX)
public class UploadServiceImpl implements IUploadService {

    @Autowired
    private IDatasetService datasetService;
    @Autowired
    private IFileInfoService fileInfoService;
    @Autowired
    private IFileChunkService fileChunkService;
    @Autowired
    private IClassifyService classifyService;
    @Autowired
    private IEntityService entityService;

    @Value("${upload.nginx-file-path}")
    private String nginxFilePath;
    @Value("${upload.file-directory-name}")
    private String fileDirectoryName;
    @Value("${upload.chunk-directory-name}")
    private String chunkDirectoryName;

    @Autowired
    private FileInfoConvert fileInfoConvert;
    @Autowired
    private FileChunkConvert fileChunkConvert;

    @Override
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    public void modifyDatasetStatus(Integer datasetId, Integer status) {
        // 参数校验：数据集必须存在、状态值必须有效、修改状态值不能和原来一样
        Dataset dataset = BriupAssert.requireNotNull(
                datasetService,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST);
        BriupAssert.requireIn(
                status,
                DatasetStatusEnum.statusList(),
                ResultCodeEnum.PARAM_IS_ERROR);
        BriupAssert.requireNotEqual(
                status,
                dataset.getDatasetStatus(),
                ResultCodeEnum.DATASET_STATUS_ERROR);
        // 设置新的状态值并更新到数据库
        dataset.setDatasetStatus(status);
        datasetService.updateById(dataset);
    }

    @Override
    @Transactional
    public UploadVerifyFileVO verifyFile(UploadVerifyFileDTO dto) {
        // 初始化返回对象，默认认为文件已上传完成
        UploadVerifyFileVO uploadVerifyFileVO = new UploadVerifyFileVO();
        uploadVerifyFileVO.setUploaded(true);
        // 查询FileInfo的信息，判断文件有没有上传过
        LambdaQueryWrapper<FileInfo> lqw = new LambdaQueryWrapper<>();
        lqw.eq(FileInfo::getFileHash, dto.getFileHash());
        FileInfo fileInfo = fileInfoService.getOne(lqw);
        if (ObjectUtil.isNull(fileInfo)){
            // 情况1: 文件没有被上传过
            // 需要完成的操作：创建文件夹、数据库里记录当前的文件信息
            uploadVerifyFileVO.setUploaded(false);
            String fileInfoDirectory = createFileInfoDirectory(dto.getFileHash());
            Long chunkSize = dto.getChunkSize();
            Long fileSize = dto.getFileSize();
            // 转换对象
            fileInfo = fileInfoConvert.uploadVerifyFileDTO2Po(dto);
            // 手动计算一些数据，比如chunkNum => 如果整除就用商，如果不能整除就用商+1
            long chunkNum = fileSize % chunkSize == 0 ? fileSize / chunkSize : fileSize / chunkSize + 1;
            fileInfo.setChunkNum(chunkNum);
            fileInfo.setFilePath(fileInfoDirectory + "/" + dto.getFileName());
            fileInfo.setUploadStatus(UploadStatusEnum.INIT.getStatus());
            fileInfo.setChunkSize(chunkSize);
            fileInfoService.save(fileInfo);
            // 因为没有被上传过，所以也就没有需要返回的分片序号
            return uploadVerifyFileVO;
        } else if(ObjectUtil.isNotNull(fileInfo)
                && ObjectUtil.notEqual(fileInfo.getUploadStatus(), UploadStatusEnum.UPLOADED.getStatus())){
            // 情况2: 文件上传过但没有上传完成
            // 需要做的事情: 需要查询已上传的分片序号
            uploadVerifyFileVO.setUploaded(false);
            // 查询已上传的分片信息
            LambdaQueryWrapper<FileChunk> fcLqw = new LambdaQueryWrapper<>();
            fcLqw.eq(FileChunk::getFileHash, dto.getFileHash());
            uploadVerifyFileVO.setUploadedChunks(
                    fileChunkService.list(fcLqw)
                            .stream().map(FileChunk::getChunkIndex).toList());
            return uploadVerifyFileVO;
        } else {
            // 情况3: 文件上传完成
            // 设置完成状态为true之后，什么也不做
            return uploadVerifyFileVO;
        }
    }

    @Override
    @Transactional
    public void uploadChunk(UploadChunkDTO dto) {
        // 获取上传的分片文件信息
        MultipartFile file = dto.getFile();
        Integer chunkIndex = dto.getChunkIndex();
        String fileHash = dto.getFileHash();
        // 创建分片文件存储路径
        String filePath = createFileChunkDirectory(fileHash) + "/" + chunkIndex;
        File chunkFile = new File(filePath);
        // 将上传的分片文件保存到指定路径
        try {
            file.transferTo(chunkFile);
        } catch (IOException e) {
            throw new CustomException(ResultCodeEnum.FILE_UPLOAD_ERROR);
        }
        // 将分片信息保存到数据库
        FileChunk fileChunk = fileChunkConvert.uploadChunkDTO2Po(dto);
        fileChunk.setChunkSize(file.getSize());
        fileChunk.setChunkPath(filePath);
        fileChunkService.save(fileChunk);
    }

    @Override
    public void modifyUploadStatus(String fileHash, Integer uploadStatus) {
        // 参数校验：文件必须存在、上传状态值必须有效、修改状态值不能和原来一样
        FileInfo fileInfo = BriupAssert.requireNotNull(
                fileInfoService,
                FileInfo::getFileHash,
                fileHash,
                ResultCodeEnum.DATA_NOT_EXIST);
        // 注意：这里使用了DatasetStatusEnum.statusList()来验证上传状态，可能需要根据实际需求调整
        BriupAssert.requireIn(
                uploadStatus,
                DatasetStatusEnum.statusList(),
                ResultCodeEnum.PARAM_IS_ERROR);
        BriupAssert.requireNotEqual(
                uploadStatus,
                fileInfo.getUploadStatus(),
                ResultCodeEnum.PARAM_IS_ERROR);
        // 设置新的上传状态值并更新到数据库
        fileInfo.setUploadStatus(uploadStatus);
        fileInfoService.updateById(fileInfo);
    }

    @Override
    @Transactional
    public void mergeChunks(String fileHash) {
        // 1. 验证文件是否存在并获取文件信息
        FileInfo fileInfo = BriupAssert.requireNotNull(
                fileInfoService,
                FileInfo::getFileHash,
                fileHash,
                ResultCodeEnum.DATA_NOT_EXIST);

        // 2. 查询该文件的所有分片，按索引升序排列
        LambdaQueryWrapper<FileChunk> lqw = new LambdaQueryWrapper<>();
        lqw.eq(FileChunk::getFileHash, fileHash).orderByAsc(FileChunk::getChunkIndex);
        List<FileChunk> fileChunks = fileChunkService.list(lqw);

        // 3. 合并所有分片文件到最终文件
        // 使用BufferedOutputStream写入目标文件，追加模式
        try(BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream(fileInfo.getFilePath())
        )) {
            // 遍历每个分片文件
            for (FileChunk fileChunk : fileChunks) {
                // 使用BufferedInputStream读取当前分片文件
                try (BufferedInputStream bis = new BufferedInputStream(
                            new FileInputStream(fileChunk.getChunkPath())
                )) {
                    // 创建2MB缓冲区
                    byte[] buffer = new byte[2 * 1024 * 1024];
                    int len = -1;
                    // 循环读取分片内容并写入目标文件
                    while ((len = bis.read(buffer)) != -1) {
                        bos.write(buffer, 0, len);
                    }
                } catch (Exception e) {
                    // 读取或写入分片时发生异常，抛出文件合并错误
                    throw new CustomException(ResultCodeEnum.FILE_MERGE_ERROR);
                }
            }
            bos.flush();
        }catch (Exception e){
            // 合并过程中发生异常，抛出文件合并错误
            throw new CustomException(ResultCodeEnum.FILE_MERGE_ERROR);
        }

        // 4. 更新文件上传状态为已上传
        fileInfo.setUploadStatus(UploadStatusEnum.UPLOADED.getStatus());
        fileInfoService.updateById(fileInfo);

        // 5. 清理分片数据：删除数据库中的分片记录
        fileChunkService.remove(lqw);

        // 6. 删除分片文件所在的目录及其中的所有文件
        FileUtil.del(createFileChunkDirectory(fileHash));
    }

    @Override
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    public void unzipDataset(Integer datasetId, String fileHash) {
        // 参数校验：数据集必须存在、文件必须存在、数据集的状态不能为完成、文件的状态必须是已上传
        Dataset dataset = BriupAssert.requireNotNull(
                datasetService,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST);
        BriupAssert.requireNotEqual(
                dataset.getDatasetStatus(),
                DatasetStatusEnum.DONE.getStatus(),
                ResultCodeEnum.DATASET_STATUS_ERROR);
        FileInfo fileInfo = BriupAssert.requireNotNull(
                fileInfoService,
                FileInfo::getFileHash,
                fileHash,
                ResultCodeEnum.DATA_NOT_EXIST);
        BriupAssert.requireEqual(
                fileInfo.getUploadStatus(),
                UploadStatusEnum.UPLOADED.getStatus(),
                ResultCodeEnum.FILE_IS_NOT_UPLOADED);
        // 将zip解压到指定文件夹下 html
        // 现在的位置
        File sourcePath = new File(fileInfo.getFilePath());
        // 解压到位置
        File targetPath = new File(nginxFilePath+"/"+datasetId);
        FileUtil.mkdir(targetPath);
        ZipUtil.unzip(sourcePath,targetPath, CharsetUtil.CHARSET_GBK);
        // 遍历解压后的目录，创建classify记录并加入到数据库classify中
        File[] classifyFiles = targetPath.listFiles(File::isDirectory);
        if (ObjectUtil.isNotNull(classifyFiles)){
            for (File classifyFile : classifyFiles) {
                // 保存classify信息到数据库
                Classify classify = new Classify();
                classify.setDatasetId(datasetId);
                classify.setClassifyName(classifyFile.getName());
                classifyService.save(classify);

                File[] entityFiles = classifyFile.listFiles(File::isFile);
                if (ObjectUtil.isNotNull(entityFiles)) {
                    UploadServiceImpl proxy = (UploadServiceImpl) AopContext.currentProxy();
                    proxy.saveEntityList(entityFiles,classify);
                }
            }
        }
    }

    @Override
    @Transactional
    @CacheEvict(key = "T(com.briup.pai.common.constant.CommonConstant).DETAIL_CACHE_PREFIX+':'+#datasetId")
    public void unzipClassify(Integer datasetId, Integer classifyId, String fileHash) {
        // 参数校验：验证数据集、分类和文件是否存在，以及文件上传状态是否正确
        BriupAssert.requireNotNull(
                datasetService,
                Dataset::getId,
                datasetId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        Classify classify = BriupAssert.requireNotNull(
                classifyService,
                Classify::getId,
                classifyId,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 验证分类是否属于指定的数据集
        BriupAssert.requireEqual(
                datasetId,
                classify.getDatasetId(),
                ResultCodeEnum.PARAM_IS_ERROR);
        FileInfo fileInfo = BriupAssert.requireNotNull(
                fileInfoService,
                FileInfo::getFileHash,
                fileHash,
                ResultCodeEnum.DATA_NOT_EXIST
        );
        // 验证文件是否已上传完成
        BriupAssert.requireEqual(
                fileInfo.getUploadStatus(),
                UploadStatusEnum.UPLOADED.getStatus(),
                ResultCodeEnum.FILE_IS_NOT_UPLOADED
        );

        // 获取源文件（zip包）和目标目录路径
        File sourceFile = new File(fileInfo.getFilePath());
        // 构建目标路径：nginx路径/datasetId/分类名称
        String classifyName = classify.getClassifyName();
        File targetFile = new File(nginxFilePath+"/"+datasetId+"/"+classifyName);
        
        // 获取目标目录中已存在的文件列表，用于去重，避免重复处理
        File[] oldEntityFile = targetFile.listFiles(File::isFile);
        List<String> oldEntityFileNameList = ObjectUtil.isNull(oldEntityFile) ? null : 
            Arrays.stream(oldEntityFile).map(File::getName).toList();
        
        // 解压zip文件到目标目录
        ZipUtil.unzip(sourceFile,targetFile,CharsetUtil.CHARSET_GBK);

        // 过滤出新解压的文件（不在原文件列表中的文件）
        // 注意：这里的逻辑有问题，应该使用 !oldNames.contains(file.getName()) 来获取新文件
        final List<String > oldNames = oldEntityFileNameList;
        File[] newEntityList = targetFile.listFiles(file -> file.isFile() && 
            (oldNames == null || !oldNames.contains(file.getName())));
        
        // 将新解压的实体文件信息保存到数据库
        if(ObjectUtil.isNotNull(newEntityList)){
            UploadServiceImpl proxy = (UploadServiceImpl) AopContext.currentProxy();
            proxy.saveEntityList(newEntityList, classify);
        }
    }

    //================================== private method ==================================

    /**
     * 创建文件目录方法
     * @param fileHash 文件MD5值
     * @return 文件目录路径
     * 存放路径格式：D:/nginx/pi-file-nginx/html/file/${fileHash}
     */
    private String createFileInfoDirectory(String fileHash) {
        // 构建文件信息存储路径：nginx根目录/file目录名/fileHash
        String fileInfoPath = this.nginxFilePath + "/" + this.fileDirectoryName + "/" + fileHash;
        // 创建目录，如果不存在的话
        FileUtil.mkdir(fileInfoPath);
        // 返回创建的目录路径
        return fileInfoPath;
    }

    /**
     * 创建分片目录方法
     * @param fileHash 文件MD5值
     * @return 分片目录路径
     * 存放路径格式：D:/nginx/pi-file-nginx/html/chunk/${fileHash}
     */
    private String createFileChunkDirectory(String fileHash) {
        // 构建分片文件存储路径：nginx根目录/chunk目录名/fileHash
        String fileChunkPath = this.nginxFilePath + "/" + this.chunkDirectoryName + "/" + fileHash;
        // 创建目录，如果不存在的话
        FileUtil.mkdir(fileChunkPath);
        // 返回创建的目录路径
        return fileChunkPath;
    }

    /**
     * 批量保存实体图片
     * @param entityFile 实体文件
     * @param classify 分类
     */
    @Transactional
    public void saveEntityList(File[] entityFile, Classify classify) {
        // 继续遍历的修改图片名字，加入到数据库entity中
        List<Entity> entityList = Arrays.stream(entityFile).map(file -> {
            // 批处理插入图片的内容
            // 1、修改实体文件的名字
            String oldName = file.getName();
            String newName = "";
            // 判断图片名称是否包含error
            if (oldName.contains("error")) {
                newName = oldName;
            } else {
                // 用uuid替换原图片名字
                newName = UUID.randomUUID().toString() + oldName.substring(oldName.lastIndexOf("."));
            }
            // 重命名
            FileUtil.rename(file, newName, true);
            Entity entity = new Entity();
            entity.setClassifyId(classify.getId());
            entity.setEntityUrl(newName);
            return entity;
        }).toList();
        entityService.saveBatch(entityList);
    }
}