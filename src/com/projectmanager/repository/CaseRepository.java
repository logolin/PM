package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Case;

/**
 * @Description: CaseRepository类用于操作数据库的用例表
 */
public interface CaseRepository extends BaseBeanlRepository<Case>{

	/**
	 * @Description: 根据需求ID查找用例ID、用例标题、用例状态、创建者、最后修改者
	 * @param story_id 需求ID
	 * @return 用例ID、用例标题、用例状态、创建者、最后修改者
	 */
	@Query("select c.id,c.title,c.status,c.openedBy,c.lastEditedBy,(select realname from User u where c.openedBy = u.account),(select realname from User u where c.lastEditedBy = u.account) from Case c where c.story_id = ?1")
	List<Object[]> findByStory_id(Integer story_id);
	
	/**
	 * @Description: 根据需求ID判断该需求是否存在用例
	 * @param story_id 需求ID
	 * @return 是否存在用例
	 */
	@Query("select case when count(c) > 0 then true else false end from Case c where c.story_id = ?1")
	Boolean existsByStory_id(Integer story_id);
	
	/**
	 * @Description: 根据产品ID统计用例数量
	 * @param product_id 产品ID
	 * @return 用例数量
	 */
	Long countByProductId(Integer product_id);
}
