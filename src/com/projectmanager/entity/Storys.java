package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Storys {

	private List<Story> storys = new AutoPopulatingList<Story>(Story.class);

	public List<Story> getStorys() {
		return storys;
	}

	public void setStorys(List<Story> storys) {
		this.storys = storys;
	}
}
