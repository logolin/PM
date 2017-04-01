package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Doc;

public interface DocRepository extends CrudRepository<Doc, Integer> {
	
	@Query("from Doc d where d.project_id=?1")
	List<Doc> findByProject(Integer projectId);

	@Query("select count(*) from Doc d where d.product_id = ?1")
	Long countByProduct_id(Integer product_id);
	
	@Query("select d from Doc d where d.product_id = ?1")
	List<Doc> findByProuct_id(Integer product_id);
}
