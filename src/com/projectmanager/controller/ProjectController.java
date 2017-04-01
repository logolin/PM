package com.projectmanager.controller;

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
import org.springframework.web.bind.annotation.SessionAttributes;

import com.projectmanager.entity.Action;
import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Burn;
import com.projectmanager.entity.Group;
import com.projectmanager.entity.PjPdRelations;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Projects;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.Teams;
import com.projectmanager.entity.TestTask;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.BurnRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.PjPdRelationRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.TeamRepository;
import com.projectmanager.repository.TestTaskRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.ActionService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.TeamService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@Transactional
@SessionAttributes("userAccount")
public class ProjectController {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private GroupRepository groupRepository;
	
	@Autowired
	private TestTaskRepository testTaskRepository;
	
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private TeamRepository teamRepository;
	
	@Autowired
	private PjPdRelationRepository pjPdRelationRepository;
	
	@Autowired
	private BurnRepository burnRepository;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private TeamService teamService;

	
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
	 * 路由
	 * @param subMenu 二层菜单
	 * @param action 执行的操作
	 * @param projectId 项目ID
	 * @return
	 */
	@RequestMapping("/{subMenu:[a-z]+}_{action:[a-z]+}_{projectId:\\d+}")
	public String route(@PathVariable String subMenu, @PathVariable String action, @PathVariable int projectId) {
		
		if(projectId == 0) {
			return "redirect:project_create_0";
		}
		switch (subMenu) {
		case "task":
			return "redirect:project_task_" + projectId;
		case "build":
			return "redirect:project_build_" + projectId;
		default:
			return null;
		}
		
		
	}
	
	/**
	 * 显示项目主页
	 */
/*	@RequestMapping(value = "/project_index_{projectId}", method = RequestMethod.GET)
	public String viewProjectIndex(@PathVariable("projectId") int projectId, @ModelAttribute("userAccount") String userAccount, Model model) {
		//查找所有未删除的项目
		List<Project> projectList = this.projectRepository.findByDeleted("0");
		//查找指派给用户的所有未删除任务
		List<Task> taskList= this.taskRepository.findByAssignedToAndDeleted(userAccount, "0");
		//项目
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(taskList);
		model.addAttribute(projectList);
		model.addAttribute(project);
		return "project/project_index";
	}*/

	/**
	 * 按项目状态显示项目列表
	 */
	@RequestMapping("/project_all_{projectId}_{status:[a-zA-Z]+}")
	public String viewAllProject(@PathVariable int projectId, @PathVariable String status) {
		return "forward:project_all_" + projectId +"_" + status + "_id_up_0_0_10_1";
	}
	
	/**
	 * 按状态或者产品查找项目
	 * @param content
	 * @param status （状态或者product）
	 * @param projectId （产品id，status不为product得都默认为0）
	 * @param orderBy （以此排序）
	 * @param ascOrDesc （升/降序）
	 * @param productId
	 * @param projectSum
	 * @param recPerPage
	 * @param page
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/project_all_{projectId}_{status}_{orderBy}_{ascOrDesc}_{productId}_{projectSum}_{recPerPage}_{page}")
	public String viewAllProjectGet(@RequestParam(value="content", defaultValue="", required=false) String content,@PathVariable String status, @PathVariable int projectId, 
			@PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int productId,
			@PathVariable int projectSum, @PathVariable int recPerPage, @PathVariable int page, Model model) throws Exception {
		//判断升/降序
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		//page默认是从0开始，即第一页的页数java中为0
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		//根据状态或者产品来查找项目
		Page<Project> projectPage = this.projectService.findProjectByStatus(status, productId, pageRequest);
		for(Project project1 : projectPage.getContent()) {
			System.out.println("前面：" + project1.getRemain());
		}
		
		//返回总消耗等信息
		this.projectService.getProjectForStatus(projectPage.getContent());
		Project project = this.projectRepository.findOne(projectId);
		//返回所有产品
		List<Product> productList = this.productRepository.findByDeleted("0");
		model.addAttribute(productList);
		model.addAttribute("projectPage", projectPage);
		model.addAttribute(project);
		return "project/project_all_undone";
	}

	/**
	 * 根据产品来查找项目
	 */
	 
	@RequestMapping(value = "/project_all_{projectId}_byproduct_{productId}", method = RequestMethod.GET)
	public String viewProjectByProduct(@PathVariable("productId") int productId, 
			@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		List<Project> projectList = this.projectService.findProjectsForProduct(productId);
		List<Product> productList = this.productRepository.findByDeleted("0");
		model.addAttribute(projectList);
		model.addAttribute(project);
		model.addAttribute(productList);
		return "project/project_all_undone";
	}
	
