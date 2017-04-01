package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.TestTask;

public interface TestTaskRepository extends CrudRepository<TestTask, Integer> {

	@Query("from TestTask t where t.project_id=?1 and t.deleted='0'")
	List<TestTask> findByProject_id(Integer projectId);
}
