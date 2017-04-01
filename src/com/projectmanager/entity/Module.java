package com.projectmanager.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.fasterxml.jackson.annotation.JsonView;

@Entity
@Table(name="proj_module")
@DynamicUpdate
@DynamicInsert
public class Module implements Log{
	
	public interface Public{};
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@JsonView(Public.class)
	private Integer id;
	
	private Integer root;
	
	@JsonView(Public.class)
	private Integer branch_id;
	
	@JsonView(Public.class)
	private String name;
	
	@JsonView(Public.class)
	private Integer parent;
	
	private String path;
	
	private Integer grade;
	
	private Integer sort;
	
	private String type;
	
	private String owner;
	
	private String shortname;
	
	@JsonView(Public.class)
	@Transient
	private List<Module> children;
	
	@JsonView(Public.class)
	@Transient
	private String branchName;
	
	@JsonView(Public.class)
	@Transient
	private String productName;
	
	public Module() {
		this.children = new ArrayList<Module>();
	}
	
	public Module(Integer id) {
		this.id = id;
		this.sort = 0;
		this.children = new ArrayList<Module>();
	}
	
	@Override
	public boolean equals(Object o){
		if(this == o) return true;
		if (!(o instanceof Module)) return false;
		Module module = (Module) o;
		
		return this.getId() == module.getId() ? true : false;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getRoot() {
		return root;
	}

	public void setRoot(Integer root) {
		this.root = root;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getShortname() {
		return shortname;
	}

	public void setShortname(String shortname) {
		this.shortname = shortname;
	}

	public Integer getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(Integer branch_id) {
		this.branch_id = branch_id;
	}

	public Integer getParent() {
		return parent;
	}

	public void setParent(Integer parent) {
		this.parent = parent;
	}

	public List<Module> getChildren() {
		return children;
	}

	public void setChildren(List<Module> children) {
		this.children = children;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProductId() {
		return this.root;
	}
	
}
