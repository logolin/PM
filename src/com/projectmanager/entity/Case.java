package com.projectmanager.entity;

import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="proj_case")
@AttributeOverride(name="module_id",column=@Column(name="module_id"))
public class Case extends BaseBean{

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne
	private Product product;
	
	private Integer branch_id;
	
	private Integer path;  //保留字段
	
	private Integer story_id;
	
	private Integer storyVersion;	
	
	private String title;
	
	private String precondition;
	
	private String keywords;
	
	private String type;
	
	private Integer pri;	
	
	private String stage;
	
	private String howRun;  //保留字段,暂不作使用
	
	private String scriptedBy;  //保留字段
	
	private Date scriptedDate;  //保留字段
	
	private String scriptedStatus;  //保留字段
	
	private String scriptedLocation;  //保留字段
	
	private String status;
	
	private String color;
	
	private String frequency;  //保留字段
	
	private Integer sort;
	
	private String openedBy;
	
	private Timestamp openedDate;
	
	private String lastEditedBy;
	
	private Timestamp lastEditedDate;	
	
	private Integer version;
	
	private String linkCase;
	
	private Integer fromBug;  //保留字段
	
	private String deleted;
	
	private String lastRunner;
	
	private Timestamp lastRunDate;
	
	private String lastRunResult;
	
	public Case() {
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

	public Integer getPath() {
		return path;
	}

	public void setPath(Integer path) {
		this.path = path;
	}

	public Integer getStoryVersion() {
		return storyVersion;
	}

	public void setStoryVersion(Integer storyVersion) {
		this.storyVersion = storyVersion;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPrecondition() {
		return precondition;
	}

	public void setPrecondition(String precondition) {
		this.precondition = precondition;
	}

	public String getKeywords() {
		return keywords;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Integer getPri() {
		return pri;
	}

	public void setPri(Integer pri) {
		this.pri = pri;
	}

	public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public String getHowRun() {
		return howRun;
	}

	public void setHowRun(String howRun) {
		this.howRun = howRun;
	}

	public String getScriptedBy() {
		return scriptedBy;
	}

	public void setScriptedBy(String scriptedBy) {
		this.scriptedBy = scriptedBy;
	}

	public Date getScriptedDate() {
		return scriptedDate;
	}

	public void setScriptedDate(Date scriptedDate) {
		this.scriptedDate = scriptedDate;
	}

	public String getScriptedStatus() {
		return scriptedStatus;
	}

	public void setScriptedStatus(String scriptedStatus) {
		this.scriptedStatus = scriptedStatus;
	}

	public String getScriptedLocation() {
		return scriptedLocation;
	}

	public void setScriptedLocation(String scriptedLocation) {
		this.scriptedLocation = scriptedLocation;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getFrequency() {
		return frequency;
	}

	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getOpenedBy() {
		return openedBy;
	}

	public void setOpenedBy(String openedBy) {
		this.openedBy = openedBy;
	}

	public Timestamp getOpenedDate() {
		return openedDate;
	}

	public void setOpenedDate(Timestamp openedDate) {
		this.openedDate = openedDate;
	}

	public String getLastEditedBy() {
		return lastEditedBy;
	}

	public void setLastEditedBy(String lastEditedBy) {
		this.lastEditedBy = lastEditedBy;
	}

	public Timestamp getLastEditedDate() {
		return lastEditedDate;
	}

	public void setLastEditedDate(Timestamp lastEditedDate) {
		this.lastEditedDate = lastEditedDate;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getLinkCase() {
		return linkCase;
	}

	public void setLinkCase(String linkCase) {
		this.linkCase = linkCase;
	}

	public Integer getFromBug() {
		return fromBug;
	}

	public void setFromBug(Integer fromBug) {
		this.fromBug = fromBug;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	public String getLastRunner() {
		return lastRunner;
	}

	public void setLastRunner(String lastRunner) {
		this.lastRunner = lastRunner;
	}

	public Timestamp getLastRunDate() {
		return lastRunDate;
	}

	public void setLastRunDate(Timestamp lastRunDate) {
		this.lastRunDate = lastRunDate;
	}

	public String getLastRunResult() {
		return lastRunResult;
	}

	public void setLastRunResult(String lastRunResult) {
		this.lastRunResult = lastRunResult;
	}

	public Integer getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(Integer branch_id) {
		this.branch_id = branch_id;
	}

	public Integer getStory_id() {
		return story_id;
	}

	public void setStory_id(Integer story_id) {
		this.story_id = story_id;
	}
	
}
