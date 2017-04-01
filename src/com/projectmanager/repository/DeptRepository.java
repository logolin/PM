package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Dept;

public interface DeptRepository extends CrudRepository<Dept, Integer> {

	/**
	 * 根据parent查找deptList
	 * @param parent
	 * @return
	 */
	List<Dept> findByParent(Integer parent);
}
