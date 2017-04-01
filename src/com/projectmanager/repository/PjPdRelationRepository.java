package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.PjPdRelation;
import com.projectmanager.entity.PjPdRelationPK;


public interface PjPdRelationRepository extends CrudRepository<PjPdRelation, PjPdRelationPK>{

	@Query(value="SELECT * FROM proj_projectproduct WHERE product_id = ?1 AND branch_id = ?2",nativeQuery=true)
	List<PjPdRelation> findByProduct_idAndBranch_id(Integer product_id, Integer branch_id);
	
	@Query(value="select * from proj_projectproduct where product_id = ?1", nativeQuery = true)
	List<PjPdRelation> findByProduct_id(Integer productId);
	
	@Query(value="select * from proj_projectproduct where project_id=?1", nativeQuery = true)
	List<PjPdRelation> findByProject_id(Integer projectId);
	
	Long countByIdProductId(Integer product_id);
	
	void deleteByIdProjectId(Integer projectId);
	
	/**
	 * 删除某一个关联的产品信息
	 * @param projectId
	 * @param productId
	 */
	void deleteByIdProjectIdAndIdProductId(Integer projectId, Integer productId);
}
