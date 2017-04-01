package com.projectmanager.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Clock;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.ProjectStory;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.StorySpec;
import com.projectmanager.entity.Storys;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.User;
import com.projectmanager.repository.CaseRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ProjectStoryRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.FileService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@Transactional
@SessionAttributes("userAccount")
public class StoryController {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private CaseRepository caseRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private ProjectService projectService;

	@Autowired
	private StoryService storyService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ProjectStoryRepository projectStoryRepository;
	
	@Autowired
	private FileService fileService;
	
	/**
	 * 需求列表
	 */
	@RequestMapping("/project_story_{projectId:\\d+}")
	public String viewProjectStory(@PathVariable int projectId) {
		return "forward:/project/project_story_" + projectId + "_byProject_0";
	}
	
	/**
	 * 按状态显示需求
	 */
	@RequestMapping("/project_story_{projectId:\\d+}_{status:[a-zA-Z]+}_{statusId:\\d+}")
	public String viewProjectStoryForStatus(@PathVariable int projectId, @PathVariable String status, @PathVariable int statusId) {
		
		return "forward:/project/project_story_" + projectId + "_id_up_" + status + "_" + statusId + "_10_1";
	}
	
	/**
	 * 显示需求列表
	 * @param projectId
	 * @param orderBy
	 * @param ascOrDesc
	 * @param byProductOrModule （根据产品或模块）
	 * @param byPrOrMdId （产品id或模块id）
	 * @param recPerPage
	 * @param page
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_story_{projectId}_{orderBy}_{ascOrDesc}_{byProductOrModule}_{byPrOrMdId}_{recPerPage}_{page}", method = RequestMethod.GET)
	public String viewProjectStoryGet(@PathVariable int projectId, @PathVariable String orderBy, @PathVariable String ascOrDesc,
			@PathVariable String byProductOrModule, @PathVariable int byPrOrMdId, @PathVariable int recPerPage, @PathVariable int page,Model model) {
		//用例数
		int caseSum = 0;
		//排序
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		
		//page默认是从0开始，即第一页的页数java中为0
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		//分页
		Page<Story> storyPage;
		//判断根据产品或者模块查找需求
		if(byProductOrModule.equals("byProduct")) {
			storyPage = this.storyRepository.findByProjectAndProduct(projectId,byPrOrMdId, pageRequest);
		} else if(byProductOrModule.equals("byModule")) {
				storyPage = this.storyRepository.findByProjectAndModule(projectId,byPrOrMdId, pageRequest);
		} else {
			storyPage = this.storyRepository.findByProject(projectId, pageRequest);
		}
		
		//求关联用例
		for(Story story : storyPage.getContent()) {
			if (this.caseRepository.existsByStory_id(story.getId())) {
				caseSum ++;
			}
			//任务数
			story.setTaskSum(this.taskRepository.countByStoryAndDeleted(story.getId(), "0").size());
		}
		Project project = this.projectRepository.findOne(projectId);
		List<Product> productList = this.projectService.getProductForProject(projectId);
		//判断项目是否关联产品，决定页面是否出现新增需求按钮
		int idProduct;
		if(productList.size() > 0) {
			idProduct = productList.get(0).getId();
		} else {
			idProduct = 0;
		}
		model.addAttribute("idProduct",idProduct);
		model.addAttribute("storyPage", storyPage);
		//查找关联产品
		model.addAttribute("productList",this.projectService.getProductForProject(projectId));
		model.addAttribute(project);
		model.addAttribute("caseSum", caseSum);
		return "project/project_story";
	}
	/**
	 * 移除需求
	 * @param projectId
	 * @param storyId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/projectstory_deleted_{projectId}_{storyId}")
	public String deletedProjectStory(@PathVariable("projectId") int projectId, @PathVariable("storyId") int storyId, Model model) {
		this.storyRepository.deletedStory(storyId);
		List<Story> storyList = this.storyRepository.findByStory(projectId);
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(storyList);
		model.addAttribute(project);
		return "redirect:/project/project_story_"+project.getId();
	}
	
	/**
	 * 显示批量编辑需求页面
	 * @param projectId
	 * @param storyId
	 * @param model
	 * @return
	 */
	@RequestMapping("/story_batchEdit_{projectId:\\d+}")
	public String viewStoryBatchEdit(@PathVariable int projectId, Integer[] storyIds, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		
		List<User> userList = (List<User>) this.userRepository.findAll();
		List<Story> stoyList = this.storyRepository.findByIdIn(storyIds);	
		model.addAttribute(stoyList);
		model.addAttribute(project);
		model.addAttribute(userList);
		return "project/story_batchEdit";
	}
	
