package com.projectmanager.service;

import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Burn;
import com.projectmanager.entity.BurnPK;
import com.projectmanager.entity.Module;
import com.projectmanager.entity.PjPdRelation;
import com.projectmanager.entity.PjPdRelationPK;
import com.projectmanager.entity.PjPdRelations;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.TeamPK;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BurnRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.PjPdRelationRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.TeamRepository;
import com.projectmanager.repository.UserRepository;

@Service
public class ProjectService {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private PjPdRelationRepository pjPdRelationRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private BurnRepository burnRepository;
	
	@Autowired
	private EntityManager entityManager;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;

	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private BranchRepository branchRepository;

	@Autowired
	private TeamRepository teamRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private HttpSession session;
	
	/**
	 * 创建项目
	 * @param project
	 * @param products
	 * @param model
	 */
	public Project created(Project project, Integer[] products, Integer[] branchs) {
		
		this.projectRepository.save(project);
		project.setSort(project.getId()*5);
		
		
		//燃尽图初始化
		BurnPK burnPk = new BurnPK();
		burnPk.setDate(project.getBegin());
		burnPk.setProject(project);
		Burn burn = new Burn();
		burn.setConsumed(0);
		burn.setRemain(0);
		burn.setId(burnPk);
		this.burnRepository.save(burn);

		
		//关联产品
		linkProductAndBranch(project, products, branchs);
		return project;
	}
	
	/**
	 * 关联产品（创建、编辑项目处）
	 * @param project
	 * @param products
	 * @param branchs
	 */
	public void linkProductAndBranch(Project project, Integer[] products, Integer[] branchs) {
		
		//清除原来的记录
		this.pjPdRelationRepository.deleteByIdProjectId(project.getId());
		
		//关联产品
		if(products.length > 0) {
			for(int i = 0; i < products.length - 1; i++) {
				PjPdRelation pjPdRelation = new PjPdRelation();
				if(products[i] != null && products[i] != 0) {
					
					PjPdRelationPK pjPdPk = new PjPdRelationPK();
					pjPdPk.setProduct(this.productRepository.findOne(products[i]));
					pjPdPk.setProject(project);
					pjPdRelation.setId(pjPdPk);
					if(branchs[i] == null) {
						pjPdRelation.setBranch_id(0);
					} else {
						pjPdRelation.setBranch_id(branchs[i]);
					}
					this.pjPdRelationRepository.save(pjPdRelation);
				}
			}
		}
	}
	
	/**
	 * 创建项目时设置默认团队成员
	 * @param project
	 */
	public void linkTeamProject(Integer projectId, String account) {
		
		Project project = this.projectRepository.findOne(projectId);
		//设置团队
		Team team = new Team();
		TeamPK teamPk = new TeamPK();
		teamPk.setProject(project);
		teamPk.setUser(this.userRepository.findByAccount(account));
		team.setId(teamPk);
		team.setDays(project.getDays());
		team.setHiredate(project.getBegin());
		team.setHours(7);
		this.teamRepository.save(team);
	}
	
	/**
	 * 编辑项目
	 * @param source
	 * @param target
	 * @param comment
	 * @param action
	 */
	public void alter(Project source, Project target, String comment, String action) {
		
		MyUtil.copyProperties(source, target);
	}
	
	/**
	 * 返回分组白名单
	 * @param whitelist
	 * @return
	 */
	public List<Integer> getWhiteList(String whitelist) {
		List<Integer> whiteList = new ArrayList<Integer>();
		if(whitelist != null && whitelist != "") {
			for(String white : whitelist.split(",")) {
				whiteList.add(Integer.valueOf(white));
			}
		}
		return whiteList;
	}
	
