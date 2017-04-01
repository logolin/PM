package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Task;

public interface BugRepository extends BaseBeanlRepository<Bug> {

	@Query("from Bug b where b.project_id=?1 and b.deleted='0'")
	Page<Bug> findByProject_id(Integer projectId, Pageable pageable);
	
	@Query("select b.id,b.title,b.status,b.openedBy,b.resolvedBy,b.resolution,b.lastEditedBy,(select realname from User u where b.openedBy = u.account),(select realname from User u where b.resolvedBy = u.account),(select realname from User u where b.lastEditedBy = u.account) from Bug b where b.story_id = ?1")
	List<Object[]> findByStory_id(Integer story_id);
	
	List<Bug> findByIdIn(List<Integer> ids);
	
	@Query("select b from Bug b where b.plan_id = ?1")
	List<Bug> findByPlan_id(Integer plan_id);
	
	@Query("select b from Bug b where b.id in ?1 and b.plan_id = ?2")
	List<Bug> findByIdInAndPlan_id(Integer[] ids, Integer plan_id);
	
	@Query("select b from Bug b where b.product.id = ?1 and (b.branch_id = 0 or b.branch_id = ?2) and b.plan_id != ?3 and b.status = ?4")
	List<Bug> findByProductIdAndBranch_idIsZeroOrAndPlan_idNotAndStatus(Integer product_id, Integer branch_id, Integer plan_id, String status);

	List<Bug> findByProductIdAndIdNotIn(Integer product_id, List<Integer> ids);
	
	Long countByProductId(Integer product_id);
	
	@Query("select count(*) from Bug b where b.product.id = ?1 and (b.assignedTo = '' or b.assignedTo is null)")
	Long countByProductIdAndUnassigned(Integer product_id);
	
	Long countByProductIdAndStatus(Integer product_id, String status);
	
	/**
	 * 根据指派给、状态、是否删除，查找bug
	 * @param assignedTo
	 * @param status
	 * @param deleted
	 * @return
	 */
	List<Bug> findByAssignedToAndStatusInAndDeleted(String assignedTo, String[] status, String deleted);
	
	/**
	 * ids数组中查找bug
	 * @param ids
	 * @return
	 */
	List<Bug> findByIdIn(Integer[] ids);
	
}
