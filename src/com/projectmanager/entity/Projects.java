package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Projects {

	private List<Project> projects = new AutoPopulatingList<Project>(Project.class);

	public List<Project> getProjects() {
		return projects;
	}

	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}
}
