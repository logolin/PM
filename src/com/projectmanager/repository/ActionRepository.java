package com.projectmanager.repository;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Action;

/**
 * @Description: ActionRepository类用于操作数据库的动态表，类方法返回值一般为多个动态对象，特殊情况在方法注释说明
 */
public interface ActionRepository extends CrudRepository<Action, Integer> {
	
//	@Query("from Action a where a.project=?1")
	List<Action> findByProject(Integer projectId);
	
//	@Query("from Action a where a.project=?1 and a.date=?2")
	List<Action> findByProjectAndDate(Integer projectId, java.util.Date date);
	
	/**
	 * @Description: 根据操作者名字查询动态
	 * @param actor 操作者名字
	 * @return
	 */
	List<Action> findByActor(String actor);

	/**
	 * @Description: 根据产品ID和日期、操作对象类型、操作查找动态
	 * @param product 产品ID
	 * @param start 起始时间
	 * @param end 末端时间
	 * @param objectType 操作对象类型
	 * @param action 操作
	 * @param pageable 分页排序条件
	 * @return
	 */
	Page<Action> findByProductContainingAndDateBetweenAndObjectTypeNotAndActionNot(String product, Timestamp start, Timestamp end, String objectType, String action, Pageable pageable);
	
	/**
	 * @Description: 根据产品ID和操作者、操作对象类型、操作查找动态
	 * @param product 产品ID
	 * @param actor 操作者
	 * @param objectType 操作对象类型
	 * @param action 操作
	 * @param pageable 分页排序条件
	 * @return
	 */
	Page<Action> findByProductContainingAndActorAndObjectTypeNotAndActionNot(String product, String actor, String objectType, String action, Pageable pageable);
	
	/**
	 * @Description: 根据产品ID、操作对象类型、操作查找动态
	 * @param product 产品ID
	 * @param objectType 操作对象类型
	 * @param action 操作
	 * @param pageable 分页排序条件
	 * @return
	 */
	Page<Action> findByProductContainingAndObjectTypeNotAndActionNot(String product, String objectType, String action, Pageable pageable);

	/**
	 * @Description: 根据操作对象类型和操作对象ID查找动态
	 * @param objectType 操作对象类型
	 * @param objectId 操作对象ID
	 * @return
	 */
	List<Action> findByObjectTypeAndObjectId(String objectType, Integer objectId);
	
	/**
	 * @Description: 根据操作对象类型和产品ID查找动态
	 * @param objectType 操作对象类型
	 * @param product 产品ID
	 * @return
	 */
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
