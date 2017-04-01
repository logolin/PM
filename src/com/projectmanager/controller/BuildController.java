package com.projectmanager.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.projectmanager.entity.Build;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.User;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BuildRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.ActionService;
import com.projectmanager.service.BuildService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@SessionAttributes("userAccount")
@Transactional
public class BuildController {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private BuildRepository buildRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private BuildService buildService;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private StoryService storyService;
	
	
	/**
	 * 拦截url，获得projectId
	 * @param projectId
	 * @param session
	 */
	@ModelAttribute
	public void setProjectSession(@PathVariable Integer projectId, HttpSession session) {
		//设置产品id的session
		session.setAttribute("sessionProjectId", projectId);
	}
	
	/**
	 * 根据项目查找版本
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_build_{projectId}", method = RequestMethod.GET)
	public String viewBuildList(@PathVariable("projectId") int projectId, Model model) 
	{
		Project project = this.projectRepository.findOne(projectId);
		//根据项目查找版本列表
		List<Build> buildList = this.buildRepository.findByProjectAndDeleted(projectId);
		
		//将构建者转为中文
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute(project);
		model.addAttribute(buildList);
		return "project/project_build";
	}
	
	/**
	 * 显示build详情
	 * @param buildId
	 * @return
	 */
	@RequestMapping(value = "/build_view_{buildId}_{projectId:\\d+}", method = RequestMethod.GET)
	public String viewBuild(@PathVariable int buildId, @PathVariable int projectId) {
		
		return "redirect:build_view_" + buildId + "_" + projectId + "_story";
	}
	
	/**
	 * 根据type查看build详情
	 * @param buildId
	 * @param type （story或者linkStroy等，story为显示build详情并且显示已关联的需求）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/build_view_{buildId}_{projectId}_{type}", method = RequestMethod.GET)
	public String viewBuildByType(@PathVariable int buildId, @PathVariable String type, Model model) throws Exception{
		
		//查看版本详情
		this.buildService.viewBuildView(buildId, type, model);
		//操作历史操作和类型等对应的中文名称
		this.actionService.renderHistory("build", buildId, model);
		//需求阶段对应的中文
		model.addAttribute("stageMap", this.storyService.getStageMap());
		//需求状态对应的中文
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		return "project/build_view";
	}
	
	/**
	 * 根据type来执行批量操作（例如story：批量移除需求，linkStory：关联需求）
	 * @param buildId
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/build_view_{buildId}_{projectId}_{type}", method = RequestMethod.POST)
	public String linkTypeToBuild(@PathVariable int buildId, @PathVariable int projectId, @PathVariable String type, Integer[] storyIds) {
		//批量操作需求
		this.buildService.batchActionByBuild(storyIds, buildId, type);
		//默认跳回已完成需求页面
		return "redirect:build_view_" + buildId + "_" + projectId + "_story";
	}
	
	/**
	 * 显示编辑build
	 * @param buildId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/build_edit_{buildId}_{projectId}", method = RequestMethod.GET)
	public String viewEditBuild(@PathVariable("buildId") int buildId, Model model) {
		Build build = this.buildRepository.findOne(buildId);
		Project project = this.projectRepository.findOne(build.getProject_id());
		List<User> userList = this.userRepository.findAllUser();
		//根据项目查找关联产品
		List<Product> productList = this.projectService.getProductForProject(project.getId());
		
		model.addAttribute("productList", productList);
		model.addAttribute("build", build);
		model.addAttribute("project", project);
		model.addAttribute("userList", userList);
		return "project/build_edit";
	}
	
	/**
	 * 移除单个已关联版本需求
	 * @param buildId
	 * @return
	 */
	@RequestMapping("/build_delete_{buildId}_{storyId}_{projectId}")
	public String deleteStoryForLinkBuild(@PathVariable int buildId, @PathVariable int projectId, @PathVariable int storyId) {
		
		//移除单个需求
		this.buildService.deleteStoryForLinkBuild(storyId, buildId);
		return "redirect:build_view_" + buildId + "_" + projectId + "_story";
	}
	
	/**
	 * 编辑版本
	 * @param buildId
	 * @param build
	 * @param model
	 */
	@RequestMapping(value = "/build_edit_{buildId}_{projectId}", method = RequestMethod.POST)
	public String editBuild(@PathVariable int buildId, @PathVariable int projectId, Build build, @RequestParam(value="files", required=false) MultipartFile[] files, String[] titles) {
		
		Build updateBuild = this.buildRepository.findOne(buildId);
		//编辑版本
		this.buildService.alter(build, updateBuild, "", "edit");
		return "redirect:/project/build_view_" + buildId + "_" +projectId;
	}
	
	/**
	 * 显示创建版本
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/build_create_{projectId}", method = RequestMethod.GET)
	public String createBuildGet(@PathVariable("projectId") int projectId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		//全部用户
		List<User> userList = this.userRepository.findAllUser();
		//根据项目查找关联产品
		List<Product> productList = this.projectService.getProductForProject(projectId);
		
		model.addAttribute(productList);
		model.addAttribute(project);
		model.addAttribute(userList);
		return "project/build_create";
	}
	
	/**
	 * 创建版本
	 * @param projectId
	 * @param build
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping(value = "/build_create_{projectId}", method = RequestMethod.POST)
	public String createBuildPost(@PathVariable int projectId, Build build,
			@RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, @ModelAttribute("userAccount") String userAccount) throws Exception {
		//创建版本，返回创建后的版本id
		int buildId = this.buildService.created(build).getId();
		//上传文件
		this.fileService.createFile(files, titles, "build", buildId, userAccount);
		return "redirect:build_view_" + buildId;
	}
	
	/**
	 * 删除版本
	 * @param projectId
	 * @param buildId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/build_deleted_{buildId}_{projectId}")
	public String deletedBulid(@PathVariable int buildId, @PathVariable int projectId) {
		//删除版本
		this.buildRepository.deletedBuild(buildId);
		return "redirect:/project/project_build_" + projectId;
	}
}