	/**
	 * 显示项目详情
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_view_{projectId}", method = RequestMethod.GET)
	public String viewProejectGet(@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		this.projectService.alterProject(project);
		List<Product> productList = this.projectService.getProductForProject(projectId);
		List<User> userList = (List<User>) this.userRepository.findAll();
		model.addAttribute(userList);
		model.addAttribute(productList);
		model.addAttribute(project);
		model.addAttribute("groupMap", this.userService.getAllGroupMapIdAndName());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("project", projectId, model);
		return "project/project_view";
	}
	
	/**
	 * 显示编辑项目
	 */
	@RequestMapping(value = "/project_edit_{projectId}", method = RequestMethod.GET)
	public String viewEditProject(@PathVariable("projectId") Integer projectId, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		List<User> userList = this.userRepository.findAllUser();
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		
		
		model.addAttribute("whiteList", this.projectService.getWhiteList(project.getWhitelist()));
		model.addAttribute(project);
		model.addAttribute(userList);
		model.addAttribute(groupList);
		model.addAttribute("map", this.projectService.getMapProductAndBranch(projectId));
		model.addAttribute("branchIds",this.projectService.getBranchIds(projectId));
		model.addAttribute("productList", this.productRepository.findAll());
		return "project/project_edit";
	}
	
	/**
	 * 编辑项目
	 * @param projectId
	 * @param project
	 * @return
	 */
	@RequestMapping(value = "/project_edit_{projectId}", method = RequestMethod.POST)
	public String editProject(@PathVariable("projectId") Integer projectId, Project project, @RequestParam(required = false) Integer[] products, @RequestParam(required = false) Integer[] branchs) {
		
		Project updateProject = this.projectRepository.findOne(projectId);
		
		this.projectService.alter(project, updateProject, "", "edit");
		project.setId(projectId);
		this.projectService.linkProductAndBranch(project, products, branchs);
		
		return "redirect:project_view_" + projectId;
	}
	
	/**
	 * 显示创建项目页面
	 * @param project
	 * @return
	 */
	@RequestMapping(value = "/project_create_{projectId}", method = RequestMethod.GET)
	public String project(@PathVariable int projectId, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		
		model.addAttribute("project", project);
		model.addAttribute(groupList);
		model.addAttribute("productList", this.productRepository.findByPrivAccount(userAccount));
		
		return "project/project_create";
	}
	
