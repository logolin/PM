package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Plans {
	
	private List<Plan> plans = new AutoPopulatingList<Plan>(Plan.class);
	
	public List<Plan> getPlans() {
		return plans;
	}

	public void setPlans(List<Plan> plans) {
		this.plans = plans;
	}
}
