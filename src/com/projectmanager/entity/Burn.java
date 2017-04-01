package com.projectmanager.entity;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

@Entity(name="proj_burn")
public class Burn {

	@EmbeddedId
	private BurnPK id;
	
	private float remain;
	
	private float consumed;

	public BurnPK getId() {
		return id;
	}

	public void setId(BurnPK id) {
		this.id = id;
	}

	public float getRemain() {
		return remain;
	}

	public void setRemain(float remain) {
		this.remain = remain;
	}

	public float getConsumed() {
		return consumed;
	}

	public void setConsumed(float consumed) {
		this.consumed = consumed;
	}
}
