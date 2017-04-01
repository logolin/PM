package com.projectmanager.service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Task;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.UserRepository;

@Service
public class BugService {
	
	@Autowired
	private BugRepository bugRepository;

	@Autowired
	private UserService userService;
	
	@Autowired
	private TaskRepository  taskRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	@Autowired
	private StoryRepository storyRepository; 

	@Autowired
	private UserRepository userRepository;
	
	public final Map<String, String> statusMap = new HashMap<String, String>(){{
		put("active", "激活");
		put("resolved", "已解决");
		put("closed", "已关闭");
	}};
	
	public void setDetailedInfo(Bug bug) {
		
		bug.setOpenedBy(this.userService.getRealNameByAccount(bug.getOpenedBy()));
		bug.setLastEditedBy(this.userService.getRealNameByAccount(bug.getLastEditedBy()));
		bug.setAssignedTo(this.userService.getRealNameByAccount(bug.getAssignedTo()));
		bug.setResolvedBy(this.userService.getRealNameByAccount(bug.getResolvedBy()));
		bug.setClosedBy(this.userService.getRealNameByAccount(bug.getClosedBy()));
	}
	
	/**
	 * 返回Branch、Module、Plan、Task、Story
	 * @param bug
	 * @param model
	 */
	public void getBMPTS(Bug bug, Model model) {
		//根据branch_id查找平台名称
		model.addAttribute("branch", this.branchRepository.findOne(bug.getBranch_id()));
		//根据module_id查找模块名称
		model.addAttribute("module",this.moduleRepository.findOne(bug.getModule_id()));
		//根据plan_id查找计划名称
		model.addAttribute("plan",this.planRepository.findOne(bug.getPlan_id()));
		//根据task_id查找任务
		model.addAttribute("task", this.taskRepository.findOne(bug.getTask_id()));
		//根据story_id查找需求名称
		model.addAttribute("story",this.storyRepository.findOne(bug.getStory_id()));
		
	}
	
	/**
	 * 将bug英文状态转换为中文输出
	 * 单个(single)bug使用该方法
	 * @param bugList
	 */
	public String getSStatusName(String status) {
		
		switch (status) {
		case "active":
			return  "激活";
			
		case "resolved":
			return  "已解决";
			
		case "closed":
			return  "已关闭";
			
		default:
			break;
		}
		return  null;
	}
	
	/**
	 * 将bug英文状态转换为中文输出
	 * 多个(Multi-)bug时使用该方法
	 * @return
	 */
	public Map<String, String> getMStatusName() {
		@SuppressWarnings("serial")
		Map<String, String> statusMap = new HashMap<String, String>(){{
			put("active", "激活");
			put("resolved", "已解决");
			put("closed", "已关闭");
		}};
		return statusMap;
	}
	
	/**
	 * 将bug类型转换成中文输出
	 * @return
	 */
	public Map<String,String> getBugTypeName() {
		@SuppressWarnings("serial")
		Map<String,String> typeMap = new HashMap<String, String>() {{
			put("codeerror", "代码错误");
			put("interface", "界面优化");
			put("designdefect", "设置缺陷");
			put("config", "设计相关");
			put("install", "安装部署");
			put("security", "安全相关");
			put("performance", "性能问题");
			put("standard", "标准规范");
			put("automation", "测试脚本");
			put("codeimprovement", "代码改进");
			put("others", "其他");
		}};
		return typeMap;
	}
	
	/**
	 * 将操作系统转换成完整输出
	 * @return
	 */
	public Map<String,String> getOSName() {
		@SuppressWarnings("serial")
		Map<String,String> osMap = new HashMap<String, String>() {{
			put("all", "全部");
			put("windows", "Windows");
			put("win8", "Windows 8");
			put("win7", "Windows 7");
			put("vista", "Windows Vista");
			put("winxp", "Windows XP");
			put("win2012", "2012");
			put("win2008", "2008");
			put("win2003", "2003");
			put("win2000", "2000");
			put("android", "Android");
			put("ios", "IOS");
			put("wp8", "WP8");
			put("wp7", "WP7");
			put("symbian", "Symbian");
			put("linux", "Linux");
			put("freebsd", "FreeBSD");
			put("osx", "OS X");
			put("unix", "Unix");
		}};
		return osMap;
	}
	