	/**
	 * 创建项目
	 * @param projectId
	 * @param project
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_create_{projectId}", method = RequestMethod.POST)
	public String createProject(@PathVariable("projectId") int projectId, Project project, @ModelAttribute("userAccount") String userAccount, @RequestParam(required = false) Integer[] products,  @RequestParam(required = false) Integer[] branchs) {
		
		int projId = this.projectService.created(project, products, branchs).getId();
		this.projectService.linkTeamProject(projId, userAccount);
		return "redirect:/project/project_view_" + projId;
	}

	/**
	 * 显示测试任务页面
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_testtask_{projectId}", method = RequestMethod.GET)
	public String viewTestTask(@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		List<TestTask> testTaskList = this.testTaskRepository.findByProject_id(projectId);
		model.addAttribute(project);
		model.addAttribute(testTaskList);
		return "project/project_testtask";
	}
	
	/**
	 * 显示Bug列表 （默认显示每页10行）
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value = "/project_bug_{projectId:\\d+}", method = RequestMethod.GET)
	public String viewProjectTask(@PathVariable int projectId) {
		
		return "forward:/project/project_bug_" + projectId + "_id_up_10_1";
	}
	
	/**
	 * 显示Bug列表
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_bug_{projectId}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}", method = RequestMethod.GET)
	public String viewBug(@PathVariable("projectId") int projectId, @PathVariable String orderBy, 
			@PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		/*Sort sort;
		
		if (ascOrDesc.equals("asc")) {
			sort = new Sort(Sort.Direction.ASC, orderBy);
		} else {
			sort = new Sort(Sort.Direction.DESC, orderBy);
		}*/
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		Page<Bug> bugPage = this.bugRepository.findByProject_id(projectId, pageRequest);
		List<Team> teamList = this.teamRepository.findByProject(projectId);
		model.addAttribute(teamList);
		model.addAttribute(project);
		model.addAttribute("bugPage", bugPage);
		return "project/project_bug";
	}
	
	/**
	 * 批量指派bug
	 */
	@RequestMapping("/bug_batchAssign_{assignedTo}_{projectId}")
	public String bugBatchAssign(@PathVariable int projectId, Integer[] bugs, @PathVariable String assignedTo, Model model) {
		Bug bug = new Bug();
		for(Integer i : bugs) {
			//批量指派bug
			bug = this.bugRepository.findOne(i);
			bug.setAssignedTo(assignedTo);
			
		}
		return "redirect:/project/project_bug_" + projectId;
	}
	
	/**
	 * 显示团队列表
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_team_{projectId}", method = RequestMethod.GET)
	public String viewTeam(@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		List<Team> teamList = this.teamRepository.findByProject(projectId);
		
		model.addAttribute(project);
		model.addAttribute(teamList);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "project/project_team";
	}
	/**
	 * 移除团队成员
	 * @param acount
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/team_deleted_{projectId}_{account}")
	public String deleteTask(@PathVariable("account") String account, 
			@PathVariable("projectId") Integer projectId, Model model) {
		Team team = this.teamRepository.findByProjectAndAccount(projectId, account);
		this.teamRepository.delete(team);
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(project);
		return "redirect:/project/project_team_"+projectId;
	}
	
	/**
	 * 显示团队管理
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/project_managemembers_{projectId:\\d+}")
	public String viewManagemembers(@PathVariable int projectId) {
		
		//因为默认admin的部门id是0，所以只能用-1来做默认的部门id
		return "forward:project_managemembers_" + projectId + "_-1";
	}
	
	/**
	 * 可选部门显示团队管理
	 * @param projectId
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_managemembers_{projectId}_{deptId}")
	public String viewManagememberForDept(@PathVariable int projectId, @PathVariable int deptId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		//团队list
		List<Team> teamList = this.teamRepository.findByProject(projectId);
		//根据部门来返回未加入团队的用户list
		if(deptId != -1)  {
			model.addAttribute("deptUser", this.userService.getDeptUser(teamList, deptId));
		}
		
		//返回不在团队内的所有用户
		model.addAttribute("noteam", this.userService.getUserNotTeam(teamList));
		model.addAttribute(teamList);
		model.addAttribute("project", project);
		//返回account和realname为key和value的map，将account都用realname来显示
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "project/project_managemembers";
	}
	
	/**
	 * 管理团队
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value = "/project_managemembers_{projectId}_{deptId}", method = RequestMethod.POST)
	public String manageMembers(@PathVariable int projectId, Teams teams, @RequestParam String[] accounts, @RequestParam String[] roles,
			@RequestParam Integer[] days, @RequestParam Float[] hours) {
		
		//编辑团队成员
		this.teamService.manageTeam(projectId, teams);
		
		//添加团队成员
		this.teamService.created(projectId, accounts, roles, days, hours);
		return "redirect:project_team_" + projectId;
	}
	
	/**
	 * 显示树状图
	 */
	@RequestMapping(value = "/project_tree_{projectId}", method = RequestMethod.GET)
	public String viewTree(@PathVariable Integer projectId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		//查找无关联模块与需求的任务
		List<Task> taskList = this.projectService.getTaskForNotModule(projectId);
		
		//标记是树状图页面，让前端能识别，设对应导航栏为active
		model.addAttribute("type", "tree");
		//任务列表
		model.addAttribute(taskList);
		model.addAttribute("project", project);
		//返回所有用户名和真实姓名
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		//返回项目关联的产品
		model.addAttribute("productList", this.projectService.getProductForProject(projectId));
		return "project/project_tree";
	}
	
	/**
	 * 显示批量编辑项目
	 * @param projectId
	 * @param projectIds
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_batchEdit_{projectId}")
	public String viewProjectBatchEdit(@PathVariable int projectId, Integer[] projectIds, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		//根据项目id数组查找项目
		List<Project> projectList = this.projectRepository.findByIdIn(projectIds);
		//所有用户
		List<User> userList = (List<User>) this.userRepository.findAll();
		model.addAttribute(userList);
		model.addAttribute(project);
		model.addAttribute("projectList", projectList);
		return "project/project_batchEdit";
	}
	
	/**
	 * 批量编辑项目
	 * @param projectId
	 * @param projects
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_batchEdit_{projectId}_update")
	public String projectBatchEdit(@PathVariable int projectId, Projects projects, Model model) {
		
		Project updateProject;
		//循环编辑项目
		for(Project project : projects.getProjects()) {
			//编辑前的项目
			updateProject = this.projectRepository.findOne(project.getId());
			//编辑项目
			MyUtil.copyProperties(project, updateProject);
		}
		return "redirect:/project/project_all_undone_" + projectId + "_id_asc_0_0_10_1";
	}
	
	/**
	 * 显示燃尽图
	 */
	@RequestMapping("/project_burn_{projectId:\\d+}")
	public String viewProjectBurn(@PathVariable int projectId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		//计算燃尽图默认间隔天数
		String day = this.projectService.getDayForBurn(project);
		//标记是燃尽图页面，让前端能识别，设对应导航栏为active
		model.addAttribute("type", "burn");
		model.addAttribute(project);
		return "forward:project_burn_" + projectId + "_noweekend_" + day;
	}
	
	/**
	 * 显示燃尽图（间隔天数、是否显示周末）
	 * @param projectId
	 * @param weekend
	 * @param days
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_burn_{projectId:\\d+}_{weekend:[a-zA-Z]+}_{days}")
	public String viewBurn(@PathVariable int projectId, @PathVariable String weekend, @PathVariable String days, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		try {
			//根据项目查找燃尽图数据
			List<Burn> burnList = this.burnRepository.findByIdProjectOrderByIdDateAsc(project);
			//判断此项目是否有燃尽图数据
			if(burnList.size() > 0) {
				model.addAttribute("burnList", burnList);
			}
			
		} catch (Exception e) {
			
		}
		model.addAttribute(project);
		return "project/project_burn";
	}
	
	/**
	 * 显示关联产品
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping("/project_manageproducts_{projectId}")
	public String viewManageProducts(@PathVariable int projectId, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		//返回产品和分支map
		Map<Product,List<Branch>> map = this.projectService.getProductAndBranch(userAccount);
		//已关联产品
		model.addAttribute("pjpd", this.pjPdRelationRepository.findByProject_id(projectId));
		model.addAttribute("project",this.projectRepository.findOne(projectId));
		model.addAttribute("map",map);
		return "project/project_manageproducts";
	}
	
	/**
	 * 关联产品
	 * @param projectId
	 * @param pjPdId
	 * @param pjPdRelations
	 * @return
	 */
	@RequestMapping(value = "/project_manageproducts_{projectId}", method = RequestMethod.POST)
	public String manageProduct(@PathVariable int projectId, Integer[] pjPdId, PjPdRelations pjPdRelations) {
		
		//关联产品
		this.projectService.linkProduct(pjPdId, pjPdRelations, projectId);
		return "redirect:project_task_" + projectId +"_unclosed";
	}
	
	/**
	 * 弹出 开始/挂起/激活/结束项目
	 * 用/projects是为了防止和需求、任务url冲突
	 * @param projectId
	 * @param status
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/projects_{status}_{projectId}", method = RequestMethod.GET)
	public String viewBeginProject(@PathVariable int projectId, @PathVariable String status, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(project);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("project", projectId, model);
		return "project/project_changeStatus";
	}
	/**
	 * 开始/挂起/激活/结束项目
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/projects_{status}_{projectId}", method = RequestMethod.POST)
	public String beginProject(@PathVariable int projectId, @PathVariable String status, Project project, String comment) {
		
		
		this.projectService.alter(this.projectService.changeStatus(status, project), this.projectRepository.findOne(projectId), comment, status);
		
		return "redirect:project_view_" + projectId;
	}
	
	/**
	 * 弹出 项目延期
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/projects_delay_{projectId}", method = RequestMethod.GET)
	public String viewDelayProject(@PathVariable int projectId, Model model) {
		
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute(project);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("project", projectId, model);
		return "project/project_delay";
	}
	
	/**
	 * 项目延期
	 * @param projectId
	 * @param project
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/projects_delay_{projectId}", method = RequestMethod.POST)
	public String delayProject(@PathVariable int projectId, Project project, String comment) {
		
		Project updateProject = this.projectRepository.findOne(projectId);
		project.setStatus(updateProject.getStatus());
		this.projectService.alter(project, updateProject, comment, "delay");
		return "redirect:project_view_" + projectId;
	}
	
	/**
	 * 修改备注
	 * @param taskOrProject
	 * @param projectId
	 * @param actionId
	 * @param lastComment
	 * @return
	 */
	@RequestMapping("/action_edit{taskOrProject}Comment_{projectId}_{actionId}")
	public String editActionComment(@PathVariable String taskOrProject, @PathVariable int projectId, @PathVariable int actionId, String lastComment) {
		
		Action action = this.actionRepository.findOne(actionId);
		//修改备注
		action.setComment(lastComment);
		//返回到任务详情或者项目详情
		if (taskOrProject.equals("Task")) {
			return "redirect:task_view_" + action.getObjectId() + "_" + projectId;
		} else if (taskOrProject.equals("Project")) {
			return "redirect:project_view_" + action.getObjectId();
		} else {
			return "";
		}
	}
	
	/**
	 * 修改首日工时
	 * @param burnId
	 * @param remain
	 */
	@RequestMapping("/burn_editFirstHours_{projectId:\\d+}_{weekenAndDays}")
	public String editFirstHours(@PathVariable int projectId, @PathVariable String weekenAndDays, Integer remain) {
		try {
			//根据项目查找燃尽图数据
			List<Burn> burnList = this.burnRepository.findByIdProjectOrderByIdDateAsc(this.projectRepository.findOne(projectId));
			//判断此项目是否有燃尽图数据
			if(burnList.size() > 0) {
				//修改首日剩余工时
				burnList.get(0).setRemain(remain);
			}
		} catch (Exception e) {
			
		}
		return "redirect:project_burn_" + projectId + "_" + weekenAndDays;
	}
}
