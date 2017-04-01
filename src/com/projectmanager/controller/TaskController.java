package com.projectmanager.controller;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
import org.springframework.web.servlet.ModelAndView;

import com.projectmanager.entity.Project;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.TaskEstimate;
import com.projectmanager.entity.Tasks;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.StorySpecRepository;
import com.projectmanager.repository.TaskEstimateRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.ActionService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.TaskService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@Transactional
@SessionAttributes("userAccount")
public class TaskController {
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private TaskEstimateRepository taskEstimateRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private StoryService storyService;
	
	@Autowired
	private StorySpecRepository storySpecRepository;
	
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
	 * 显示创建任务
	 * @param task
	 */
	@RequestMapping(value = "/task_create_{projectId:\\d+}", method = RequestMethod.GET)
	public String viewCreateTask(@PathVariable("projectId") int projectId, Model model) {
		
		return "forward:task_create_" + projectId + "_0";
	}
	
	/**
	 * 显示创建任务
	 * url带storyId，用于需求分解任务时
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_create_{projectId}_{storyId:\\d+}", method = RequestMethod.GET)
	public String viewCreateTaskStoryid(@PathVariable int projectId, @PathVariable int storyId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		//需求列表
		List<Story> storyList = this.storyRepository.findByStory(projectId);
		//全部未删除用户
		List<User> userList = this.userRepository.findAllUser();
		//团队成员
		List<User> teamList = this.taskService.getUserForProject(projectId);
		Story story;
		if(storyId != 0) {
			story = this.storyRepository.findOne(storyId);
		} else {
			story = new Story();
			story.setModule_id(0);
		}
		
		model.addAttribute("story", story);
		model.addAttribute("teamList", teamList);
		model.addAttribute("userList", userList);
		model.addAttribute(project);
		model.addAttribute("storyList", storyList);
		return "project/task_create";
	}
	
	/**
	 * 创建任务
	 * @param projectId
	 * @param task
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping(value = "/task_create_{projectId}_{storyId:\\d+}", method = RequestMethod.POST)
	public String createTask(@RequestParam(value="files", required=false) MultipartFile[] files,
			String[] titles, @PathVariable("projectId") int projectId, Task task, @ModelAttribute("userAccount") String userAccount, Model model) throws Exception {
		
		this.taskService.created(projectId, task);
		//上传文件
		this.fileService.createFile(files, titles, "task", task.getId(), userAccount);
		return "redirect:/project/project_task_" + projectId;
	}
	
	/**
	 * 根据taskId显示要编辑的任务
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_edit_{projectId}_{taskId}", method = RequestMethod.GET)
	public String viewEditTask(@PathVariable int taskId, @PathVariable int projectId, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		Task task = this.taskRepository.findOne(taskId);
		Project project = this.projectRepository.findOne(projectId);
		List<User> userList = this.userRepository.findAllUser();
		//查找有权限的project
		List<Project> projectList = this.projectRepository.findByPriv(userAccount);
		
		//需求列表
		List<Story> storyList = this.storyRepository.findByStory(projectId);
		model.addAttribute("storyList", storyList);
		model.addAttribute(projectList);
		model.addAttribute(task);
		model.addAttribute(project);
		model.addAttribute(userList);
		return "project/task_edit";
	}
	
	/**
	 * 编辑任务
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/task_edit_{projectId}_{taskId}", method = RequestMethod.POST)
	public String editTask(@RequestParam(value="files", required=false) MultipartFile[] files,
			String[] titles, @PathVariable int taskId, @PathVariable int projectId, Task task, String comment, @ModelAttribute("userAccount") String userAccount) throws Exception {
		
		//编辑前任务
		Task updateTask = this.taskRepository.findOne(taskId);
		//编辑任务
		this.taskService.alter(task, updateTask, comment, "edit");
		//上传文件
		this.fileService.createFile(files, titles, "task", taskId, userAccount);
		return "redirect:/project/task_view_" + taskId +"_" + updateTask.getProject().getId();
	}
	
	/**
	 * 查看任务详情
	 * @param taskId
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_view_{taskId}_{projectId}", method = RequestMethod.GET)
	public String taskView(@PathVariable int taskId, @PathVariable int projectId, Model model) {
		
		//task对象
		Task task = this.taskRepository.findOne(taskId);
		Project project = this.projectRepository.findOne(projectId);
		//将task的status转成中文
		this.taskService.alterCh(task);
		
		model.addAttribute(task);
		model.addAttribute(project);
		//需求
		Story story = this.storyRepository.findOne(task.getStory_id());
		model.addAttribute("story", story);
		//需求描述
		model.addAttribute("storySpec", this.storySpecRepository.findByStoryIdAndVersion(task.getStory_id(), story.getVersion()));
		//返回user的account和realname构成的 map
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		//返回task的type和对应的中文名
		model.addAttribute("typeMap", this.taskService.getTypeNameMap());
		//返回task的字段的中文名称
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_view";
	}
	
	/**
	 * 根据projectId显示任务
	 */
	@RequestMapping("/project_task_{projectId:\\d+}")
	public String viewProjectTask(@PathVariable int projectId) {
		
		return "forward:project_task_" + projectId + "_unclosed_0";
	}
	
