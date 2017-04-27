package com.projectmanager.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.fasterxml.jackson.annotation.JsonView;
import com.projectmanager.entity.Action;
import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Dept;
import com.projectmanager.entity.File;
import com.projectmanager.entity.Group;
import com.projectmanager.entity.Module;
import com.projectmanager.entity.PjPdRelation;
import com.projectmanager.entity.Plan;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.ProjectStory;
import com.projectmanager.entity.Release;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.CaseRepository;
import com.projectmanager.repository.DeptRepository;
import com.projectmanager.repository.FileRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.PjPdRelationRepository;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ProjectStoryRepository;
import com.projectmanager.repository.ReleaseRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.BranchService;
import com.projectmanager.service.DeptService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.ModuleService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.PlanService;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.ReleaseService;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.TaskService;

/**
 * AjaxController用于处理各种Ajax请求
 * 以下是AjaxController类方法参数说明（特殊情况会在方法注释说明）：
 * @param productId 所属产品ID
 * @param branchId 所属分支或平台的ID
 * @param moduleId 所属模块ID
 * @param storyId 需求ID
 * @return 返回需解析成Json的对象
 */
@RestController
@SessionAttributes("userAccount")
@Transactional
public class AjaxController {

	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private CaseRepository caseRepository;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private ModuleService moduleService;

	@Autowired
	private PlanService planService;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private ReleaseRepository releaseRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private DeptService deptService;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private GroupRepository groupRepository;

	@Autowired
	private StoryService storyService;
	
	@Autowired
	private ReleaseService releaseService;
	
	@Autowired
	private DeptRepository deptRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	@Autowired
	private ProjectStoryRepository projectStoryRepository;
	
	@Autowired
	private PjPdRelationRepository pjPdRelationRepository;
	
	@Autowired
	private FileRepository fileRepository;
	
	@Autowired
	private FileService fileService;
	
	/**
	 * 按产品名称搜索有权限查看的产品
	 * @param content 搜索值
	 * @param account 用户名
	 * @return
	 */
	@RequestMapping(value="/ajaxGetProducts/{account}", method=RequestMethod.GET)
	public List<Object[]> getProducts(@RequestParam(value="content", defaultValue="", required=false) String content, @PathVariable String account) {
		
		return this.productRepository.findByPrivAndNameContaining(account, content);
	}
	
	/**
	 * @Description: 处理下载附件请求
	 * @param fileId 文件ID
	 * @param response 返回的响应
	 * @throws IOException
	 */
	@RequestMapping(value="/download/{fileId}", produces="application/octet-stream;charset=UTF-8")
	public void downloadFile(@PathVariable int fileId, HttpServletResponse response) throws IOException {
		
		File file = this.fileRepository.findOne(fileId);
		
		response.setHeader("Content-Disposition","attachment;filename=" + file.getTitle() + "." + file.getExtension());
		
		ServletOutputStream out = response.getOutputStream();
		
		fileService.getFile(file.getPathName(), out);
		
		out.flush();
		out.close();
	}
	
	/**
	 * 按分支名称搜索分支
	 * @param content 搜索值
	 * @param productId 产品Id
	 * @return
	 */
	@JsonView(Branch.Public.class)
	@RequestMapping(value="/ajaxGetBranches/{productId}", method=RequestMethod.GET)
	public List<Branch> getBranches(@RequestParam(value="content", defaultValue="", required=false) String content, @PathVariable("productId") int productId) {
		
		List<Branch> branches = new ArrayList<Branch>();
		Product product = this.productRepository.findOne(productId);
		if (!product.getType().equals("normal")) {
			Branch branch = new Branch();
			branch.setId(0);
			branch.setName(this.branchService.getBranchNameById(productId, 0));
			branches.add(branch);
		}
		
		branches.addAll(this.branchRepository.findByProductAndNameContaining(product, content));
		
		return branches;
	}	
	
