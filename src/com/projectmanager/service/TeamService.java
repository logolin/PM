package com.projectmanager.service;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.projectmanager.entity.Project;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.TeamPK;
import com.projectmanager.entity.Teams;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.TeamRepository;
import com.projectmanager.repository.UserRepository;

@Service
@Transactional
public class TeamService {

	@Autowired
	private TeamRepository teamRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	
	/**
	 * 编辑团队成员
	 * @param projectId
	 * @param teams (前端传来List<Team>)
	 */
	public void manageTeam(int projectId, Teams teams) {
		
		//项目
		Project project = this.projectRepository.findOne(projectId);
		
		//判断前端是否传团队数据过来
		if(!teams.equals(null)) {
			for(Team team : teams.getTeams()) {
				//Team的双主键重新构成一个类，必须先获得一个TeamPK才允许编辑其他属性，不然jpa会以为是更改了主键。
				TeamPK teamPk = new TeamPK();
				teamPk.setProject(project);
				teamPk.setUser(this.userRepository.findByAccount(team.getId().getUser().getAccount()));
				//取得原id
				team.setId(teamPk);
				//编辑前团队
				Team updateTeam = this.teamRepository.findByProjectAndAccount(projectId, team.getId().getUser().getAccount());
				
				//编辑团队
				MyUtil.copyProperties(team, updateTeam);
			}
		}
	}
	
	/**
	 * 添加团队成员
	 * @param projectId
	 * @param accounts
	 * @param roles
	 * @param days
	 * @param hours
	 */
	public void created(int projectId,String[] accounts, String[] roles, Integer[] days, Float[] hours) {
		
		if(accounts.length > 0) {
			for(int i = 0; i < accounts.length; i++) {
				if(accounts[i] != "") {
					Team team = new Team();
					team.setDays(days[i]);
					team.setRole(roles[i]);
					team.setHours(hours[i]);
					//入职日期为添加成员时的系统时间
					Date date = new Date(System.currentTimeMillis());
					team.setHiredate(date);
					//teamPK，作为team主键
					TeamPK teamPK = new TeamPK();
					teamPK.setProject(this.projectRepository.findOne(projectId));
					teamPK.setUser(this.userRepository.findByAccount(accounts[i]));
					team.setId(teamPK);
					this.teamRepository.save(team);
				}
			}
		}
		
		
	}
}
