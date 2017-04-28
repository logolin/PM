package com.projectmanager.controller;


import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.time.Clock;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.oxm.xstream.XStreamMarshaller;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.jasperreports.JasperReportsUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.projectmanager.entity.Action;
import com.projectmanager.entity.BranchMap;
import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Build;
import com.projectmanager.entity.Doc;
import com.projectmanager.entity.Module;
import com.projectmanager.entity.Modules;
import com.projectmanager.entity.Plan;
import com.projectmanager.entity.Plans;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Products;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Release;
import com.projectmanager.entity.Stories;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.StorySpec;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.BuildRepository;
import com.projectmanager.repository.CaseRepository;
import com.projectmanager.repository.DocRepository;
import com.projectmanager.repository.FileRepository;
import com.projectmanager.repository.HistoryRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.PjPdRelationRepository;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ReleaseRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.StorySpecRepository;
import com.projectmanager.service.ActionService;
import com.projectmanager.service.BranchService;
import com.projectmanager.service.BugService;
import com.projectmanager.service.BuildService;
import com.projectmanager.service.DynamicService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.ModuleService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.PlanService;
import com.projectmanager.service.ProductService;
import com.projectmanager.service.ProjectService;
import com.projectmanager.service.ReleaseService;
import com.projectmanager.service.RoadmapService;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.UserService;

import net.sf.jasperreports.engine.JRAbstractExporter;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.HtmlExporter;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXmlExporter;
import net.sf.jasperreports.engine.util.JRLoader;

/**
 * 以下是ProductController类方法参数说明（特殊情况会在方法注释说明）：
 * @param productId 所属产品ID，通常为当前浏览的产品的ID
 * @param branchId 所属分支或平台的ID，值为0表示所有，当该产品类型为正常，则值只能为0
 * @param model 传递到页面的数据对象
 * @return 返回需解析页面位置字符串或者附带数据的ModelAndView对象
 */
