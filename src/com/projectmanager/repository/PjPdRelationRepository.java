package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.PjPdRelation;
import com.projectmanager.entity.PjPdRelationPK;

/**
 * @Description: PjPdRelationRepository类用于操作数据库的产品项目关系表，类方法返回值一般为多个产品-项目关系对象，特殊情况在方法注释说明
 */
public interface PjPdRelationRepository extends CrudRepository<PjPdRelation, PjPdRelationPK>{

	/**
	 * @Description: 根据产品ID和分支ID查找产品-项目关系
	 * @param product_id 产品ID
	 * @param branch_id 分支ID
	 * @return
	 */
	@Query(value="SELECT * FROM proj_projectproduct WHERE product_id = ?1 AND branch_id = ?2",nativeQuery=true)
	List<PjPdRelation> findByProduct_idAndBranch_id(Integer product_id, Integer branch_id);
	
	/**
	 * @Description: 根据产品ID查找产品-项目关系
	 * @param productId 产品ID
	 * @return
	 */
	@Query(value="select * from proj_projectproduct where product_id = ?1", nativeQuery = true)
	List<PjPdRelation> findByProduct_id(Integer productId);
	
	/**
	 * @Description: 根据项目ID查找产品-项目关系
	 * @param projectId 项目ID
	 * @return
	 */
	@Query(value="select * from proj_projectproduct where project_id=?1", nativeQuery = true)
	List<PjPdRelation> findByProject_id(Integer projectId);
	
	/**
	 * @Description: 根据产品ID统计产品-项目关系数量
	 * @param product_id 产品ID
	 * @return
	 */
	Long countByIdProductId(Integer product_id);
	
	void deleteByIdProjectId(Integer projectId);
	
	/**
	 * 删除某一个关联的产品信息
	 * @param projectId
	 * @param productId
	 */
	void deleteByIdProjectIdAndIdProductId(Integer projectId, Integer productId);
}
