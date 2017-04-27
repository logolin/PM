package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Product;
import com.projectmanager.entity.Story;

/**
 * @Description: StroyRepository类用于从操作数据库的需求表，类方法返回值一般为多个需求对象，特殊返回值会在方法注释说明
 */
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
	
	/**
	 * @Description: 根据多个需求ID查找需求
	 * @param storyIds 多个需求ID
	 * @return 多个需求
	 */
	List<Story> findByIdIn(List<Integer> storyIds);
	
	/**
	 * 根据storyid数组来查找需求
	 * @param storyIds
	 */
	List<Story> findByIdIn(Integer[] storyIds);
	
	/**
	 * @Description: 根据多个需求ID查找需求ID和需求名称
	 * @param storyIds 多个需求ID
	 * @return 多个需求ID和需求名称
	 */
	@Query("select s.id,s.title,s.product.id from Story s where s.id in ?1")
	List<Object[]> findIdAndNameByIdIn(List<Integer> storyIds);
	
	/**
	 * @Description: 根据产品计划ID查找需求
	 * @param plan 产品计划ID
	 * @return 多个需求
	 */
	@Query("select s from Story s where instr(concat(',',s.plan,','),concat(',',?1,',')) > 0")
	List<Story> findByPlanContaining(String plan);
	
	/**
	 * @Description: 根据产品ID和模块ID查找需求
	 * @param productId 产品ID
	 * @param moduleId 模块ID
	 * @return 
	 */
	@Query("from Story s where s.product.id =?1 and s.module_id =?2 and s.deleted='0'")
	List<Story> findByProdutAndModule(Integer productId, Integer moduleId);
	
	/**
	 * @Description: 根据产品ID和产品计划ID查找所属计划不包含某计划的需求
	 * @param product_id 产品ID
	 * @param plan
	 * @return
	 */
	@Query("select s from Story s where s.product.id = ?1 and instr(concat(',',s.plan,','),concat(',',?2,',')) = 0")
	List<Story> findByProductIdAndPlanNotContaining(Integer product_id, String plan);
	
	/**
	 * @Description: 根据产品ID和需求ID查找需求ID不在目标需求ID集合中的需求
	 * @param product_id
	 * @param ids 需求ID集合
	 * @return
	 */
	List<Story> findByProductIdAndIdNotIn(Integer product_id, List<Integer> ids);
	
	/**
	 * @Description: 根据需求ID查找需求ID不在目标需求ID集合中的需求
	 * @param ids 需求ID集合
	 * @return
	 */
	List<Story> findByIdNotIn(List<Integer> ids);
	
	/**
	 * @Description: 根据产品ID和需求状态统计需求数量
	 * @param product_id
	 * @param status 需求状态
	 * @return 需求数量
	 */
	Long countByProductIdAndStatus(Integer product_id, String status);
	
	/**
	 * @Description: 根据需求ID集合查找需求ID和需求名称、需求所属产品ID
	 * @param ids
	 * @return 需求ID和需求名称、需求所属产品ID
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
