package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import com.projectmanager.entity.Case;

public interface CaseRepository extends BaseBeanlRepository<Case>{

	@Query("select c.id,c.title,c.status,c.openedBy,c.lastEditedBy,(select realname from User u where c.openedBy = u.account),(select realname from User u where c.lastEditedBy = u.account) from Case c where c.story_id = ?1")
	List<Object[]> findByStory_id(Integer story_id);
	
	@Query("select case when count(c) > 0 then true else false end from Case c where c.story_id = ?1")
	Boolean existsByStory_id(Integer story_id);
	
	Long countByProductId(Integer product_id);
}
