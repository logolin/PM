package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Stories {

	private List<Story> stories = new AutoPopulatingList<Story>(Story.class);
	
	private List<StorySpec> storySpecs = new AutoPopulatingList<StorySpec>(StorySpec.class);

	public List<StorySpec> getStorySpecs() {
		return storySpecs;
	}

	public void setStorySpecs(List<StorySpec> storySpecs) {
		this.storySpecs = storySpecs;
	}

	public List<Story> getStories() {
		return stories;
	}

	public void setStories(List<Story> stories) {
		this.stories = stories;
	}
}
