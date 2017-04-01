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
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonView;


@Entity
@DynamicInsert
@Table(name="proj_story")
@AttributeOverride(name="module_id",column=@Column(name="module_id"))
public class Story extends BaseBean implements Log, LogProject{

	public interface Public{};
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@JsonView(Public.class)
	private Integer id;
	
	@ManyToOne
	private Product product;
	
	private Integer branch_id;
	
	private String plan;
	
	private String source;
	
	private String sourceNote;
	
	private Integer fromBug;
	
	@JsonView(Public.class)
	private String title;
	
	private String keywords;
	
	private String type;
	
	private Integer pri;
	
	private Float estimate;
	
	private String status;
	
	private String color;
	
	private String stage;
	
	private String mailto;
	
	private String openedBy;
	
	@CreationTimestamp
	private Timestamp openedDate;
	
	private String assignedTo;
	
	private Timestamp assignedDate;
	
	private String lastEditedBy;
	
	@UpdateTimestamp
	@Column(insertable=false)
	private Timestamp lastEditedDate;
	
	private String reviewedBy;
	
	private Date reviewedDate;
	
	private String closedBy;
	
	private Timestamp closedDate;
	
	private String closedReason;
	
	private Integer toBug;
	
	private String childStories;
	
	private String linkStories;
	
	private Integer duplicateStory;
	
	private Integer version;
	
	private String deleted;
	
	@Transient
	private String branchName;

	@Transient
	private String openedByName;
	
	@Transient
	private String assignedToName;
	
	@Transient
	private String reviewedByName;
	
	@Transient
	private String closedByName;
	
	@Transient
	private Integer taskSum;
	
	@Transient
	private StorySpec storySpec;
	
	@Transient
	private String filesStr;
	
	@Transient
	private String duplicateStoryTitle;
	
	@Transient
	private String moduleName;
	
	public Story() {
		
	}
	
	//为了避免使用默认构造函数new出来的对象致使数据库字段值被修改
	public Story(Integer id) {
		this.id = id;
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
	
	public String getPlan() {
		return plan;
	}

	public void setPlan(String plan) {
		this.plan = plan;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getSourceNote() {
		return sourceNote;
	}

	public void setSourceNote(String sourceNote) {
		this.sourceNote = sourceNote;
	}

	public Integer getFromBug() {
		return fromBug;
	}

	public void setFromBug(Integer fromBug) {
		this.fromBug = fromBug;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public Float getEstimate() {
		return estimate;
	}

	public void setEstimate(Float estimate) {
		this.estimate = estimate;
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

	public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public String getMailto() {
		return mailto;
	}

	public void setMailto(String mailto) {
		this.mailto = mailto;
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

	public String getReviewedBy() {
		return reviewedBy;
	}

	public void setReviewedBy(String reviewedBy) {
		this.reviewedBy = reviewedBy;
	}

	public Date getReviewedDate() {
		return reviewedDate;
	}

	public void setReviewedDate(Date reviewedDate) {
		this.reviewedDate = reviewedDate;
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

	public Integer getToBug() {
		return toBug;
	}

	public void setToBug(Integer toBug) {
		this.toBug = toBug;
	}

	public String getChildStories() {
		return childStories;
	}

	public void setChildStories(String childStories) {
		this.childStories = childStories;
	}

	public String getLinkStories() {
		return linkStories;
	}

	public void setLinkStories(String linkStories) {
		this.linkStories = linkStories;
	}

	public Integer getDuplicateStory() {
		return duplicateStory;
	}

	public void setDuplicateStory(Integer duplicateStory) {
		this.duplicateStory = duplicateStory;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
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

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getOpenedByName() {
		return openedByName;
	}

	public void setOpenedByName(String openedByName) {
		this.openedByName = openedByName;
	}

	public String getAssignedToName() {
		return assignedToName;
	}

	public void setAssignedToName(String assignedToName) {
		this.assignedToName = assignedToName;
	}

	public String getReviewedByName() {
		return reviewedByName;
	}

	public void setReviewedByName(String reviewedByName) {
		this.reviewedByName = reviewedByName;
	}

	public String getClosedByName() {
		return closedByName;
	}

	public Integer getTaskSum() {
		return taskSum;
	}

	public void setTaskSum(Integer taskSum) {
		this.taskSum = taskSum;
	}

	public void setClosedByName(String closedByName) {
		this.closedByName = closedByName;
	}

	public StorySpec getStorySpec() {
		return storySpec;
	}

	public void setStorySpec(StorySpec storySpec) {
		this.storySpec = storySpec;
	}

	public String getFilesStr() {
		return filesStr;
	}

	public void setFilesStr(String filesStr) {
		this.filesStr = filesStr;
	}

	public String getDuplicateStoryTitle() {
		return duplicateStoryTitle;
	}

	public void setDuplicateStoryTitle(String duplicateStoryTitle) {
		this.duplicateStoryTitle = duplicateStoryTitle;
	}

	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProductId() {
		return this.product.getId();
	}

	//用于aop来写入操作日志
	@Override
	public int overrideGetProjectId() {
		
		return this.id;
	}
}
