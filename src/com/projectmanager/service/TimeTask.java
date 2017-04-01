package com.projectmanager.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.projectmanager.entity.Burn;
import com.projectmanager.entity.BurnPK;
import com.projectmanager.entity.Project;
import com.projectmanager.repository.BurnRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.TaskRepository;

@Component("timeTask")
public class TimeTask {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private BurnRepository burnRepository;
	
	/**
	 * 更新燃尽图数据
	 */
	@Scheduled(cron = "0 0 0 * * ?") //设为每天0点执行
	public void updateBurn() {
		//获取系统当前时间
		Date date = new Date();
		java.sql.Date  sqlDate  =  new java.sql.Date(date.getTime());
		//获得所有项目
		List<Project> projectList = this.projectRepository.findByDeleted("0");
		for(Project project : projectList) {
			Burn burn = new Burn();
			//判断项目是否有任务
			if(this.taskRepository.countByProject(project) == 0) {
				//无任务，则设为0
				burn.setRemain(0);
				burn.setConsumed(0);
			} else {
				//有任务则计算所属任务的总剩余和总消耗
				burn.setRemain(this.taskRepository.sumRemainByProject(project));
				//获得总消耗
				burn.setConsumed(this.taskRepository.sumConsumedByProject(project));
			}
				
			BurnPK burnPK = new BurnPK();
			burnPK.setDate(sqlDate);
			burnPK.setProject(project);
			burn.setId(burnPK);
			this.burnRepository.save(burn);
		}
	}
}