	/**
	 * 获取产品计划
	 * @param isUnexpired 是否未过期
	 * @param productId
	 * @param branchId
	 * @return
	 */
	@JsonView(Plan.Public.class)
	@RequestMapping("/ajaxGetPlans/{isUnexpired}/{productId}/{branchId}")
	public List<Plan> getPlans(@PathVariable boolean isUnexpired, @PathVariable int productId, @PathVariable int branchId) {
		if (isUnexpired)
			return this.planService.getUnexpiredPlans(productId, branchId);
		else
			return this.planService.getPlans(productId, branchId);
	}
	
	/**
	 * 按产品和产品分支获取模块
	 * @param productId
	 * @param branchId
	 * @return
	 */
	@JsonView(Module.Public.class)
	@RequestMapping("/ajaxGetModules/{productId:\\d+}/{branchId:\\d+}")
	public List<Module> ajaxGetModules(@PathVariable("productId") int productId, @PathVariable("branchId") int branchId) {
		
		return this.moduleService.getModuleTree(productId, branchId);
	}
	
	/**
	 * 获取关联或细分的需求
	 * @param linkOrChildStories 关联或细分需求
	 * @param storyId
	 * @return
	 */
	@JsonView(Story.Public.class)
	@RequestMapping("/ajaxGet{linkOrChildStories}/{storyId}")
	public List<Story> getLinkStories(@PathVariable String linkOrChildStories, @PathVariable("storyId") int storyId) {
		
		Story story = this.storyRepository.findOne(storyId);
		String storiesStr = null;
		
		try {
			storiesStr = (String) story.getClass().getMethod("get" + linkOrChildStories).invoke(story);
		} catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return this.storyRepository.findByIdIn(MyUtil.convertStrToList(storiesStr, ","));
	}
	
