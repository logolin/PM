package com.projectmanager.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Action;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.BuildRepository;
import com.projectmanager.repository.DeptRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ReleaseRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskRepository;

@Service
public class DynamicService {

	@Autowired
	protected ActionRepository actionRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private ReleaseRepository releaseRepository;
	
	@Autowired
	private BuildRepository buildRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private TaskRepository taskRepository;
	
	@Autowired
	private DeptRepository deptRepository;
	
	public List<Action> findActionByType(int projectId, String type) {
		Date date = new Date();		//生成当前日期
		date.getTime();		//获取当前日期的时间戳
		switch (type) {
		case "all":
			return this.actionRepository.findByProject(projectId);

		case "today":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "yesterday":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "twodaysago":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "thisweek":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "lastweek":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "thismonth":
			return this.actionRepository.findByProjectAndDate(projectId, date);
		
		case "lastmonth":
			return this.actionRepository.findByProjectAndDate(projectId, date);
			
		case "closed":
			return null;
			
		default:
			return this.actionRepository.findByActor(type);
		}
	}
	
	public Map<String, String> getActionMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> actionMap = new HashMap<String, String>(){{
			put("create", "创建");
			put("edit", "编辑");
			put("delete", "删除");
			put("close", "关闭");
			put("change", "变更");
			put("review", "评审");
			put("activate", "激活");
			put("terminate", "停止维护");
			put("childstories", "细分需求");
			put("linkstories", "关联需求");
			put("unlinkstories", "移除相关需求");
			put("unchildstories", "移除细分需求");
			put("linkbugs", "关联Bug");
			put("linkleftbugs", "关联剩余Bug");
			put("linkplan", "关联计划");
			put("unlinkbugs", "移除计划");
			put("unleftlinkbugs", "移除剩余Bug");
			put("unlinkplan", "移除计划");
			put("comment", "备注");
			//@author logolin
			put("suspend", "挂起");
			put("assign", "指派");
			put("delay", "延期");
			put("finish", "完成");
			put("linked2project", "关联项目");
			put("login", "登录系统");
			put("logout", "退出系统");
			put("pause", "暂停");
			put("restart", "继续");
			put("start", "启动");
			put("cancel", "取消");
			//@author Tao
//			put("resolve", "解决");
		}};
		
		return actionMap;
	}
	
	/**
	 * 返回对应的对象类型名称
	 * @return map
	 */
	public Map<String, String> getObjectTypeMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> ojectTypeMap = new HashMap<String, String>(){{
			put("story", "需求");
			put("plan", "计划");
			put("release", "发布");
			put("branch", "分支/平台");
			put("module", "模块");
			put("product", "产品");
			put("build", "版本");
			//@author logolin
			put("task", "任务");
			put("project", "项目");
			put("bug", "Bug");
			put("dept", "部门");
			put("company", "公司");
			put("group", "分组");
			put("repo", "代码");
		}};
		
		return ojectTypeMap;
	}
	public String getObjectName(String objectType, int objectId) {
		
		String objectName = null;
		switch (objectType) {
		case "story":
			objectName = this.storyRepository.findOne(objectId).getTitle();
			break;
		case "plan":
			objectName = this.planRepository.findOne(objectId).getTitle();
			break;
		case "release":
			objectName = this.releaseRepository.findOne(objectId).getName();
			break;
		case "module":
			objectName = this.moduleRepository.findOne(objectId).getName();
			break;
		case "branch":
			objectName = this.branchRepository.findOne(objectId).getName();
			break;
		case "product":
			objectName = this.productRepository.findOne(objectId).getName();
			break;
		case "build":
			objectName = this.buildRepository.findOne(objectId).getName();
			break;
		default:
			objectName = "";
			break;
		}
		
		return objectName;
	}
	
	public Map<String, String> getObjectTypeName() {
		
		@SuppressWarnings("serial")
		Map<String, String> ojectTypeMap = new HashMap<String, String>(){{
			put("story", "需求");
			put("task", "任务");
			put("bug", "Bug");
			put("project", "项目");
			put("build", "版本");
		}};
		
		return ojectTypeMap;
	}
	
	/**
	 * 根据objectType和objectId查找对应的名称
	 * @param objectType （对象名称，例如product、task等）
	 * @param objectId （对应id）
	 * @return
	 */
	public String getObjectNameOrTitle(String objectType, int objectId) {
		
		String objectName = null;
		switch (objectType) {
		case "story":
			objectName = this.storyRepository.findOne(objectId).getTitle();
			break;
		case "task":
			objectName = this.taskRepository.findOne(objectId).getName();
			break;
		case "project":
			objectName = this.projectRepository.findOne(objectId).getName();
			break;
		case "bug":
			objectName = this.bugRepository.findOne(objectId).getTitle();
			break;
		case "build":
			objectName = this.buildRepository.findOne(objectId).getName();
			break;
		case "dept":
			try {
				objectName = this.deptRepository.findOne(objectId).getName();
			} catch (Exception e) {
				objectName = "";
			}
			break;
		case "product":
			objectName = this.productRepository.findOne(objectId).getName();
			break;
		case "release":
			objectName = this.releaseRepository.findOne(objectId).getName();
			break;
		case "plan":
			objectName = this.planRepository.findOne(objectId).getTitle();
			break;
		case "module":
			try {
				objectName = this.moduleRepository.findOne(objectId).getName();
			} catch (Exception e) {
				objectName = "";
			}
			
			break;
		case "branch":
			try {
				objectName = this.branchRepository.findOne(objectId).getName();
			} catch (Exception e) {
				objectName = "";
			}
			
			break;
		default:
			objectName = "";
			break;
		}
		
		return objectName;
	}
	
	public Map<String, String> getActionName() {
		
		@SuppressWarnings("serial")
		Map<String, String> actionMap = new HashMap<String, String>(){{
			put("create", "创建");
			put("edit", "编辑");
			put("delete", "删除");
			put("close", "关闭");
			put("pause", "暂停");
			put("comment", "备注");
		}};
		
		return actionMap;
	}
	
}