package com.projectmanager.service;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.projectmanager.controller.AppConfig;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.ProjectStory;
import com.projectmanager.entity.Stories;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.StorySpec;
import com.projectmanager.entity.Story_;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.CaseRepository;
import com.projectmanager.repository.FileRepository;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ProjectStoryRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.StorySpecRepository;
import com.projectmanager.repository.TaskRepository;

@Service
public class StoryService implements LogInterfaceService<Story>{

	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private StorySpecRepository storySpecRepository;
	
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private EntityManager entityManager;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private CaseRepository caseRepository;
	
	@Autowired
	private FileRepository fileRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	@Autowired
	private ProjectStoryRepository projectStoryRepository;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private MailService mailService;
	
	/**
	 * 编辑需求
	 * @param source
	 * @param taget
	 * @param comment
	 * @param action
	 */
	public void alter(Story source, Story target, String comment, String action) {
		//编辑需求
		MyUtil.copyProperties(source, target);
	}
	
	//来源
	public Map<String, String> getSourceMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> sourceMap = new LinkedHashMap<String, String>(){{
			put("customer", "客户");
			put("user", "用户");
			put("po", "产品经理");
			put("market", "市场");
			put("service", "客服");
			put("operation", "运营");
			put("support", "技术支持");
			put("competitor", "竞争对手");
			put("partner", "合作伙伴");
			put("dev", "开发人员");
			put("tester", "测试人员");
			put("bug", "Bug");
			put("other", "其他");
		}};
		
		return sourceMap;
	}
	
	//状态
	public Map<String, String> getStatusMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> statusMap = new LinkedHashMap<String, String>(){{
			put("changed", "已变更");
			put("active", "激活");
			put("draft", "草稿");
			put("closed", "已关闭");
		}};
		
		return statusMap;
	}
	
	//阶段
	public Map<String, String> getStageMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> stageMap = new LinkedHashMap<String, String>(){{
			put("wait", "未开始");
			put("planned", "已计划");
			put("projected", "已立项");
			put("developing", "研发中");
			put("developed", "研发完毕");
			put("testing", "测试中");
			put("tested", "测试完毕");
			put("verified", "已验收");
			put("released", "已发布");
		}};
		
		return stageMap;
	}
	
	//关闭原因
	public Map<String, String> getClosedReasonMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> closedReasonMap = new LinkedHashMap<String, String>(){{
			put("done", "已完成");
			put("subdivided", "已细分");
			put("duplicate", "重复");
			put("postponed", "延期");
			put("willnotdo", "不做");
			put("cancel", "已取消");
			put("bydesign", "设计如此");
		}};
		
		return closedReasonMap;
	}
	
	//字段名
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("product", "所属产品");
			put("branch_id", "所属分支/平台");
			put("module_id", "所属模块");
			put("plan", "所属计划");
			put("source", "需求来源");
			put("sourceNote", "备注");
			put("title", "需求名称");
			put("keywords", "关键词");
			put("pri", "优先级");
			put("estimate", "预计工时");
			put("status", "状态");
			put("color", "标题颜色");
			put("stage", "阶段");
			put("mailto", "抄送给");
			put("assignedTo", "指派给谁");
			put("assignedDate", "指派日期");
			put("reviewedBy", "由谁评审");
			put("reviewedDate", "评审日期");
			put("closedBy", "由谁关闭");
			put("closedDate", "关闭日期");
			put("closedReason", "关闭原因");
			put("childStories", "细分需求");
			put("linkStories", "相关需求");
			put("duplicateStory", "重复需求");
			put("version", "版本号");
		}};
		
		return fieldNameMap;
	}
	
	/**
	 * 创建需求
	 * @param story 需求对象
	 * @param storySpec 需求描述和验收标准对象
	 * @return 创建的需求对象
	 */
	public Story create(Story story, StorySpec storySpec) {
		
		story = this.storyRepository.save(story);
		
		storySpec.setStoryId(story.getId());
		storySpec.setVersion(1);
		
		this.storySpecRepository.save(storySpec);
		
		String mailto = story.getMailto();
		
		if(mailto != null) {
			//获取抄送用户名列表
			List<String> accountList = Arrays.asList(mailto.split(","));
			
			//抄送邮件
			mailService.mailTo(accountList, "您有一条新动态", "您有一个新的需求，请登录项目管理系统查看！");
		}
		
		return story;
	}
	
	/**
	 * 变更需求
	 * @param storyId 需求ID
	 * @param story 要变更的需求
	 * @param storySpec 变更历史
	 * @return 变更成功返回true，否则返回false
	 */
	//可能变更不成功，但是记录了操作记录
	public boolean change(Story source, Story target, StorySpec storySpec, String comment) {
		
		int storyId = target.getId();
		StorySpec lastStorySpec = this.storySpecRepository.findFirstByStoryIdOrderByIdDesc(storyId);
		
		if (!storySpec.equals(lastStorySpec)) {
			Integer lastVersion = lastStorySpec.getVersion();
			storySpec.setStoryId(storyId);
			storySpec.setVersion(lastVersion + 1);
			this.storySpecRepository.save(storySpec);
			source.setVersion(lastVersion + 1);
			if (target.getStatus().equals("active")) 
				source.setStatus("changed");
			source.setReviewedBy("");
			target.setReviewedDate(null);
			((StoryService)AopContext.currentProxy()).modify(source, target, comment, "change");
			
			//获取抄送用户名列表
			List<String> accountList = Arrays.asList(target.getMailto().split(","));
			
			//抄送邮件
			mailService.mailTo(accountList, "您有一条新动态", "您的一个需求已被变更，请登录项目管理系统查看！");
			
			return true;
		} 
		((StoryService)AopContext.currentProxy()).modify(target, target, comment, "change");
		return false;
	}	
	
