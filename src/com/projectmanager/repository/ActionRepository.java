package com.projectmanager.repository;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Action;

public interface ActionRepository extends CrudRepository<Action, Integer> {
	
//	@Query("from Action a where a.project=?1")
	List<Action> findByProject(Integer projectId);
	
//	@Query("from Action a where a.project=?1 and a.date=?2")
	List<Action> findByProjectAndDate(Integer projectId, java.util.Date date);
	
	List<Action> findByActor(String actor);

	Page<Action> findByProductContainingAndDateBetweenAndObjectTypeNotAndActionNot(String product, Timestamp start, Timestamp end, String objectType, String action, Pageable pageable);
	
	Page<Action> findByProductContainingAndActorAndObjectTypeNotAndActionNot(String product, String actor, String objectType, String action, Pageable pageable);
	
	Page<Action> findByProductContainingAndObjectTypeNotAndActionNot(String product, String objectType, String action, Pageable pageable);

	List<Action> findByObjectTypeAndObjectId(String objectType, Integer objectId);
	
	List<Action> findByObjectTypeAndProductContaining(String objectType, String product);
	
	/**
	 * 查找所有项目动态
	 * @param pageRequest 
	 * @param projectId 
	 * @param product
	 * @param objectType
	 * @param action
	 * @param pageable
	 * @return
	 */
	Page<Action> findByProject(Integer project, Pageable pageable);
	
	/**
	 * 根据操作者查找该项目动态
	 * @param project
	 * @param actor
	 * @param pageable
	 * @return
	 */
	Page<Action> findByProjectAndActor(Integer project, String actor, Pageable pageable);
	
	/**
	 * 按时间段查找项目动态
	 * @param project
	 * @param start
	 * @param end
	 * @param pageable
	 * @return
	 */
	Page<Action> findByProjectAndDateBetween(Integer project, Timestamp start, Timestamp end, Pageable pageable);
	
	/**
	 * 查找所有动态
	 * @param pageable
	 * @return
	 */
	Page<Action> findAll(Pageable pageable);
	
	/**
	 * 按操作者查找动态
	 * @param actor
	 * @param pageable
	 * @return
	 */
	Page<Action> findByActor(String actor, Pageable pageable);
	
	/**
	 * 按时间段查找动态
	 * @param start
	 * @param end
	 * @param pageable
	 * @return
	 */
	Page<Action> findByDateBetween(Timestamp start, Timestamp end, Pageable pageable);
	
	/**
	 * 根据产品查动态
	 * @param product
	 * @param pageable
	 * @return
	 */
	Page<Action> findByProductContaining(String product, Pageable pageable);
}
