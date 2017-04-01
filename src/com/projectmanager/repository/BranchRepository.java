package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Product;


public interface BranchRepository extends CrudRepository<Branch, Integer>{
	
	List<Branch> findByProduct(Product product);
	
	List<Branch> findByProductAndNameContaining(Product product, String name);
	
	@Query("select b,(select case when count(m) > 0 then true else false end from Module m where m.branch_id = b.id) from Branch b where b.product.id = ?1")
	List<Object[]> findByProductExistsSubmodule(Integer productId);
	
	List<Branch> findByProduct_id(Integer productId);
	
	@Query("select b.id,b.name from Branch b where b.product.id = ?1")
	List<Object[]> findIdAndNameByProductId(Integer product_id);
}