	/**
	 * 按状态查找项目
	 * @param status
	 * @return
	 */
	public Page<Project> findProjectByStatus(String status, int productId, Pageable pageable) {
		Page<Project> projectPage;
		//product=0，表示是按类型查找所有未删除project
		if(productId == 0) {
			switch (status) {
			//全部项目
			case "all":
				String account = session.getAttribute("userAccount").toString();
				projectPage = this.projectRepository.findByPrivAndName(account, pageable);
				return projectPage;
			case "undone":
				projectPage = this.projectRepository.findUndoneProject("done",pageable);
				return projectPage;
			default:
				projectPage = this.projectRepository.findProjectByStatus(status, pageable);
//				this.getProjectForStatus(projectPage.getContent());
				return projectPage;
			}
		} else {
			//查找project的id
			List<PjPdRelation> pjPdRelations = this.pjPdRelationRepository.findByProduct_id(productId);
			//判断product是否有关联project
			if(pjPdRelations != null && !pjPdRelations.isEmpty()) {
				Integer ids[] = new Integer[pjPdRelations.size()];
				int i = 0;
				for(PjPdRelation pjPdRelation : pjPdRelations) {
					ids[i] = pjPdRelation.getId().getProject().getId();
					i++;
				}
				
				projectPage = this.projectRepository.findByIdIn(ids, pageable);
			} else {
				//product没有关联的project，返回null
				projectPage = null;
			}
			
			return projectPage;
		}
		
	}
	
	/*
	 * 在产品模块获取项目
	 * @param productId
	 * @param branchId
	 * @return
	 */
	public List<Project> getProjectsForProduct(int productId, int branchId) {
		
		List<PjPdRelation> pjPdRelations;
		List<Project> projects = new ArrayList<Project>();
		List<String> burns;
		Project project;
		String status;
		Date today = new Date(System.currentTimeMillis());
		
		if (branchId == 0) {
			pjPdRelations = this.pjPdRelationRepository.findByProduct_id(productId);
		} else {
			pjPdRelations = this.pjPdRelationRepository.findByProduct_idAndBranch_id(productId, branchId);
		}
		
		for (PjPdRelation pjPdRelation : pjPdRelations) {
			project = pjPdRelation.getId().getProject();
			burns = new ArrayList<String>();
			status = project.getStatus();
			if (status.equals("wait") || status.equals("doing")) {
				if (today.compareTo(project.getEnd()) > 0) {
					entityManager.clear();
					project.setStatus("delay");
					project.setStatusStr("已延期");
				} else {
					if (status.equals("wait")) {
						project.setStatusStr("未开始");
					} else {
						project.setStatusStr("进行中");
					}
				}
			} else {
				if (status.equals("done")) {
					project.setStatusStr("已完成");
				} else {
					project.setStatusStr("已挂起");
				}
			}
			if (this.taskRepository.countByProject(project) == 0) {
				project.setEstimate(0);
				project.setConsumed(0);
				project.setRemain(0);
			} else {
				project.setEstimate(this.taskRepository.sumEstimateByProject(project));
				project.setConsumed(this.taskRepository.sumConsumedByProject(project));
				project.setRemain(this.taskRepository.sumRemainByProject(project));
			}
			for (Burn burn : this.burnRepository.findByIdProject(project)) {
				burns.add(String.valueOf(burn.getRemain()));
			}
			project.setBurnStr(String.join(",", burns));
			projects.add(project);
		}
		
		return projects;
	}
	
	/**
	 * 返回总消耗等信息
	 * @param projectList
	 * @return
	 */
	public void getProjectForStatus(List<Project> projectList) {
		List<String> burns;
		for(Project project : projectList) {
			burns = new ArrayList<String>();
			this.alterProject(project);
			for (Burn burn : this.burnRepository.findByIdProject(project)) {
				burns.add(String.valueOf(burn.getRemain()));
			}
			project.setBurnStr(String.join(",", burns));
		}
	}
	
