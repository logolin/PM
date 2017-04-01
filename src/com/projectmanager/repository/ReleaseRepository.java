package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Release;

public interface ReleaseRepository extends CrudRepository<Release, Integer> {

	@Query("select r from Release r where r.product.id = ?1 and r.branch_id = ?2 order by r.date")
	List<Release> findByProductIdAndBranch_idOrderByDate(Integer product_id, Integer branch_id);
	
	List<Release> findByProductId(Integer product_id);
	
	List<Release> findByProductIdOrderByDate(Integer product_id);
	
	@Query(value="SELECT * FROM PROJ_RELEASE WHERE PRODUCT_ID = ?1 AND BRANCH_ID = ?2 ORDER BY DATE DESC,ID DESC LIMIT 1", nativeQuery=true)
	Release findFirstByProductAndBranch_idOrderByDate(Integer product_id, Integer branch_id);
	
	Long countByProductId(Integer product_id);
}
