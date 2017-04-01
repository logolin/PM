package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Group;

public interface GroupRepository extends CrudRepository<Group, Integer> {

	/**
	 * 根据分组id数组查找分组
	 * @param groupIds
	 * @return
	 */
	List<Group> findByIdIn(List<Integer> groupIds);
}