	/**
	 * 将单个project状态转成中文
	 */
	public void alterProject(Project project) {
		String status = project.getStatus();
		Date today = new Date(System.currentTimeMillis());
		if (status.equals("wait") || status.equals("doing")) {
			if (project.getEnd() == null || project.getEnd().equals("")) {
				project.setStatusStr("未开始");
			} else if (today.compareTo(project.getEnd()) > 0) {
				entityManager.clear();
//				project.setStatus("delay");
				project.setStatusStr("已延期");
			} else {
				if (status.equals("wait")) {
					project.setStatusStr("未开始");
				} else {
					project.setStatusStr("进行中");
				}
			}
		} else {
			if (status.equals("done")) {
				project.setStatusStr("已完成");
			} else {
				project.setStatusStr("已挂起");
			}
		}
		if (this.taskRepository.countByProject(project) == 0) {
			project.setEstimate(0);
			project.setConsumed(0);
			project.setRemain(0);
		} else {
			project.setEstimate(this.taskRepository.sumEstimateByProject(project));
			project.setConsumed(this.taskRepository.sumConsumedByProject(project));
			project.setRemain(this.taskRepository.sumRemainByProject(project));
		}
	}
	
	/**
	 * 根据产品id查找项目
	 * @param productId
	 * @param branchId
	 * @return
	 */
	public List<Project> findProjectsForProduct(int productId) {
		
		List<PjPdRelation> pjPdRelations = this.pjPdRelationRepository.findByProduct_id(productId);
		List<Project> projectLsit = new ArrayList<Project>();
		List<String> burns;
		Project project;
		String status;
		Date today = new Date(System.currentTimeMillis());
		
		for (PjPdRelation pjPdRelation : pjPdRelations) {
			project = pjPdRelation.getId().getProject();
			burns = new ArrayList<String>();
			status = project.getStatus();
			if (status.equals("wait") || status.equals("doing")) {
				if (today.compareTo(project.getEnd()) > 0) {
					entityManager.clear();
					project.setStatus("delay");
					project.setStatusStr("已延期");
				} else {
					if (status.equals("wait")) {
						project.setStatusStr("未开始");
					} else {
						project.setStatusStr("进行中");
					}
				}
			} else {
				if (status.equals("done")) {
					project.setStatusStr("已完成");
				} else {
					project.setStatusStr("已挂起");
				}
			}
			if (this.taskRepository.countByProject(project) == 0) {
				project.setEstimate(0);
				project.setConsumed(0);
				project.setRemain(0);
			} else {
				project.setEstimate(this.taskRepository.sumEstimateByProject(project));
				project.setConsumed(this.taskRepository.sumConsumedByProject(project));
				project.setRemain(this.taskRepository.sumRemainByProject(project));
			}
			for (Burn burn : this.burnRepository.findByIdProject(project)) {
				burns.add(String.valueOf(burn.getRemain()));
			}
			project.setBurnStr(String.join(",", burns));
			projectLsit.add(project);
		}
		
		return projectLsit;
	}
	
	/**
	 * 根据project查找关联产品
	 */
	public List<Product> getProductForProject(Integer projectId) {
		List<Product> productList = new ArrayList<Product>();
		List<PjPdRelation> pjPdRelationList = this.pjPdRelationRepository.findByProject_id(projectId);
		for(PjPdRelation pjPdRelation : pjPdRelationList) {
			Product product = pjPdRelation.getId().getProduct();
			productList.add(product);
		}
		return productList;
	}
	
	/**
	 * 返回项目关联的产品对应的branchId
	 * （用于编辑项目处显示已关联产品分支）
	 * @param projectId
	 * @return
	 */
	public List<Integer> getBranchIds(Integer projectId) {
		
		List<Integer> branchIds = new ArrayList<Integer>();
		List<PjPdRelation> pjPdRelationList = this.pjPdRelationRepository.findByProject_id(projectId);
		for(PjPdRelation pjPdRelation : pjPdRelationList) {
			branchIds.add(pjPdRelation.getBranch_id());
		}
		return branchIds;
	}
	