	/**
	 * 根据produt或module显示任务
	 * @param projectId
	 * @param status
	 * @param statusId
	 * @return
	 */
	@RequestMapping("/project_task_{projectId:\\d+}_{status:[a-zA-Z]+}_{statusId:\\d+}")
	public String viewProjectTaskForType(@PathVariable int projectId, @PathVariable String status, @PathVariable int statusId) {
		//跳转到返回分页的任务
		return "forward:project_task_" + projectId + "_" + status + "_" + statusId + "_id_up_10_1";
	}
	
	/**
	 * 根据status和projectId显示任务
	 */
	@RequestMapping("/project_task_{projectId}_{status:[a-zA-Z]+}")
	public String viewProjectTaskForStatus(@PathVariable int projectId, @PathVariable("status") String status) {
		
		return "forward:project_task_" + projectId + "_"+ status +"_0";
	}
	
	
	/**
	 * 返回分页后的任务
	 * @param projectId
	 * @param status （状态、产品和模块）
	 * @param statusId （产品id、模块id）
	 * @param orderBy （以此排序）
	 * @param ascOrDesc （升、降序）
	 * @param recPerPage （每页记录数）
	 * @param page （页码）
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_task_{projectId}_{status}_{statusId}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}")
	public String viewProjectTaskGet(@PathVariable int projectId, @PathVariable String status ,@PathVariable int statusId, @PathVariable String orderBy, 
			@PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		if(projectId == 0) {
			return "redirect:project_create_0";
		}
		Page<Task> tasks;
		//判断升/降序
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		//取得页码、行数和排序顺序
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		//根据projectId、status、statusId返回分页后的任务list
		tasks = this.taskService.findTaskByStatus(projectId, status, statusId, pageRequest, userAccount);
		if(tasks.getSize() > 0) {
			//将任务的status转成中文
			this.taskService.alterCh(tasks.getContent());
		}
		
		//项目
		Project project = this.projectRepository.findOne(projectId);
		//全部用户
		List<User> userList = this.userRepository.findAllUser();
		
		//返回user的account和realname构成的 map
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		//根据projectId查找关联产品
		model.addAttribute("productList",this.projectService.getProductForProject(projectId));
		model.addAttribute("userList",userList);
		model.addAttribute(project);
		//返回task的type和对应的中文名
		model.addAttribute("typeMap", this.taskService.getTypeNameMap());
		model.addAttribute("taskPage", tasks);
		//根据projectId查找关联需求（用于任务处显示关联需求）
		model.addAttribute("storyMap", this.storyService.getStoryMappingIdAndTitle(projectId));
		return "project/project_task";
	}
	
	/**
	 * 弹出指派/激活任务
	 */
	@RequestMapping(value = "/task_assigned_{taskId}_{projectId}_{statu}", method = RequestMethod.GET)
	public String viewAssignedTask(@PathVariable("taskId") int taskId, @PathVariable String statu, 
			@PathVariable("projectId") int projectId, Model model) {
		Task task = this.taskRepository.findOne(taskId);
		//团队成员
		List<User> userList = this.taskService.getUserForProject(projectId);
		model.addAttribute(userList);
		model.addAttribute(task);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_assigned";
	}
	
