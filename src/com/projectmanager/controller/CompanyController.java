package com.projectmanager.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

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
import com.projectmanager.entity.Company;
import com.projectmanager.entity.Dept;
import com.projectmanager.entity.Depts;
import com.projectmanager.entity.Group;
import com.projectmanager.entity.User;
import com.projectmanager.entity.UserGroup;
import com.projectmanager.entity.Users;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.CompanyRepository;
import com.projectmanager.repository.DeptRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.UserGroupRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.CompanyService;
import com.projectmanager.service.DeptService;
import com.projectmanager.service.DynamicService;
import com.projectmanager.service.GroupPrivService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/company")
@SessionAttributes("userAccount")
@Transactional
public class CompanyController {

	@Autowired
	private UserService userService;
	
	@Autowired
	private DeptRepository deptRepository;
	
	@Autowired
	private GroupRepository groupRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserGroupRepository userGroupRepository;
	
	@Autowired
	private CompanyService companyService;
	
	@Autowired
	private DeptService deptService;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private DynamicService dynamicService;
	
	@Autowired
	private CompanyRepository companyRepository;
	
	@Autowired
	private GroupPrivService groupPrivService;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	/**
	 * 显示组织视图：部门结构（用户列表）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/company_browse", method = RequestMethod.GET)
	public String viewCompanyBrowse(Model model) {
		
		//默认显示全部部门用户
		return "forward:company_browse_0_bydept_id_asc_10_1";
	}
	
	/**
	 * 根据部门显示用户
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/company_browse_{deptId:\\d+}")
	public String viewCompanyUserForDept(@PathVariable int deptId, Model model) {
		
		return "forward:company_browse_" + deptId + "_bydept_id_up_10_1";
	}
	
	/**
	 * 分页后的用户列表
	 * @param deptId
	 * @param orderby
	 * @param ascOrDesc
	 * @param recPerPage
	 * @param page
	 * @param model
	 * @return
	 */
	@RequestMapping("/company_browse_{deptId:\\d+}_{type}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}")
	public String viewCompanyUserPage(@PathVariable int deptId, @PathVariable String type, @PathVariable String orderBy, 
			@PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		
		Page<User> users;
		//判断升/降序
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		//取得页码、行数和排序顺序
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		//根据部门和分页信息查询用户
		users = this.userService.getUserForDept(deptId, pageRequest);
		model.addAttribute("users", users);
		return "company/company_browse";
	}
	
