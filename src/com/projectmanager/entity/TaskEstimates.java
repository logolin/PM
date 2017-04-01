package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class TaskEstimates {

	private List<TaskEstimate> taskEstimates = new AutoPopulatingList<TaskEstimate>(TaskEstimate.class);

	public List<TaskEstimate> getTaskEstimates() {
		return taskEstimates;
	}

	public void setTaskEstimates(List<TaskEstimate> taskEstimates) {
		this.taskEstimates = taskEstimates;
	}
}
