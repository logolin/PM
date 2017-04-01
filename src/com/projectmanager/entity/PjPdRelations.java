package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class PjPdRelations {

	private List<PjPdRelation> pjPdRelations = new AutoPopulatingList<PjPdRelation>(PjPdRelation.class);

	public List<PjPdRelation> getPjPdRelations() {
		return pjPdRelations;
	}

	public void setPjPdRelations(List<PjPdRelation> pjPdRelations) {
		this.pjPdRelations = pjPdRelations;
	}
}
