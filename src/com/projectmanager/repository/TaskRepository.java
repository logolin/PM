package com.projectmanager.repository;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Project;
import com.projectmanager.entity.Task;

public interface TaskRepository extends CrudRepository<Task, Integer> {

	/**
	 * 根据projectId和status查找未删除任务
	 * @param project
	 * @param status
	 * @return
	 */
	@Query("from Task t where t.project.id=?1 and t.status=?2 and t.deleted='0'")
	Page<Task> findByStatus(int projectId, String status, Pageable pageable);
	
	/**
	 * 查找未关闭任务
	 * @return
	 */
	@Query("from Task t where t.status<>?1 and t.project.id=?2 and t.deleted='0'")
	Page<Task> findUncloseTask(String status, Integer projectId, Pageable pageable);
	
	/**
	 * 查找已延期任务
	 * @param deadline
	 * @return
	 */
	@Query("from Task t where t.project.id=?1 and t.deleted='0' and t.deadline<?2 and t.status in ('wait','doing')")
	Page<Task> findDelayedTask(Integer projectId, Date deadline, Pageable pageable);
	
	/**
	 * 查找需求变动的task
	 * @param projectId
	 * @param pageable
	 * @return
	 */
	@Query(value = "select distinct * from proj_task t inner join proj_story s on t.story_id = s.id where s.version>t.storyVersion and t.project_id=?1 and t.deleted='0' \n#pageable\n",
			countQuery="select count(distinct t.id) from proj_task t inner join proj_story s on t.story_id = s.id where s.version>t.storyVersion and t.project_id=?1 and t.deleted='0' \n#pageable\n",
			nativeQuery=true)
	Page<Task> findByStoryChange(Integer projectId, Pageable pageable);
	
	/**
	 * 根据projectId查找未删除任务
	 * @param projectId
	 * @return
	 */
	@Query("from Task t where t.deleted='0' and t.project.id=?1")
	Page<Task> findByProjectId( int projectId, Pageable pageable);
	
	@Query("from Task t where t.deleted='0' and t.project.id=?1 order by t.module_id asc")
	List<Task> findByProjectId( int projectId);
	
	/**
	 * 计算预期时间
	 */
	@Query("select sum(t.estimate) from Task t where t.project = ?1 and t.deleted = '0'")
	float sumEstimateByProject(Project project);

	/**
	 * 计算消耗时间
	 */
	@Query("select sum(t.consumed) from Task t where t.project = ?1 and t.deleted = '0'")
	float sumConsumedByProject(Project project);
	
	/**
	 * 计算剩余时间
	 */
	@Query("select sum(t.remain) from Task t where t.project = ?1 and t.deleted = '0'")
	float sumRemainByProject(Project project);

	/**
	 * 是否存在某个project
	 * @param project
	 * @return
	 */
	Long countByProject(Project project);
	
	/**
	 * 由projectId、status查找未删除任务
	 * @param projectId
	 * @param status
	 * @param deleted
	 * @return
	 */
	List<Task> findByProject_IdAndStatusAndDeleted(Integer projectId, String status, String deleted);
	
	@Query("select t.pri from Task t")
	List<Integer> countPri();
	/**
	 * 根据优先级查找任务
	 * @return
	 */
	List<Task> findByPri(Integer pri);
	
	List<Task> findByPriAndProject_IdAndDeleted(Integer pri, Integer projectId, String deleted);
	
	@Query("from Task t where t.story_id=?1")
	Integer countByStory(Integer storyId);
	
	/**
	 * 根据需求查找未关闭任务数
	 * @param storyId
	 * @return
	 */
	@Query("from Task t where t.story_id=?1 and t.deleted=?2")
	List<Task> countByStoryAndDeleted(Integer storyId, String deleted);
	
	/**
	 * 查找由谁完成
	 */
	@Query("from Task t where t.finishedBy=?1 and t.project.id=?2 and t.deleted='0'")
	Page<Task> findByFinishedByAndProjectId(String acount, Integer projectId, Pageable pageable);
	
	/**
	 * 根据模块查找该项目下任务
	 */
	@Query("from Task t where t.module_id=?1 and t.project.id=?2 and t.deleted='0'")
	Page<Task> findByModuleAndProjectId(Integer moduleId, Integer projectId, Pageable pageable);
	
	/**
	 * 根据product查找任务
	 */
	@Query(value = "select distinct * from proj_task t inner join proj_story s on s.id=t.story_id where t.project_id=?1 and s.product_id=?2 and t.module_id=0 and t.story_id=0 \n#pageable\n",
			countQuery="select count(distinct t.id) from proj_task t inner join proj_story s on s.id=t.story_id where t.project_id=?1 and s.product_id=?2 and t.module_id=0 and t.story_id=0 \n#pageable\n",
			nativeQuery=true)
	Page<Task> findByProduct(Integer projectId, Integer productId, Pageable pageable);
	
	/**
	 * 根据project和story、module查找该项目下任务
	 */
	@Query("from Task t where t.project.id=?1 and t.module_id=0 and t.story_id<>0 and t.deleted='0'")
	List<Task> findByProjectAndStory(Integer projectId);
	
	/**
	 * 根据product和project查找任务
	 */
	@Query("from Task t where t.project.id=?1 and t.story_id<>0 and t.deleted='0'")
	List<Task> findByProjectAndNotNullStory(Integer projectId);
	
	/**
	 * 按由谁关闭分组查找任务
	 * @param acount
	 * @param projectId
	 * @param deleted
	 * @return
	 */
	List<Task> findByFinishedByAndProjectIdAndDeleted(String acount, Integer projectId, String deleted);
	
