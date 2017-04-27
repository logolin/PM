package com.projectmanager.repository;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.StorySpec;

/**
 * @Description: StorySpecRepository类用于操作数据库的storyspec表，类方法返回值一般为多个需求补充说明对象，特殊情况在方法注释说明
 */
public interface StorySpecRepository extends CrudRepository<StorySpec, Integer>{

	/**
	 * @Description: 根据需求ID查询需求补充说明对象并按ID降序排序
	 * @param storyId 需求ID
	 * @return
	 */
	StorySpec findFirstByStoryIdOrderByIdDesc(Integer storyId);
	
	/**
	 * @Description: 根据需求ID和需求版本查询需求补充说明对象
	 * @param storyId 需求ID
	 * @param version 需求版本
	 * @return
	 */
	StorySpec findByStoryIdAndVersion(Integer storyId, Integer version);
	
	/**
	 * @Description: 根据需求ID和需求版本删除大于目标需求版本的需求补充说明对象
	 * @param storyId 需求ID
	 * @param version 目标需求版本
	 */
	void removeByStoryIdAndVersionGreaterThan(Integer storyId, Integer version);
}

