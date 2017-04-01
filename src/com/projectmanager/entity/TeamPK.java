package com.projectmanager.entity;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Embeddable
public class TeamPK implements Serializable{

	public static final long serialVersionUID = 1L;
	
	@ManyToOne
	@JoinColumn(name="project_id",referencedColumnName="id")
	private Project project;
	
	@ManyToOne
	@JoinColumn(name="account",referencedColumnName="account")
	private User user;
	
	@Override
	public boolean equals(Object o) {
		if(this == o) return true;
		if(!(o instanceof TeamPK)) return false;
		
		TeamPK teamPK = (TeamPK) o;
		return Objects.equals(teamPK.project, project) && Objects.equals(teamPK.user, user);
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(project,user);
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

}
