package com.projectmanager.entity;

import java.sql.Date;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="proj_team")
public class Team {

	@EmbeddedId
	private TeamPK id;
	
	private String role;
	
	private Date hiredate;
	
	private Integer days;
	
	private float hours;

	public TeamPK getId() {
		return id;
	}

	public void setId(TeamPK id) {
		this.id = id;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Date getHiredate() {
		return hiredate;
	}

	public void setHiredate(Date hiredate) {
		this.hiredate = hiredate;
	}

	public Integer getDays() {
		return days;
	}

	public void setDays(Integer days) {
		this.days = days;
	}

	public float getHours() {
		return hours;
	}

	public void setHours(float hours) {
		this.hours = hours;
	}
}
