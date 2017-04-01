package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Team;
import com.projectmanager.entity.TeamPK;

public interface TeamRepository extends CrudRepository<Team, TeamPK> {

	/**
	 * 根据projectId查找团队成员
	 * @param projectId
	 * @return
	 */
	@Query(value="select * from proj_team where project_id=?1", nativeQuery=true)
	List<Team> findByProject(Integer projectId);
	
	/**
	 * 根据projectId和account查找团队成员
	 * @param projectId
	 * @param account
	 * @return
	 */
	@Query("from Team t where t.id.project.id=?1 and t.id.user.account=?2")
	Team findByProjectAndAccount(Integer projectId, String account);
}