	/**
	 * 显示添加用户
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user_create_{deptId:\\d+}", method = RequestMethod.GET)
	public String viewUserCreate(@PathVariable int deptId, Model model) {
		//所有部门
		List<Dept> deptList = (List<Dept>) this.deptRepository.findAll();
		//所有分组
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		model.addAttribute(groupList);
		model.addAttribute(deptList);
		return "company/user_create";
	}
	
	/**
	 * 添加用户
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/user_create_{deptId:\\d+}", method = RequestMethod.POST)
	public String userCreate(User user, Integer groupId) throws Exception {
		
		this.userService.create(user);
//		this.userRepository.save(user);
		//若选了分组则用户分组下新增一条记录
		if(groupId != null && groupId != 0) {
			UserGroup ug = new UserGroup();
			ug.setUser(user);
			ug.setGroup(this.groupRepository.findOne(groupId));
			this.userGroupRepository.save(ug);
		}
		
		return "redirect:company_browse";
	}
	
	/**
	 * 弹出删除用户（验证密码）
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/user_delete_{userId}", method = RequestMethod.GET)
	public String viewUserdelete(@PathVariable int userId) {
		return "company/user_delete";
	}
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/user_delete_{userId}", method = RequestMethod.POST)
	public String userdelete(@PathVariable int userId) {
		this.userRepository.deletedUser(userId);
		return "redirect:/comapny_browse";
	}
	
	/**
	 * 显示编辑用户
	 * @param userId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user_edit_{userId}_company", method = RequestMethod.GET)
	public String viewUserEdit(@PathVariable int userId, Model model) {
		
		User user = this.userRepository.findOne(userId);
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		List<UserGroup> ugList = this.userGroupRepository.findByUserAccount(user.getAccount());
		model.addAttribute("ugList", ugList);
		model.addAttribute(groupList);
		model.addAttribute(user);
		return "company/user_edit";
	}
	
	/**
	 * 编辑用户
	 * @param userId （用户id）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user_edit_{userId}_company", method = RequestMethod.POST)
	public String userEdit(@PathVariable int userId, String group, User user, Model model) {
		
		User updateUser = this.userRepository.findOne(userId);
		//判断密码是否为空，不更改密码
		if(user.getPassword() == null || user.getPassword() == "") {
			user.setPassword(updateUser.getPassword());
		}
		//编辑用户
		MyUtil.copyProperties(user, updateUser);
		//必须选中权限才更新权限
		if(group != null && group.trim().length() != 0) {
			//此处权限即系分组，选择分组即获得该分组权限
			this.companyService.saveUserGroup(group, user.getAccount());
		}
		
		return "redirect:company_browse";
	}
	
	/**
	 * 显示用户档案
	 * @param account
	 * @return
	 */
	@RequestMapping("/user_profile_{account:[A-Za-z0-9]+}")
	public String viewUserTodo(@PathVariable String account, Model model) {

		User user = this.userRepository.findByAccount(account);
		if(user.getDept_id() != 0) {
			Dept dept = this.deptRepository.findOne(user.getDept_id());
			model.addAttribute(dept);
		}
		
		model.addAttribute(user);
		return "company/user_profile";
	}
	
	/**
	 * 显示批量编辑用户
	 * @param userIds
	 * @param companyId
	 * @param model
	 * @return
	 */
	@RequestMapping("/user_batchEdit_{companyId:\\d+}")
	public String viewUserBatchEditByCompany(Integer[] userIds, @PathVariable int companyId, Model model) {
		
		//根据选择的用户Id数组查找用户
		List<User> userList = this.userRepository.findByIdIn(userIds);
		model.addAttribute(userList);
		return "company/user_batchEdit";
	}
	
	/**
	 * 批量编辑用户
	 * @param users
	 * @return
	 */
	@RequestMapping(value = "/user_batchEdit_post", method = RequestMethod.POST)
	public String userBatchEdit(Users users) {
		
		User updateuser;
		for(User user : users.getUsers()) {
			//编辑前的用户
			updateuser = this.userRepository.findOne(user.getId());
			//编辑用户
			MyUtil.copyProperties(user, updateuser);
		}
		return "redirect:company_browse";
	}
	
	/**
	 * 显示批量添加用户
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user_batchCreate", method = RequestMethod.GET)
	public String viewUserBatchCreate(Model model) {
		
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		model.addAttribute(groupList);
		return "company/user_batchCreate";
	}
	
	/**
	 * 批量添加用户
	 * @param users
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/user_batchCreate", method = RequestMethod.POST)
	public String userBatchCreate(Users users, Integer[] groupId) {
		
		this.userService.batchCreateUser(users, groupId);
		return "redirect:company_browse";
	}
	
	/**
	 * 显示添加分组
	 * @return
	 */
	@RequestMapping(value = "/group_create", method = RequestMethod.GET)
	public String viewGroupCreate() {
		
		return "company/group_create";
	}
	