	/**
	 * 删除模块
	 * @param moduleId
	 * @param userAccount
	 * @return
	 */
	@RequestMapping(value="/ajaxDeleteModule/{moduleId}",method=RequestMethod.DELETE,produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	public String ajaxDeleteModule(@PathVariable int moduleId, @ModelAttribute("userAccount") String userAccount) {
		
		Action action;
		List<Action> actions = new LinkedList<>();
		String product = "," + this.moduleRepository.findOne(moduleId).overrideGetProductId() + ",";
		Integer[] moduleIds = this.moduleRepository.findIdByPathContaining("," + moduleId + ",");
		for (Integer id : moduleIds) {
			action = new Action();
			action.setAction("delete");
			action.setActor(userAccount);
			action.setObjectType("module");
			action.setObjectId(id);
			action.setProduct(product);
			actions.add(action);
		}
		this.actionRepository.save(actions);
		this.moduleRepository.deleteByIdIn(moduleIds);
		this.storyRepository.setModule_idForByModule_idIn(0, moduleIds);
		this.bugRepository.setModule_idForByModule_idIn(0, moduleIds);
		this.caseRepository.setModule_idForByModule_idIn(0, moduleIds); 
		
		return String.valueOf(moduleId);
	}

	/**
	 * 按产品获取模块
	 * @param productId
	 * @return
	 */
	@JsonView(Module.Public.class)
	@RequestMapping("/ajaxGetModulesForproduct/{productId:\\d+}")
	public List<Module> getModules(@PathVariable("productId") int productId) {
		
		List<Module> modules = this.moduleRepository.findByRootAndTypeOrderByBranch_idAscGradeDesc(productId, "story");
		
		List<Module> tree = new ArrayList<Module>();
		
		int parent;
		
		for (Module module : modules) {
			parent = module.getParent();
			module.setProductName(this.productRepository.findOne(module.getRoot()).getName());
			if (parent != 0) {
				modules.get(modules.indexOf(new Module(parent))).getChildren().add(module);
			} else {
				tree.add(module);
			}
		}
		
		return tree;
	}
	
	/**
	 * 根据项目查找模块
	 */
	@JsonView(Module.Public.class)
	@RequestMapping("/ajaxGetModules/{projectId:\\d+}")
	public List<Module> ajaxGetModules(@PathVariable int projectId) {
		
		List<Product> productList = this.projectService.getProductForProject(projectId);
		List<Module> modules = new ArrayList<Module>();
		List<Module> modules1 = new ArrayList<Module>();
		for(Product product : productList) {
			modules1 = this.moduleRepository.findByRootAndTypeOrderByBranch_idAscGradeDesc(product.getId(), "story");
			modules.addAll(modules1);
		}
		
		List<Module> tree = new ArrayList<Module>();
		
		int parent;
		
		for (Module module : modules) {
			parent = module.getParent();
			module.setProductName(this.productRepository.findOne(module.getRoot()).getName());
			if (parent != 0) {
				modules.get(modules.indexOf(new Module(parent))).getChildren().add(module);
			} else {
				tree.add(module);
			}
		}
		
		return tree;
	}
	
	/**
	 * 根据需求查找产品后再来查找模块
	 */
	@JsonView(Module.Public.class)
	@RequestMapping("/ajaxGetModules/{storyId:\\d+}/story")
	public List<Module> ajaxGetModulesForStory(@PathVariable int storyId) {
		
		List<Module> modules;
		Story story = this.storyRepository.findOne(storyId);
		
		modules = this.moduleRepository.findByRootAndTypeOrderByBranch_idAscGradeDesc(story.getProduct().getId(), "story");
		
		List<Module> tree = new ArrayList<Module>();
		
		int parent;
		
		for (Module module : modules) {
			parent = module.getParent();
			module.setProductName(this.productRepository.findOne(module.getRoot()).getName());
			if (parent != 0) {
				modules.get(modules.indexOf(new Module(parent))).getChildren().add(module);
			} else {
				tree.add(module);
			}
		}
		
		return tree;
	}
	
	/**
	 * 返回有权限访问的项目
	 * @param content
	 * @param account
	 * @return
	 */
	@RequestMapping(value="/ajaxGetProjects/{account}", method=RequestMethod.GET)
	public List<Object[]> getProjects(@RequestParam(value="content", defaultValue="", required=false) String content, @PathVariable String account) {
		
		return this.projectRepository.findByPrivAndNameContaining(account, content);
	}
	
	/**
	 * 根据产品和产品模块查找需求
	 * @param productId
	 * @param moduleId
	 * @return
	 */
	@JsonView(Story.Public.class)
	@RequestMapping(value = "/ajaxGetStorys/{productId}/{moduleId}", method = RequestMethod.GET)
	public List<Story> ajaxGetStoryForProject(@PathVariable int productId, @PathVariable int moduleId) {
		return this.storyRepository.findByProdutAndModule(productId, moduleId);
	}
	
	/**
	 * 根据任务和需求查找关联的模块
	 */
	@RequestMapping("/ajaxGetModules/{projectId:\\d+}/task")
	public List<Module> ajaxGetModuleForTaskAndStory(@PathVariable int projectId) {
		//返回左侧树形模块栏
		return this.projectService.getModuleTreeForTaskAndStory(projectId);
	}
	
	//关联产品
	@RequestMapping(value="/ajaxGetProductsAndBranch/{account}", method=RequestMethod.GET)
	public List<Product> getProductsAndBranch(@RequestParam(value="content", defaultValue="", required=false) String content, @PathVariable String account) {
		
		return this.productRepository.findByPrivAndName(account, content);
	}
	
	/**
	 * 根据模块ajax查找需求
	 */
	@RequestMapping(value = "/ajaxGetStoryForModule/{moduleId}")
	public List<Story> getStoryForModule(@PathVariable int moduleId) {
	
		Module module = this.moduleRepository.findOne(moduleId);
		List<Story> storyList = this.storyRepository.findByProdutAndModule(module.getRoot(), moduleId);
		return storyList;
	}

	/**
	 * 转移产品需求到目标产品计划
	 * @param planId 源产品计划id
	 * @param storyIds 一个或多个产品需求Id
	 * @param replacePlanId 目标产品计划id
	 */
	@RequestMapping(value="/ajaxChangePlan/{planId}", method=RequestMethod.POST)
	public void ajaxChangePlan(@PathVariable String planId, @RequestParam("storyIds[]") Integer[] storyIds, @RequestParam("replacePlanId") String replacePlanId) {
		
		List<Story> stories = this.storyRepository.findByIdIn(storyIds);
		Story source = new Story();
		
		for (Story target : stories) {
			if (replacePlanId.equals("")) {
				source.setPlan(target.getPlan().replaceAll("^" + planId + "$", replacePlanId).replaceAll("^" + planId + ",", replacePlanId).replaceAll("," + planId +",", ",").replaceAll("," + planId +"$", replacePlanId));
				this.storyService.modify(source, target, "", "unlinkplan");
			}
			else {
				source.setPlan(target.getPlan().replaceAll("^" + planId + "$", replacePlanId).replaceAll("^" + planId + ",", replacePlanId + ",").replaceAll("," + planId + ",", "," + replacePlanId + ",").replaceAll("," + planId +"$", "," + replacePlanId));
				this.storyService.modify(source, target, "", "unlinkplan");
			}
		}
	}
	
	/**
	 * 关联计划到多个需求
	 * @param planId
	 * @param storyIds
	 */
	@RequestMapping(value="/ajaxLinkPlanToStories/{planId}", method=RequestMethod.POST)
	public void ajaxLinkPlan2Stories(@PathVariable String planId, @RequestParam("ids[]") Integer[] storyIds) {
		
		List<Story> stories = this.storyRepository.findByIdIn(storyIds);
		StringBuilder plan = new StringBuilder();
		Story source = new Story();
		
		for (Story target : stories) {
			plan.setLength(0);
			plan.append(target.getPlan());
			if (plan.toString() == null || plan.toString().equals("")) {
				source.setPlan(planId);
			} else {
				source.setPlan(plan + "," + planId);
			}
			this.storyService.modify(source, target, "", "linkplan");
		}
	}
	
	/**
	 * project里的批量编辑需求
	 */
	@JsonView(Plan.Public.class)
	@RequestMapping("/ajaxGetPlans/{productId}")
	public List<Plan> getPlansForProject(@PathVariable("productId") int productId) {
		
		return this.planService.getPlans(productId, 0);
	}
	
	/**
	 * 从产品计划中取消关联Bug
	 * @param planId
	 * @param bugIds 
	 */
	@RequestMapping(value="/ajaxUnlinkPlanFromBugs/{planId}",method=RequestMethod.POST)
	public void ajaxUnlinkPlanFromBugs(@PathVariable int planId, @RequestParam("bugIds[]") Integer[] bugIds) {
		
		List<Bug> bugs = this.bugRepository.findByIdInAndPlan_id(bugIds, planId);
		
		for (Bug bug : bugs) {
			bug.setPlan_id(0);
		}
	}
	
	/**
	 * 关联或细分需求
	 * @param field 关联或细分
	 * @param storyId
	 * @param storyIds
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
	//LinkOrChildStories的值为LinkStories或ChildStories
	@RequestMapping(value="/ajaxLink{LinkOrChildStories}ToStory/{storyId}",method=RequestMethod.POST)
	public void ajaxLinkStories2Story(@PathVariable("LinkOrChildStories") String field, @PathVariable int storyId, @RequestParam("ids[]") String storyIds) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		
		Story story = this.storyRepository.findOne(storyId);
		String stories = (String) story.getClass().getMethod("get" + field).invoke(story);
		String fieldVal;
		if (stories == null || stories.equals("")) {
			fieldVal = storyIds;
		} else {
			fieldVal = stories + "," + storyIds;
		}
		this.storyService.modifiedByColumn(field, fieldVal, new Integer[]{storyId}, field.toLowerCase());
	}
	
	/**
	 * 关联Bug或需求到产品发布
	 * @param field Bug或需求
	 * @param releaseId
	 * @param ids bugID或产品ID
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 */
	@RequestMapping(value="/ajaxLink{field}ToRelease/{releaseId}",method=RequestMethod.POST)
	public void ajaxLinkBugsOrStories2Release(@PathVariable String field, @PathVariable int releaseId, @RequestParam("ids[]") String ids) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException {
		
		Release target = this.releaseRepository.findOne(releaseId);
		Release source = new Release();
		String fieldVal = (String) target.getClass().getMethod("get" + field).invoke(target);
		Method setterMethod = source.getClass().getMethod("set" + field, String.class);
		if (fieldVal == null || fieldVal.equals("")) {
			setterMethod.invoke(source, ids);
		} else {
			setterMethod.invoke(source, fieldVal + "," + ids);
		}
		this.releaseService.modify(source, target, "", "link" + field.toLowerCase());
	}
	
	/**
	 * 取消关联或取消细分需求
	 * @param field
	 * @param storyId
	 * @param story2Unlink 取消关联的需求
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
	@RequestMapping(value="/ajaxUn{linkOrChildStories}FromStory/{storyId}",method=RequestMethod.POST)
	public void ajaxUnlinkStoryFromStory(@PathVariable("linkOrChildStories") String field, @PathVariable int storyId, @RequestParam("storyId") String story2Unlink) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		
		Story story = this.storyRepository.findOne(storyId);
		String fieldVal = ((String) story.getClass().getMethod("get" + field).invoke(story)).replaceAll("^" + story2Unlink + "$", "").replaceAll("^" + story2Unlink + ",", "").replaceAll("," + story2Unlink +",", ",").replaceAll("," + story2Unlink +"$", "");
		
		this.storyService.modifiedByColumn(field, fieldVal, new Integer[]{storyId}, "un" + field.toLowerCase());
	}
	
	/**
	 * 取消关联Bug或需求到产品发布
	 * @param field
	 * @param releaseId
	 * @param ids
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 */
	@RequestMapping(value="/ajaxUnlink{field}FromRelease/{releaseId}",method=RequestMethod.POST)
	public void ajaxUnlinkFromRelease(@PathVariable String field, @PathVariable int releaseId, @RequestParam("ids[]") Integer[] ids) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException {
		
		Release target = this.releaseRepository.findOne(releaseId);
		Release source = new Release();
		Method setterMethod = source.getClass().getMethod("set" + field, String.class);
		String fieldVal = (String) target.getClass().getMethod("get" + field).invoke(target);
		
		for (Integer id : ids) {
			fieldVal = fieldVal.replaceAll("^" + id + "$", "").replaceAll("^" + id + ",", "").replaceAll("," + id +",", ",").replaceAll("," + id +"$", "");
		}
		setterMethod.invoke(source, fieldVal);
		this.releaseService.modify(source, target, "", "unlink" + field.toLowerCase());
	}
	
	/**
	 * 关联产品计划到Bug
	 * @param planId
	 * @param bugIds 一个或多个Bug的ID
	 */
	@RequestMapping(value="/ajaxLinkPlanToBugs/{planId}",method=RequestMethod.POST)
	public void ajaxLinkPlan2Bugs(@PathVariable Integer planId, @RequestParam("bugIds[]") List<Integer> bugIds) {
		
		List<Bug> bugs = this.bugRepository.findByIdIn(bugIds);
		
		for (Bug bug : bugs) {
			bug.setPlan_id(planId);
		}
	}

	/**
	 * 返回关联产品
	 */
	@RequestMapping("/getProductForProject/{projectId:\\d+}")
	public List<Product> getProductForProject(@PathVariable int projectId) {
		return this.projectService.getProductForProject(projectId);
	}
	
	/**
	 * 产品排序
	 * @param ids
	 * @param sorts 序数
	 */
	@RequestMapping(value="/ajaxSort",method=RequestMethod.POST)
	public void sort(@RequestParam("ids[]") Integer[] ids, @RequestParam("sorts[]") Integer[] sorts) {
		
		Integer sort;
		@SuppressWarnings("serial")
		Map<Integer, Integer> map = new HashMap<Integer, Integer>(){{
			for (int i = 0; i < ids.length; i++) 
				put(ids[i], sorts[i]);
		}};
		
		List<Product> products = this.productRepository.findByIdIn(ids);
		
		for (Product product : products) {
			sort = map.get(product.getId());
			if (product.getSort() != sort) 
				product.setSort(sort);
		}
	}
	
	/**
	 * 根据 project返回storylist（用于树状图）
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getStorysForProject/{projectId}")
	public List<Story> getStorysForProject(@PathVariable int projectId) {
		List<Story> storyList = this.storyRepository.findByProject(projectId);
		return storyList;
	}
	
	/**
	 * 根据project返回未删除的需求不为空的tasklist（用于树状图）
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getTaskForProject/{projectId}")
	public List<Task> getTaskForProject(@PathVariable int projectId) {
		List<Task> taskList = this.taskRepository.findByProjectAndNotNullStory(projectId);
		//转为中文状态
		this.taskService.alterCh(taskList);
		return taskList;
	}
	
	/**
	 * 返回部门树
	 * @return
	 */
	@RequestMapping("/getDept")
	public List<Dept> getDept() {
		return this.deptService.getDept();
	}
	
	/**
	 * 返回所有用户的account（验证唯一用户名）
	 * @return
	 */
	@RequestMapping("/getAllUser")
	public List<User> getAllUser() {
		return (List<User>) this.userRepository.findAll();
	}
	
	/**
	 * 返回所有未删除的用户(组织-用户档案等处)
	 * @return
	 */
	@RequestMapping("/getUser")
	public List<User> getUser() {
		return this.userRepository.findAllUser();
	}
	
	/**
	 * 返回所有分组
	 * @return
	 */
	@RequestMapping("/getGroup")
	public List<Group> getGroup() {
		return (List<Group>) this.groupRepository.findAll();
	}
	
	/**
	 * 根据deptId返回dept
	 * @param deptId
	 * @return
	 */
	@RequestMapping("/getDept_{deptId}")
	public Dept getDeptById(@PathVariable int deptId) {
		
		Dept dept = this.deptRepository.findOne(deptId);
		return dept;
	}
	
	/**
	 * 返回一条分级模块给详情
	 * @param moduleId
	 * @return
	 */
	@JsonView(Module.Public.class)
	@RequestMapping("/getSingleModule/{moduleId}")
	public List<Module> getSingleModule(@PathVariable int moduleId) {
		//未分级的所有模块
		List<Module> modules = new ArrayList<Module>();
		//分级后的模块树
		List<Module> tree = new ArrayList<Module>();
		//判断模块是否为0
		if(moduleId != 0) {
			Module module = this.moduleRepository.findOne(moduleId);
			int parentM;
			//获得模块父节点
			int parent = module.getParent();
			modules.add(module);
			//判断模块是否有父节点
			while(parent != 0) {
				//查找父节点
				Module parentModule = this.moduleRepository.findOne(parent);
				//将父模块也添加到modules
				modules.add(parentModule);
				//给parent重新赋值
				parent = parentModule.getParent();
			}
			//循环构造模块树
			for (Module mod : modules) {
				parentM = mod.getParent();
				//设置产品名
				module.setProductName(this.productRepository.findOne(mod.getRoot()).getName());
				//判断是否根节点
				if (parentM != 0) {
					//父节点还不是根节点，则将当前模块都作为父模块的子模块
					modules.get(modules.indexOf(new Module(parentM))).getChildren().add(mod);
				} else {
					//设置产品名
					mod.setProductName(this.productRepository.findOne(mod.getRoot()).getName());
					//给模块树添加新值
					tree.add(mod);
				}
			}
		}
		
		return tree;
	}
	
	/**
	 * 返回需求所属产品id
	 * @param storyId
	 * @return
	 */
	@RequestMapping("/getStoryProduct_{storyId}")
	public int getStoryProductId(@PathVariable int storyId) {
		int productId = this.storyRepository.findOne(storyId).getProduct().getId();
		return productId;
	}
	
	/**
	 * 查找该部门下是否有用户
	 * @param deptId
	 * @return
	 */
	@RequestMapping("/getDeptUser_{deptId}")
	public int getDeptUser(@PathVariable int deptId) {
		
		int userNum = 0;
		userNum = this.userRepository.findByDept(deptId).size();
		return userNum;
	}
	
	/**
	 * 根据用户名返回用户
	 * @param account
	 * @return
	 */
	@RequestMapping("/getSingleUser/{account}")
	public User getUser(@PathVariable String account) {
		//根据用户名查找用户
		User user = this.userRepository.findByAccount(account);
		return user;
	}
	
	/**
	 * 根据计划id查找计划
	 * @param planId
	 * @return
	 */
	@RequestMapping("/getSinglePlan/{planId}")
	public Plan getPlan(@PathVariable int planId) {
		//根据planId查找计划
		Plan plan = this.planRepository.findOne(planId);
		return plan;
	}
	
	/**
	 * @author 丽桃
	 * 根据项目获取需求list
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getStorys/{projectId}")
	public List<Story> getStorys(@PathVariable int projectId) {
		//需求list
		List<Story> storyList = new ArrayList<Story>();
		//根据projectId查找关联的需求
		List<ProjectStory> pjstorylist = this.projectStoryRepository.findByProjectId(projectId);
		//循环添加story到需求list
		for(ProjectStory projectStory : pjstorylist) {
			//根据storyid查找story
			Story story = this.storyRepository.findOne(projectStory.getStory_id());
			//storyList添加story
			storyList.add(story);
		}
		return storyList;
	}
	
	/**
	 * @author 丽桃 2017-1-22
	 * 根据产品获取需求list
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getPdStorys/{productId}")
	public List<Story> getProductStorys(@PathVariable int productId) {
		//需求list
		List<Story> storyList = new ArrayList<Story>();
		//根据productId查找关联的需求
		List<Story> productStorylist = this.storyRepository.findByProductId(productId);
		//循环添加story到需求list
		for(Story story: productStorylist) {
			//根据storyid查找story
			Story oStory = this.storyRepository.findOne(story.getId());
			//storyList添加story
			storyList.add(oStory);
		}
		return storyList;
	}
	
	/**
	 * @author 丽桃 2017-2-20
	 * 根据产品获取平台list
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getPdBranch/{productId}")
	public List<Branch> getProductBranchs(@PathVariable int productId) {
		//branchList
		List<Branch> branchList = new ArrayList<Branch>();
		//据productId查找关联的branch
		List<Branch> productBranchList = this.branchRepository.findByProduct_id(productId);
		//循环添加branch到需求list
		for(Branch branch: productBranchList) {
			//根据branchId查找branch
			Branch oBranch = this.branchRepository.findOne(branch.getId());
			//branchList添加oBranch
			branchList.add(oBranch);
		}
		return branchList;
	}
	
	/**
	 * @author 丽桃 2017-2-21
	 * 根据产品获取计划list
	 * @param projectId
	 * @return
	 */
	@RequestMapping("/getPdPlan/{productId}")
	public List<Plan> getProductPlan(@PathVariable int productId) {
		//PlanList
		List<Plan> planList = new ArrayList<Plan>();
		//据productId查找关联的plan
		List<Plan> productPlanList = this.planRepository.findByProductIdOrderByBegin(productId);
		//循环添加plan到需求list
		for(Plan plan: productPlanList) {
			//根据planId查找plan
			Plan oPlan = this.planRepository.findOne(plan.getId());
			//planList添加plan
			planList.add(oPlan);
		}
		return planList;
	}
	
	/**
	 * 根据产品获取项目
	 * @param productId
	 * @return
	 */
	@RequestMapping("/getPdProject/{productId}")
	public List<Project> getProductProject(@PathVariable int productId) {
		List<Project> projectList = new ArrayList<Project>();
		List<PjPdRelation> productPj = this.pjPdRelationRepository.findByProduct_id(productId);
		for(PjPdRelation project : productPj) {
			Project oProject = this.projectRepository.findOne(project.getId().getProject().getId());
			projectList.add(oProject);
		}
		return projectList;
	}
	
	/**
	 * 根据产品查找任务
	 */
	@RequestMapping("/getProTask/{projectId}") 
	public List<Task> getProductTask(@PathVariable int projectId) {
		List<Task> taskList= new ArrayList<Task>();
		List<Task> tList = this.taskRepository.findByProjectId(projectId);
		for(Task task : tList) {
			Task oTask = this.taskRepository.findOne(task.getId());
			taskList.add(oTask);
		}
		return taskList;
	}
}