	/**
	 * 查找项目关联的产品和产品下的所有分支、平台
	 * （用于编辑项目时关联产品）
	 * @param projectId
	 * @return
	 */
	public Map<Product,List<Branch>> getMapProductAndBranch(Integer projectId) {
		
		List<Product> productList = this.getProductForProject(projectId);
		Map<Product,List<Branch>> map = new LinkedHashMap<Product,List<Branch>>();
		for(Product product : productList) {
			if(product.getType() == "normal") {
				map.put(product, null);
			} else {
				List<Branch> branchList = this.branchRepository.findByProduct_id(product.getId());
				map.put(product, branchList);
			}
		}
		
		return map;
		
	}
	
	/**
	 * 查找关联产品，返回action表内指定格式
	 * @param projectId
	 * @return
	 */
	public String getLinkProductIds(int projectId) {
		
		String productIds = ",";
		//查找关联产品
		List<Product> productList = this.getProductForProject(projectId);
		//判断是否关联产品
		if(productList.size() < 1) {
			//加上“,”,按照action表的格式
			productIds = productIds + ",";
		}
		for(Product product : productList) {
			//循环加逗号
			productIds = productIds + product.getId().toString() + ",";
		}
		return productIds;
	}
	
	/**
	 * 查找任务所属需求
	 * @param projectId
	 * @return
	 */
	public List<Story> getStoryForTask(int projectId) {
		//根据project查找未删除任务
		List<Task> taskList = this.taskRepository.findByProjectId(projectId);
		List<Story> storyList = new ArrayList<Story>();
		for(Task task : taskList) {
			if(task.getStory_id() != 0) {
				Story story = this.storyRepository.findOne(task.getStory_id());
				storyList.add(story);
			}
		}
		return storyList;
	}
	
	/**
	 * 查找无关联模块的需求
	 */
	public List<Story> getStoryForNotModule(List<Task> taskList) {
		List<Story> storyList = new ArrayList<Story>();
		for(Task task : taskList) {
			if(task.getStory_id() != 0 && task.getModule_id() == 0) {
				Story story = this.storyRepository.findOne(task.getStory_id());
				storyList.add(story);
			}
		}
		return storyList;
	}
	
	/**
	 * 查找有关联模块的需求
	 */
	public List<Story> getStoryForModule(List<Task> taskList) {
		List<Story> storyList = new ArrayList<Story>();
		for(Task task : taskList) {
			if(task.getStory_id() != 0 && task.getModule_id() != 0) {
				Story story = this.storyRepository.findOne(task.getStory_id());
				storyList.add(story);
			}
		}
		return storyList;
	}
	
	/**
	 * 查找任务所属模块
	 */
	public List<Module> getModuleForTask(List<Task> taskList, List<Story> storyList) {
		List<Module> moduleList = new ArrayList<Module>();
		//查找
		for(Task task : taskList) {
			if(task.getModule_id() != 0) {
				Module module = this.moduleRepository.findOne(task.getModule_id());
				moduleList.add(module);
			}
		}
		//根据需求查找模块
		for(Story story : storyList) {
			if(story.getModule_id() != 0) {
				Module module = this.moduleRepository.findOne(story.getModule_id());
				moduleList.add(module);
			}
		}
		return moduleList;
	}
	
	/**
	 * 判断产品与模块是否匹配
	 */
	public boolean boolModuleForProduct(Product product, List<Module> moduleList, List<Story> storyList) {
		for(Story story : storyList) {
			if(product.getId() == story.getProduct().getId()) {
				return true;
			}
		}
		for(Module module : moduleList) {
			if(product.getId() == module.getRoot()) {
				return true;
			}
		}
			
		return false;
	}
	
	/**
	 * 查找模块树
	 * @param modules
	 * @return
	 */
	public List<Module> getModuleTree(List<Module> modules, Module module) {
		
		List<Module> tree = new ArrayList<Module>();
		
		int parent = module.getParent();
		
			while(parent != 0) {
				//逐级查找模块，联接起来
				modules.get(modules.indexOf(new Module(parent))).getChildren().add(module);
			}
			tree.add(module);

		
		return tree;
	}


