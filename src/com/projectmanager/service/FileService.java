package com.projectmanager.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.projectmanager.entity.File;
import com.projectmanager.repository.FileRepository;

@Service
public class FileService {
	
	@Autowired
	private FileRepository fileRepository;
	
	@Autowired
	private HttpServletRequest request;
	
	/**
	 * 上传文件
	 * @param files 
	 * @param titles 文件名数组
	 * @param objectType 类型(task或者story等)
	 * @param objectId (taskId/storyId等)
	 * @param userAccount (上传者)
	 * @throws IOException
	 */
	public void createFile(MultipartFile[] files, String[] titles, String objectType, Integer objectId, String userAccount) throws IOException {
		
		List<File> fileList = new ArrayList<File>();
		File file;
		//系统当前时间
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMss");
		String folderName = formatter.format(date);
		//设置存储路径
		String totalPath = request.getServletContext().getRealPath("/") + "upload/" + folderName;
		System.out.println("上传到这里" + totalPath);
		String fileName;
		//循环上传文件
		for (int i = 0; i < files.length; i++) {
			//判断是否有文件
			if (!files[i].isEmpty()) {
				//判断该文件是否已存在
				if (Files.notExists(Paths.get(totalPath))) {
					//文件尚未存在则创建文件
					Files.createDirectory(Paths.get(totalPath));
				}				
				file = new File();
				fileName = UUID.randomUUID().toString() + "." + FilenameUtils.getExtension(files[i].getOriginalFilename());
				Files.copy(files[i].getInputStream(), Paths.get(totalPath, fileName));
				//将各值set到file里
				file.setAddedBy(userAccount);
				file.setObjectType(objectType);
				file.setObjectId(objectId);
				file.setExtension(FilenameUtils.getExtension(files[i].getOriginalFilename()));
				file.setSize((int) files[i].getSize());
				//下面的加的日期是为了防止上传的名字一样
				file.setPathName(folderName + "/" + fileName);
				//判断用户是否填写title
				if (titles.length == 0 || titles[i].isEmpty()) {
					//用户没填写title，则将文件名设为title
					file.setTitle(FilenameUtils.getBaseName(files[i].getOriginalFilename()));
				} else {
					//保存用户填写的title
					file.setTitle(titles[i]);
				}
				fileList.add(file);
			} 
		}
		//判断是否有上传文件
		if(!fileList.isEmpty()) {
			//保存用户上传的文件
			this.fileRepository.save(fileList);
		}
	}
	
	/**
	 * 根据类型和id查找文件列表
	 * @param type (文件类型，例如task等)
	 * @param objectId
	 * @return
	 */
	public List<File> getFileByTypeAndObjectId(String type, int objectId) {
		
		//通过objectType和objectId查找文档
		List<File> fileList = this.fileRepository.findByObjectTypeAndObjectId(type, objectId);
		if(fileList.size() > 0) {
			
		}
		return fileList;
	}
}
