package com.projectmanager.entity;

import javax.persistence.MappedSuperclass;

@MappedSuperclass
public abstract class BaseBean {

	private Integer module_id;

	public Integer getModule_id() {
		return module_id;
	}

	public void setModule_id(Integer module_id) {
		this.module_id = module_id;
	}
}
