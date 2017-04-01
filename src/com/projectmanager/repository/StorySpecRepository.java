package com.projectmanager.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.StorySpec;

public interface StorySpecRepository extends CrudRepository<StorySpec, Integer>{

	Page<StorySpec> findByStoryId(Integer storyId, Pageable pageable);
	
	StorySpec findFirstByStoryIdOrderByIdDesc(Integer storyId);
	
//	Long countByStoryId(Integer storyId);
	
	StorySpec findByStoryIdAndVersion(Integer storyId, Integer version);
	
	void removeByStoryIdAndVersionGreaterThan(Integer storyId, Integer version);
}