	/**
	 * 指派/激活任务
	 */
	@RequestMapping(value = "/task_assigned_{taskId}_{projectId}_{statu}", method = RequestMethod.POST)
	public String assignedTask(@PathVariable("taskId") int taskId, @PathVariable String statu, Task task, 
			@PathVariable("projectId") int projectId, String comment) {
		
		Task updateTask = this.taskRepository.findOne(taskId);
		//激活任务
		if(statu.equals("activate")) {
			task.setStatus("doing");
			updateTask.setFinishedBy(null);
			updateTask.setFinishedDate(null);
			updateTask.setClosedBy(null);
			updateTask.setClosedDate(null);
			updateTask.setClosedReason(null);
			updateTask.setCanceledBy(null);
			updateTask.setCanceledDate(null);
			this.taskService.alter(task, updateTask, comment, "activate");
		} else {
//			task.setRemain(updateTask.getRemain());
			this.taskService.alter(task, updateTask, comment, "assign");
		}
		
		//返回任务详情页面
		if(statu.equals("view") || statu.equals("activate")) {
			return "redirect:task_view_"+taskId + "_" + projectId;
		}
		//返回树状图页面
		if(statu.equals("tree")) {
			return "redirect:project_tree_" + projectId;
		}
		return "redirect:/project/project_task_"+projectId+"_"+statu;
	}
	
	/**
	 * 弹出完成任务
	 */
	@RequestMapping(value = "/task_finish_{taskId}_{projectId}_{statu}", method = RequestMethod.GET)
	public String viewFinishedTask(@PathVariable int taskId, @PathVariable String statu,
			@PathVariable("projectId") int projectId,  Model model) {
		Task task = this.taskRepository.findOne(taskId);
		//团队成员
		List<User> userList = this.taskService.getUserForProject(projectId);
		model.addAttribute(userList);
		model.addAttribute(task);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_finish";
	}
	
	/**
	 * 完成任务
	 * @throws IOException 
	 */
	@RequestMapping(value = "/task_finish_{taskId}_{projectId}_{statu}", method = RequestMethod.POST)
	public String finishedTask(@PathVariable int taskId, @PathVariable String statu,
			@PathVariable("projectId") int projectId, Task task, String[] titles, @ModelAttribute("userAccount") String userAccount,
			@RequestParam(value="files", required=false) MultipartFile[] files,
			 String comment) throws IOException {
		
		task.setStatus("done");
		//完成任务
		this.taskService.alter(task, this.taskRepository.findOne(taskId), comment, "finish");
		
		//上传文件
		this.fileService.createFile(files, titles, "task", task.getId(), userAccount);
		if(statu.equals("view")) {
			return "redirect:task_view_" + taskId + "_" + projectId;
		}
		if(statu.equals("tree")) {
			return "redirect:project_tree_" + projectId;
		}
		return "redirect:/project/project_task_"+projectId+"_"+statu;
	}
	
	/**
	 * 弹出开始任务
	 */
	@RequestMapping(value = "/task_begin_{taskId}_{projectId}_{status}", method = RequestMethod.GET)
	public String viewBeginTask(@PathVariable("taskId") int taskId, Model model) {
		
		Task task = this.taskRepository.findOne(taskId);
		model.addAttribute(task);
		//返回操作历史
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_begin";
	}
	
