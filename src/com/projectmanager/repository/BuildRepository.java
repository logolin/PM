package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Build;

/**
 * @Description: BuildRepository类用于操作数据库的版本表，类方法返回值一般为多个版本对象，特殊情况在方法注释说明
 */
public interface BuildRepository extends CrudRepository<Build, Integer>{

	/**
	 * @Description: 根据版本ID和产品ID查找不在目标版本ID集合的版本并按分支ID升序排序
	 * @param builds 目标版本ID集合
	 * @param product_id 产品ID
	 * @return
	 */
	@Query("select b from Build b where b.id not in ?1 and b.product.id = ?2 order by b.branch_id asc")
	List<Build> findByIdNotInAndProductIdOrderByBranch_id(List<Integer> builds, Integer product_id);
	
	/**
	 * @Description: 根据版本ID和产品ID和分支ID查找不在目标版本ID集合的版本并根据分支ID升序排序
	 * @param builds 目标版本ID集合
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @return
	 */
	@Query("select b from Build b where b.id not in ?1 and b.product.id = ?2 and (b.branch_id = ?3 or b.branch_id = 0) order by b.branch_id asc")
	List<Build> findByIdNotInAndProductIdAndBranch_idOrderByBranch_id(List<Integer> builds, Integer product_id, Integer branch_id);
	
	@Query("from Build b where b.project_id=?1")
	List<Build> findByProject(int projectId);
	
	/**
	 * @Description: 根据产品ID查找版本
	 * @param product_id 产品ID
	 * @return
	 */
	List<Build> findByProductId(Integer product_id);
	
	/**
	 * @Description: 修改目标版本的名称
	 * @param name 修改名称值
	 * @param buildId 版本ID
	 */
	@Query("update Build b set b.name=?1 where b.id=?2")
	void updateBuild(String name, int buildId);
	
	@Query("from Build b where b.project_id=?1 and b.deleted='0'")
	List<Build> findByProjectAndDeleted(int projectId);
	
	/**
	 * 移除版本
	 * @param buildId
	 */
	@Modifying
	@Query("update Build b set b.deleted='1' where b.id=?1")
	void deletedBuild(Integer buildId);
	
	/**
	 * @Description: 根据产品ID统计版本数量
	 * @param product_id 产品ID
	 * @return
	 */
	Long countByProductId(Integer product_id);
}
