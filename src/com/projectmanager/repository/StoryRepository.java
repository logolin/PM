package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Product;
import com.projectmanager.entity.Story;

public interface StoryRepository extends BaseBeanlRepository<Story>,JpaSpecificationExecutor<Story> {

	/**
	 * 根据项目查找未移除需求
	 * @return List<Story>
	 */
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.deleted='0'")
	List<Story> findByStory(Integer projectId);
	
	/**
	 * 根据项目查找未移除需求
	 * @return List<Story>
	 */
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.deleted='0' and s.module_id<>0")
	List<Story> findByProjectAndModuleAndDelete(Integer projectId);
	
	/**
	 * 根据project返回分页storylist
	 * @param projectId
	 * @param pageable
	 * @return
	 */
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.deleted='0'")
	Page<Story> findByProject(Integer projectId, Pageable pageable);
	
	/**
	 * 根据project查找storylist
	 * @param projectId
	 * @return
	 */
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.deleted='0'")
	List<Story> findByProject(Integer projectId);
	
	//根据product来查找关联该project的需求
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.product.id=?2 and s.deleted='0'")
	Page<Story> findByProjectAndProduct(Integer projectId, Integer productId, Pageable pageable);
	
	//根据module来查找关联该project的需求
	@Query("select s from Story s,ProjectStory p where p.project_id=?1 and s.id=p.story_id and s.module_id=?2 and s.deleted='0'")
	Page<Story> findByProjectAndModule(Integer projectId, Integer moduleId, Pageable pageable);
	
	//移除需求
	@Modifying
	@Query("update Story s set s.deleted='1' where s.id=?1")
	void deletedStory(int storyId);
	
	List<Story> findByIdIn(List<Integer> storyIds);
	
	/**
	 * 根据storyid数组来查找需求
	 * @param storyIds
	 */
	List<Story> findByIdIn(Integer[] storyIds);
	
	@Query("select s.id,s.title,s.product.id from Story s where s.id in ?1")
	List<Object[]> findIdAndNameByIdIn(List<Integer> storyIds);
	
	@Query("select s from Story s where instr(concat(',',s.plan,','),concat(',',?1,',')) > 0")
	List<Story> findByPlanContaining(String plan);
	/**
	 * 根据product和module查找需求
	 */
	@Query("from Story s where s.product.id =?1 and s.module_id =?2 and s.deleted='0'")
	List<Story> findByProdutAndModule(Integer productId, Integer moduleId);
	
	@Query("select s from Story s where s.product.id = ?1 and instr(concat(',',s.plan,','),concat(',',?2,',')) = 0")
	List<Story> findByProductIdAndPlanNotContaining(Integer product_id, String plan);
	
	List<Story> findByProductIdAndIdNotIn(Integer product_id, List<Integer> ids);
	
	List<Story> findByIdNotIn(List<Integer> ids);
	
	Long countByProductIdAndStatus(Integer product_id, String status);
	
	@Query(value="select s.status,count(*) from Story s where s.product.id = ?1 group by s.status")
	List<Object[]> countBypProductIdGroupByStatus(Integer product_id);
	
	/**
	 * 根据需求id数组查找关联需求的id和title
	 * @return
	 */
	@Query("select s.id,s.title,s.product.id from Story s where s.id in?1")
	List<Object[]> findAllAccountAndRealnameAndProductId(List<Integer> ids);
	
	/**
	 * 根据项目关联的产品来查找未关联项目的需求
	 * @return
	 */
	List<Story> findByProductInAndIdNotIn(List<Product> products, List<Integer> ids);
	
	/**
	 * 根据产品id查找需求
	 * @param productId
	 * @return
	 */
	List<Story> findByProductId(Integer productId);
}