	/**
	 * 开始、继续任务
	 * @param taskId
	 * @param projectId
	 * @param status
	 * @param task
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_begin_{taskId}_{projectId}_{status}", method = RequestMethod.POST)
	public String beginTask(@PathVariable("taskId") int taskId, @PathVariable("projectId") int projectId,
			 @PathVariable("status") String status, Task task, String comment) {
		
		Task updateTask = this.taskRepository.findOne(taskId);
		task.setStatus("doing");
		//继续任务不修改实际开始时间
		if(status.equals("restart")) {
			task.setRealStarted(updateTask.getRealStarted());
			this.taskService.alter(task, updateTask, comment, "restart");
		} else {
			this.taskService.alter(task, updateTask, comment, "start");
		}
		
		//判断是否从任务详情处打开，若是则跳回任务详情页面
		if(status.equals("view") || status.equals("restart")) {
			return "redirect:task_view_" + taskId + "_" + projectId;
		}
		if(status.equals("tree")) {
			return "redirect:project_tree_" + projectId;
		}
		return "redirect:/project/project_task_" + projectId + "_" + status;
	}
	
	/**
	 * 弹出关闭任务或者暂停任务(status为view的就是暂停)
	 */
	@RequestMapping(value = "/task_close_{taskId}_{projectId}_{status}", method = RequestMethod.GET)
	public String viewCloseTask(@PathVariable int taskId, @PathVariable String status, Model model) {		
		Task task = this.taskRepository.findOne(taskId);
		model.addAttribute(task);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_close";
	}
	
	/**
	 * 关闭任务或者暂停任务(status为pause的就是暂停)
	 */
	@RequestMapping(value = "/task_close_{taskId}_{projectId}_{status}", method = RequestMethod.POST)
	public String closeTask(@PathVariable("taskId") int taskId, @PathVariable int projectId,
			 @PathVariable String status,Task task, String comment) {
		
		Task updateTask = this.taskRepository.findOne(taskId);
		//暂停任务
		if(status.equals("pause")) {
			task.setStatus("pause");
			//不改变预计剩余等数值
			this.taskService.copyRemain(task, updateTask);
			this.taskService.alter(task, updateTask, comment, "pause");
			return "redirect:task_view_"+taskId +"_" + projectId;
		} else {
			//关闭任务
			
			if(updateTask.getStatus().equals("cancel") || updateTask.getStatus().equals("done")) {
				task.setClosedReason(updateTask.getStatus());
			}
			task.setStatus("closed");
			this.taskService.copyRemain(task, updateTask);
			task.setAssignedTo("closed");
			//关闭任务
			this.taskService.alter(task, updateTask, comment, "close");
		}
		//在任务详情处关闭，跳转回任务详情处
		if(status.equals("view") || status.equals("pause")) {
			return "redirect:task_view_" + taskId + "_" + projectId;
		}
		//跳回树状图页面
		if(status.equals("tree")) {
			return "redirect:project_tree_" + projectId;
		}
		return "redirect:project_task_"+projectId+"_"+status;
	}
	