	/**
	 * 添加分组
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "/group_create", method = RequestMethod.POST)
	public String groupCreate(Group group) {
		this.groupRepository.save(group);
		return "redirect:group_browse";
	}
	
	/**
	 * 显示分组列表
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/group_browse", method = RequestMethod.GET)
	public String viewGroupBrowse(Model model) {
		
		Map<Group,List<User>> map = this.userService.getDeptAndUser();
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		model.addAttribute(groupList);
		model.addAttribute("map",map);
		return "company/group_browse";
	}
	
	/**
	 * 删除分组
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/delete_group_{groupId}")
	public String deleteGroup(@PathVariable int groupId) {
		
		this.groupRepository.delete(groupId);
		return "redirect:group_browse";
	}
	
	/**
	 * 显示编辑/新增/复制分组（弹出框）
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/group_{status:[a-zA-Z]+}_{groupId:\\d+}", method = RequestMethod.GET)
	public String viewEditGroup(@PathVariable int groupId, @PathVariable String status, Model model) {
		Group group;
		switch (status) {
		case "edit":
			group = this.groupRepository.findOne(groupId);
			model.addAttribute("group", group);
			break;

		case "create":
			break;
			
		case "copy":
			group = this.groupRepository.findOne(groupId);
			model.addAttribute("group", group);
			break;
		default:
			break;
		}
		return "company/group_edit";
	}
	
	/**
	 * 编辑/新增/复制分组
	 * @param groupId
	 * @return
	 */
	@RequestMapping(value = "/group_{status:[a-zA-Z]+}_{groupId:\\d+}", method = RequestMethod.POST)
	public String editGroup(@PathVariable int groupId, @PathVariable String status, Group group, String options) {
		switch (status) {
		case "edit":
			Group updategroup = this.groupRepository.findOne(groupId);
			MyUtil.copyProperties(group, updategroup);
			break;

		case "create":
			this.groupRepository.save(group);
			break;
			
		case "copy":
//			
			//复制权限/用户
			this.userService.copyGroup(group, options, groupId);
			break;
			
		default:
			break;
		}
		
		return "redirect:group_browse";
	}
	
	/**
	 * 显示维护成员
	 * @param groupId
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/group_managemember_{groupId}_{deptId}", method = RequestMethod.GET)
	public String viewGroupManagemember(@PathVariable int groupId, @PathVariable int deptId, Model model) {
		
		//获得组内用户
		List<User> userInList = this.userService.getUserForGroup(groupId);
		//组外用户
		List<User> userOutList = this.userService.getUserForGroupOut(userInList, deptId);
		Group group = this.groupRepository.findOne(groupId);
		model.addAttribute("group", group);
		model.addAttribute("userOutList", userOutList);
		model.addAttribute("userInList", userInList);
		return "company/group_manageUser";
	}
	
	/**
	 * 维护成员
	 * 修改该分组下的成员
	 * @param groupId （分组id）
	 * @param accountIns （组内用户）
	 * @param accountOuts （组外用户）
	 * @return
	 */
	@RequestMapping(value = "/group_managemember_{groupId}_{deptId:\\d+}", method = RequestMethod.POST)
	public String groupManagemember(@PathVariable int groupId, String accountIns, String accountOuts) {
		
		//移除组内成员或添加组外成员到此分组
		this.userService.updateUserGroup(groupId, accountIns, accountOuts);
		return "redirect:group_browse";
	}
	
