package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Bug;

/**
 * @Description: BugRepository类用于操作数据库的Bug表，类方法返回值一般为多个BUg对象，特殊情况在方法注释说明
 */
public interface BugRepository extends BaseBeanlRepository<Bug> {

	@Query("from Bug b where b.project_id=?1 and b.deleted='0'")
	Page<Bug> findByProject_id(Integer projectId, Pageable pageable);
	
	/**
	 * @Description: 根据需求ID查找BugID、Bug标题、创建者、最后修改者
	 * @param story_id 需求ID
	 * @return BugID、Bug标题、创建者、最后修改者
	 */
	@Query("select b.id,b.title,b.status,b.openedBy,b.resolvedBy,b.resolution,b.lastEditedBy,(select realname from User u where b.openedBy = u.account),(select realname from User u where b.resolvedBy = u.account),(select realname from User u where b.lastEditedBy = u.account) from Bug b where b.story_id = ?1")
	List<Object[]> findByStory_id(Integer story_id);
	
	/**
	 * @Description: 根据BugID集合查找Bug
	 * @param ids BugID集合
	 * @return
	 */
	List<Bug> findByIdIn(List<Integer> ids);
	
	/**
	 * @Description: 根据产品计划ID查找Bug
	 * @param plan_id 产品计划ID
	 * @return
	 */
	@Query("select b from Bug b where b.plan_id = ?1")
	List<Bug> findByPlan_id(Integer plan_id);
	
	/**
	 * @Description: 根据BugID和计划ID查找不在BugID集合的Bug
	 * @param ids BugID集合
	 * @param plan_id 计划ID
	 * @return
	 */
	@Query("select b from Bug b where b.id in ?1 and b.plan_id = ?2")
	List<Bug> findByIdInAndPlan_id(Integer[] ids, Integer plan_id);
	
	/**
	 * @Description: 根据产品ID和分支ID、计划ID以及Bug状态查找Bug
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @param plan_id 计划ID
	 * @param status Bug状态
	 * @return
	 */
	@Query("select b from Bug b where b.product.id = ?1 and (b.branch_id = 0 or b.branch_id = ?2) and b.plan_id != ?3 and b.status = ?4")
	List<Bug> findByProductIdAndBranch_idIsZeroOrAndPlan_idNotAndStatus(Integer product_id, Integer branch_id, Integer plan_id, String status);

	/**
	 * @Description: 根据产品ID和BugID集合查找不在集合中的Bug
	 * @param product_id 产品ID
	 * @param ids BugID集合
	 * @return
	 */
	List<Bug> findByProductIdAndIdNotIn(Integer product_id, List<Integer> ids);
	
	/**
	 * @Description: 根据产品ID统计Bug数量
	 * @param product_id 产品ID
	 * @return Bug数量
	 */
	Long countByProductId(Integer product_id);
	
	/**
	 * @Description: 根据产品ID统计未指派的Bug数量
	 * @param product_id 产品ID
	 * @return 未指派的Bug数量
	 */
	@Query("select count(*) from Bug b where b.product.id = ?1 and (b.assignedTo = '' or b.assignedTo is null)")
	Long countByProductIdAndUnassigned(Integer product_id);
	
	/**
	 * @Description: 根据产品ID和Bug状态统计Bug数量
	 * @param product_id 产品ID
	 * @param status Bug状态
	 * @return Bug数量
	 */
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
