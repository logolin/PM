package com.projectmanager.entity;

import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@DynamicUpdate
@DynamicInsert
@Table(name="proj_task")
public class Task implements LogProject {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne
	private Project project;
	
	private Integer module_id;
	
	private Integer story_id;
	
	private Integer storyVersion;
	
	private Integer fromBug;
	
	private String name;
	
	private String type;
	
	private Integer pri;
	
	private float estimate;
	
	private float consumed;
	
	private float remain;
	
	private Date deadline;
	
	private String status;
	
	private String color;
	
	private String mailto;
	
	private String descript;
	
	private String openedBy;
	
	@CreationTimestamp
	private Timestamp openedDate;
	
	private String assignedTo;
	
	private Timestamp assignedDate;
	
	private Date estStarted;
	
	private Date realStarted;	
	
	private String finishedBy;
	
	private Timestamp finishedDate;	
	
	private String canceledBy;
	
	private Timestamp canceledDate;	
	
	private String closedBy;
	
	private Timestamp closedDate;
	
	private String closedReason;
	
	private String lastEditedBy;
	
	private Timestamp lastEditedDate;	
	
	private String deleted;
	
	//中文状态
	@Transient
	private String ch_status;
	
	public String getCh_status() {
		return ch_status;
	}

	public void setCh_status(String ch_status) {
		this.ch_status = ch_status;
	}

	public Task() {
		this.deleted = "0";
	}

	public Integer getId() {
		return id;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getStoryVersion() {
		return storyVersion;
	}

	public void setStoryVersion(Integer storyVersion) {
		this.storyVersion = storyVersion;
	}

	public Integer getFromBug() {
		return fromBug;
	}

	public void setFromBug(Integer fromBug) {
		this.fromBug = fromBug;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public float getEstimate() {
		return estimate;
	}

	public void setEstimate(float estimate) {
		this.estimate = estimate;
	}

	public float getConsumed() {
		return consumed;
	}

	public void setConsumed(float consumed) {
		this.consumed = consumed;
	}
	
	public float getRemain() {
		return remain;
	}

	public void setRemain(float remain) {
		this.remain = remain;
	}

	public Date getDeadline() {
		return deadline;
	}

	public void setDeadline(Date deadline) {
		this.deadline = deadline;
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

	public String getMailto() {
		return mailto;
	}

	public void setMailto(String mailto) {
		this.mailto = mailto;
	}

	public String getDescript() {
		return descript;
	}

	public void setDescript(String descript) {
		this.descript = descript;
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

	public String getAssignedTo() {
		return assignedTo;
	}

	public void setAssignedTo(String assignedTo) {
		this.assignedTo = assignedTo;
	}

	public Timestamp getAssignedDate() {
		return assignedDate;
	}

	public void setAssignedDate(Timestamp assignedDate) {
		this.assignedDate = assignedDate;
	}

	public Date getEstStarted() {
		return estStarted;
	}

	public void setEstStarted(Date estStarted) {
		this.estStarted = estStarted;
	}

	public Date getRealStarted() {
		return realStarted;
	}

	public void setRealStarted(Date realStarted) {
		this.realStarted = realStarted;
	}

	public String getFinishedBy() {
		return finishedBy;
	}

	public void setFinishedBy(String finishedBy) {
		this.finishedBy = finishedBy;
	}

	public Timestamp getFinishedDate() {
		return finishedDate;
	}

	public void setFinishedDate(Timestamp finishedDate) {
		this.finishedDate = finishedDate;
	}

	public String getCanceledBy() {
		return canceledBy;
	}

	public void setCanceledBy(String canceledBy) {
		this.canceledBy = canceledBy;
	}

	public Timestamp getCanceledDate() {
		return canceledDate;
	}

	public void setCanceledDate(Timestamp canceledDate) {
		this.canceledDate = canceledDate;
	}

	public String getClosedBy() {
		return closedBy;
	}

	public void setClosedBy(String closedBy) {
		this.closedBy = closedBy;
	}

	public Timestamp getClosedDate() {
		return closedDate;
	}

	public void setClosedDate(Timestamp closedDate) {
		this.closedDate = closedDate;
	}

	public String getClosedReason() {
		return closedReason;
	}

	public void setClosedReason(String closedReason) {
		this.closedReason = closedReason;
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

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	public Integer getModule_id() {
		return module_id;
	}

	public void setModule_id(Integer module_id) {
		this.module_id = module_id;
	}

	public Integer getStory_id() {
		return story_id;
	}

	public void setStory_id(Integer story_id) {
		this.story_id = story_id;
	}

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProjectId() {
		return this.project.getId();
	}
}
