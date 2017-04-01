package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Plan;

public interface PlanRepository extends CrudRepository<Plan, Integer>{

	@Query("select p from Plan p where p.product.id = ?1 and (p.branch_id = 0 or p.branch_id = ?2) order by p.begin")
	List<Plan> findByProductIdAndBranch_idIsZeroOrOrderByBegin(Integer product_id, Integer branch_id);
	
	List<Plan> findByProductIdOrderByBegin(Integer product_id);
	
	@Query("select p from Plan p where p.product.id = ?1 and p.branch_id = ?2")
	Page<Plan> findByProductIdAndBranch_idWithPageAndSort(Integer product_id, Integer branch_id, Pageable pageable);
	
	@Query("select p from Plan p where p.product.id = ?1")
	Page<Plan> findByProductIdWithPageAndSort(Integer product_id, Pageable pageable);
	
	List<Plan> findByIdIn(Integer[] ids);
	
	@Query("select p from Plan p where p.product.id = ?1 and (p.branch_id = 0 or p.branch_id = ?2) and p.end > curdate() order by p.begin")
	List<Plan> findByProductIdAndBranch_idInAndEndAfterTodayOrderByBegin(Integer product_id, Integer branch_id);
	
	@Query("select p from Plan p where p.product.id = ?1 and p.end > curdate() order by p.begin")
	List<Plan> findByProductIdAndEndAfterTodayOrderByBegin(Integer product_id);
	
	Long countByProductId(Integer product_id);
	
}