	/**
	 * 显示维护权限 
	 * 返回该状态的权限（从该分组查询已有权限，在页面勾选已有权限）
	 * @param groupId （分组id）
	 * @param status （类型或状态：产品、项目之类）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/group_managepriv_byGroup_{groupId:\\d+}_{status:[a-zA-Z]+}", method = RequestMethod.GET)
	public String viewManagePriv(@PathVariable int groupId, @PathVariable String status, Model model) {
		
		Group group = this.groupRepository.findOne(groupId);
		
		//已有权限
		model.addAttribute("havaMap", this.companyService.getGroupPermission(groupId));
		//根据类型不同返回不同权限（例如返回产品权限等）
		model.addAttribute("map", this.companyService.getPermission(groupId, status));
		model.addAttribute(group);
		//product等的中文名
		model.addAttribute("fieldNameMap", this.companyService.getFieldNameMap());
		return "company/group_managepriv";
	}
	
	/**
	 * 权限维护
	 * @param groupId （分组id）
	 * @param status （状态：我的地盘、产品、项目等等）
	 * @return 
	 */
	@RequestMapping(value = "/group_managepriv_byGroup_{groupId:\\d+}_{status:[a-zA-Z]+}", method = RequestMethod.POST)
	public String managePriv(@PathVariable int groupId, @PathVariable String status, @RequestParam(required = false) String[] actions) {
		
		//删除已取消勾选权限，将勾选的权限都写入数据库
		this.groupPrivService.managePriv(groupId, status, actions);
		//刷新，留在原页面
		return "redirect:group_managepriv_byGroup_" + groupId + "_" + status;
	}
	/**
	 * 显示视图维护
	 * @param groupId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/group_manageView_{groupId}", method = RequestMethod.GET)
	public String viewGroupManageView(@PathVariable int groupId, Model model) {
		List<String> viewList = new ArrayList<String>();
		Group group = this.groupRepository.findOne(groupId);
		//判断视图权限是否默认为拥有全部权限
		if(group.getAcl() == null || group.getAcl() == "") {
			viewList = null;
		} else {
			for(String view : group.getAcl().split(",")) {
				viewList.add(view);
			}
		}
		model.addAttribute(group);
		model.addAttribute("viewList", viewList);
		return "company/group_manageView";
	}
	
	/**
	 * 视图维护
	 * @param groupId
	 * @param views
	 * @return
	 */
	@RequestMapping(value = "/group_manageView_{groupId}", method = RequestMethod.POST)
	public String groupManageView(@PathVariable int groupId, String views) {
		Group group = this.groupRepository.findOne(groupId);
		//如果为空则保存null （空意味着拥有全部视图权限）
		if(views == null || views == "") {
			group.setAcl(null);
		} else {
			//保存选择的视图权限
			group.setAcl(views);
		}
		this.groupRepository.save(group);
		return "redirect:group_browse";
	}
	/**
	 * 显示部门结构
	 * @param model
	 * @return
	 */
	@RequestMapping("/dept_browse")
	public String viewDeptBrowse(Model model) {
		
		//默认显示一级部门
		return "forward:dept_browse_0";
	}
	
	/**
	 * 显示部门结构
	 * 返回该部门的下级部门在页面上，
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dept_browse_{deptId:\\d+}", method = RequestMethod.GET)
	public String viewDeptBrowseId(@PathVariable int deptId, Model model) {
		//判断是否选中部门来维护
		if(deptId != 0) {
			//返回部门信息
			Dept dept = this.deptRepository.findOne(deptId);
			model.addAttribute(dept);
		}
		//查找该部门的下级部门list
		List<Dept> deptList = this.deptRepository.findByParent(deptId);
		if(deptList.size() > 0) {
			//返回下级部门list
			model.addAttribute(deptList);
		}
		//返回用户account对应的真实姓名
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "company/dept_browse";
	}
	
	/**
	 * 管理部门（编辑部门名，添加部门）
	 * @param deptId （部门id）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dept_browse_{deptId:\\d+}", method = RequestMethod.POST)
	public String manageDept(@PathVariable int deptId, Depts depts, Integer[] deptIds, String[] deptNames) {
		
		//创建部门
		for(Dept dept : depts.getDepts()) {
			//判断是否新增的部门（前台会传值为""的deptName过来）
			if(!dept.getName().equals("")) {
				dept.setParent(deptId);
				this.deptService.created(deptId, dept);
			}
		}
		//修改部门名
		for(int i = 0; i < deptIds.length; i++) {
			//编辑后的部门
			Dept newDept = this.deptRepository.findOne(deptIds[i]);
			//编辑前的部门
			Dept updateDept = this.deptRepository.findOne(deptIds[i]);
			//将前端的编辑的部门名赋给编辑后的部门
			newDept.setName(deptNames[i]);
			//编辑部门
			this.deptService.alter(newDept, updateDept, "", "edit");
		}
		return "redirect:dept_browse_" + deptId;
	}
	
	/**
	 * 显示编辑部门（弹出框）
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping("/dept_edit_{deptId}")
	public String viewDeptEdit(@PathVariable int deptId, Model model) {
		
		Dept dept = this.deptRepository.findOne(deptId);
		//返回dept
		model.addAttribute(dept);
		//返回未删除的用户
		model.addAttribute("userList", this.userRepository.findAllUser());
		return "company/dept_edit";
	}
	
	/**
	 * 编辑部门
	 * @param deptId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dept_edit_{deptId}", method = RequestMethod.POST)
	public String deptEdit(@PathVariable int deptId, Dept dept) {
		
		//编辑部门
		this.deptService.alter(dept, this.deptRepository.findOne(deptId), "", "edit");
		return "redirect:dept_browse_" + deptId;
	}
	
	/**
	 * 删除部门
	 * @param deptId
	 * @return
	 */
	@RequestMapping("/dept_delete_{deptId}")
	public String deleteDept(@PathVariable int deptId) {
		//删除部门
		this.deptRepository.delete(deptId);
		return "redirect:dept_browse";
	}

