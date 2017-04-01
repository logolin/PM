package com.projectmanager.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicUpdate;

@Entity
@Table(name="proj_dept")
@DynamicUpdate
public class Dept implements LogProject {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	private String name;
	
	private Integer parent;
	
	private String path;
	
	private Integer grade;
	
	private Integer sort;
	
	private String position;
	
	private String function;
	
	private String manager;
	
	@Transient
	private List<Dept> children;
	
	public Dept() {
		this.children = new ArrayList<Dept>();
	}
	
	public Dept(Integer id) {
		this.id = id;
		this.children = new ArrayList<Dept>();
	}
	
	@Override
	public boolean equals(Object o){
		if(this == o) return true;
		if (!(o instanceof Dept)) return false;
		Dept dept = (Dept) o;
		
		return this.getId() == dept.getId() ? true : false;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public Integer getGrade() {
		return grade;
	}

	public void setGrade(Integer grade) {
		this.grade = grade;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getFunction() {
		return function;
	}

	public void setFunction(String function) {
		this.function = function;
	}

	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}

	public Integer getParent() {
		return parent;
	}

	public void setParent(Integer parent) {
		this.parent = parent;
	}

	public List<Dept> getChildren() {
		return children;
	}

	public void setChildren(List<Dept> children) {
		this.children = children;
	}

	@Override
	public int OverrideGetId() {
		
		return this.id;
	}

	@Override
	public int overrideGetProjectId() {
		
		return 0;
	}
}