	/**
	 * 弹出记录工时
	 * @param taskId
	 * @param projectId
	 * @param status
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_recordEstimate_{taskId}_{projectId}_{status}", method = RequestMethod.GET)
	public String viewRecordEstimate(@PathVariable int taskId,  @PathVariable int projectId, @PathVariable String status, Model model) {
		//任务
		Task task = this.taskRepository.findOne(taskId);
		//任务工时记录
		List<TaskEstimate> taskEstimateList = this.taskEstimateRepository.findByTaskId(taskId);
		model.addAttribute("taskEstimateList",taskEstimateList);
		model.addAttribute(task);
		return "project/task_recordEstimate";
	}
	
	/**
	 * 记录工时
	 * @param taskId
	 * @param projectId
	 * @param status
	 * @param model
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/task_recordEstimate_{taskId}_{projectId}_{status}", method = RequestMethod.POST)
	public String recordEstimate(@PathVariable int taskId, @PathVariable int projectId, @PathVariable String status, 
			String[] dates, float[] consumed, float[] remain, String[] work, @ModelAttribute("userAccount") String account) throws ParseException {
		
		//批量记录工时
		this.taskService.batchCreateEstimateTask(dates, consumed, remain, work, taskId, account);
		//判断来源
		if(status.equals("view")) {
			//跳回任务详情页面
			return "redirect:task_view_" + taskId + "_" + projectId;
		}
		if(status.equals("tree")) {
			//跳回树状图页面
			return "redirect:project_tree_" + projectId;
		}
		return "redirect:/project/project_task_"+projectId+"_"+status;
	}
	
	/**
	 * 显示编辑单个工时
	 * @param estimateId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/recordEstimate_edit_{estimateId:\\d+}_{taskId}_{status}_{projectId}", method = RequestMethod.GET)
	public String viewRecordEstimateEdit(@PathVariable int estimateId, Model model) {
		
		//工时
		TaskEstimate estimate = this.taskEstimateRepository.findOne(estimateId);
		model.addAttribute("estimate", estimate);
		return "project/recordEstimate_edit";
	}

	/**
	 * 编辑单个工时
	 * @param estimateId
	 * @param estimate
	 * @return
	 */
	@RequestMapping(value = "/recordEstimate_edit_{estimateId:\\d+}_{taskId:\\d+}_{status}_{projectId}", method = RequestMethod.POST)
	public String recordEstimateEdit(@PathVariable int estimateId, @PathVariable int taskId,
			@PathVariable String status, @PathVariable int projectId,TaskEstimate estimate) {
		//任务
		Task task = this.taskRepository.findOne(taskId);
		//工时信息
		TaskEstimate taskEstimate = this.taskEstimateRepository.findOne(estimateId);
		//编辑工时
		MyUtil.copyProperties(estimate, taskEstimate);
		//判断是否任务详情处点开，若是则返回
		if(status.equals("view")) {
			return "redirect:task_view_" + taskId + "_" + projectId;
		}
		return "redirect:task_recordEstimate_"+ taskId +"_"+ task.getProject().getId() +"_" +status;
	}
	
	/**
	 * 删除工时
	 * @param estimateId
	 * @param taskId
	 * @return
	 */
	@RequestMapping(value = "/recordEstimate_delete_{teId:\\d+}_{taskId:\\d+}_{status}")
	public String recordEstimateDelete(@PathVariable int teId, @PathVariable int taskId, @PathVariable String status) {
		//删除工时
		this.taskEstimateRepository.delete(teId);
		//所属任务
		Task task = this.taskRepository.findOne(taskId);
		return "redirect:task_recordEstimate_"+ taskId +"_"+ task.getProject().getId() +"_" +status;
	}
	
	/**
	 * 弹出取消任务
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_cancel_{projectId}_{taskId}", method = RequestMethod.GET)
	public String viewCancelTask(@PathVariable("taskId") int taskId, Model model) {
		
		Task task = this.taskRepository.findOne(taskId);
		model.addAttribute(task);
		//用户名对应的真实姓名
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		//返回历史记录
		this.actionService.renderHistory("task", taskId, model);
		return "project/task_cancel";
	}
	
	/**
	 * 取消任务
	 * @param taskId
	 * @param projectId
	 * @param task （编辑后任务）
	 * @param comment (备注)
	 * @return
	 */
	@RequestMapping(value = "/task_cancel_{projectId}_{taskId}", method = RequestMethod.POST)
	public String cancelTask(@PathVariable("taskId") int taskId, @PathVariable("projectId") int projectId,Task task, String comment) {
		
		//修改任务状态
		task.setStatus("cancel");
		Task updateTask = this.taskRepository.findOne(taskId);
		//取消任务，aop存进操作历史
		this.taskService.alter(task, updateTask, comment, "cancel");
		return "redirect:/project/task_view_"+taskId;
	}
	
