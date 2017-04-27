package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Doc;

/**
 * @Description: DocRepository类用于操作数据库的文档表
 */
public interface DocRepository extends CrudRepository<Doc, Integer> {
	
	/**
	 * @Description: 根据项目ID查找文档
	 * @param projectId 项目ID
	 * @return 多个文档对象
	 */
	@Query("from Doc d where d.project_id=?1")
	List<Doc> findByProject(Integer projectId);

	/**
	 * @Description: 根据产品ID统计文档数量
	 * @param product_id 产品ID
	 * @return 文档数量
	 */
	@Query("select count(*) from Doc d where d.product_id = ?1")
	Long countByProduct_id(Integer product_id);
	
	/**
	 * @Description: 根据产品ID查找文档
	 * @param product_id 产品ID
	 * @return 多个文档对象
	 */
	@Query("select d from Doc d where d.product_id = ?1")
	List<Doc> findByProuct_id(Integer product_id);
}
