package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Release;

/**
 * @Description: ReleaseRepository类用于操作数据库的发布表，类方法返回值一般为Release对象
 */
public interface ReleaseRepository extends CrudRepository<Release, Integer> {

	/**
	 * @Description: 根据产品ID和分支ID查找发布并根据发布日期进行排序
	 * @param product_id 产品ID
	 * @param branch_id 分支ID,值为0表示无分支或属于所有分支
	 * @return
	 */
	@Query("select r from Release r where r.product.id = ?1 and r.branch_id = ?2 order by r.date")
	List<Release> findByProductIdAndBranch_idOrderByDate(Integer product_id, Integer branch_id);
	
	/**
	 * @Description: 根据产品ID查找发布
	 * @param product_id 产品ID
	 * @return
	 */
	List<Release> findByProductId(Integer product_id);
	
	/**
	 * @Description: 根据产品ID查找发布并根据发布日期进行排序
	 * @param product_id
	 * @return
	 */
	List<Release> findByProductIdOrderByDate(Integer product_id);
	
	/**
	 * @Description: 根据产品ID和分支ID查找符合条件的第一个发布对象并按发布日期排序
	 * @param product_id
	 * @param branch_id
	 * @return 符合条件的第一个发布
	 */
	@Query(value="SELECT * FROM PROJ_RELEASE WHERE PRODUCT_ID = ?1 AND BRANCH_ID = ?2 ORDER BY DATE DESC,ID DESC LIMIT 1", nativeQuery=true)
	Release findFirstByProductAndBranch_idOrderByDate(Integer product_id, Integer branch_id);
	
	/**
	 * @Description: 根据产品ID统计发布数量
	 * @param product_id 产品ID
	 * @return 发布数量
	 */
	Long countByProductId(Integer product_id);
}
