package com.projectmanager.entity;

import java.sql.Date;
import java.sql.Timestamp;

import javax.annotation.Resource;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicUpdate;

import com.projectmanager.service.ProjectService;

@Entity
@Table(name="proj_project")
@DynamicUpdate
public class Project implements LogProject {

	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	private String type;
	
	private String parent; //保留
	
	private String name;
	
	private String code;
	
	private Date begin;
	
	private Date end;
	
	private Integer days;
	
	private String status;
	
	private String stage;
	
	private String pri;
	
	private String descript;
	
	private String openedBy;
	
	private Timestamp openedDate;
	
	private String openedVersion;  
	
	private String closedBy;
	
	private Timestamp closedDate;
	
	private String canceledBy;
	
	private Timestamp canceledDate;
	
	private String PO;
	
	private String PM;
	
	private String QD;
	
	private String RD;
	
	private String team;
	
	private String acl;
	
	private String whitelist;
	
	private Integer sort;
	
	private String deleted;
	
	@Transient
	private float estimate;
	
	@Transient
	private float consumed;
	
	@Transient
	private float remain;
	
	@Transient
	private String burnStr;
	
	@Transient
	private String statusStr;
	
	public Project() {
		this.acl = "open";
		this.status = "wait";
		this.deleted = "0";
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}
 
	public void setCode(String code) {
		this.code = code;
	}

	public Date getBegin() {
		return begin;
	}

	public void setBegin(Date begin) {
		this.begin = begin;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}

	public Integer getDays() {
		return days;
	}

	public void setDays(Integer days) {
		this.days = days;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStage() {
		return stage;
	}

	public void setStage(String stage) {
		this.stage = stage;
	}

	public String getPri() {
		return pri;
	}

	public void setPri(String pri) {
		this.pri = pri;
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

	public String getOpenedVersion() {
		return openedVersion;
	}

	public void setOpenedVersion(String openedVersion) {
		this.openedVersion = openedVersion;
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

	public String getPO() {
		return PO;
	}

	public void setPO(String pO) {
		PO = pO;
	}

	public String getPM() {
		return PM;
	}

	public void setPM(String pM) {
		PM = pM;
	}

	public String getQD() {
		return QD;
	}

	public void setQD(String qD) {
		QD = qD;
	}

	public String getRD() {
		return RD;
	}

	public void setRD(String rD) {
		RD = rD;
	}

	public String getTeam() {
		return team;
	}

	public void setTeam(String team) {
		this.team = team;
	}

	public String getAcl() {
		return acl;
	}

	public void setAcl(String acl) {
		this.acl = acl;
	}

	public String getWhitelist() {
		return whitelist;
	}

	public void setWhitelist(String whitelist) {
		this.whitelist = whitelist;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
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

	public String getBurnStr() {
		return burnStr;
	}

	public void setBurnStr(String burnStr) {
		this.burnStr = burnStr;
	}

	public String getStatusStr() {
		return statusStr;
	}

	public void setStatusStr(String statusStr) {
		this.statusStr = statusStr;
	}

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProjectId() {
		
		return this.id;
	}
}
