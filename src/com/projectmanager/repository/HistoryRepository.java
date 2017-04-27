package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.History;

/**
 * @Description: HistoryRepository类用于操作数据库的历史纪录表
 */
public interface HistoryRepository extends CrudRepository<History, Integer>{

	/**
	 * @Description: 根据动态ID查找历史纪录
	 * @param action_id 动态ID
	 * @return 多个历史记录对象
	 */
	List<History> findByActionId(Integer action_id);
}
