package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Plan;

/**
 * @Description: PlanRepository类用于操作数据库的产品计划表，类方法返回值一般为多个产品计划对象，特殊情况在方法注释说明
 */
public interface PlanRepository extends CrudRepository<Plan, Integer>{

	/**
	 * @Description: 根据产品ID和分支ID查找分支ID为0或等于目标分支ID和产品计划并按计划开始日期排序
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @return
	 */
	@Query("select p from Plan p where p.product.id = ?1 and (p.branch_id = 0 or p.branch_id = ?2) order by p.begin")
	List<Plan> findByProductIdAndBranch_idIsZeroOrOrderByBegin(Integer product_id, Integer branch_id);
	
	/**
	 * @Description: 根据产品ID查找产品计划并按产品开始日期排序
	 * @param product_id 产品ID
	 * @return
	 */
	List<Plan> findByProductIdOrderByBegin(Integer product_id);
	
	/**
	 * @Description: 根据产品ID和分支ID查找计划并按参数进行分页和排序
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @param pageable 分页和排序条件
	 * @return
	 */
	@Query("select p from Plan p where p.product.id = ?1 and p.branch_id = ?2")
	Page<Plan> findByProductIdAndBranch_idWithPageAndSort(Integer product_id, Integer branch_id, Pageable pageable);
	
	/**
	 * @Description: 根据产品ID查找计划并按参数进行分页和排序
	 * @param product_id 产品ID
	 * @param pageable 分页和排序条件
	 * @return
	 */
	@Query("select p from Plan p where p.product.id = ?1")
	Page<Plan> findByProductIdWithPageAndSort(Integer product_id, Pageable pageable);
	
	/**
	 * @Description: 根据计划ID集合查找计划
	 * @param ids 计划ID集合
	 * @return
	 */
	List<Plan> findByIdIn(Integer[] ids);
	
	/**
	 * @Description: 根据产品ID和分支Id查找计划结束日期大于今天的计划并按计划开始日期排序
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @return
	 */
	@Query("select p from Plan p where p.product.id = ?1 and (p.branch_id = 0 or p.branch_id = ?2) and p.end > curdate() order by p.begin")
	List<Plan> findByProductIdAndBranch_idInAndEndAfterTodayOrderByBegin(Integer product_id, Integer branch_id);
	
	/**
	 * @Description: 根据产品ID查找计划结束日期大于今天的计划并按计划开始日期排序
	 * @param product_id 产品ID
	 * @return
	 */
	@Query("select p from Plan p where p.product.id = ?1 and p.end > curdate() order by p.begin")
	List<Plan> findByProductIdAndEndAfterTodayOrderByBegin(Integer product_id);
	
	/**
	 * @Description: 根据产品ID统计计划数量
	 * @param product_id 产品ID
	 * @return 计划数量
	 */
	Long countByProductId(Integer product_id);
	
}