//	public void modify4Change(Story source, Story target, String comment) {
//		
//		MyUtil.copyProperties(source, target);
//	}
//	
//	public void modify4Close(Story source, Story target, String comment) {
//		
//		MyUtil.copyProperties(source, target);
//	}
	
	/**
	 * @Description: 修改需求
	 * @param source 带有修改值的需求
	 * @param target 被修改的需求
	 * @param comment 备注
	 * @param action 操作
	 */
	@Override
	public void modify(Story source, Story target, String comment, String action) {
		
		if (action.equals("activate")) {
			target.setClosedDate(source.getClosedDate());
			target.setAssignedTo(source.getAssignedTo());
			target.setClosedBy(source.getClosedBy());
			target.setStatus(source.getStatus());
			if (target.getClosedReason().equals("subdivided")) {
				target.setChildStories(source.getChildStories());
			} else if (target.getClosedReason().equals("duplicate")) {
				target.setDuplicateStory(source.getDuplicateStory());
			} 
			target.setClosedReason(source.getClosedReason());
		} else {
			MyUtil.copyProperties(source, target);
		}
		
		//获取抄送用户名列表
		List<String> accountList = Arrays.asList(target.getMailto().split(","));
		
		//抄送邮件
		mailService.mailTo(accountList, "您有一条新动态", "您的一个需求已被修改，请登录项目管理系统查看！");
	}
	
	/**
	 * @Description: 获取受影响的用例、Bug、任务
	 * @param storyId
	 * @param model
	 */
	public void renderAffectItems(int storyId, Model model) {
		
		List<Object> project;
		List<List<Object>> projects = new ArrayList<List<Object>>();
		List<Object[]> bugs = this.bugRepository.findByStory_id(storyId);
		List<Object[]> cases = this.caseRepository.findByStory_id(storyId);
		List<Object[]> tempProjects = this.projectRepository.findByStory_id(storyId);
		
		for (Object[] objects : tempProjects) { 
			project = new ArrayList<Object>(Arrays.asList(objects));
			project.add(this.taskRepository.findByProject_idAndStory_id(Integer.valueOf(objects[0].toString()), storyId));
			projects.add(project);
		}
		
		model.addAttribute("bugList", bugs);
		model.addAttribute("caseList", cases);
		model.addAttribute("projectList", projects);
		
	}
	
	/**
	 * @Description: 根据多个需求ID获取需求ID和名称
	 * @param idsStr 多个需求ID
	 * @return 需求ID和名称
	 */
	public List<Object[]> getStoriesByIdsStr(String idsStr) {
		
		List<Object[]> stories = this.storyRepository.findIdAndNameByIdIn(MyUtil.convertStrToList(idsStr, ","));		
		
		return stories;
	}
	
	/**
	 * @Description: 修改需求某列的值
	 * @param fieldName 列名
	 * @param fieldVal 列值
	 * @param storyIds 多个需求ID
	 * @param action 操作
	 */
	public void modifiedByColumn(String fieldName, Object fieldVal, Integer[] storyIds, String action) {
		
		if (fieldName.equals("Module_id") || fieldVal.equals("Branch_id")) {
			fieldVal = Integer.valueOf((String)fieldVal);
		}
		
		List<Story> stories = this.storyRepository.findByIdIn(storyIds);
		
		ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
		
		Story source = ctx.getBean(Story.class);
		
		Method method;
		try {
			method = source.getClass().getMethod("set" + fieldName, fieldVal.getClass());
			method.invoke(source, fieldVal);
		} catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			e.printStackTrace();
		}
		
		for (Story target : stories) {
			((StoryService)AopContext.currentProxy()).modify(source, target, "", action);
		}
		((ConfigurableApplicationContext)ctx).close();
	}
	
	/**
	 * @Description: 批量创建需求
	 * @param stories 多个需求对象
	 */
	public void batchCreate(Stories stories) {
		
		Integer dittoModule = null, dittoPri = null;
		String dittoPlan = null, dittoSource = null;
		Story story;
		List<Story> storyList = stories.getStories();
		List<StorySpec> storySpecList = stories.getStorySpecs();
		
		for (int index = 0, size = storyList.size(); index < size; index++) {
			story = storyList.get(index);
			if (story.getModule_id() == -1) {
				story.setModule_id(dittoModule);
			} else {
				dittoModule = story.getModule_id();
			}
			if (story.getPlan().equals("-1")) {
				story.setPlan(dittoPlan);
			} else {
				dittoPlan = story.getPlan();
			}
			if (story.getSource().equals("-1")) {
				story.setSource(dittoSource);
			} else {
				dittoSource = story.getSource();
			}
			if (story.getPri() == -1) {
				story.setPri(dittoPri);
			} else {
				dittoPri = story.getPri();
			}
			if (!story.getTitle().equals("")) {
				((StoryService)AopContext.currentProxy()).create(story, storySpecList.get(index));
			}
		}
		
	}
	
	/**
	 * @Description: 构造查询需求的条件
	 * @param product 产品
	 * @param branchId 分支ID
	 * @param moduleId 模块ID
	 * @param column 列名
	 * @param columnVal 列值
	 * @return 查询条件
	 */
	public Specification<Story> getSpecification(Product product, int branchId, int moduleId, String column, String columnVal) {
		
		Specification<Story> specification = new Specification<Story>() {
			
			@SuppressWarnings("unchecked")
			@Override
			public Predicate toPredicate(Root<Story> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
				
				@SuppressWarnings("rawtypes")
				Expression columnExp = root.get(column);
				Predicate columnPd;
				Predicate branchPd = builder.equal(root.get(Story_.branch_id), branchId);
				Predicate productPd = builder.equal(root.get(Story_.product), product);
				Predicate modulePd = builder.equal(root.get(Story_.module_id), moduleId);
				
				if (column.equals("stage") && columnVal.equals("willclose")) {
					columnPd = builder.or(builder.equal(columnExp, "developed"),builder.equal(columnExp, "released"));
				} else if (column.equals("status") && columnVal.equals("unclosed")) {
					columnPd = builder.notEqual(columnExp, "closed");
				} else if (column.equals("reviewedBy")) {
					columnPd = builder.like(builder.concat(builder.concat(",", columnExp), ","), "%," + columnVal + ",%");
				} else {
					columnPd = builder.equal(root.get(column), columnVal);
				}
				
				if (branchId == 0) {
					if (moduleId == 0) {
						return builder.and(columnPd,productPd);
					} else {
						return builder.and(columnPd,productPd,modulePd);
					}
				} 
				
				if (moduleId == 0) {
					return builder.and(columnPd,productPd,branchPd);
				} else {
					return builder.and(columnPd,productPd,branchPd,modulePd);
				}
			}
		};
		return specification;
	}
	
	/**
	 * @Description: 补全需求详细信息用于导出需求
	 * @param story
	 * @param userMap
	 * @param moduleMap
	 */
	public void setDetailedInfo(Story story, Map<String, String> userMap, Map<Integer, String> moduleMap) {
		
		Story duplicateStory = this.storyRepository.findOne(story.getDuplicateStory());
		Integer moduleId = story.getModule_id();
		String duplicateStoryStr = duplicateStory == null ? "" : duplicateStory.getTitle() + "(#" + duplicateStory.getId() + ")",
				moduleName = moduleId == 0 ? "0" : moduleMap.get(moduleId);
		StringBuilder split = new StringBuilder(""), mailtoStr = new StringBuilder(""), filesStr = new StringBuilder(""), plansStr = new StringBuilder(""), childStoriesStr = new StringBuilder(""), linkStoriesStr = new StringBuilder("");
		entityManager.clear();
		
		this.fileRepository.findByObjectTypeAndObjectId("story", story.getId()).forEach(file->filesStr.append(file.getTitle() + "(#" + file.getId() +") "));
		this.planRepository.findByIdIn(MyUtil.convertStrToArr(story.getPlan(), ",")).forEach(plan->plansStr.append(plan.getTitle() + "(#" + plan.getId() + ") "));
		this.storyRepository.findByIdIn(MyUtil.convertStrToList(story.getChildStories(), ",")).forEach(storyTemp->childStoriesStr.append(storyTemp.getTitle() + "(#" + storyTemp.getId() + ") "));
		this.storyRepository.findByIdIn(MyUtil.convertStrToList(story.getLinkStories(), ",")).forEach(storyTemp->linkStoriesStr.append(storyTemp.getTitle() + "(#" + storyTemp.getId() + ") "));
		for (String account : story.getMailto().split(",")) {
			if (!account.equals("")) {
				mailtoStr.append(split + userMap.get(account));
				split.replace(0, split.length(), ",");
			}
		}
		story.setModuleName(moduleName);
		story.setFilesStr(filesStr.toString());
		story.setPlan(plansStr.toString());
		story.setMailto(mailtoStr.toString());
		story.setChildStories(childStoriesStr.toString());
		story.setLinkStories(linkStoriesStr.toString());
		story.setDuplicateStoryTitle(duplicateStoryStr);
		story.setStorySpec(this.storySpecRepository.findFirstByStoryIdOrderByIdDesc(story.getId()));
		story.setOpenedBy(userMap.get(story.getOpenedBy()));
		story.setLastEditedBy(userMap.get(story.getLastEditedBy()));
		story.setAssignedTo(userMap.get(story.getAssignedTo()));
		story.setReviewedBy(userMap.get(story.getReviewedBy()));
		story.setClosedBy(userMap.get(story.getClosedBy()));
	}
	
	/**
	 * 根据projectId查找关联需求的id和title
	 * @param projectId
	 * @return
	 */
	public Map<String, Object[]> getStoryMappingIdAndTitle(int projectId) {
		//根据项目查找所有关联的需求的id
		List<Integer> ids = this.projectStoryRepository.findStoryIdByProject(projectId);
		//判断是否有关联的需求
		if(ids.size() > 0) {
			//查找关联需求的id和title
			List<Object[]> storys = this.storyRepository.findAllAccountAndRealnameAndProductId(ids);
			//调用mappingIdAndTitle来返回map
			return this.mappingIdAndTitle(storys);
		} else {
			return null;
		}
	}
	
	/**
	 * 根据需求id和title，构造map
	 * @param storys
	 * @return
	 */
	private Map<String, Object[]> mappingIdAndTitle(List<Object[]> storys) {
		
		//key为id，value为title的map
		Map<String, Object[]> map = new HashMap<String, Object[]>();
		//获得数组
		Iterator<Object[]> it = storys.iterator();
		
		Object[] story;
		//循环给map赋值
		while (it.hasNext()) {
			story = it.next();
			map.put(story[0].toString(), story);
		}
		
		return map;
	}
	
	/**
	 * 批量关闭、指派、关联模块
	 * @param projectId
	 * @param storyIds （需求id数组）
	 * @param fieldName （操作：例如close=关闭）
	 * @param fieldVal （操作目的：例如指派给某个fieldVal）
	 */
	public void modifiedByColumn(int projectId,String fieldName, Integer[] storyIds) {
		
		List<Story> storys = this.storyRepository.findByIdIn(storyIds);
		String status = fieldName;
		for (Story story : storys) {
			Story updateStory = this.storyRepository.findOne(story.getId());
			//判断执行哪个操作
			if(status.equals("close")) {
				//设置模块
				story.setStatus("closed");
				
			} else if(status.equals("delete")){
				//移除需求
				this.projectStoryRepository.deleteByProjectIdAndStoryId(projectId, story.getId());
			}
			this.alter(story, updateStory, "", status);
		}
	}
	
	/**
	 * 查找未关联项目的需求
	 * @param projectId
	 * @return
	 */
	public List<Story> getNoLinkStoryByProject(int projectId) {
		//关联产品
		List<Product> products = this.projectService.getProductForProject(projectId);
		//已关联此项目的需求
		List<Story> storys = this.storyRepository.findByProject(projectId);
		List<Integer> storyIds = new ArrayList<Integer>();
		for(Story story : storys) {
			storyIds.add(story.getId());
		}
		//项目未关联的需求
		List<Story> storyList = this.storyRepository.findByProductInAndIdNotIn(products, storyIds);
		return storyList;
	}
	
	/**
	 * 项目关联需求
	 * @param storyIds
	 * @param projectId
	 */
	public void linkStoryToProject(Integer[] storyIds, int projectId) {
		//选择的需求
		List<Story> storyList = this.storyRepository.findByIdIn(storyIds);
		for(Story story : storyList) {
			
			ProjectStory pjStory = new ProjectStory();
			//将值赋给pjStory
			pjStory.setProduct_id(story.getProduct().getId());
			pjStory.setProject_id(projectId);
			pjStory.setStory_id(story.getId());
			//项目关联此需求
			this.projectStoryRepository.save(pjStory);
		}
	}
	
}
