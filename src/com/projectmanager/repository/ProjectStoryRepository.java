package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.ProjectStory;

public interface ProjectStoryRepository extends CrudRepository<ProjectStory, Integer> {

	/**
	 * 根据projectId来查找storyId
	 */
	@Query("from ProjectStory p where p.project_id=?1")
	List<ProjectStory> findByProject(Integer projectId);
	
	@Query(value = "select * from proj_projectstory p where p.project_id=?1", nativeQuery = true)
	List<ProjectStory> findByProjectId(Integer projectId);
	
	/**
	 * 根据projectId查找关联需求数组
	 * @param projectId
	 * @return
	 */
	@Query("select p.story_id from ProjectStory p where p.project_id=?1")
	List<Integer> findStoryIdByProject(Integer projectId);
	
	/**
	 * 根据projectId和storyId删除记录
	 * @param projectId
	 * @param storyId
	 */
	@Modifying
	@Query("delete from ProjectStory p where p.project_id=?1 and p.story_id=?2")
	void deleteByProjectIdAndStoryId(Integer projectId, Integer storyId);
	
}
