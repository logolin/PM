package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Teams {

	private List<Team> teams = new AutoPopulatingList<Team>(Team.class);

	public List<Team> getTeams() {
		return teams;
	}

	public void setTeams(List<Team> teams) {
		this.teams = teams;
	}
}
