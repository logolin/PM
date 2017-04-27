package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Product;

/**
 * @Description: BranchRepository类用于操作数据库的产品分支表，类方法返回值一般为多个分支对象，特殊返回值在方法注释说明
 */
public interface BranchRepository extends CrudRepository<Branch, Integer>{
	
	/**
	 * @Description: 根据产品对象查找分支
	 * @param product 产品对象
	 * @return
	 */
	List<Branch> findByProduct(Product product);
	
	/**
	 * @Description: 根据产品对象和分支名称查找分支名称包含某字符串的分支
	 * @param product 产品对象
	 * @param name 查找字符串
	 * @return
	 */
	List<Branch> findByProductAndNameContaining(Product product, String name);
	
	/**
	 * @Description: 根据产品ID查找存在子模块的分支
	 * @param productId 产品ID
	 * @return
	 */
	@Query("select b,(select case when count(m) > 0 then true else false end from Module m where m.branch_id = b.id) from Branch b where b.product.id = ?1")
	List<Object[]> findByProductExistsSubmodule(Integer productId);
	
	/**
	 * @Description: 根据产品ID查找分支
	 * @param productId 产品ID
	 * @return
	 */
	List<Branch> findByProduct_id(Integer productId);
	
	/**
	 * @Description: 根据产品ID查找分支ID和分支名称
	 * @param product_id 产品ID
	 * @return 分支ID和分支名称
	 */
	@Query("select b.id,b.name from Branch b where b.product.id = ?1")
	List<Object[]> findIdAndNameByProductId(Integer product_id);
}
