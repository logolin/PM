package com.projectmanager.entity;

import java.sql.Date;
import java.util.Map;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@DynamicInsert
@DynamicUpdate
@Table(name="proj_build")
public class Build implements Log,LogProject{

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne
	private Product product;
	
	private Integer branch_id;
	
	private Integer project_id;
	
	private String name;
	
	private String scmPath;
	
	private String filePath;
	
	private Date date;
	
	private String stories;
	
	private String bugs;
	
	private String builder;
	
	private String descript;
	
	private String deleted;
	
	@Transient
	private String branchName;
	
	public Build() {
		this.deleted = "0";
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getScmPath() {
		return scmPath;
	}

	public void setScmPath(String scmPath) {
		this.scmPath = scmPath;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getStories() {
		return stories;
	}

	public void setStories(String stories) {
		this.stories = stories;
	}

	public String getBugs() {
		return bugs;
	}

	public void setBugs(String bugs) {
		this.bugs = bugs;
	}

	public String getBuilder() {
		return builder;
	}

	public void setBuilder(String builder) {
		this.builder = builder;
	}

	public String getDescript() {
		return descript;
	}

	public void setDescript(String descript) {
		this.descript = descript;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	public Integer getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(Integer branch_id) {
		this.branch_id = branch_id;
	}

	public Integer getProject_id() {
		return project_id;
	}

	public void setProject_id(Integer project_id) {
		this.project_id = project_id;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}
	
	@Override
	public String toString() {
		return id.toString();
	};

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProductId() {
		return this.product.getId();
	}

	//LogProject
	@Override
	public int overrideGetProjectId() {
		return this.project_id;
	}
	
	@Override
	public Map<String, Object[]> compare(Log target) {
		// TODO Auto-generated method stub
		return Log.super.compare(target);
	}

	
}
