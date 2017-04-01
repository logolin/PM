package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class GroupPrivs {

	private List<GroupPriv> groupPrivs = new AutoPopulatingList<GroupPriv>(GroupPriv.class);

	public List<GroupPriv> getGroupPrivs() {
		return groupPrivs;
	}

	public void setGroupPrivs(List<GroupPriv> groupPrivs) {
		this.groupPrivs = groupPrivs;
	}
	
}
