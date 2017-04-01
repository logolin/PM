package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Permission;

public interface PermissionRepository extends CrudRepository<Permission, Integer> {

	/**
	 * 根据module来查找permission
	 * @param module
	 * @return
	 */
	List<Permission> findByModuleOrderById(String module);
	
	/**
	 * 查找所有的module
	 * @return
	 */
	@Query("select p.module from Permission p")
	List<String> findAllModule();
	
	/**
	 * 根据module和method返回name
	 * @param module
	 * @param method
	 * @return
	 */
	@Query("select p.name from Permission p where p.module=?1 and p.method=?2")
	String findByModuleAndMethod(String module, String method);
}