	/**
	 * 将浏览器转换成完整输出
	 * @return
	 */
	public Map<String,String> getBrowserName() {
		@SuppressWarnings("serial")
		Map<String,String> browserMap = new HashMap<String, String>() {{
			put("all", "全部");
			put("ie", "IE系列");
			put("ie11", "IE 11");
			put("ie10", "IE 10");
			put("ie9", "IE 9");
			put("ie8", "IE 8");
			put("ie7", "IE 7");
			put("ie6", "IE 6");
			put("chrome", "Chrome");
			put("firefox", "Firefox系列");
			put("firefox4", "Firefox 4");
			put("firefox3", "Firefox 3");
			put("firefox2", "Firefox 2");
			put("opera", "Opera系列");
			put("opera11", "Opera 11");
			put("opera10", "Opera 10");
			put("opera9", "Opera 9");
			put("safari", "Safari");
			put("maxthon", "遨游");
		}};
		return browserMap;
	}
	
	/**
	 * 将解决方案转换成中文输出
	 * @return
	 */
	public Map<String, String> getResolutionName() {
		@SuppressWarnings("serial")
		Map<String, String> resolutionMap = new HashMap<String, String>(){{
			put("bydesign", "设计如此");
			put("duplicate", "重复Bug");
			put("external", "外部原因");
			put("fixed", "已解决");
			put("notrepro", "无法重现");
			put("postponed", "延期处理");
			put("willnotfix", "不予解决");
			put("tostory", "转需求");
		}};
		return resolutionMap;
	}
	
	/**
	 * bug里字段对应的中文
	 * @return
	 */
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("storyVersion", "需求版本");
			put("toTask", "转任务");
			put("toStory", "转需求");
			put("title", "bug标题");
			put("keywords", "关键字");
			put("severity", "严重程度");
			put("pri", "优先级");
			put("type", "bug类型");
			put("os", "操作系统");
			put("browser", "浏览器");
			put("steps", "重现步骤");
			put("status", "bug状态");
			put("color", "颜色标签");
			put("confirmed", "是否确认");
			put("activatedCount", "激活次数");
			put("mailto", "抄送给谁");
			put("openedBy", "由谁创建");
			put("openedDate", "创建日期");
			put("openedBuild", "影响版本");
			put("assignedTo", "当前指派给谁");
			put("assignedDate", "指派日期");
			put("resolvedBy", "由谁解决");
			put("resolution", "解决方案");
			put("resolvedBuild", "解决版本");
			put("resolvedDate", "解决日期");
			put("closedBy", "由谁关闭");
			put("closedDate", "关闭日期");
			put("duplicateBug", "重复bugid");
			put("linkBug", "相关bug");
			put("useCase", "相关用例");
			put("caseVersion", "用例版本");
			put("lastEditedBy", "最后修改者");
			put("lastEditedDate", "最后修改日期");
			put("deleted", "已删除");
			put("testtask", "测试任务");
						
		}};
		
		return fieldNameMap;
	}
	
	/**
	 * 编辑bug
	 * @param source
	 * @param taget
	 * @param comment
	 * @param action
	 */
	public void alter(Bug source, Bug target, String comment, String action) {
		MyUtil.copyProperties(source, target);
	}
	
	/**
	 * 批量指派任务
	 * @param fieldVal 操作目的，指派给某个fieldVal
	 * @param bugIds bugId数组
	 */
	public void massAssignBug(String fieldName, String fieldVal, Integer[] bugIds, String account) {
		//根据bugId数组中查找bug
		List<Bug> bugs = this.bugRepository.findByIdIn(bugIds);
		String flag = fieldName;
		//循环，完成bug批量指派
		for(Bug bug : bugs) {
			//判断执行哪个操作
			if(flag.equals("assignedTo")) {
				//指派给谁
				bug.setAssignedTo(fieldVal);
				//将指派日期设置为当前系统时间
				bug.setAssignedDate(new Timestamp(System.currentTimeMillis()));
			}else if(flag.equals("delete")) {
				//设置delete字段为 "1"
				bug.setDeleted("1");
			}
			bug.setLastEditedBy(account);
			bug.setLastEditedDate(new Timestamp(System.currentTimeMillis()));
		}
	}
	
	/**
	 * 由bugId获得productId
	 * @param bugId
	 * @return
	 */
	public Integer getBugerProductId(Integer bugId) {
		
		return this.bugRepository.findOne(bugId).getProduct().getId();
	}
	
}
