package com.projectmanager.entity;

import java.io.Serializable;
import java.sql.Date;
import java.util.Objects;

import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;

@Embeddable
public class BurnPK implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@ManyToOne
	private Project project;
	
	private Date date;
	
	@Override
	public boolean equals(Object o) {
		if(this == o) return true;
		if(!(o instanceof BurnPK)) return false;
		
		BurnPK burnPK = (BurnPK) o;
		return Objects.equals(burnPK.project, project) && Objects.equals(burnPK.date, date);
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(project,date);
	}	

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
}
