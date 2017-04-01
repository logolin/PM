package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Tasks {

	private List<Task> tasks = new AutoPopulatingList<Task>(Task.class);

	public List<Task> getTasks() {
		return tasks;
	}

	public void setTasks(List<Task> tasks) {
		this.tasks = tasks;
	}
}