	/**
	 * 查找该产品下的模块-树状图
	 */
	public List<Module> getModuleForProduct(Product product, List<Module> moduleList) {
		List<Module> modules = new ArrayList<Module>();
			for(Module module : moduleList) {
				if(product.getId() == module.getRoot()) {
					modules.add(module);
				}
			}
			return modules;
	}
	
	/**
	 * 查找关联该模块的需求-树状图
	 */
	public List<Story> getStoryForModule(Module module, List<Story> storyList) {
		List<Story> storys = new ArrayList<Story>();
		for(Story story : storyList) {
			if(module.getId() == story.getModule_id()) {
				storys.add(story);
			}
		}
		return storys;
	}
	
	/**
	 * 查找关联该需求的任务-树状图
	 * @param story
	 * @param taskList
	 * @return
	 */
	public List<Task> getTaskForStory(Story story, List<Task> taskList) {
		List<Task> tasks = new ArrayList<Task>();
		for(Task task : taskList) {
			if(story.getId() == task.getStory_id()) {
				tasks.add(task);
			}
		}
		return tasks;
	}
	
	
	/**
	 * 根据project查找没关联需求和模块的任务-树状图
	 * @param projectId
	 * @return
	 */
	public List<Task> getTaskForNotModule(Integer projectId) {
		List<Task> taskList = this.taskRepository.findByNotModuleAndProject_Id(projectId);
		this.taskService.alterCh(taskList);
		return taskList;
	}
	
	/**
	 * 查找左边滑动栏的模块
	 */
	public List<Module> getModuleForTaskAndStory(int projectId) {
		//根据project查找未删除任务
		List<Task> taskList = this.taskRepository.findByProjectId(projectId);
		
		List<Module> moduleList = new ArrayList<Module>();
		
		//根据project查找需求
		List<Story> storyList = this.storyRepository.findByProjectAndModuleAndDelete(projectId);
		/*List<ProjectStory> pStoryList = this.projectStoryRepository.findByProject(projectId);
		for(ProjectStory pStory : pStoryList) {
			Story story = this.storyRepository.findOne(pStory.getStory_id());
			if(story.getDeleted() == "0" && story.getModule_id() != 0) {
				storyList.add(story);
			}
		}*/
		//根据task来查找模块
		for(Task task : taskList) {
			if(task.getModule_id() != 0) {
				Module module = this.moduleRepository.findOne(task.getModule_id());
				
				moduleList.add(module);
			}
		}
		
		//根据story来查找模块
		for(Story story : storyList) {
			Module module = this.moduleRepository.findOne(story.getModule_id());
			moduleList.add(module);
		}
		
		//去除重复模块
		HashSet<Module> hModule = new HashSet<Module>(moduleList);
		moduleList.clear();
		moduleList.addAll(hModule);
		
		return moduleList;
	}
	
	/**
	 * 返回左侧树形模块栏
	 */
	public List<Module> getModuleTreeForTaskAndStory(@PathVariable int projectId) {
		
		//查找该项目下任务和需求关联的模块
		List<Module> moduleList = this.getModuleForTaskAndStory(projectId);
		List<Module> tree = new ArrayList<Module>();

		int parentM;

		//连接parent后的modulelist
		List<Module> modules = new ArrayList<Module>();
		for(Module module : moduleList) {
			modules.add(module);
			//获得模块父节点
			int parent = module.getParent();
			//判断模块是否有父节点
			while(parent != 0) {
				Module parentModule = this.moduleRepository.findOne(parent);
				modules.add(parentModule);
				parent = parentModule.getParent();
			}
			
		}
		
		//去除重复模块
		HashSet<Module> hModule = new HashSet<Module>(modules);
		modules.clear();
		modules.addAll(hModule);
		
		for (Module module : modules) {
			parentM = module.getParent();
			module.setProductName(this.productRepository.findOne(module.getRoot()).getName());
			//
			if (parentM != 0) {
				modules.get(modules.indexOf(new Module(parentM))).getChildren().add(module);
			} else {
				module.setProductName(this.productRepository.findOne(module.getRoot()).getName());
				tree.add(module);
				}
			}
		return tree;
	}
	/**
	 * 返回有权限的产品和对应分支或平台
	 * @param account
	 * @return
	 */
	public Map<Product,List<Branch>> getProductAndBranch(String account) {
		Map<Product,List<Branch>> map = new LinkedHashMap<Product,List<Branch>>();
		List<Product> productList = this.productRepository.findByPrivAccount(account);
		for(Product product : productList) {
			if(product.getType() == "normal") {
				map.put(product, null);
			} else {
				List<Branch> branchList = this.branchRepository.findByProduct_id(product.getId());
				map.put(product, branchList);
			}
		}
		return map;
	}
	