@Controller
@RequestMapping("/product")
@SessionAttributes("userAccount")
@Transactional
public class ProductController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	
	@Autowired
	private HttpServletRequest request;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private FileRepository fileRepository;
	
	@Autowired
	private DocRepository docRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private PjPdRelationRepository pjPdRelationRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private ReleaseRepository releaseRepository;
	
	@Autowired
	private StorySpecRepository storySpecRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;
	
	@Autowired
	private CaseRepository caseRepository;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private HistoryRepository historyRepository;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private BuildRepository buildRepository;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private RoadmapService roadmapService;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private ReleaseService releaseService;
	
	@Autowired
	private BuildService buildService;
	
	@Autowired
	private StoryService storyService;
	
	@Autowired
	private PlanService planService;
	
	@Autowired
	private DynamicService dynamicService;
	
	@Autowired
	private BugService bugService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private ModuleService moduleService;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	/**
	 * 路由
	 * @param subMenu 二层菜单
	 * @param action 执行的操作
	 * @param productId 产品ID
	 * @return
	 */
	@RequestMapping("/{subMenu:[a-z]+}_{action:[a-z]+}_{productId:\\d+}")
	public String route(@PathVariable String subMenu, @PathVariable String action, @PathVariable int productId) {
		 //获得所有项目
    	List<Project> projects = this.projectRepository.findByDeleted("0");
    	//判断是否有产品
		if(productId == 0 || projects.size() < 1) {
			return "redirect:product_create_0";
		} else {
			switch (subMenu) {
			case "story":
				return "forward:" + subMenu + "_browse_" + productId + "_0_0_status_unclosed_id_up_10_1_true";
			case "plan":
				return "forward:" + subMenu + "_browse_" + productId + "_0_id_SortUp_10_1";
			case "dynamic":
				return "forward:" + subMenu + "_browse_" + productId + "_today_date_up_10_1";
			case "release":
			case "roadmap":
			case "project":
				return "forward:" + subMenu + "_browse_" + productId + "_0";
			case "module":
				return "forward:" + subMenu + "_manage_" + productId + "_0_0";
			case "branch":
				return "forward:" + subMenu + "_manage_" + productId;
			case "product":
				if (action.equals("browse"))
					return "forward:" + subMenu + "_browse_" + productId + "_closed_id_SortUp_10_1";
				else
					return "forward:" + subMenu + "_" + action + "_" + productId;
			default:
				return null;
			}
		}
		
	}
	
	/**
	 * @Description: 产品导航栏产品选择框
	 * @param subMenu 二层菜单名字
	 * @param action 操作
	 * @param productId
	 * @param branchId
	 * @return
	 */
	@RequestMapping("/{subMenu:[a-z]+}_{action:[a-zA-Z]+}_{productId:\\d+}_{branchId:\\d+}")
	public String route(@PathVariable String subMenu, @PathVariable String action, @PathVariable int productId, @PathVariable int branchId) {
		
		switch (subMenu) {
		case "plan":
			if (action.equals("browse")) 
				return "forward:" + subMenu + "_browse_" + productId + "_" + branchId + "_id_sortUp_10_1";
		case "story":
			if (action.equals("batchCreate")) 
				return "forward:" + subMenu + "_batchCreate_" + productId + "_" + branchId + "_0";
			if (action.equals("browse")) 
				return "forward:" + subMenu + "_browse_" + productId + "_" + branchId;
		case "module":
			return "forward:" + subMenu + "_" + action + "_" + productId + "_" + branchId + "_0";
		default:
			return "forward:" + subMenu + "_browse_" + productId;
		}
	}

	/**
	 * @Description: 配置当前产品信息
	 * @param productId
	 * @param model
	 * @param userAccount
	 * @param session
	 */
	@ModelAttribute
	public void pre(@PathVariable("productId") Integer productId, Model model, @ModelAttribute("userAccount") String userAccount, HttpSession session) {
		if(productId != 0) {
			Product product = this.productRepository.findOne(productId);
			String uri = request.getRequestURI();
			Pattern pattern = Pattern.compile("/(.*)/([a-zA-Z]*)/([a-zA-Z]*)_([a-zA-Z]*)_");
			Matcher m = pattern.matcher(uri);
			if (m.find()) {
				model.addAttribute("menu", m.group(2));
			} else {
				logger.debug("NO MATCH");
			}
			//设置产品id的session
			session.setAttribute("sessionProductId", product.getId());
			model.addAttribute("currentProduct", product);
			model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		}
	}
	
	/**
	 * @Description: 请求浏览产品页面
	 * @param userAccount
	 * @param status 产品状态
	 * @param orderBy 排序字段
	 * @param ascOrDesc 升序或降序
	 * @param recPerPage 分页大小
	 * @param page 页码
	 * @param model
	 * @return
	 */
	@RequestMapping("/product_browse_{productId}_{status}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}")
	public String browseProduct(@ModelAttribute("userAccount") String userAccount, @PathVariable String status, @PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		
		Long[] count;
		Integer product_id;
		Sort sort;
		Page<Object[]> productPage;
		if (ascOrDesc.equals("SortUp")) {
			sort = new Sort(Sort.Direction.DESC, orderBy);
		} else {
			sort = new Sort(Sort.Direction.ASC, orderBy);
		}
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		
		productPage = this.productRepository.findByPrivAndStatus(userAccount, status, pageRequest);
		Map<Integer, Long[]> countMap = new HashMap<>();
		for (Object[] product : productPage.getContent()) {
			count = new Long[9];
			product_id =  (Integer) product[0];
			count[0] = this.storyRepository.countByProductIdAndStatus(product_id, "active");
			count[1] = this.storyRepository.countByProductIdAndStatus(product_id, "changed");
			count[2] = this.storyRepository.countByProductIdAndStatus(product_id, "draft");
			count[3] = this.storyRepository.countByProductIdAndStatus(product_id, "closed");
			count[4] = this.planRepository.countByProductId(product_id);
			count[5] = this.releaseRepository.countByProductId(product_id);
			count[6] = this.bugRepository.countByProductId(product_id);
			count[7] = this.bugRepository.countByProductIdAndStatus(product_id, "active");
			count[8] = this.bugRepository.countByProductIdAndUnassigned(product_id);
			countMap.put(product_id, count);
		}
		
		model.addAttribute("productPage", productPage);
		model.addAttribute("countMap", countMap);
		
		return "product/product_browse";
	}
	
	/**
	 * @Description: 请求批量编辑产品页面
	 * @param productIdList 一个或多个产品ID
	 * @param model
	 * @return
	 */
	@RequestMapping("/product_batchEdit_{productId}_form")
	public String batchEditProductsGet(Integer[] productIdList, Model model) {
		
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("productList", this.productRepository.findByIdIn(productIdList));
		
		return "product/product_batchedit";
	}
	
	/**
	 * @Description: 处理批量添加产品请求
	 * @param productId
	 * @param products 页面表单传递的多个产品对象
	 * @return
	 */
	@RequestMapping(value="/product_batchEdit_{productId}", method=RequestMethod.POST)
	public String batchEditProductsPost(@PathVariable int productId, Products products) {
		
		products.getProducts().forEach(product->this.productService.modify(product, this.productRepository.findOne(product.getId()), "", "edit"));
		
		return "redirect:product_browse_" + productId;
	}
	
	/**
	 * @Description: 请求创建产品页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/product_create_{productId}", method=RequestMethod.GET)
	public String createProductGet(Model model) {
		
		model.addAttribute("groupMap", this.userService.getAllGroupMapIdAndName());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/product_create";
	}
	
	/**
	 * @Description: 处理创建产品请求
	 * @param product 页面表单传递的产品对象
	 * @return
	 */
	@RequestMapping(value="/product_create_{productId}", method=RequestMethod.POST) 
	public String createProductPost(Product product) {  
		
		return "redirect:story_browse_" + this.productService.create(product).getId();
	}
	
	/**
	 * @Description: 请求查看产品详细信息页面
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/product_view_{productId:\\d+}", method=RequestMethod.GET)
	public String viewProductGet(@PathVariable int productId, Model model) {
		
		if(productId == 0) {
			return "redirect:product_create_0";
		} else {
			Product product = this.productRepository.findOne(productId);
			Set<String> set = new HashSet<String>();
			set.add(product.getCreatedBy());
			set.add(product.getPo());
			set.add(product.getQd());
			set.add(product.getRd());
			
			model.addAttribute("product", product);
			model.addAttribute("activeStoryCount", this.storyRepository.countByProductIdAndStatus(productId, "active"));
			model.addAttribute("changedStoryCount", this.storyRepository.countByProductIdAndStatus(productId, "changed"));
			model.addAttribute("draftStoryCount", this.storyRepository.countByProductIdAndStatus(productId, "draft"));
			model.addAttribute("closedStoryCount", this.storyRepository.countByProductIdAndStatus(productId, "closed"));
			model.addAttribute("planCount", this.planRepository.countByProductId(productId));
			model.addAttribute("projectCount", this.pjPdRelationRepository.countByIdProductId(productId));
			model.addAttribute("bugCount", this.bugRepository.countByProductId(productId));
			model.addAttribute("docCount", this.docRepository.countByProduct_id(productId));
			model.addAttribute("caseCount", this.caseRepository.countByProductId(productId));
			model.addAttribute("buildCount", this.buildRepository.countByProductId(productId));
			model.addAttribute("releaseCount", this.releaseRepository.countByProductId(productId));
			model.addAttribute("userMap", this.userService.findByAccountIn(set));
			model.addAttribute("groupMap", this.userService.getAllGroupMapIdAndName());
			this.actionService.renderHistory("product", productId, model);
			
			return "product/product_view";
		}
	}
	
	/**
	 * @Description: 请求编辑产品页面
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/product_edit_{productId}", method=RequestMethod.GET)
	public String editProductGet(@PathVariable int productId, Model model) {
		
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("groupMap", this.userService.getAllGroupMapIdAndName());
		model.addAttribute("product", this.productRepository.findOne(productId));
		
		return "product/product_create";
	}
	
	/**
	 * @Description: 处理编辑产品请求
	 * @param productId
	 * @param product 页面表单传递的产品对象
	 * @return
	 */
	@RequestMapping(value="/product_edit_{productId}", method=RequestMethod.POST)
	public String editProductPost(@PathVariable int productId, Product product) {
		
		this.productService.modify(product, this.productRepository.findOne(productId), "", "edit");
		
		return "redirect:product_view_" + productId;
	}		
	
	/**
	 * @Description: 请求关闭产品页面
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/product_close_{productId}",method=RequestMethod.GET)
	public String closeProductGet(@PathVariable int productId, Model model) {
		
		Product product = this.productRepository.findOne(productId);
		Set<String> set = new HashSet<String>();
		set.add(product.getCreatedBy());
		set.add(product.getPo());
		set.add(product.getQd());
		set.add(product.getRd());
		
		model.addAttribute("userMap", this.userService.findByAccountIn(set));
		this.actionService.renderHistory("product", productId, model);
		
		return "product/product_close";
	}
	
	/**
	 * @Description: 处理关闭产品请求
	 * @param productId
	 * @param comment 备注
	 */
	@RequestMapping(value="/product_close_{productId}",method=RequestMethod.POST)
	@ResponseBody
	public void closeProductPost(@PathVariable int productId, String comment) {
		
		this.productService.modify(new Product("closed"), this.productRepository.findOne(productId), comment, "close");
	}
	
	/**
	 * @Description: 请求浏览产品计划页面
	 * @param productId
	 * @param branchId
	 * @param orderBy 排序字段
	 * @param ascOrDesc 升序或降序
	 * @param recPerPage 分页大小
	 * @param page 页码
	 * @param model
	 * @return
	 */
	@RequestMapping("/plan_browse_{productId}_{branchId}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}")
	public String browsePlan(@PathVariable int productId, @PathVariable int branchId, @PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		
		Sort sort = ascOrDesc.equals("SortUp") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		Page<Plan> plans;
		
		if (branchId == 0) {
			plans = this.planRepository.findByProductIdWithPageAndSort(productId, new PageRequest(page - 1, recPerPage, sort));
		} else {
			plans = this.planRepository.findByProductIdAndBranch_idWithPageAndSort(productId, branchId, new PageRequest(page - 1, recPerPage, sort));
		}
		
		model.addAttribute("planPage", plans);
		model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		
		return "product/plan_browse";
	}
	
	/**
	 * @Description: 请求查看产品计划详细信息页面
	 * @param productId
	 * @param planId 产品计划ID
	 * @param model
	 * @return
	 */
	@RequestMapping("/plan_view_{productId}_{planId}")
	public String viewPlan(@PathVariable int productId, @PathVariable int planId, Model model) {
		
		int caseSum = 0;
		List<Story> stories = this.storyRepository.findByPlanContaining(String.valueOf(planId));
		List<Bug> bugs = this.bugRepository.findByPlan_id(planId);
		Plan plan = this.planRepository.findOne(planId);
		plan.setBranchName(this.branchService.getBranchNameById(productId, plan.getBranch_id()));
		for (Story story : stories) {
			if (this.caseRepository.existsByStory_id(story.getId())) {
				caseSum ++;
			}
		}
		
		model.addAttribute("plan", plan);
		model.addAttribute("storyList", stories);
		model.addAttribute("bugList", bugs);
		model.addAttribute("planList", this.planRepository.findByProductIdAndBranch_idIsZeroOrOrderByBegin(productId, plan.getBranch_id()));
		model.addAttribute("caseSum", caseSum);
		model.addAttribute("storyStatusMap", this.storyService.getStatusMap());
		model.addAttribute("bugStatusMap", this.bugService.statusMap);
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("plan", planId, model);
		
		return "product/plan_view";
	}
	
	/**
	 * @Description: 请求关联多个需求到产品计划页面
	 * @param productId
	 * @param planId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/plan_linkStories_{productId}_{planId}",method=RequestMethod.GET)
	public String linkStories2Plan(@PathVariable int productId, @PathVariable int planId, Model model) {
		
		List<Story> stories = this.storyRepository.findByProductIdAndPlanNotContaining(productId, String.valueOf(planId));
		
		model.addAttribute("objectId", planId);
		model.addAttribute("where", "PlanToStories");
		model.addAttribute("storyList", stories);
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/linkstories";
	}
	
	/**
	 * @Description: 请求关联Bug到计划页面
	 * @param productId
	 * @param planId
	 * @param model
	 * @return
	 */
	@RequestMapping("/plan_linkBugs_{productId}_{planId}")
	public String linkBugs2Plan(@PathVariable int productId, @PathVariable int planId, Model model) {

		List<Bug> bugs = this.bugRepository.findByProductIdAndBranch_idIsZeroOrAndPlan_idNotAndStatus(productId, this.planRepository.findOne(planId).getBranch_id(), planId, "active");
		
		model.addAttribute("bugList", bugs);
		model.addAttribute("objectId", planId);
		model.addAttribute("where", "PlanToBugs");
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("statusMap", this.bugService.statusMap);
		
		return "product/linkbugs";
	}
	
	/**
	 * 创建计划
	 * @param productId
	 * @param branchId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/plan_create_{productId}", method=RequestMethod.GET)
	public ModelAndView createPlanGet(@PathVariable int productId, Model model) {
		
		model.addAttribute("operate", "create");
		
		return new ModelAndView("product/plan_create", "branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
	}
	
	/**
	 * @Description: 处理创建产品计划请求
	 * @param productId
	 * @param plan 页面传递的产品计划对象
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/plan_create_{productId}", method=RequestMethod.POST) 
	public String createPlanPost(@PathVariable int productId, Plan plan, Model model) {
		
		int planId = this.planService.create(productId, plan).getId();
		
		return "redirect:plan_view_" + productId + "_" + planId;
	}	
	
	/**
	 * @Description: 请求编辑产品计划页面
	 * @param productId
	 * @param planId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/plan_edit_{productId}_{planId}", method=RequestMethod.GET)
	public ModelAndView editPlanGet(@PathVariable int productId, @PathVariable int planId, Model model) {
		
		Plan plan = this.planRepository.findOne(planId);
		Product product = plan.getProduct();
		if (product.getId() != productId) {
			return new ModelAndView("redirect:/");
		}
		
		model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		model.addAttribute("operate", "edit");
		
		return new ModelAndView("product/plan_create", "plan", plan);
	}
	
	/**
	 * @Description: 处理编辑产品计划请求
	 * @param productId
	 * @param planId
	 * @param plan
	 * @return
	 */
	@RequestMapping(value="/plan_edit_{productId}_{planId}", method=RequestMethod.POST)
	public String editPlanPost(@PathVariable int productId, @PathVariable int planId, Plan plan) {
		
		this.planService.modify(plan, this.planRepository.findOne(planId), "", "edit");
		
		return "redirect:plan_view_" + productId + "_" + planId;
	}
	
	/**
	 * 请求批量修改计划页面
	 * @param planIdList 批量修改的多个计划ID
	 * @param model 传递到页面的数据对象
	 * @param productId 所属产品ID
	 * @return 需解析的页面位置字符串
	 */
	@RequestMapping(value="/plan_batchEdit_{productId}_form")
	public String batchEditPlansGet(Integer[] planIdList, Model model, @PathVariable String productId) {
		
		model.addAttribute("planList", this.planRepository.findByIdIn(planIdList));
		
		return "product/plan_batchedit";
	}
	
	/**
	 * 处理批量修改计划请求
	 * @param plans 表单绑定的多个计划
	 * @param productId 所属产品ID
	 * @return 跳转到浏览计划页面
	 */
	@RequestMapping(value="/plan_batchEdit_{productId}",method=RequestMethod.POST)
	public String batchEditPlansPost(Plans plans, @PathVariable String productId) {
		
//		for (Plan plan : plans.getPlans()) {
//			MyUtil.copyProperties(plan, this.planRepository.findOne(plan.getId()));
//		}
		plans.getPlans().forEach(plan->this.planService.modify(plan, this.planRepository.findOne(plan.getId()), "", "edit"));
		
		return "redirect:plan_browse_" + productId;
	}
	
	/**
	 * 请求管理分支或平台页面
	 * @param productId 所属产品ID
	 * @param model 传递到页面的数据对象
	 * @return 页面对象
	 */
	@RequestMapping(value="/branch_manage_{productId}", method=RequestMethod.GET)
	public ModelAndView manageBranchGet(@PathVariable int productId, Model model) {
		
		List<Action> actions = this.actionRepository.findByObjectTypeAndProductContaining("branch", "," + productId + ",");
		actions.forEach(action->action.getHistories().addAll(this.historyRepository.findByActionId(action.getId())));
		
		model.addAttribute("actionList", actions);
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		model.addAttribute("fieldNameMap", this.branchService.getFieldNameMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return new ModelAndView("product/branch", "branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
	}
	
	/**
	 * 处理修改或者增加分支请求
	 * @param productId 所属产品ID
	 * @param newbranch 新增的一个或多个分支名字
	 * @param modifiedBranch 修改的分支
	 * @return 跳转到分支管理页面
	 */
	@RequestMapping(value="/branch_manage_{productId}", method=RequestMethod.POST)
	public String manageBranchPost(@PathVariable int productId, @RequestParam("newbranch[]") String newbranch[], BranchMap modifiedBranch) {

		this.branchService.createAndUpadateBranch(productId, newbranch, modifiedBranch);
		
		return "redirect:/product/branch_manage_" + productId;
	}
	
	/**
	 * 请求浏览路线图页面
	 * @param productId 所属产品ID
	 * @param branchId 要浏览路线图的分支ID,0表示显示所有，如果该产品类型为normal则branchId为0
	 * @param model
	 * @return 页面
	 */
	@RequestMapping("/roadmap_browse_{productId}_{branchId}")
	public ModelAndView roadmap(@PathVariable int productId, @PathVariable int branchId, Model model) {
		
		model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		
		return new ModelAndView("product/roadmap", "roadmap", this.roadmapService.generateRoadmap(productId, branchId));
	}
	
	/**
	 * 请求浏览发布页面
	 * @param productId 所属产品ID
	 * @param branchId
	 * @param model
	 * @return
	 */
	@RequestMapping("/release_browse_{productId}_{branchId}")
	public ModelAndView browseRelease(@PathVariable int productId, @PathVariable int branchId, Model model) {
		model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		
		return new ModelAndView("product/release_browse", "releaseList", this.releaseService.getReleases(productId, branchId));
}
	
	/**
	 * 请求编辑发布页面
	 * @param releaseId 需要编辑的发布ID
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/release_edit_{productId}_{releaseId}", method=RequestMethod.GET)
	public String editReleaseGet(@PathVariable int releaseId, @PathVariable int productId, Model model) {
		
		Release release = this.releaseRepository.findOne(releaseId);
		if (productId != release.getProduct().getId()) {
			return "redirect:";
		}
		List<Build> builds = this.buildService.getAllBuild(productId);
		Map<Integer, String> branchMap = this.branchService.getBranchesByProductIdMappingIdAndName(productId);
		builds.sort((a,b)->a.getBranch_id()-b.getBranch_id());
		
		model.addAttribute("buildList", builds);
		model.addAttribute("operate", "edit");
		model.addAttribute("release", release);
		model.addAttribute("branchMap", branchMap);
	
		return "product/release_create";
	}
	
	/**
	 * 处理编辑发布请求
	 * @param files 表单上传的附件
	 * @param titles 附件的名字
	 * @param releaseId
	 * @param productId
	 * @param release 表单绑定的发布对象
	 * @param userAccount 操作的用户名
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/release_edit_{productId}_{releaseId}", method=RequestMethod.POST)
	public String editReleasePost(@RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, @PathVariable int releaseId, @PathVariable int productId, Release release, @ModelAttribute("userAccount") String userAccount) throws IOException {
		
		release.setBranch_id(this.buildRepository.findOne(release.getBuild().getId()).getBranch_id());
		
		this.releaseService.modify(release, this.releaseRepository.findOne(releaseId), "", "edit");
		
		this.fileService.createFile(files, titles, "release", releaseId, userAccount);
		
		return "redirect:release_view_" + productId + "_" + releaseId;
	}
	
	/**
	 * 请求创建发布页面
	 * @param productId
	 * @param branchId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/release_create_{productId}_{branchId}", method=RequestMethod.GET)
	public ModelAndView createReleaseGet(@PathVariable int productId, @PathVariable int branchId, Model model) {
		
		List<Build> builds = this.buildService.getUnreleasedBuild(productId, branchId);
		Release release = this.releaseService.getLastRelease(productId, branchId);
		Map<Integer, String> branchMap = this.branchService.getBranchesByProductIdMappingIdAndName(productId);
		builds.sort((a,b)->a.getBranch_id()-b.getBranch_id());
		
		model.addAttribute("operate", "create");
		model.addAttribute("lastRelease", release);
		model.addAttribute("branchMap", branchMap);
		
		return new ModelAndView("product/release_create", "buildList", builds);
	}
	
	/**
	 * 处理创建发布请求
	 * @param productId
	 * @param files
	 * @param titles
	 * @param branchId
	 * @param release
	 * @param build_id 表单所选择的版本ID
	 * @param model
	 * @param userAccount
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/release_create_{productId}_{branchId}", method=RequestMethod.POST)
	public String createReleasePost(@PathVariable int productId, @RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, @PathVariable int branchId, Release release, Integer build_id, Model model, @ModelAttribute("userAccount") String userAccount) throws IOException {
		
		int releaseId = this.releaseService.create(productId, branchId, build_id, release).getId();
		
		this.fileService.createFile(files, titles, "release", releaseId, userAccount);
		
		return "redirect:/product/release_view_" + productId + "_" + releaseId;
	}	
	
	/**
	 * 修改发布的状态
	 * @param productId
	 * @param releaseId
	 * @param status 修改后发布的状态，normal为正常状态，terminate为暂停维护状态
	 * @return
	 */
	@RequestMapping("/release_changeStatus_{productId}_{releaseId}_{status}")
	public String changeStatusRelease(@PathVariable String productId, @PathVariable int releaseId, @PathVariable String status) {
		
		Release source = new Release();
		source.setStatus(status);
		String action = status.equals("normal") ? "activate" : status;
		this.releaseService.modify(source, this.releaseRepository.findOne(releaseId), "", action);  //原设计是不记录修改字段的新旧值
		
		return "redirect:/product/release_view_" + productId + "_" + releaseId;
	}	
	
	//附件未完成
	/**
	 * 查看发布详细信息
	 * @param productId
	 * @param releaseId
	 * @param model
	 * @return
	 */
	@RequestMapping("/release_view_{productId}_{releaseId}")
	public String viewRelease(@PathVariable int productId, @PathVariable int releaseId, Model model) {
		
		Release release = this.releaseRepository.findOne(releaseId);
		release.setBranchName(this.branchService.getBranchNameById(productId, release.getBranch_id()));
		
		List<Story> stories = this.storyRepository.findByIdIn(MyUtil.convertStrToList(release.getStories(), ","));
		List<Bug> bugs = this.bugRepository.findByIdIn(MyUtil.convertStrToList(release.getBugs(), ","));
		List<Bug> leftBugs = this.bugRepository.findByIdIn(MyUtil.convertStrToList(release.getLeftBugs(), ","));
		
		model.addAttribute("release", release);
		model.addAttribute("storyList", stories);
		model.addAttribute("bugList", bugs);
		model.addAttribute("leftBugList", leftBugs);
		model.addAttribute("fileList", this.fileRepository.findByObjectTypeAndObjectId("release", releaseId));
		model.addAttribute("storyStatusMap", this.storyService.getStatusMap());
		model.addAttribute("bugStatusMap", this.bugService.statusMap);
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("release", releaseId, model);
		
		return "product/release_view";
	}
	
	/**
	 * 请求关联需求到发布页面
	 * @param productId
	 * @param releaseId
	 * @param model
	 * @return
	 */
	@RequestMapping("/release_linkStories_{productId}_{releaseId}")
	public String linkStories2Release(@PathVariable int productId, @PathVariable int releaseId, Model model) {
		
		String storiesStr = this.releaseRepository.findOne(releaseId).getStories();
		List<Integer> ids = MyUtil.convertStrToList(storiesStr, ",");
		ids.add(0);
		List<Story> stories = this.storyRepository.findByProductIdAndIdNotIn(productId, ids);
		
		model.addAttribute("objectId", releaseId);
		model.addAttribute("where", "StoriesToRelease");
		model.addAttribute("storyList", stories);
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/linkstories";
	}
	
	/**
	 * 请求关联Bug到发布页面
	 * @param productId
	 * @param releaseId
	 * @param model
	 * @return
	 */
	@RequestMapping("/release_linkBugs_{productId}_{releaseId}")
	public String linkBugs2Release(@PathVariable int productId, @PathVariable int releaseId, Model model) {
		
		String bugsStr = this.releaseRepository.findOne(releaseId).getBugs();
		List<Integer> ids = MyUtil.convertStrToList(bugsStr, ",");
		ids.add(0);
		List<Bug> bugs = (List<Bug>) this.bugRepository.findByProductIdAndIdNotIn(productId, ids);
		
		model.addAttribute("bugList", bugs);
		model.addAttribute("objectId", releaseId);
		model.addAttribute("where", "BugsToRelease");
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("statusMap", this.bugService.statusMap);
		
		return "product/linkbugs";
	}
	
	/**
	 * 请求关联剩余Bug到发布页面
	 * @param productId
	 * @param releaseId
	 * @param model
	 * @return
	 */
	@RequestMapping("/release_linkLeftBugs_{productId}_{releaseId}")
	public String linkLeftBugs2Release(@PathVariable int productId, @PathVariable int releaseId, Model model) {
		
		String leftBugsStr = this.releaseRepository.findOne(releaseId).getLeftBugs();
		List<Integer> ids = MyUtil.convertStrToList(leftBugsStr, ",");
		ids.add(0);
		List<Bug> bugs = (List<Bug>) this.bugRepository.findByProductIdAndIdNotIn(productId, ids);
		
		model.addAttribute("bugList", bugs);
		model.addAttribute("objectId", releaseId);
		model.addAttribute("where", "LeftBugsToRelease");
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("statusMap", this.bugService.statusMap);
		
		return "product/linkbugs";
	}
	
	/**
	 * 请求浏览项目页面
	 * @param productId
	 * @param branchId
	 * @return
	 */
	@RequestMapping("/project_browse_{productId}_{branchId}")
	public ModelAndView browseProject(@PathVariable int productId, @PathVariable int branchId) {
		
		return new ModelAndView("product/project_browse", "projectList", this.projectService.getProjectsForProduct(productId, branchId));
	}	

	/**
	 * 根据分支浏览需求
	 * @param productId
	 * @param branchId
	 * @return
	 */
	@RequestMapping("/story_browse_{productId:\\d+}_{branchId:\\d+}")
	public String browseStoryByBranch(@PathVariable int productId, @PathVariable int branchId) {
		
		return "forward:story_browse_" + productId + "_" + branchId + "_0_status_unclosed_id_up_10_1_true";
	}
	
	/**
	 * 根据模块浏览需求
	 * @param productId
	 * @param branchId
	 * @param moduleId 模块ID
	 * @return
	 */
	@RequestMapping("/story_browse_{productId:\\d+}_{branchId:\\d+}_{moduleId:\\d+}")
	public String browseStoryByModule(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId) {
		
		return "forward:story_browse_" + productId + "_" + branchId + "_" + moduleId + "_status_unclosed_id_up_10_1_true";
	}
	
	/**
	 * 根据某列和列值浏览需求
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param column 列名
	 * @param columnVal 列值
	 * @param orderBy 按列排序
	 * @param ascOrDesc 升序或降序
	 * @param recPerPage 分页大小
	 * @param page 页码
	 * @param isComplex 是否详细模式
	 * @param model
	 * @return
	 */
	@RequestMapping("/story_browse_{productId}_{branchId}_{moduleId}_{column}_{columnVal}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}_{isComplex}")
	public String browseStory(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, @PathVariable String column, @PathVariable String columnVal, @PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, @PathVariable Boolean isComplex, Model model) {
		
		Product product = this.productRepository.findOne(productId);
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		StringBuilder plansStr = new StringBuilder();
		Map<Integer, String> planStrMap = new HashMap<>();
		int caseSum = 0;
		Page<Story> stories = this.storyRepository.findAll(this.storyService.getSpecification(product, branchId, moduleId, column, columnVal), new PageRequest(page - 1, recPerPage, sort));
		
		for (Story story : stories.getContent()) {
			plansStr.setLength(0);
			if (this.caseRepository.existsByStory_id(story.getId()))
				caseSum ++;
			for (Plan plan : this.planRepository.findByIdIn(MyUtil.convertStrToArr(story.getPlan(), ","))) {
				plansStr.append(plan.getTitle() + "(#" + plan.getId() + ") ");
			}
			planStrMap.put(story.getId(), plansStr.toString());
		}
		List<Object[]> branches = this.branchRepository.findByProductExistsSubmodule(productId);
		
		model.addAttribute("branchMap", this.branchService.getBranchesByProductIdMappingIdAndName(productId));
		model.addAttribute("branchList", branches);
		model.addAttribute("planStrMap", planStrMap);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("planList", this.planRepository.findByProductIdAndBranch_idIsZeroOrOrderByBegin(productId, branchId));
		model.addAttribute("storyPage", stories);
		model.addAttribute("caseSum", caseSum);
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		
		return "product/story_browse";
	}
	
	/**
	 * 请求创建需求页面
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_create_{productId:\\d+}", method=RequestMethod.GET)
	public String createStoryGet(@PathVariable int productId, Model model) {
		
		List<Product> products = this.productRepository.findByStatusNotAndIdNot("closed", productId);
		
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("productList", products);
		
		return "product/story_create";
	}
	
	/**
	 * 处理创建需求请求
	 * @param productId
	 * @param story 表单绑定的需求对象
	 * @param storySpec 表单绑定的需求描述和验收标准对象
	 * @param files 附件
	 * @param titles 附件名字
	 * @param userAccount 创建者
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/story_create_{productId:\\d+}", method=RequestMethod.POST)
	public String createStoryPost(@PathVariable int productId, Story story, StorySpec storySpec, @RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, @ModelAttribute("userAccount") String userAccount,Model model) throws IOException {
		
		story.setOpenedBy(userAccount);
		if (story.getAssignedTo() != null && !story.getAssignedTo().equals(""))
			story.setAssignedDate(new Timestamp(Clock.systemDefaultZone().millis()));
		int storyId = this.storyService.create(story, storySpec).getId();
		
		this.fileService.createFile(files, titles, "story", storyId, userAccount);
		
		return "redirect:story_view_" + productId + "_" + storyId;
	}
	
	/**
	 * 请求批量创建需求页面
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_batchCreate_{productId:\\d+}_{branchId:\\d+}_{moduleId:\\d+}", method=RequestMethod.GET)
	public String batchCreateStoryGet(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, Model model) {
		
		model.addAttribute("branchName", this.branchService.getBranchNameById(productId, branchId));
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		
		return "product/story_batchcreate";
	}
	
	/**
	 * 处理批量创建需求请求
	 * @param productId
	 * @param branchId
	 * @param stories 页面表单绑定的多个需求对象
	 * @return
	 */
	@RequestMapping(value="/story_batchCreate_{productId:\\d+}_{branchId:\\d+}_{moduleId:\\d+}", method=RequestMethod.POST)
	public String batchCreateStoryPost(@PathVariable int productId , @PathVariable int branchId, Stories stories) {
		
		logger.debug(String.valueOf(stories.getStories().size()) + "," + String.valueOf(stories.getStorySpecs().size()) + "," + String.valueOf(stories.getStories().get(0).getProduct().getId()) + "," + String.valueOf(stories.getStories().get(0).getStatus()));
		
		this.storyService.batchCreate(stories);
		
		return "redirect:story_browse_" + productId;
	}
	
	/**
	 * 请求查看最新版本的需求页面
	 * @param productId
	 * @param storyId 要查看的需求ID
	 * @return
	 */
	@RequestMapping("/story_view_{productId:\\d+}_{storyId:\\d+}")
	public String viewStoryDefault(@PathVariable int productId, @PathVariable int storyId) {
		
		Integer version = this.storyRepository.findOne(storyId).getVersion();
		
		return "forward:story_view_" + productId + "_" + storyId + "_" + version;
	}
	
	/**
	 * 请求查看需求页面
	 * @param storyId
	 * @param version 版本号，需求变更后version自动递增
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_view_{productId}_{storyId}_{version}",method=RequestMethod.GET)
	public String viewStoryGet(@PathVariable int storyId, @PathVariable int version, Model model) {
		
		Story story = this.storyRepository.findOne(storyId);
		int module_id = story.getModule_id();
		
		if (module_id != 0)
			model.addAttribute("path", this.moduleRepository.findIdAndNameByIn(MyUtil.convertStrToList(this.moduleRepository.findOne(module_id).getPath(), ",")));
		model.addAttribute("story", story);
		model.addAttribute("fileList", this.fileRepository.findByObjectTypeAndObjectId("story", story.getId()));
		model.addAttribute("planList", this.planRepository.findByIdIn(MyUtil.convertStrToArr(story.getPlan(), ",")));
		model.addAttribute("storySpec", this.storySpecRepository.findByStoryIdAndVersion(storyId, version));
		model.addAttribute("linkStoryList", this.storyService.getStoriesByIdsStr(story.getLinkStories()));
		model.addAttribute("childStoryList", this.storyService.getStoriesByIdsStr(story.getChildStories()));
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		this.storyService.renderAffectItems(storyId, model);
		this.actionService.renderHistory("story", storyId, model);
		
		return "product/story_view";
	}
	
	/**
	 * 处理查看需求页面的添加备注请求
	 * @param userAccount 当前用户
	 * @param productId
	 * @param storyId 需求ID
	 * @param version 版本号
	 * @param comment 备注内容
	 * @return
	 */
	@RequestMapping(value="/story_view_{productId}_{storyId}_{version}",method=RequestMethod.POST)
	public String viewStoryPost(@ModelAttribute("userAccount") String userAccount, @PathVariable int productId, @PathVariable int storyId, @PathVariable int version, String comment) {
		
		Action action = new Action();
		action.setObjectType("story");
		action.setObjectId(storyId);
		action.setProduct("," + productId + ",");
		action.setComment(comment);
		action.setActor(userAccount);
		action.setAction("comment");
		this.actionRepository.save(action);
		
		return "redirect:story_view_" + productId + "_" + storyId + "_" + version;
	}
	
	/**
	 * 处理编辑备注请求
	 * @param storyOrProduct 需求备注或产品备注
	 * @param productId
	 * @param actionId 动态ID
	 * @param lastComment 页面表单传递的备注
	 * @return
	 */
	@RequestMapping("/action_edit{storyOrProduct}Comment_{productId}_{actionId}")
	public String editActionComment(@PathVariable String storyOrProduct, @PathVariable int productId, @PathVariable int actionId, String lastComment) {
		
		Action action = this.actionRepository.findOne(actionId);
		action.setComment(lastComment);
		
		if (storyOrProduct.equals("Story")) {
			return "redirect:story_view_" + productId + "_" + action.getObjectId();
		} else if (storyOrProduct.equals("Product")) {
			return "redirect:product_view_" + action.getObjectId();
		} else {
			return "";
		}
	}
	
	/**
	 * 请求关闭需求页面
	 * @param storyId 要关闭的需求ID
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_close_{productId}_{storyId}",method=RequestMethod.GET)
	public String closeStoryGet(@PathVariable int storyId, Model model) {
		
		Story story = this.storyRepository.findOne(storyId);
		
		model.addAttribute("storyTitle", story.getTitle());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		this.actionService.renderHistory("story", storyId, model);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/story_close";
	}
	
	/**
	 * 处理关闭需求请求
	 * @param storyId
	 * @param story
	 * @param userAccount
	 * @param comment 备注
	 */
	@RequestMapping(value="/story_close_{productId}_{storyId}",method=RequestMethod.POST)
	@ResponseBody
	public void closeStoryPost(@PathVariable int storyId, Story story, @ModelAttribute("userAccount") String userAccount, String comment) {
		
		story.setStatus("closed");
		story.setClosedBy(userAccount);
		story.setAssignedTo("closed");
		story.setClosedDate(new Timestamp(Clock.systemDefaultZone().millis()));
		if (story.getClosedReason().equals("done")) {
			story.setStage("released");
		} else if (story.getClosedReason().equals("subdivided")) {
			story.setPlan("");
		}
		this.storyService.modify(story, this.storyRepository.findOne(storyId), comment, "close");
	}
	
	/**
	 * 请求激活需求页面
	 * @param storyId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_activate_{productId}_{storyId}",method=RequestMethod.GET)
	public String activateStoryGet(@PathVariable int storyId, Model model) {
		
		Story story = this.storyRepository.findOne(storyId);
		
		model.addAttribute("storyTitle", story.getTitle());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		this.actionService.renderHistory("story", storyId, model);
		
		return "product/story_activate";
	}
	
	/**
	 * 处理激活需求请求
	 * @param storyId
	 * @param assignedTo 指派给某用户
	 * @param comment 备注
	 * @return
	 */
	@RequestMapping(value="/story_activate_{productId}_{storyId}",method=RequestMethod.POST)
	public String activateStoryPost(@PathVariable int storyId, String assignedTo, String comment) {
		
		Story source = new Story(null);
		source.setClosedDate(null);
		source.setAssignedTo(assignedTo);
		source.setClosedBy(null);
		source.setStatus("active");
		source.setChildStories(null);
		source.setDuplicateStory(0);
		source.setClosedReason(null);
		this.storyService.modify(source, this.storyRepository.findOne(storyId), comment, "activate");
		
		return "product/story_activate";
	}
	
	/**
	 * 请求变更需求页面
	 * @param storyId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_change_{productId}_{storyId}", method=RequestMethod.GET)
	public String changeStoryGet(@PathVariable int storyId, Model model) {
		
		model.addAttribute("story", this.storyRepository.findOne(storyId));
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("storySpec", this.storySpecRepository.findFirstByStoryIdOrderByIdDesc(storyId));
		this.storyService.renderAffectItems(storyId, model);
		this.actionService.renderHistory("story", storyId, model);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/story_change";
	}
	
	/**
	 * 处理变更需求请求
	 * @param storyId
	 * @param productId
	 * @param story 表单绑定的需求对象
	 * @param storySpec 表单绑定的需求描述和验收标准对象
	 * @param files 附件
	 * @param titles 附件名称
	 * @param comment 备注
	 * @param userAccount 当前用户
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/story_change_{productId}_{storyId}", method=RequestMethod.POST)
	public String changeStoryPost(@PathVariable int storyId, @PathVariable int productId, Story story, StorySpec storySpec, @RequestParam(value="files", required=false) MultipartFile[] files, String[] titles, String comment, @ModelAttribute("userAccount") String userAccount) throws IOException {
		
		if (this.storyService.change(story, this.storyRepository.findOne(storyId), storySpec, comment))
			this.fileService.createFile(files, titles, "story", storyId, userAccount);
		
		return "redirect:story_view_" + productId + "_" + storyId;
	}
	
	/**
	 * 请求编辑需求页面
	 * @param storyId
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_edit_{productId}_{storyId}",method=RequestMethod.GET)
	public String editStoryGet(@PathVariable int storyId, @PathVariable int productId, Model model) {
		
		Story story = this.storyRepository.findOne(storyId);
		StorySpec storySpec = this.storySpecRepository.findFirstByStoryIdOrderByIdDesc(storyId);
		List<Product> products = this.productRepository.findByStatusNotAndIdNot("closed", productId);
		
		model.addAttribute("productList", products);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("story", story);
		model.addAttribute("storySpec", storySpec);
		this.actionService.renderHistory("story", storyId, model);
		
		return "product/story_edit";
	}
	
	/**
	 * 处理编辑需求请求
	 * @param storyId
	 * @param story 表单绑定的需求对象
	 * @param comment 备注
	 * @return
	 */
	@RequestMapping(value="/story_edit_{productId}_{storyId}",method=RequestMethod.POST)
	public String editStoryPost(@PathVariable int storyId, Story story, String comment) {
		
		this.storyService.modify(story, this.storyRepository.findOne(storyId), comment, "edit");
		
		return "redirect:story_view_" + story.getProduct().getId() + "_" + storyId;
	}
	
	/**
	 * 请求细分需求或关联需求页面
	 * @param linkOrChild 关联需求或细分需求
	 * @param productId
	 * @param storyId 
	 * @param model
	 * @return
	 */
	@RequestMapping("/story_{linkOrChild}Stories_{productId}_{storyId}")
	public String linkStories2Story(@PathVariable String linkOrChild, @PathVariable int productId, @PathVariable int storyId, Model model) {
		
		Story storyTemp = this.storyRepository.findOne(storyId);
		String storiesStr = null;
		Method method;
		
		try {
			method = storyTemp.getClass().getMethod("get" + linkOrChild + "Stories");
			storiesStr = (String) method.invoke(storyTemp);
		} catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			e.printStackTrace();
		}
		List<Integer> ids = MyUtil.convertStrToList(storiesStr, ",");
		ids.add(storyId);
		
		List<Story> stories = this.storyRepository.findByIdNotIn(ids);
		
		model.addAttribute("objectId", storyId);
		model.addAttribute("where", linkOrChild + "StoriesToStory");
		model.addAttribute("storyList", stories);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		
		return "product/linkstories";
	}
	
	/**
	 * 请求评审需求页面
	 * @param storyId 被评审的需求ID
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_review_{productId}_{storyId}",method=RequestMethod.GET)
	public String reviewStoryGet(@PathVariable int storyId, Model model) {
		
		Story story = this.storyRepository.findOne(storyId);
		this.storyService.renderAffectItems(storyId, model);
		
		model.addAttribute("story", story);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		this.actionService.renderHistory("story", storyId, model);
		
		return "product/story_review";
	}
	
	/**
	 * 处理评审需求请求
	 * @param userAccount 评审的用户
	 * @param productId
	 * @param storyId
	 * @param story
	 * @param result 评审结果
	 * @param preVersion 如果评审结果为撤销变更，那么需求版本就会恢复到preVersion版本
	 * @param comment
	 * @return
	 */
	@RequestMapping(value="/story_review_{productId}_{storyId}",method=RequestMethod.POST)
	public String reviewStoryPost(@ModelAttribute("userAccount") String userAccount, @PathVariable int productId, @PathVariable int storyId, Story story, @RequestParam("result") String result, @RequestParam(value="preVersion", required=false) Integer preVersion, String comment) {
		
		if (result.equals("revert")) {
			story.setVersion(preVersion);
			this.storySpecRepository.removeByStoryIdAndVersionGreaterThan(storyId, preVersion);
		}
		if (result.equals("reject")) {
			story.setClosedBy(userAccount);
			story.setClosedDate(new Timestamp(Clock.systemDefaultZone().millis()));
		}
		this.storyService.modify(story, this.storyRepository.findOne(storyId), comment, "review");
		
		return "redirect:story_view_" + productId + "_" + storyId;
	}
	
	/**
	 * 请求批量编辑需求页面
	 * @param storyIds 要编辑的一个或多个需求ID
	 * @param branchId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_batchEdit_{productId}_{branchId}_form",method=RequestMethod.POST)
	public String batchEditStoriesForm(String storyIds, @PathVariable int branchId ,Model model) {
		
		model.addAttribute("stories", this.storyRepository.findByIdIn(MyUtil.convertStrToList(storyIds, ",")));
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute("sourceMap", this.storyService.getSourceMap());
		model.addAttribute("stageMap", this.storyService.getStageMap());
		model.addAttribute("statusMap", this.storyService.getStatusMap());
		model.addAttribute("closedReasonMap", this.storyService.getClosedReasonMap());
		
		return "product/story_batchedit";
	}	
	
	/**
	 * 处理批量编辑需求请求
	 * @param productId
	 * @param stories 表单绑定的一个或多个需求对象
	 * @return
	 */
	@RequestMapping(value="/story_batchEdit_{productId:\\d+}",method=RequestMethod.POST)
	public String batchEditStoriesPost(@PathVariable int productId, Stories stories) {
		
		stories.getStories().forEach(story->this.storyService.modify(story, this.storyRepository.findOne(story.getId()), "", "edit"));
		
		return "forward:story_browse_" + productId;
	}
	
	/**
	 * 请求管理模块页面
	 * @param productId
	 * @param branchId
	 * @param moduleId 
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/module_manage_{productId}_{branchId}_{moduleId}",method=RequestMethod.GET)
	public String manageModuleGet(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, Model model) {
		
		List<Object[]> branches = this.branchRepository.findByProductExistsSubmodule(productId);
		Map<Integer, String> branchMap = this.branchService.getBranchesByProductIdMappingIdAndName(productId);
		branchMap.computeIfPresent(0, (a,b)->"所有" + b);
		Module module;
		List<Integer> moduleIds = new LinkedList<>();
		List<Module> children;
		
		if (moduleId == 0) {
			ApplicationContext applicationContext = new AnnotationConfigApplicationContext(AppConfig.class);
			module = applicationContext.getBean(Module.class);
			module.setBranch_id(0);
			module.setBranchName(this.branchService.getBranchNameById(productId, 0));
			((ConfigurableApplicationContext)applicationContext).close();
			moduleIds.add(0);
			children = this.moduleRepository.findByRootAndBranch_idAndType(productId,branchId,"story");
		} else {
			module = this.moduleRepository.findOne(moduleId);
			module.setBranchName(this.branchService.getBranchNameById(productId, module.getBranch_id()));
			moduleIds.addAll(MyUtil.convertStrToList(module.getPath(), ","));
			children = this.moduleRepository.findByRootAndParentAndType(productId,moduleId,"story");
		}
		
		children.forEach(item->item.setBranchName(branchMap.get(item.getBranch_id())));
		
		module.getChildren().addAll(children);
		
		List<Action> actions = this.actionRepository.findByObjectTypeAndProductContaining("module", "," + productId + ",");
		actions.forEach(action->action.getHistories().addAll(this.historyRepository.findByActionId(action.getId())));
		
		model.addAttribute("actionList", actions);
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		model.addAttribute("fieldNameMap", this.moduleService.getFieldNameMap());
		model.addAttribute("path", this.moduleRepository.findIdAndNameByIn(moduleIds));
		model.addAttribute("module", module);
		model.addAttribute("branchList", branches);
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		
		return "product/module";
	}
	
	/**
	 * 处理管理模块请求，包括创建模块和修改模块
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param names 创建模块的名字
	 * @param branch_ids 模块所属分支id
	 * @param shortnames 模块简称
	 * @param modules 页面表单绑定的模块对象
	 * @return
	 */
	@RequestMapping(value="/module_manage_{productId}_{branchId}_{moduleId}",method=RequestMethod.POST)
	public String manageModulePost(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, String[] names, Integer[] branch_ids, String[] shortnames, Modules modules) {
		
		this.moduleService.createModules(productId, names, branch_ids, moduleId, "story", shortnames);
		
		this.moduleService.modifyModules(modules);
		
		return "redirect:module_manage_" + productId + "_" + branchId + "_" + moduleId;  
	}
	
	/**
	 * 请求编辑模块页面
	 * @param moduleId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/module_edit_{productId}_{moduleId}",method=RequestMethod.GET)
	public String editModuleGet(@PathVariable int moduleId, Model model) {
		
		Module module = this.moduleRepository.findOne(moduleId);
		
		model.addAttribute("module", module);
		model.addAttribute("productList", this.productRepository.findAll());
		
		return "product/module_edit";
	}
	
	//缺修改关联的task
	/**
	 * 处理编辑模块请求
	 * @param productId
	 * @param moduleId
	 * @param module
	 */
	@ResponseBody
	@RequestMapping(value="/module_edit_{productId}_{moduleId}",method=RequestMethod.POST)
	public void editModulePost(@PathVariable int productId, @PathVariable int moduleId, Module module) {
		
		Integer parent = module.getParent();
		Module moduleTarget = this.moduleRepository.findOne(moduleId);
		Module moduleParent = this.moduleRepository.findOne(parent);
		String path = parent != 0 ? moduleParent.getPath().substring(0, moduleParent.getPath().length() - 1) : "";
		Integer branch_id = parent != 0 ? moduleParent.getBranch_id() : 0;
		Integer grade = parent != 0 ? moduleParent.getGrade() : 0;
		Integer root = module.getRoot();
		Product product = this.productRepository.findOne(root);
		List<Integer> moduleIds = new LinkedList<>();
		if (parent != moduleTarget.getParent()) {
			module.setBranch_id(branch_id);
			module.setGrade(grade + 1);
			module.setPath(path + "," + moduleTarget.getId() + ",");
			List<Module> childModules = this.moduleRepository.findByRootAndParentAndType(productId, moduleId, "story");
			for (Module childModule : childModules) {
				if (root != moduleTarget.getRoot()) {
					moduleIds.add(childModule.getId());
					childModule.setRoot(root);
				}
				childModule.setBranch_id(branch_id);
				childModule.setGrade(module.getGrade() + 1);
				childModule.setPath(module.getPath().substring(0, module.getPath().length() - 1) + "," + childModule.getId() + ",");
			}
		}
		if (root != moduleTarget.getRoot()) {
			moduleIds.add(moduleTarget.getId());
			this.storyRepository.findByModule_idIn(moduleIds).forEach(story->{story.setProduct(product);story.setBranch_id(branch_id);});
			this.caseRepository.findByModule_idIn(moduleIds).forEach(caze->{caze.setProduct(product);caze.setBranch_id(branch_id);});
			this.bugRepository.findByModule_idIn(moduleIds).forEach(bug->{bug.setProduct(product);bug.setBranch_id(branch_id);});
		}
		this.moduleService.modify(module, moduleTarget, "", "edit");
	}
	
	/**
	 * 处理批量编辑需求请求
	 * @param productId
	 * @param storyIds 需求的id
	 * @param fieldName 要修改的需求的列名称
	 * @param fieldVal 要修改的需求的列值
	 */
	@ResponseBody
	@RequestMapping(value="/story_batchChange_{productId}",method=RequestMethod.POST)
	public void modifyStories(@PathVariable int productId, @RequestParam Integer[] storyIds, @RequestParam String fieldName, @RequestParam String fieldVal) {
		
		this.storyService.modifiedByColumn(fieldName, fieldVal, storyIds, "edit");
		
	}
	
	/**
	 * 处理导出需求请求
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param column 按列名查找需求的列名
	 * @param columnVal 按列名查找需求的列值
	 * @param fileName 页面表单传递的导出文件名
	 * @param fileType 页面表单传递的导出文件类型
	 * @param encode 页面表单传递的导出文件字符编码
	 * @param exportType 页面表单传递的导出类型
	 * @param exportFields 页面表单传递的要导出字段
	 * @param storyIds
	 * @param resp 处理后返回的响应（即文件）
	 * @throws JRException
	 * @throws IOException
	 */
	@RequestMapping(value="/story_export_{productId}_{branchId}_{moduleId}_{column}_{columnVal}", method=RequestMethod.POST)
	public void exportStories(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, @PathVariable String column, @PathVariable String columnVal, String fileName, String fileType, String encode, String exportType, String exportFields, String storyIds, HttpServletResponse resp) throws JRException, IOException {
		
		String contentType; 
		List<Story> stories;
		JRAbstractExporter exporter;
		if (exportType.equals("all")) {
			Product product = this.productRepository.findOne(productId);
			stories = this.storyRepository.findAll(this.storyService.getSpecification(product, branchId, moduleId, column, columnVal));
		} else {
			stories = this.storyRepository.findByIdIn(MyUtil.convertStrToList(storyIds, ","));
		}
		stories.sort((a,b)-> a.getId()-b.getId());
		
		for (Story story : stories) {
			this.storyService.setDetailedInfo(story, this.userService.getAllUsersMappingAccountAndRealname(), this.moduleService.getModulesMappingIdAndName(productId, branchId));
		}
		
		resp.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "utf-8") + "." + fileType);

		switch (fileType) {
		case "csv":
			contentType = "text/" + fileType;
			exporter = new JRCsvExporter();
			break;
		case "xml":
			contentType = "text/" + fileType;
			exporter = new JRXmlExporter();
			break;
		case "html":
			contentType = "text/" + fileType;
			exporter = new HtmlExporter();
			break;
		case "pdf":
			contentType = "application/pdf";
			exporter = new JRPdfExporter();
			break;
		default:
			contentType = "application/vnd.ms-excel";
			exporter = new JRXlsExporter();
			break;
		}
		if (encode == null) 
			encode = "utf-8";
		resp.setContentType(contentType + ";charset=" + encode);
		
		Collection<Story> storiesCol = (Collection<Story>) stories;
		
		if (!fileType.equals("xml")) {
			JRBeanCollectionDataSource jrb = new JRBeanCollectionDataSource(storiesCol);
			JasperReport jr = (JasperReport) JRLoader.loadObject(new File(request.getServletContext().getRealPath("/") + "WEB-INF/classes/report/story.jasper"));
			Map<String, Object> map = new HashMap<>();
			map.put("FIELD_SHOW", exportFields);
			map.put("SOURCE_MAP", this.storyService.getSourceMap());
			map.put("STATUS_MAP", this.storyService.getStatusMap());
			map.put("STAGE_MAP", this.storyService.getStageMap());
			map.put("CLOSED_REASON_MAP", this.storyService.getClosedReasonMap());
			map.put("USER_MAP", this.userService.getAllUsersMappingAccountAndRealname());
			JasperPrint jp = JasperFillManager.fillReport(jr, map, jrb);
			JasperReportsUtils.render(exporter, jp, resp.getOutputStream());
		} else {
			XStreamMarshaller marshaller = new XStreamMarshaller();
			marshaller.marshalOutputStream(storiesCol, resp.getOutputStream());
		}
		
		resp.flushBuffer();
	}
	
	/**
	 * 请求报表页面
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param column
	 * @param columnVal
	 * @return
	 */
	@RequestMapping(value="/story_report_{productId}_{branchId}_{moduleId}_{column}_{columnVal}",method=RequestMethod.GET)
	public String reportStoryGet(@PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, @PathVariable String column, @PathVariable String columnVal) {
		
		return "product/story_report";
	}
	
	/**
	 * 处理显示报表请求
	 * @param charts 表单传递的要查看的报表名字
	 * @param productId
	 * @param branchId
	 * @param moduleId
	 * @param column
	 * @param columnVal
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/story_report_{productId}_{branchId}_{moduleId}_{column}_{columnVal}",method=RequestMethod.POST)
	public String reportStoryPost(String[] charts, @PathVariable int productId, @PathVariable int branchId, @PathVariable int moduleId, @PathVariable String column, @PathVariable String columnVal, Model model) {
		
		Product product = this.productRepository.findOne(productId);
		List<Story> list = this.storyRepository.findAll(this.storyService.getSpecification(product, branchId, moduleId, column, columnVal));
		
		Map<String, Map<? extends Object, Long>> chartTableMap = new LinkedHashMap<>();
		
		Function<Story, Object> function;

		for (String s : charts) {
			if (s.equals("Plan")) {
				String plan;
				Map<Integer, Long> planCountMap = new HashMap<>();
				for (Story sy : list) {
					plan = sy.getPlan();
					if (plan == null || plan.equals("")) {
						planCountMap.merge(0, 1L, (a,b)->a+b);
					} else {
						for (Integer planId : MyUtil.convertStrToArr(plan, ",")) {
							planCountMap.merge(planId, 1L, (a,b)->a+b);
						}
					}
				}
				chartTableMap.put(s, planCountMap);
			} else {
				function = story->{try {return story.getClass().getMethod("get" + s).invoke(story);} catch (Exception e) {
					e.printStackTrace();
				};
				return story;};
				chartTableMap.put(s, list.stream().collect(Collectors.groupingBy(function, Collectors.counting())));
			}
		}
		//如果userMap的key与其他Map的key重复
		Map<String, String> chartColumnMap = new HashMap<>();
		chartColumnMap.putAll(this.storyService.getSourceMap());
		chartColumnMap.putAll(this.storyService.getStageMap());
		chartColumnMap.putAll(this.userService.getAllUsersMappingAccountAndRealname());
		chartColumnMap.putAll(this.storyService.getStatusMap());
		chartColumnMap.putAll(this.storyService.getClosedReasonMap());
		chartColumnMap.put("", "未设定");
		Map<String, String[]> chartTitleMap = new HashMap<>();
		chartTitleMap.put("Product", new String[]{"产品需求数量","产品"});
		chartTitleMap.put("Module_id", new String[]{"模块需求数量","模块"});
		chartTitleMap.put("Source", new String[]{"需求来源统计","来源"});
		chartTitleMap.put("Plan", new String[]{"计划进行统计","计划"});
		chartTitleMap.put("Status", new String[]{"状态进行统计","状态"});
		chartTitleMap.put("Stage", new String[]{"所处阶段进行统计","阶段"});
		chartTitleMap.put("Pri", new String[]{"优先级进行统计","优先级"});
		chartTitleMap.put("Estimate", new String[]{"预计工时进行统计","预计工时"});
		chartTitleMap.put("OpenedBy", new String[]{"由谁创建来进行统计","用户"});
		chartTitleMap.put("AssignedTo", new String[]{"当前指派来进行统计","用户"});
		chartTitleMap.put("ClosedReason", new String[]{"关闭原因来进行统计","原因"});
		chartTitleMap.put("Version", new String[]{"变更次数来进行统计","变更次数"});
		model.addAttribute("chartTableMap", chartTableMap);
		model.addAttribute("chartColumnMap", chartColumnMap);
		model.addAttribute("chartTitleMap", chartTitleMap);
		model.addAttribute("moduleMap", this.moduleService.getModulesMappingIdAndName(productId, branchId));
		model.addAttribute("planMap", this.planService.getPlansMappingIdAndTitle(productId, branchId));
		model.addAttribute("size", list.size());
		
		return "product/story_report";
	}
	
	/**
	 * 请求浏览文档页面
	 * @param productId
	 * @param model
	 * @return
	 */
	@RequestMapping("/doc_browse_{productId}")
	public String browseDoc(@PathVariable Integer productId, Model model) {
		//判断是否有文档
		if(this.docRepository.findByProuct_id(productId).size() > 0) {
			List<Doc> docs = this.docRepository.findByProuct_id(productId);
		
			//Set<Integer> moduleSet = new HashSet<Integer>();
			Set<String> userSet = new HashSet<String>();
			for (Doc doc : docs) {
				//获得操作者列表
				//moduleSet.add(doc.getModule());
				userSet.add(doc.getAddedBy());
			}
	
			model.addAttribute("docList", docs);
			//模块map
			//model.addAttribute("moduleMap", this.moduleService.getModulesByIdInMappingIdAndName(moduleSet));
			//用户map
			model.addAttribute("userMap", this.userService.findByAccountIn(userSet));
		}
		return "product/doc_browse";
	}
	
	/**
	 * @Description: 处理创建文档请求
	 * @param model
	 * @param userAccount
	 * @return
	 */
	@RequestMapping("/doc_create_{productId}")
	public String createDoc(Model model, @ModelAttribute("userAccount") String userAccount) {
		
		model.addAttribute("productList", this.productRepository.findByPrivAndNameContaining(userAccount, ""));
		
		return "product/doc_create";
	}
	
	/**
	 * 请求浏览动态页面
	 * @param productId
	 * @param condition 查找动态的条件
	 * @param orderBy 动态排序字段
	 * @param ascOrDesc 升序或降序排序
	 * @param recPerPage 分页大小
	 * @param page 页码
	 * @param model
	 * @return
	 */
	@RequestMapping("/dynamic_browse_{productId}_{condition}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}")
	public String browseDynamic(@PathVariable int productId, @PathVariable String condition, @PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		Page<Action> actions = null;
		Timestamp start = null, end = null;
		Calendar calendar = Calendar.getInstance();
		calendar.setFirstDayOfWeek(Calendar.MONDAY);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		
		switch (condition) {
		case "today":
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "yesterday":
			calendar.add(Calendar.DAY_OF_MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "twodaysago":
			calendar.add(Calendar.DAY_OF_MONTH, -2);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "thisweek":
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "lastweek":
			calendar.add(Calendar.WEEK_OF_MONTH, -1);
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "thismonth":
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "lastmonth":
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			calendar.add(Calendar.MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "all":
			actions = this.actionRepository.findByProductContainingAndObjectTypeNotAndActionNot("," + productId + ",", "module", "delete", pageRequest);
			break;
		default:
			actions = this.actionRepository.findByProductContainingAndActorAndObjectTypeNotAndActionNot("," + productId + ",", condition, "module", "delete", pageRequest);
			break;
		}
		if (actions == null) {
			calendar.add(Calendar.MONTH, 1);
			end = new Timestamp(calendar.getTimeInMillis());
			actions = this.actionRepository.findByProductContainingAndDateBetweenAndObjectTypeNotAndActionNot("," + productId + ",", start, end, "module", "delete", pageRequest);
		}
		actions.getContent().forEach(action->action.setObjectName(this.dynamicService.getObjectName(action.getObjectType(), action.getObjectId())));

		model.addAttribute("actionPage", actions);
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		model.addAttribute("objectTypeMap", this.dynamicService.getObjectTypeMap());
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "product/dynamic_browse";
	}
	
}
