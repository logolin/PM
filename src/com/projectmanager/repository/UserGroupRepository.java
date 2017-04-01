package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.UserGroup;

public interface UserGroupRepository extends CrudRepository<UserGroup, String> {

	/**
	 * 根据account查找所有usergroup
	 * @param account
	 * @return
	 */
	List<UserGroup> findByUserAccount(String account);
	
	/**
	 * 根据account删除记录
	 * @param account
	 */
	void deleteByUserAccount(String account);
	
	/**
	 * 根据groupId删除记录
	 * @param groupId
	 */
	void deleteByGroupId(Integer groupId);
	
	/**
	 * 根据groupId查找用户
	 * @param groupId
	 * @return
	 */
	List<UserGroup> findByGroupId(Integer groupId);
	
	/**
	 * 查找不是此分组的用户
	 * @param groupId
	 * @return
	 */
	List<UserGroup> findByGroupIdNot(Integer groupId);
}
