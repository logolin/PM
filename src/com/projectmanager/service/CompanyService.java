package com.projectmanager.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.GroupPriv;
import com.projectmanager.entity.Permission;
import com.projectmanager.entity.UserGroup;
import com.projectmanager.repository.GroupPrivRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.PermissionRepository;
import com.projectmanager.repository.UserGroupRepository;
import com.projectmanager.repository.UserRepository;

@Service
public class CompanyService {

	@Autowired
	private UserGroupRepository userGroupRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private GroupRepository groupRepository;
	
	@Autowired
	private GroupPrivRepository groupPrivRepository;
	
	@Autowired
	private PermissionRepository permissionRepository;
	
	/**
	 * 保存userGroup（不重复添加记录）
	 * @param group （分组id，以","隔开）
	 * @param account
	 */
	public void saveUserGroup(String group, String account) {
		
		//分组id数组
		List<Integer> groupIdList = new ArrayList<Integer>();
		//删除用户原有分组
		this.userGroupRepository.deleteByUserAccount(account);
		//将字符串转成integer数组
		for (String groupid : group.split(",")) {
			groupIdList.add(Integer.valueOf(groupid));
		}
		//循环添加分组
		for(Integer i : groupIdList) {
			UserGroup ug = new UserGroup();
			//设置account
			ug.setUser(this.userRepository.findByAccount(account));
			ug.setGroup(this.groupRepository.findOne(i));
			this.userGroupRepository.save(ug);
		}
	}
	
	/**
	 * 返回所有权限，若分组已有权限则选中
	 * @param groupId （分组id）
	 * @param status （状态）
	 * @return
	 */
	public Map<String,List<Permission>> getPermission(int groupId, String status) {
		
		//第一层是module，然后是是否选中，最后是permission
		Map<String,List<Permission>> map = new HashMap<String,List<Permission>>();
		//根据状态添加对应的module，再根据module来查找权限
		List<String> moduleList = new ArrayList<String>();
		switch (status) {
		//"所有"权限（数据库有些暂时没用到，就不添加全部权限了）
		case "all":
			moduleList = this.permissionRepository.findAllModule();
			
			break;
		//我的地盘
		case "my":
			moduleList.add("my");	//我的地盘
			moduleList.add("todo");	//待办
			moduleList.add("effort");	//日志
			break;
		//产品权限
		case "product":
			moduleList.add("product");	//产品
			moduleList.add("story");	//需求
			moduleList.add("productplan");	//产品计划
			moduleList.add("release");	//发布
			moduleList.add("branch");	//分支
			break;
		//项目权限
		case "project":
			moduleList.add("build");	//版本
			moduleList.add("task");		//任务
			moduleList.add("project");	//项目视图
			break;
		//测试权限
		case "qa":
			moduleList.add("bug");	//Bug
			moduleList.add("testcase");	//用例
			moduleList.add("testtask");	//测试视图版本
			break;
		//组织权限
		case "company":
			moduleList.add("company");	//组织视图
			moduleList.add("dept");	//部门结构
			moduleList.add("group");	//权限分组
			moduleList.add("user");	//用户 
			break;
		//代码权限
		case "repo":
			moduleList.add("repo");	//代码
			break;
		//文档权限
		case "doc":
			moduleList.add("doc");	//文档
			break;
		//统计权限
		case "report":
			moduleList.add("report");	//统计视图
			break;
		//后台权限
		case "admin":
			moduleList.add("admin");	//后台管理
			moduleList.add("extension");	//插件管理
			moduleList.add("custom");	//自定义
			moduleList.add("editor");	//编辑器
			moduleList.add("convert");	//从其他系统导入
			moduleList.add("mail");		//发信配置
			moduleList.add("backup");	//备份
			moduleList.add("cron");		//计划任务
			moduleList.add("dev");		//二次开发
			moduleList.add("ldap");		//LDAP配置
			moduleList.add("sms");		//短信配置
			break;
		//反馈权限
		case "feedback":
			moduleList.add("feedback");	//反馈
			break;
		//其他权限
		case "other":
			moduleList.add("index");	//首页
			moduleList.add("svn");	//Subversion
			moduleList.add("git");	//Git
			moduleList.add("search");	//搜索
			moduleList.add("tree");	//模块维护
			moduleList.add("api");	//API接口
			moduleList.add("file");	//附件
			moduleList.add("misc");	//杂项
			break;
		default:
			break;
		}
		
		//判断是否有选中module
		if(moduleList.size() > 0) {
			for(String module : moduleList) {
				List<Permission> permissList = this.permissionRepository.findByModuleOrderById(module);
				map.put(module, permissList);
			}
		}
		return map;
	}
	
	/**
	 * 返回分组权限的map
	 * @param groupId
	 * @return
	 */
	public Map<String,List<GroupPriv>> getMapGroupPri(int groupId) {
		
		Map<String,List<GroupPriv>> map = new HashMap<String,List<GroupPriv>>();
		List<GroupPriv> gpriList = this.groupPrivRepository.findByGroupId(groupId);
		for(GroupPriv gpri : gpriList) {
			List<GroupPriv> groupPris = this.groupPrivRepository.findByModuleAndGroupId(gpri.getModule(), groupId);
			map.put(gpri.getModule(), groupPris);
		}
		return map;
	}

	/**
	 * 返回权限中文名
	 * @return
	 */
	public Map<String,String> getFieldNameMap() {
		
		Map<String,String> map = new HashMap<String,String>(){{
			put("product","产品视图");
			put("story","需求");
			put("productplan","产品计划");
			put("release","发布");
			put("branch","分支");
			put("project","项目视图");
			put("task","任务");
			put("build","版本");
			put("company","组织视图");
			put("dept","部门结构");
			put("group","权限分组");
			put("user","用户");
			put("testtask","测试视图版本");
			put("bug","Bug");
			put("my","我的地盘");
			put("todo","待办");
			put("effort","日志");
			put("repo","代码");
			put("doc","文档");
			put("report","统计视图");
			put("admin","后台管理");
			put("extension","插件管理");
			put("custom","自定义");
			put("editor","编辑器");
			put("convert","从其他系统导入");
			put("mail","发信配置");
			put("backup","备份");
			put("cron","计划任务");
			put("dev","二次开发");
			put("ldap","LDAP配置");
			put("sms","短信配置");
			put("feedback","反馈");
			put("index","首页");
			put("svn","Subversion");
			put("git","Git");
			put("search","搜索");
			put("tree","模块维护");
			put("api","API接口");
			put("file","附件");
			put("misc","杂项");
			put("testcase","用例");
			
			
		}};
		return map;
	}
	
	/**
	 * 返回已有权限map
	 * @return
	 */
	public Map<String,String> getGroupPermission(int groupId) {
		
		return this.mappingModuleAndMethod(this.groupPrivRepository.findAllModuleAndMethodBygroupId(groupId));
	}
	
	/**
	 * 返回该分组已有权限map
	 * @param permiss
	 * @return Map<String, String> key:权限的module+method；value:checked，这样前端就能快速判断是否已有权限从而来勾选复选框
	 */
	private Map<String, String> mappingModuleAndMethod(List<Object[]> permiss) {
		
		//已有权限map
		Map<String, String> map = new HashMap<String, String>();
		//已有权限数组
		Iterator<Object[]> it = permiss.iterator();
		
		Object[] perm;
		
		//循环添加数据进map
		while (it.hasNext()) {
			perm = it.next();
			map.put(perm[0].toString() + perm[1].toString(), "checked");
		}
		
		return map;
	}
	
}
