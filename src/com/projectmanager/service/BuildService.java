package com.projectmanager.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Build;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Release;
import com.projectmanager.entity.Story;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BuildRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.StoryRepository;

/**
 * @Description: BuildService类封装了一些有关版本的操作
 */
@Service
public class BuildService {

	@Autowired
	private BuildRepository buildRepository;
	
	@Autowired
	private ReleaseService releaseService;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private StoryRepository storyRepository;
	
	public Build create(Build build) {
		
		return this.buildRepository.save(build);
	}
	
	/**
	 * @Description: 获取未发布的版本
	 * @param productId 产品ID
	 * @param branchId 分支ID
	 * @return 版本集合
	 */
	public List<Build> getUnreleasedBuild(int productId, int branchId) {
		
		List<Release> releases = this.releaseService.getReleasesIncludeBranch0(productId, branchId);
		
		List<Integer> releaseBuildIds = new ArrayList<Integer>();
		
		List<Build> builds;
				
		for (Release release : releases) {
			releaseBuildIds.add(release.getBuild().getId());
		}
		if (releaseBuildIds.isEmpty()) {
			releaseBuildIds.add(0);
		}
		if (branchId == 0) {
			builds = this.buildRepository.findByIdNotInAndProductIdOrderByBranch_id(releaseBuildIds, productId);
		} else {
			builds = this.buildRepository.findByIdNotInAndProductIdAndBranch_idOrderByBranch_id(releaseBuildIds, productId, branchId);
		}
		
//		for (Build build : builds) {
//			build.setBranchName(this.branchService.getBranchNameById(productId, build.getBranch_id()));
//		}
		
		return builds;
	}	
	
	/**
	 * @Description: 获取某版本所有版本
	 * @param productId 产品ID
	 * @return 版本集合
	 */
	public List<Build> getAllBuild(int productId) {
		
		List<Build> builds = this.buildRepository.findByProductId(productId);
		
		return builds;
	}
	
	/**
	 * 创建版本
	 * @param build 版本对象
	 * @return 已创建的版本对象
	 */
	public Build created(Build build) {
		
		//创建build
		return this.buildRepository.save(build);
	}
	
	/**
	 * 修改版本信息
	 * @param source 带有修改信息的版本对象
	 * @param target 被修改版本对象
	 * @param comment 备注
	 * @param action 操作
	 */
	public void alter(Build source, Build target, String comment, String action) {
		
		MyUtil.copyProperties(source, target);
	}
	
	/**
	 * 显示build详情
	 * @param buildId
	 * @param model
	 */
	public void viewBuildView(int buildId, String type, Model model) {
		//build
		Build build = this.buildRepository.findOne(buildId);
		//项目
		Project project = this.projectRepository.findOne(build.getProject_id());
		//分支
		Branch branch = this.branchRepository.findOne(build.getBranch_id());
		if(branch != null) {
			model.addAttribute(branch);
		}
		//根据type返回storyList
		model.addAttribute("storyList", this.getStoryByType(type, build));
		model.addAttribute(build);
		model.addAttribute(project);
		//所有用户的用户名和真实名
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
	}
	
	/**
	 * 根据type 和build返回对应的已关联需求或者bug
	 * @param type
	 * @param build
	 * @return
	 */
	public List<Story> getStoryByType(String type, Build build) {
		List<Story> storyList;
		//版本关联的需求id
		List<Integer> storyIds = new ArrayList<Integer>();
		switch (type) {
		case "story":
			//判断版本是否关联需求
			if(build.getStories() != null && build.getStories() !="") {
				//截取需求id
				for(String storyId : build.getStories().split(",")) {
					storyIds.add(Integer.valueOf(storyId));
				}
			}
			//根据需求id查找需求
			storyList = this.storyRepository.findByIdIn(storyIds);
			return storyList;

		case "linkStory":
			//版本所属产品的需求
			storyList = this.storyRepository.findByProductId(build.getProduct().getId());
			List<Story> storys = new ArrayList<Story>();
			if(build.getStories() != null && build.getStories() !="") {
				//截取需求id
				for(String storyId : build.getStories().split(",")) {
					storyIds.add(Integer.valueOf(storyId));
				}
				//循环判断需求是否已关联build
				for(Story story : storyList) {
					//标记是否已关联需求，若mark=0，则尚未关联
					int mark = 0;
					for(Integer storyId : storyIds) {
						if(story.getId() == storyId) {
							mark = 1;
						}
					}
					//将尚未关联的需求添加
					if(mark == 0) {
						storys.add(story);	
					}
				}
			} else { //尚未关联任何需求，则直接显示产品下全部需求
				storys = storyList;
			}
			return storys;
			
		default:
			return null;
		}
	}
	
	/**
	 * 移除或者关联需求
	 * @param ids （操作的需求id数组）
	 * @param buildId
	 * @param type （用于判断何种操作，以下说明）
	 */
	public void batchActionByBuild(Integer[] ids, int buildId, String type) {
		
		Build build = this.buildRepository.findOne(buildId);
		//新的stories或者bugs
		String stories = "";
		switch (type) {
		//移除需求
		case "story":
			//版本关联的需求id
			List<Integer> storyIds = new ArrayList<Integer>();
			if(build.getStories() != null && build.getStories() != "") {
				//截取需求id
				for(String storyId : build.getStories().split(",")) {
					storyIds.add(Integer.valueOf(storyId));
				}
				for(Integer storyId : storyIds) {
					//标记是否移除此需求：mark=0，则不移除
					int mark = 0;
					for(Integer i : ids) {
						if(storyId == i) {
							mark = 1;
						}
					}
					//判断出不移除此需求，则加入stories
					if(mark == 0) {
						stories = stories + storyId + ",";
					}
				}
			}
			
			//保存stories
			build.setStories(stories);
			break;

		//批量关联需求
		case "linkStory":
			//取出原先关联需求id
			stories = build.getStories();
			//循环添加关联的需求id
			for(Integer i : ids) {
				stories = stories + i + ",";
			}
			//关联需求
			build.setStories(stories);
			break;
			
		default:
			break;
		}
	}
	
	/**
	 * 移除单个需求
	 * @param storyid
	 * @param buildId
	 */
	public void deleteStoryForLinkBuild(int storyid, int buildId) {
		Build build = this.buildRepository.findOne(buildId);
		//新的stories或者bugs
		String stories = "";
		//版本关联的需求id
		List<Integer> storyIds = new ArrayList<Integer>();
		//判断版本是否关联有需求
		if(build.getStories() != null && build.getStories() != "") {
			//截取需求id
			for(String storyId : build.getStories().split(",")) {
				storyIds.add(Integer.valueOf(storyId));
			}
			
			for(Integer storyId : storyIds) {
				//判断此storyId是否要移除的storyid
				if(storyId != storyid) {
					stories = stories + storyId + ",";
				}
			}
		}
		//保存stories
		build.setStories(stories);
	}
}
