package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.PjPdRelation;
import com.projectmanager.entity.Project;

public interface ProjectRepository extends CrudRepository<Project, Integer> {

	/**
	 * 按状态查找项目
	 */
	@Query("select p from Project p where p.status=?1 and p.deleted='0'")
	Page<Project> findProjectByStatus(String status, Pageable pageable);

	/**
	 * 查询未完成项目
	 */
	@Query("select p from Project p where p.status<>?1 and p.deleted='0'")
	List<Project> findUndoneProject(String status);
			
	@Query("select p from Project p where p.status<>?1 and p.deleted='0'")
	Page<Project> findUndoneProject(String status, Pageable pageable);
	
	@Query(value="select p.id,p.name,p.openedBy,u.realname from Project p inner join ProjectStory ps on p.id = ps.project_id inner join User u on u.account = p.openedBy where ps.story_id = ?1")
	List<Object[]> findByStory_id(Integer story_id);
	
	/**
	 * 查找所有未删除的project
	 * @param pageable
	 * @return
	 */
	@Query("from Project p where p.deleted='0'")
	Page<Project> findByAll(Pageable pageable);
	
	/**
	 * 查找所有未删除的project
	 */
	List<Project> findByDeleted(String deleted);
	
	List<Project> findByIdIn(Integer[] ids);
	
	Page<Project> findByIdIn(Integer[] ids, Pageable pageable);
	
	/**
	 * 查找所有 有权限访问的project
	 * @param account
	 * @param name
	 * @return（数组）
	 */
	@Query(value="select distinct proj_project.id,proj_project.name,proj_project.status,proj_project.pm "
			+ "from proj_project left join proj_team on proj_project.id = proj_team.project_id "
			+ "where (instr(concat(',',proj_project.whitelist,','), "
			+ "concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role "
			+ "where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_project.acl = 'open' "
			+ "or proj_project.po = ?1 or proj_project.qd = ?1 or proj_project.pm = ?1 "
			+ "or proj_project.rd = ?1 or proj_project.openedBy = ?1) "
			+ "and proj_project.name like %?2% order by proj_project.pm = ?1",nativeQuery=true)
	List<Object[]> findByPrivAndNameContaining(String account, String name);
	
	@Query(value="select distinct * from proj_project p left join proj_team t on p.id = t.project_id "
			+ "where (instr(concat(',',p.whitelist,','), "
			+ "concat(',',(select g.id from proj_group g inner join proj_user u on g.role = u.role "
			+ "where u.account = ?1 and p.id in (select Max(proj_project.id) from proj_project group by proj_project.id Having Count(proj_project.name)>1)),',')) > 0 or t.account = ?1 or p.acl = 'open' "
			+ "or p.po = ?1 or p.qd = ?1 or p.pm = ?1 or p.rd = ?1 or p.openedBy = ?1) \n#pageable\n",
			countQuery="select count(distinct p.id) from proj_project p left join proj_team t on p.id = t.project_id "
					+ "where (instr(concat(',',p.whitelist,','), "
					+ "concat(',',(select g.id from proj_group g inner join proj_user u on g.role = u.role "
					+ "where u.account = ?1 and p.id in (select Max(proj_project.id) from proj_project group by proj_project.id Having Count(proj_project.name)>1)),',')) > 0 or t.account = ?1 or p.acl = 'open' "
					+ "or p.po = ?1 or p.qd = ?1 or p.pm = ?1 or p.rd = ?1 or p.openedBy = ?1) \n#pageable\n",
			nativeQuery=true)
	Page<Project> findByPrivAndName(String account, Pageable pageable);
	
	/**
	 * 查找所有有权限的project
	 * @param account
	 * @return
	 */
	@Query(value="select distinct * from proj_project p left join proj_team t on p.id = t.project_id "
			+ "where (instr(concat(',',p.whitelist,','), "
			+ "concat(',',(select g.id from proj_group g inner join proj_user u on g.role = u.role "
			+ "where u.account = ?1 and p.id in (select Max(proj_project.id) from proj_project group by proj_project.id Having Count(proj_project.name)>1)),',')) > 0 or t.account = ?1 or p.acl = 'open' "
			+ "or p.po = ?1 or p.qd = ?1 or p.pm = ?1 or p.rd = ?1 or p.openedBy = ?1)  \n#pageable\n",
			countQuery="select count(distinct proj_project.id) from proj_project p left join proj_team t on p.id = t.project_id "
					+ "where (instr(concat(',',p.whitelist,','), "
					+ "concat(',',(select g.id from proj_group g inner join proj_user u on g.role = u.role "
					+ "where u.account = ?1 and p.id in (select Max(proj_project.id) from proj_project group by proj_project.id Having Count(proj_project.name)>1)),',')) > 0 or t.account = ?1 or p.acl = 'open' "
					+ "or p.po = ?1 or p.qd = ?1 or p.pm = ?1 or p.rd = ?1 or p.openedBy = ?1) \n#pageable\n",
			nativeQuery=true)
	List<Project> findByPriv(String account);
	
}