	/**
	 * 更改项目状态（开始、挂起、延期等）
	 * @param status
	 * @param projectId
	 */
	public Project changeStatus(String status, Project project) {
		
		switch (status) {
		case "start":
			project.setStatus("doing");
			return project;

		case "suspend":
			project.setStatus("suspended");
			return project;
			
		case "close":
			project.setStatus("done");
			return project;
			
		case "activate":
			project.setStatus("doing");
			return project;
			
		default:
			return project;
		}
	}
	
	/**
	 * 计算燃尽图默认间隔天数
	 * @param project
	 * @return days (间隔天数)
	 */
	public String getDayForBurn(Project project) {
		//设置时间格式
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		long days = 0;
		String day = "full";
		try
		{
			//起始日期
		    java.util.Date begin = df.parse(project.getBegin().toString());
		    //结束日期
		    java.util.Date end = df.parse(project.getEnd().toString());
		    long diff = end.getTime() - begin.getTime();
		    //算出起始到结束的天数
		    days = diff / (1000 * 60 * 60 * 24) + 1;
		    //判断天数是否大于25
		    if(days / 25 > 1) {
		    	//大于25天的则间隔天数为days/5的余数
		    	day = ""+(days / 25);
		    }
		} catch (Exception e)
		{
			day = "full";
		}
		return day;
	}
	
	/**
	 * 关联产品
	 * @param pjPdId （勾选产品id）
	 * @param pjPdRelations （关联产品表list）
	 */
	public void linkProduct(Integer[] pjPdId, PjPdRelations pjPdRelations, int projectId) {
		//先删除该project的关联
		this.pjPdRelationRepository.deleteByIdProjectId(projectId);
		//判断是否有勾选产品
		if(pjPdId != null && pjPdId.length > 0) {
			for(PjPdRelation pjPdRelation : pjPdRelations.getPjPdRelations()) {
				for(Integer i : pjPdId) {
					//判断是否选择关联此产品
					if(pjPdRelation.getId().getProduct().getId() == i && pjPdRelation.getId().getProject().getId() == projectId) {
						//关联产品
						this.pjPdRelationRepository.save(pjPdRelation);
						break;
					}
				}
			}
		}
	}
	
	/**
	 * task里字段对应的中文
	 * @return
	 */
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("name", "项目名称");
			put("code", "项目代号");
			put("begin", "起始日期");
			put("end", "结束日期");
			put("type", "项目类型");
			put("days", "可用工作日");
			put("status", "项目状态");
			put("stage", "项目阶段");
			put("pri", "优先级");
			put("descript", "项目描述");
			put("openedBy", "由谁创建");
			put("openedVersion", "创建版本");
			put("closedBy", "由谁关闭");
			put("closedDate", "关闭时间");
			put("canceledBy", "由谁取消");
			put("canceledDate", "取消时间");
			put("PO", "产品负责人");
			put("PM", "项目负责人");
			put("QD", "测试负责人");
			put("RD", "发布负责人");
			put("acl", "访问控制");
			put("whitelist", "分组白名单");
		}};
		
		return fieldNameMap;
	}
}
