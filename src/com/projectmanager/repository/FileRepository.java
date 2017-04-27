package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.File;

public interface FileRepository extends CrudRepository<File, Integer>{

	/**
	 * @Description: 根据文件类型和该类型对应的对象ID查找文件
	 * @param objectType 文件类型
	 * @param objectId 对象ID
	 * @return 多个文件
	 */
	List<File> findByObjectTypeAndObjectId(String objectType, Integer objectId);
}
