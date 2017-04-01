package com.projectmanager.entity;

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
@Table(name="proj_bug")
@AttributeOverride(name="module_id",column=@Column(name="module_id"))
public class Bug extends BaseBean implements Log, LogProject {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne
	private Product product;
	
	private Integer branch_id;
	
	private Integer project_id;
	
	private Integer plan_id;
	
	private Integer story_id;
	
	private Integer storyVersion;
	
	private Integer task_id;
	
	private Integer toTask;  //保留字段
	
	private Integer toStory;  //保留字段
	
	private String title;
	
	private String keywords;
	
	private Integer severity;
	
	private String type;
	
	private Integer pri;
	
	private String os;
	
	private String browser;
	
	private String hardware;
	
	private String found;
	
	private String steps;
	
	private String status;
	
	private String color;
	
	private Integer confirmed;
	
	private Integer activatedCount;
	
	private String mailto;
	
	private String openedBy;
	
	private Timestamp openedDate;
	
	private String openedBuild;
	
	private String assignedTo;
	
	private Timestamp assignedDate;
	
	private String resolvedBy;
	
	private String resolution;
	
	private String resolvedBuild;
	
	private Timestamp resolvedDate;
	
	private String closedBy;
	
	private Timestamp closedDate;
	
	private Integer duplicateBug;
	
	private String linkBug;
	
	private Integer useCase;  //保留字段
	
	private Integer caseVersion;
	
	private Integer result;
	
	private Integer repo;  //保留字段,代码
	
	private String entry;  //保留字段
	
	private String line;  //保留字段
	
	private String v1;  //保留字段
	
	private String v2;  //保留字段
	
	private String repoType;  //保留字段
	
	private Integer testTask;  //保留字段
	
	private String lastEditedBy;
	
	private Timestamp lastEditedDate;	
	
	private String deleted;
	
	public Bug() {
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

	public Integer getStoryVersion() {
		return storyVersion;
	}

	public void setStoryVersion(Integer storyVersion) {
		this.storyVersion = storyVersion;
	}

	public Integer getToTask() {
		return toTask;
	}

	public void setToTask(Integer toTask) {
		this.toTask = toTask;
	}

	public Integer getToStory() {
		return toStory;
	}

	public void setToStory(Integer toStory) {
		this.toStory = toStory;
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

	public Integer getSeverity() {
		return severity;
	}

	public void setSeverity(Integer severity) {
		this.severity = severity;
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

	public String getOs() {
		return os;
	}

	public void setOs(String os) {
		this.os = os;
	}

	public String getBrowser() {
		return browser;
	}

	public void setBrowser(String browser) {
		this.browser = browser;
	}

	public String getHardware() {
		return hardware;
	}

	public void setHardware(String hardware) {
		this.hardware = hardware;
	}

	public String getFound() {
		return found;
	}

	public void setFound(String found) {
		this.found = found;
	}

	public String getSteps() {
		return steps;
	}

	public void setSteps(String steps) {
		this.steps = steps;
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

	public Integer getConfirmed() {
		return confirmed;
	}

	public void setConfirmed(Integer confirmed) {
		this.confirmed = confirmed;
	}

	public Integer getActivatedCount() {
		return activatedCount;
	}

	public void setActivatedCount(Integer activatedCount) {
		this.activatedCount = activatedCount;
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

	public String getOpenedBuild() {
		return openedBuild;
	}

	public void setOpenedBuild(String openedBuild) {
		this.openedBuild = openedBuild;
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

	public String getResolvedBy() {
		return resolvedBy;
	}

	public void setResolvedBy(String resolvedBy) {
		this.resolvedBy = resolvedBy;
	}

	public String getResolution() {
		return resolution;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}

	public String getResolvedBuild() {
		return resolvedBuild;
	}

	public void setResolvedBuild(String resolvedBuild) {
		this.resolvedBuild = resolvedBuild;
	}

	public Timestamp getResolvedDate() {
		return resolvedDate;
	}

	public void setResolvedDate(Timestamp resolvedDate) {
		this.resolvedDate = resolvedDate;
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

	public Integer getDuplicateBug() {
		return duplicateBug;
	}

	public void setDuplicateBug(Integer duplicateBug) {
		this.duplicateBug = duplicateBug;
	}

	public String getLinkBug() {
		return linkBug;
	}

	public void setLinkBug(String linkBug) {
		this.linkBug = linkBug;
	}

	public Integer getUseCase() {
		return useCase;
	}

	public void setUseCase(Integer useCase) {
		this.useCase = useCase;
	}

	public Integer getCaseVersion() {
		return caseVersion;
	}

	public void setCaseVersion(Integer caseVersion) {
		this.caseVersion = caseVersion;
	}

	public Integer getResult() {
		return result;
	}

	public void setResult(Integer result) {
		this.result = result;
	}

	public Integer getRepo() {
		return repo;
	}

	public void setRepo(Integer repo) {
		this.repo = repo;
	}

	public String getEntry() {
		return entry;
	}

	public void setEntry(String entry) {
		this.entry = entry;
	}

	public String getLine() {
		return line;
	}

	public void setLine(String line) {
		this.line = line;
	}

	public String getV1() {
		return v1;
	}

	public void setV1(String v1) {
		this.v1 = v1;
	}

	public String getV2() {
		return v2;
	}

	public void setV2(String v2) {
		this.v2 = v2;
	}

	public String getRepoType() {
		return repoType;
	}

	public void setRepoType(String repoType) {
		this.repoType = repoType;
	}

	public Integer getTestTask() {
		return testTask;
	}

	public void setTestTask(Integer testTask) {
		this.testTask = testTask;
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

	public Integer getPlan_id() {
		return plan_id;
	}

	public void setPlan_id(Integer plan_id) {
		this.plan_id = plan_id;
	}

	public Integer getStory_id() {
		return story_id;
	}

	public void setStory_id(Integer story_id) {
		this.story_id = story_id;
	}

	public Integer getTask_id() {
		return task_id;
	}

	public void setTask_id(Integer task_id) {
		this.task_id = task_id;
	}

	@Override
	public int overrideGetProjectId() {
		
		return this.getProject_id();
	}

	@Override
	public int OverrideGetId() {
		
		return this.id;
	}

	@Override
	public int overrideGetProductId() {
		
		return this.getProduct().getId();
	}	
	
}
