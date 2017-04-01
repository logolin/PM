package com.projectmanager.entity;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="proj_projectproduct")
public class PjPdRelation {

	@EmbeddedId
	private PjPdRelationPK id;
	
	private Integer branch_id;

	public PjPdRelationPK getId() {
		return id;
	}

	public void setId(PjPdRelationPK id) {
		this.id = id;
	}

	public Integer getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(Integer branch_id) {
		this.branch_id = branch_id;
	}
}
