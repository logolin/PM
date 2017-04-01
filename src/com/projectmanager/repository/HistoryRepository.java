package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.History;

public interface HistoryRepository extends CrudRepository<History, Integer>{

	List<History> findByActionId(Integer action_id);
}
