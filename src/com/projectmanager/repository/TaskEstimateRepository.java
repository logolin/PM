package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.TaskEstimate;

public interface TaskEstimateRepository extends CrudRepository<TaskEstimate, Integer> {

	List<TaskEstimate> findByTaskId(Integer taskId);
}