	/**
	 * 删除任务后返回任务列表
	 * @param taskId
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value = "/task_deleted_{taskId}_{projectId}")
	public String deleteTask(@PathVariable int taskId, @PathVariable("projectId") int projectId) {
		
		Task task = this.taskRepository.findOne(taskId);
		//并不真的在数据库删除，只是设deleted字段为1
		task.setDeleted("1");
		//删除任务，aop会监测这个方法，保存进操作历史
		this.taskService.alter(task, this.taskRepository.findOne(taskId), "", "delete");
		return "redirect:/project/project_task_"+projectId+"_unclosed";
	}
	
	/**
	 * 显示看板
	 * @param projectId
	 * @param sort （排序方式）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_kanban_{projectId}-{sort}", method = RequestMethod.GET)
	public ModelAndView viewKanban(@PathVariable Integer projectId, @PathVariable String sort, Model model) {
		
		//按需求显示任务 ，根据sort来排序（返回需求对应的任务）
		Map<Story, Map<String,List<Task>>> map = this.taskService.getTaskForStory(projectId, sort);
		Project project = this.projectRepository.findOne(projectId);
		//标记是看板页面，使导航栏设其属性为active
		model.addAttribute("type", "kanban");
		model.addAttribute(project);
		return new ModelAndView("project/project_kanban", "map", map);
		
	}
	
	/**
	 * 分组查看任务
	 * @param projectId
	 * @param type
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_group_{projectId}_{grouptype}_{typeName}", method = RequestMethod.GET)
	public ModelAndView viewGroupStoryByGroup(@PathVariable int projectId, @PathVariable("grouptype") String type, @PathVariable String typeName, Model model) {
		//项目
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(project);
		//返回task的type和对应的中文名
		model.addAttribute("typeMap", this.taskService.getTypeNameMap());
		//根据type返回分好组的任务
		return new ModelAndView("project/project_group_story", "tempMap", this.taskService.getTaskForGroup(projectId, type, typeName));
	}
	
	/**
	 * 在分组查看处删除任务
	 * @param taskId
	 * @param projectId
	 * @param types（分组）
	 * @return
	 */
	@RequestMapping(value = "/deleted_task_{projectId}_{taskId}_{type}")
	public String deleteTaskReturnGroup(@PathVariable("taskId") int taskId, 
			@PathVariable("projectId") int projectId, @PathVariable("type") String types) {
		//任务
		Task task = this.taskRepository.findOne(taskId);
		//并不真的在数据库删除，只是设deleted字段为1
		task.setDeleted("1");
		//删除任务，aop会监测这个方法，保存进操作历史
		this.taskService.alter(task, this.taskRepository.findOne(taskId), "", "delete");
		return "redirect:/project/project_group_"+projectId+"_"+types;
	}
	
	/**
	 * 显示批量编辑任务页面
	 * @param projectId
	 * @param taskIds （任务id数组）
	 * @param model
	 * @return
	 */
	@RequestMapping("/task_batchEdit_{projectId:\\d+}")
	public String viewTaskBatchEdit(@PathVariable int projectId, Integer[] taskIds, Model model) {
		
//		List<Integer> taskIdList = new ArrayList<Integer>();
//		//将字符串转成integer数组
//		for (String taskid : taskIds.split(",")) {
//			taskIdList.add(Integer.valueOf(taskid));
//		}
		
		Project project = this.projectRepository.findOne(projectId);
		//需要编辑的任务list
		List<Task> tasks = this.taskRepository.findByIdIn(taskIds);
		//所有用户
		List<User> userList = this.userRepository.findAllUser();
		model.addAttribute("userList",userList);
		model.addAttribute("tasks",tasks);
		model.addAttribute(project);
		return "project/task_batchEdit";
	}
	