	/**
	 * 按由谁关闭分组查找任务
	 */
	List<Task> findByClosedByAndProjectIdAndDeleted(String acount, Integer projectId, String deleted);
	
	/**
	 * 按类型分组查找任务
	 */
	List<Task> findByTypeAndProjectIdAndDeleted(String type, Integer projectId, String deleted);
	/**
	 * 按截止时间分组查找任务
	 */
	List<Task> findByDeadlineAndProjectIdAndDeleted(Date deadline, Integer projectId, String deleted);
	
	/**
	 * 根据assignedTo、projectId查找未删除任务
	 * @param assignedTo
	 * @param projectId
	 * @param deleted
	 * @return
	 */
	List<Task> findByAssignedToAndProjectIdAndDeleted(String assignedTo, Integer projectId, String deleted);
	
	/**
	 * 查找指派给用户的所有未删除任务
	 * @param assignedTo
	 * @param deleted
	 * @return
	 */
	List<Task> findByAssignedToAndDeleted(String assignedTo, String deleted);
	
	/**
	 * 根据assignedTo、projectId和status查找未删除任务
	 * @param assignedTo
	 * @param projectId
	 * @param deleted
	 * @return
	 */
	List<Task> findByAssignedToAndProjectIdAndStatusNotAndDeleted(String assignedTo, Integer projectId, String status, String deleted);
	
	/**
	 * 根据storyId和projectId还有status来查找任务
	 */
	@Query("from Task t where t.story_id=?1 and t.project.id=?2 and t.status=?3 and deleted='0'")
	List<Task> findByStoryAndProjectAndStatus(Integer storyId, Integer projectId, String status);
	
	/**
	 * 根据需求和项目查找未删除任务
	 * @param storyId
	 * @param projectId
	 * @return
	 */
	@Query("from Task t where t.story_id=?1 and t.project.id=?2 and deleted='0'")
	List<Task> findByStoryAndProject(Integer storyId, Integer projectId);
	
	/**
	 * 返回无需求任务
	 * @param projectId
	 * @return
	 */
	@Query("from Task t where t.story_id=0 and t.project.id=?1 and deleted='0'")
	List<Task> findByNotStory(Integer projectId);
	
	@Query("select t.id,t.name,t.assignedTo,t.status,t.consumed,t.remain,u.realname from Task t inner join User u on t.assignedTo = u.account where t.project.id = ?1 and t.story_id = ?2")
	List<Object[]> findByProject_idAndStory_id(Integer project_id, Integer story_id);
	
	/**
	 * 根据proje和story查找未删除任务
	 * @param projectId
	 * @param storyId
	 * @return
	 */
	@Query("from Task t where t.project.id=?1 and t.story_id=?2 and deleted='0'")
	List<Task> findByProject_IdAndStory_id(Integer projectId, Integer storyId);
	
	/**
	 * 根据project查找无关联需求和模块任务
	 * @param projectId
	 * @return
	 */
	@Query("from Task t where t.project.id=?1 and t.module_id=0 and t.story_id=0 and deleted='0'")
	List<Task> findByNotModuleAndProject_Id(Integer projectId);
	
	/**
	 * 分页
	 * @param productId
	 * @param pageable
	 * @return
	 */
	@Query("from Task t where t.project.id=?1")
	Page<Task> findByProjectWithPageAndSort(Integer projectId, Pageable pageable);
	
	List<Task> findByIdIn(List<Integer> ids);
	
	List<Task> findByIdIn(Integer[] ids);
	
	@Query("from Task t where t.project.id=?1 and t.story_id=?2 and t.module_id=?3 and t.deleted='0'")
	List<Task> findByProjectAndStoryAndModule(Integer projectId,Integer storyId, Integer moduleId);
	
	/**
	 * 根据项目查找未关联需求，未删除的任务
	 * @param projectId
	 * @return
	 */
	@Query("from Task t where t.project.id=?1 and t.story_id=0 and t.deleted='0'")
	List<Task> findByProjectAndModuleNotStory(Integer projectId);
	
	/**
	 * 查找指派给用户的已完成的任务
	 * @param assignedTo
	 * @return
	 */
//	@Query("from Task t where t.assignedTo=?1 and t.status='done' adn t.delete='0'")
//	List<Task> findByAssignedToAndDone(String assignedTo);
	
	/**
	 * 查找指派给用户的未完成的任务
	 * @param assignedTo
	 * @return
	 */
//	List<Task> findByAssignedToAndStatusNotInAndDelete(String assignedTo, String[] status, String delete);
	
	@Query("select t.id,t.name from Task t where t.project.id=?1 and t.story_id=0 and t.deleted='0'")
	List<Task> findByProjectIdAndModuleNotStory(Integer projectId);
	
	/**
	 * 根据指派给、状态查找任务
	 * @param assignTo （指派给）
	 * @param status （状态）
	 * @param delete （是否已删除）
	 * @return
	 */
	List<Task> findByAssignedToAndStatusAndDeleted(String assignedTo, String status, String deleted);
	
	
	/**
	 * 根据指派给、状态查找某些状态下的任务
	 * @param assignTo （指派给）
	 * @param status （状态）
	 * @param delete （是否已删除）
	 * @return
	 */
//	@Query("select t from Task t where t.assignedTo=?1 and t.status<>?2 and deleted='0'")
//	List<Task> findByAssignedToAndStatusNotAndDeleted(String assignedTo, String status, String deleted);
//	
	
	List<Task> findByAssignedToAndStatusInAndDeleted(String assignedTo, String[] status, String deleted);
	
}