	/**
	 * 批量编辑需求
	 * @param projectId
	 * @param stories
	 * @return
	 */
	@RequestMapping("/story_batchEdit_{projectId}_update")
	public String storyBatchEdit(@PathVariable int projectId, Storys stories) {
		Story updateStory;
		//选中需求才执行编辑需求
		if(stories != null) {
			for(Story story : stories.getStorys()) {
				//编辑前需求
				updateStory = this.storyRepository.findOne(story.getId());
				//编辑需求
				this.storyService.alter(story, updateStory, "", "edit");
			}
		}
		return "redirect:/project/project_story_" + projectId;
	}
	
	/**
	 * 弹出相关任务
	 * @param storyId
	 * @param model
	 * @return
	 */
	@RequestMapping("story_taskSum_{projectId}_{storyId}")
	public String viewStoryTaskSum(@PathVariable int storyId, Model model) {
		//根据storyId查找相关任务
		List<Task> taskList = this.taskRepository.countByStoryAndDeleted(storyId, "0");
		model.addAttribute("taskList",taskList);
		return "project/story_taskSum";
	}

	
	/**
	 * 显示新增需求 （项目页面点击新增需求）
	 * @author logolin
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_create_{productId}_{projectId}", method=RequestMethod.GET)
	public String viewcreateStory(@PathVariable int productId, @PathVariable int projectId, Model model) {
		//项目关联的产品
		List<Product> products = this.projectService.getProductForProject(projectId);
		//需求来源（转成对应的中文）map
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		//返回user的account和realname构成的 map
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("productList", products);
		
		return "product/story_create";
	}
	
	/**
	 * 新增需求
	 * @author logolin
	 * @param productId
	 * @param story
	 * @param storySpec
	 * @param files
	 * @param titles
	 * @param userAccount
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/story_create_{productId}_{projectId}", method=RequestMethod.POST)
	public String createStory(@PathVariable int projectId, Story story, StorySpec storySpec, @PathVariable int productId,
			@RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, 
			@ModelAttribute("userAccount") String userAccount,Model model) throws IOException {
		
		story.setOpenedBy(userAccount);
		if (story.getAssignedTo() != null && !story.getAssignedTo().equals(""))
			story.setAssignedDate(new Timestamp(Clock.systemDefaultZone().millis()));
		int storyId = this.storyService.create(story, storySpec).getId();
		
		this.fileService.createFile(files, titles, "story", storyId, userAccount);
		
		//项目关联需求
		ProjectStory pStory = new ProjectStory();
		pStory.setProduct_id(story.getProduct().getId());
		pStory.setProject_id(projectId);
		pStory.setStory_id(story.getId());
		this.projectStoryRepository.save(pStory);
		return "redirect:/project/project_story_" + projectId;
	}
	
	/**
	 * 批量关闭、移除需求
	 * @param projectId
	 * @param storyIds （需求id数组）
	 * @param fieldName （操作：例如close=关闭）
	 */
	@ResponseBody
	@RequestMapping(value="/story_batchChange_{projectId}",method=RequestMethod.POST)
	public void modifyStories(@PathVariable int projectId, @RequestParam Integer[] storyIds, @RequestParam String fieldName) {
		//批量关闭、移除需求
		this.storyService.modifiedByColumn(projectId, fieldName, storyIds);
	}
	
	/**
	 * 显示关联需求 （项目关联需求）
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/project_linkStory_{projectId}",method=RequestMethod.GET)
	public String viewLinkStory(@PathVariable int projectId, Model model) {
		
		//未关联需求
		List<Story> storyList = this.storyService.getNoLinkStoryByProject(projectId);
		model.addAttribute(storyList);
		//项目
		model.addAttribute(this.projectRepository.findOne(projectId));
		//返回user的account和realname构成的 map
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "project/project_linkStory";
	}
	
	/**
	 * 关联需求 （项目关联需求）
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value="/project_linkStory_{projectId}",method=RequestMethod.POST)
	public String linkStory(@PathVariable int projectId, Integer[] storyIds) {
		
		this.storyService.linkStoryToProject(storyIds, projectId);
		return "redirect:project_story_" + projectId;
	}
}