	/**
	 * 批量编辑任务
	 * @param projectId
	 * @param tasks
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_batchEdit_{projectId}_post", method = RequestMethod.POST)
	public String taskBatchEdit(@PathVariable int projectId, Tasks tasks, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		Task updateTask;
		//批量编辑任务
		for(Task task : tasks.getTasks()) {
			//编辑前任务
			updateTask = this.taskRepository.findOne(task.getId());
			//编辑任务
			this.taskService.alter(task, updateTask, "", "edit");
			MyUtil.copyProperties(task, updateTask);
		}
		
		model.addAttribute(project);
		return "redirect:/project/project_task_" + projectId + "_unclosed";
	}
	
	/**
	 * 显示批量添加任务
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value = "/task_batchCreate_{projectId:\\d+}", method = RequestMethod.GET)
	public String viewTaskBatchCreate(@PathVariable int projectId) {
		
		return "redirect:task_batchCreate_" + projectId + "_0";
	}
	
	/**
	 * 显示批量添加任务（storyId不为0就是需求处批量分解任务）
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_batchCreate_{projectId}_{storyId}", method = RequestMethod.GET)
	public String viewTaskBatchCreateStory(@PathVariable int projectId, @PathVariable int storyId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		Story story;
		//判断是否需求处批量分解任务
		if(storyId != 0) {
			story = this.storyRepository.findOne(storyId);
		} else {
			story = new Story();
			//设为0，页面处的模块栏无默认模块
			story.setModule_id(0);
		}
		model.addAttribute("story", story);
		//所有user
		model.addAttribute("userList", this.userRepository.findAllUser());
		model.addAttribute(project);
		return "project/task_batchCreate";
	}
	
	/**
	 * 批量添加任务
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/task_batchCreate_{projectId:\\d+}_{storyId}", method = RequestMethod.POST)
	public String taskBatchCreate(@PathVariable int projectId, @PathVariable int storyId, Tasks tasks) {
		//判断是否有添加任务
		if(tasks != null) {
			//批量添加任务
			this.taskService.batchCreateTask(tasks, projectId);
		}
		return "redirect:project_task_" + projectId;
	}
	
	/**
	 * 批量关闭、指派、关联模块
	 * @param projectId
	 * @param taskIds （任务id数组）
	 * @param fieldName （操作：例如close=关闭）
	 * @param fieldVal （操作目的：例如指派给某个fieldVal）
	 */
	@ResponseBody
	@RequestMapping(value="/task_batchChange_{projectId}",method=RequestMethod.POST)
	public void modifyStories(@PathVariable int projectId, @RequestParam Integer[] taskIds, @RequestParam String fieldName, @RequestParam String fieldVal,  @ModelAttribute("userAccount") String account) {
		//批量关闭、指派、关联模块
		this.taskService.modifiedByColumn(fieldName, fieldVal, taskIds, account);
	}
	
	/**
	 * 添加备注
	 * @param taskId
	 * @return
	 */
	@RequestMapping("/action_createComment_{taskId}_{projectId}")
	public String editActionComment(@PathVariable int taskId, @PathVariable int projectId, String comment) {
		
		Task task = this.taskRepository.findOne(taskId);
		//任务操作历史添加备注
		this.taskService.alter(task, task, comment, "comment");
		return "redirect:task_view_" + taskId + "_" + projectId;
	}
	
	/**
	 * 确认需求变动
	 * @param taskId
	 * @return
	 */
	@RequestMapping("/task_confirmStoryChange_{projectId}_{taskId}")
	public String confirmStoryChange(@PathVariable int projectId, @PathVariable int taskId) {
		
		Task task = this.taskRepository.findOne(taskId);
		//确认需求变动后，将需求版本更新到最新
		task.setStoryVersion(this.storyRepository.findOne(task.getStory_id()).getVersion());
		return "redirect:task_view_" + taskId + "_" + projectId;
	}
}
