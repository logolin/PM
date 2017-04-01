package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.File;

public interface FileRepository extends CrudRepository<File, Integer>{

	List<File> findByObjectTypeAndObjectId(String objectType, Integer objectId);
}
