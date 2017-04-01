package com.projectmanager.entity;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name="proj_storyspec")
public class StorySpec {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;
	
	private Integer storyId;
	
	private Integer version;
	
	private String title;
	
	private String spec;
	
	private String verify;
	
	@Override
	public boolean equals(Object o) {
		if(this == o) return true;
		if(!(o instanceof StorySpec)) return false;
		
		StorySpec storySpec = (StorySpec) o;
		return storySpec.title.equals(title) && storySpec.spec.equals(spec) && storySpec.verify.equals(verify);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getStoryId() {
		return storyId;
	}

	public void setStoryId(Integer storyId) {
		this.storyId = storyId;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}

	public String getVerify() {
		return verify;
	}

	public void setVerify(String verify) {
		this.verify = verify;
	}
}