	/**
	 * 显示动态列表
	 * @return
	 */
	@RequestMapping("/company_dynamic")
	public String viewDefalutDynamic() {
		
		//默认显示今天的动态（每页10行记录）
		return "forward:dynamic_today_0_date_up_10_1";
	}

	/**
	 * 动态处菜单栏（根据时间查找动态）
	 * @param condition
	 * @return
	 */
	@RequestMapping("/company_dynamic_{condition:[a-zA-Z0-9]+}")
	public String viewDynamicByDate(@PathVariable String condition) {
		//根据时间来查询动态
		return "forward:dynamic_"+ condition + "_0_date_up_10_1";
	}
	
	/**
	 * 根据产品、项目和操作者查找动态
	 * @param condition (用来区分项目、产品、时间、用户)
	 * @param conditionId （若是项目和产品，则为相应id，若是用户则是account，其他默认是0，无作用）
	 * @return
	 */
	@RequestMapping("/company_dynamic_{condition}_{conditionId}")
	public String viewDynamic(@PathVariable String condition, @PathVariable String conditionId) {
		
		//按条件查询动态（每页10行记录）
		return "forward:dynamic_"+ condition + "_" + conditionId +"_date_up_10_1";
	}
	
	/**
	 * 显示（按日期等）动态列表
	 * @param condition （类型：今天、昨天、上周、本月、产品和项目等等，用来做条件查询动态）
	 * @param conditionId （若是项目和产品，则为相应id，若是用户则是account，其他默认是0，无作用）
	 * @param orderBy （按那字段排序）
	 * @param ascOrDesc （升序或者降序）
	 * @param recPerPage （每页记录数）
	 * @param page （页码）
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dynamic_{condition}_{conditionId}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}", method = RequestMethod.GET)
	public String viewDynamicType(@PathVariable String condition, @PathVariable String conditionId, @PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, @ModelAttribute("userAccount") String userAccount, Model model) {
		
		//根据哪个字段排序和设置是升序还是降序
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		//分页信息
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		//动态（分页后）
		Page<Action> actions = null;
		//时间段的开始和结束（用于根据时间段查询动态）
		Timestamp start = null, end = null;
		//日期
		Calendar calendar = Calendar.getInstance();
		calendar.setFirstDayOfWeek(Calendar.MONDAY);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		
		//判断条件，若是时间，则初始化相应的start时间
		switch (condition) {
		case "today":
			//获得今天的时间作为start
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "yesterday":
			//获得昨天的时间，就是当前时间减1
			calendar.add(Calendar.DAY_OF_MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "twodaysago":
			//获得前天的时间，就是当前时间减2
			calendar.add(Calendar.DAY_OF_MONTH, -2);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "thisweek":
			//利用DAY_OF_WEEK来获得这一周，并设置周一为一周开始时间
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "lastweek":
			//获得上一周的周一，将值赋给start
			calendar.add(Calendar.WEEK_OF_MONTH, -1);
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "thismonth":
			//本月
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			start = new Timestamp(calendar.getTimeInMillis());
			//月份增加1
			calendar.add(Calendar.MONTH , 1);
			//将下月的第一天时间赋给end，这样start到end的时间间隔就是一个月
			end = new Timestamp(calendar.getTimeInMillis());
			break;
		case "lastmonth":
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			//设上一个月时间
			calendar.add(Calendar.MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			//月份增加1
			calendar.add(Calendar.MONTH , 1);
			//将下月的第一天时间赋给end，这样start到end的时间间隔就是一个月
			end = new Timestamp(calendar.getTimeInMillis());
			break;
		//全部动态
		case "all":
			actions = this.actionRepository.findAll(pageRequest);
			break;
		//根据产品查找动态
		case "product":
			//conditionId = 0.则查询全部动态
			if(conditionId.equals("0")) {
				actions = this.actionRepository.findAll(pageRequest);
			} else { //根据产品查找动态
				actions = this.actionRepository.findByProductContaining("," + conditionId + ",", pageRequest);
			}
			break;
		//根据项目查找动态
		case "project":
			//conditionId = 0.则查询全部动态
			if(conditionId.equals("0")) {
				actions = this.actionRepository.findAll(pageRequest);
			} else { //根据项目查找动态
				actions = this.actionRepository.findByProject(Integer.valueOf(conditionId), pageRequest);
			}
			break;
		default:
			//按操作者查找
			actions = this.actionRepository.findByActor(conditionId, pageRequest);
			break;
		}
		//判断是根据时间查找动态的，则给end时间赋值
		if (actions == null) {
			//判断是否按月份来查找
			if(!condition.equals("lastmonth") && !condition.equals("thismonth")) {
				//不是按月来查找动态，所以此处用Calendar.DAY_OF_MONTH来实现
				calendar.add(Calendar.DAY_OF_MONTH , 1);
				end = new Timestamp(calendar.getTimeInMillis());
			}
			//根据时间查找动态
			actions = this.actionRepository.findByDateBetween(start, end, pageRequest);
		}
		
		//返回所有产品
		model.addAttribute("productList", this.productRepository.findByDeleted("0"));
		//返回有权限的项目
		model.addAttribute("projectList", this.projectRepository.findByPriv(userAccount));
		//获得对象名称的name或title
		actions.getContent().forEach(action->action.setObjectName(this.dynamicService.getObjectNameOrTitle(action.getObjectType(), action.getObjectId())));
		//返回分页后的动态
		model.addAttribute("actionPage", actions);
		//将操作动作转为中文
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		//将对象类型转为中文
		model.addAttribute("objectTypeMap", this.dynamicService.getObjectTypeMap());
		//将操作者转为中文
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "company/company_dynamic";
	}
	
	/**
	 * 显示公司信息
	 * @return
	 */
	@RequestMapping("/company_view")
	public String viewCompanyView() {
		
		//默认显示第一家公司
		return "forward:company_view_1";
	}
	
	/**
	 * 显示公司具体信息
	 * @param companyId （公司id）
	 * @param model
	 * @return
	 */
	@RequestMapping("/company_view_{companyId}")
	public String viewCompanyViewById(@PathVariable int companyId, Model model) {
		
		//默认力德科技有限公司
		model.addAttribute("company", this.companyRepository.findOne(companyId));
		return "company/company_view";
	}
	
	/**
	 * 显示编辑公司
	 * @param companyId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/company_edit_{companyId}", method = RequestMethod.GET)
	public String viewCompanyEdit(@PathVariable int companyId, Model model) {
		
		//根据id查找公司
		Company company = this.companyRepository.findOne(companyId);
		model.addAttribute(company);
		return "company/company_edit";
	}
	
	/**
	 * 编辑公司
	 * @param companyId
	 * @param company
	 * @return
	 */
	@RequestMapping(value = "/company_edit_{companyId}", method = RequestMethod.POST)
	public String companyEdit(@PathVariable int companyId, Company company) {
		
		//编辑前公司
		Company updateCompany = this.companyRepository.findOne(companyId);
		//编辑公司
		MyUtil.copyProperties(company, updateCompany);
		return "redirect:company_view_" + companyId;
	}
}
