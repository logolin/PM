package com.projectmanager.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Group;
import com.projectmanager.entity.GroupPriv;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.User;
import com.projectmanager.entity.UserGroup;
import com.projectmanager.entity.Users;
import com.projectmanager.repository.GroupPrivRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.UserGroupRepository;
import com.projectmanager.repository.UserRepository;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private GroupRepository groupRepository;
	
	@Autowired
	private UserGroupRepository userGroupRepository;
	
	@Autowired
	private GroupPrivRepository groupPrivRepository;
	
	
	/**
	 * 创建用户，并对密码进行md5加密（salt先默认为"java"）
	 * @param user
	 * @throws Exception 
	 */
	public void create(User user) throws Exception {
		 
//		user.setPassword(CryptographyUtil.encodeECB(user.getPassword()).toString());
		this.userRepository.save(user);
	}
	
	/**
	 * @Description: 获取真实姓名
	 * @param account 用户名
	 * @return 真实姓名
	 */
	public String getRealNameByAccount(final String account) {
		
		return this.userRepository.findRealnameByAccount(account);
	}
	
	/**
	 * @Description: 获取所有用户的用户名和真实姓名映射对集合
	 * @return
	 */
	public Map<String, String> getAllUsersMappingAccountAndRealname() {
		
		return mappingAccountAndRealname(this.userRepository.findAllAccountAndRealname());
	}
	
	/**
	 * @Description: 获取所有分组的ID和名称映射对集合
	 * @return
	 */
	public Map<Integer, String> getAllGroupMapIdAndName() {
		
		Map<Integer, String> map = new HashMap<Integer, String>();
		
		List<Group> groups = (List<Group>) this.groupRepository.findAll();
		
		Iterator<Group> iterator = groups.iterator();
		
		Group group;
		
		while (iterator.hasNext()) {
			group = iterator.next();
			map.put(group.getId(), group.getName());
		}
		return map;
	}
	
	/**
	 * @Description: 形成用户名和真实姓名的映射对
	 * @param users 多个用户
	 * @return
	 */
	private Map<String, String> mappingAccountAndRealname(List<Object[]> users) {
		
		Map<String, String> map = new HashMap<String, String>();
		//用户列表
		Iterator<Object[]> it = users.iterator();
		
		Object[] user;
		//循环给map赋值
		while (it.hasNext()) {
			user = it.next();
			map.put(user[0].toString(), user[1].toString());
		}
		
		return map;
	}
	
	public Map<String, String> findByAccountIn(Collection<String> accounts) {
		 
		return mappingAccountAndRealname(this.userRepository.findAcountAndRealnameByAccountIn(accounts));
	}
	
	/**
	 * 根据dept查找用户（分页）
	 * @param deptId
	 * @param type
	 * @param pageable
	 * @return
	 */
	public Page<User> getUserForDept(int deptId, Pageable pageable) {
		Page<User> users;
		if(deptId == 0) {
			users = this.userRepository.findAllUser(pageable);
			return users;
		} else {
			users = this.userRepository.findByDept(deptId, pageable);
			return users;
		}
	}
	
	/**
	 * 批量添加用户
	 * @param users
	 * @param group
	 */
	public void batchCreateUser(Users users, Integer[] group) {
		Integer dittoDept = null, dittoGroup = null;
		String dittoAccount = null, dittoRealname = null, dittoRole = null, dittoPassword = null;
		User user;
		List<User> userList = users.getUsers();
		
		for (int index = 0; index < userList.size(); index++) {
			user = userList.get(index);
			if (user.getDept_id() == -1) {
				user.setDept_id(dittoDept);
			} else {
				dittoDept = user.getDept_id();
			}
			if (user.getAccount() == "-1") {
				user.setAccount(dittoAccount);
			} else {
				dittoAccount = user.getAccount();
			}
			if(user.getRealname() == "-1") {
				user.setRealname(dittoRealname);
			} else {
				dittoRealname = user.getRealname();
			}
			if(user.getRole() == "-1") {
				user.setRole(dittoRole);
			} else {
				dittoRole = user.getRole();
			}
			if(user.getPassword().equals("")) {
				user.setRole(dittoPassword);
			} else {
				dittoPassword = user.getPassword();
			}
			//判断是否选中分组
			if(group[index] == -1) {
				group[index] = dittoGroup;
			} else {
				dittoGroup = group[index];
			}
			//用户名、真实姓名、职位和密码都不能为空
			if(user.getAccount() != null && !user.getAccount().equals("") && user.getRealname() != null && !user.getRealname().equals("") 
					&& user.getRole() != null && !user.getRole().equals("") && user.getPassword() != null && !user.getPassword().equals("")) {
				this.userRepository.save(user);
				if(group[index] != null && group[index] != 0) {
					UserGroup ug = new UserGroup();
					//设置account
//					ug.setAccount(user.getAccount());
					ug.setUser(user);
//					ug.setGroupId(group[index]);
					ug.setGroup(this.groupRepository.findOne(group[index]));
					this.userGroupRepository.save(ug);
				}
			}
		}
	}
	
	/**
	 * 返回部门列表和相应的用户列表
	 * @return
	 */
	public Map<Group,List<User>> getDeptAndUser() {
		Map<Group,List<User>> map = new LinkedHashMap<Group,List<User>>();
		List<Group> groupList = (List<Group>) this.groupRepository.findAll();
		for(Group group : groupList) {
			List<User> userList = getUserForGroup(group.getId());
			if(userList.size() > 0) {
				map.put(group, userList);
			} else {
				map.put(group, null);
			}
		}
		return map;
	}
	
	/**
	 * 根据groupId查找分组下用户list
	 * @param groupId
	 * @return userList
	 */
	public List<User> getUserForGroup(int groupId) {
		List<UserGroup> ugList = this.userGroupRepository.findByGroupId(groupId);
		List<User> userList = new ArrayList<User>();
		for(UserGroup ug : ugList) {
			//设置account
//			User user = this.userRepository.findByAccount(ug.getAccount());
			
			userList.add(ug.getUser());
		}
		
		return userList;
	}
	
	/**
	 * 根据部门查找组外用户
	 * @param groupId
	 * @param deptId
	 * @return
	 */
	public List<User> getUserForGroupOut(List<User> userInList, int deptId) {
		List<User> userOutList = new ArrayList<User>();
		List<User> userList;
		int out = 0;
		//判断是否还没选择部门
		if(deptId == 0) {
			userList = this.userRepository.findAllUser();
			for(User user : userList) {
				out = 0;
				for(User userin : userInList) {
					if(user.equals(userin)) {
						out = 1;
					}
				}
				if(out == 0) {
					userOutList.add(user);
				}
			}
		} else {
			userList = this.userRepository.findByDept(deptId);
			for(User user : userList) {
				for(User userin : userInList) {
					if(user.equals(userin)) {
						out = 1;
					}
				}
				if(out == 0) {
					userOutList.add(user);
				}
			}
		}
		return userOutList;
	}
	
	/**
	 * 维护成员，分组下添加新用户，删除已移除的用户
	 * @param groupId
	 * @param accountIns
	 * @param accountOuts
	 */
	public void updateUserGroup(int groupId, String accountIns, String accountOuts) {
		
		//原本组内成员
		List<UserGroup> ugList = this.userGroupRepository.findByGroupId(groupId);
		//组内用户
		List<String> ainlist = new ArrayList<String>();
		//组外用户
		List<String> aoutlist = new ArrayList<String>();
		//将“组内”字符串转成数组
		if(accountIns != null && !accountIns.equals("")) {
			for (String account : accountIns.split(",")) {
				ainlist.add(account);
			}
		}
		
		//标记用户是否已被移除出该分组，若mark=0，则已移除，将该成员从分组内移除
		int mark;
		for(UserGroup ug : ugList) {
			mark = 0;
			for(String account : ainlist) {
				//判断是否该分组的原有成员
				if(ug.getUser().getAccount().equals(account)) {
					mark = 1;
				}
			}
			//移除成员
			if(mark == 0) {
				this.userGroupRepository.delete(ug);
			}
		}
		
		//将“组外”字符串转成数组
		if(accountOuts != null && !accountOuts.equals("")) {
			for (String account : accountOuts.split(",")) {
				aoutlist.add(account);
			}
		}
		
		//添加新的用户
		for(String account : aoutlist) {
			UserGroup userGroup = new UserGroup();
			//设置account
			userGroup.setUser(this.userRepository.findByAccount(account));
			userGroup.setGroup(this.groupRepository.findOne(groupId));
			this.userGroupRepository.save(userGroup);
		}
	}
	
	/**
	 * 复制权限/用户
	 * @param group
	 * @param options
	 * @param groupId
	 */
	public void copyGroup(Group group, String options, int groupId) {
		
		List<String> copyList = new ArrayList<String>();
		if(options != null && !options.equals("")) {
			for(String copypri : options.split(",")) {
				copyList.add(copypri);
			}
		}
		this.groupRepository.save(group);
		for(String copypri : copyList) {
			//复制权限
			if(copypri.equals("copyPriv")) {
				List<GroupPriv> gprivList = this.groupPrivRepository.findByGroupId(groupId);
				for(GroupPriv gpriv : gprivList) {
					GroupPriv groupPriv = new GroupPriv();
					groupPriv.setGroup(group);
					groupPriv.setMethod(gpriv.getMethod());
					groupPriv.setModule(gpriv.getModule());
				}
				
			}
			//复制用户
			if(copypri.equals("copyUser")) {
				List<UserGroup> ugList = this.userGroupRepository.findByGroupId(groupId);
				
				for(UserGroup userGroup : ugList) {
					UserGroup ug = new UserGroup();
					//设置account
//					ug.setAccount(userGroup.getAccount());
					ug.setUser(userGroup.getUser());
//					ug.setGroupId(group.getId());
					ug.setGroup(group);
					this.userGroupRepository.save(ug);
				}
			}
		}
	}
	
	/**
	 * 根据用户名返回其分组列表
	 * @param account
	 * @return
	 */
	public List<Group> getGroupByaccount(String account) {
		
		List<Group> groupList = new ArrayList<Group>();
		List<UserGroup> ugList = this.userGroupRepository.findByUserAccount(account);
		for(UserGroup ug : ugList) {
			//设置account
//			groupList.add(this.groupRepository.findOne(ug.getGroupId()));
			groupList.add(ug.getGroup());
		}
		return groupList;
	}
	
	/**
	 * 返回尚未在团队中的user
	 * @param teamList
	 * @return
	 */
	public List<User> getUserNotTeam(List<Team> teamList) {
		
		List<User> users = new ArrayList<User>();
		//全部用户（未删除）
		List<User> userList = this.userRepository.findAllUser();
		//逐个判断用户是否已加入团队
		for(User user : userList) {
			//标记是否已加入团队，若是0，则尚未加入团队
			int mark = 0;
			for(Team team : teamList) {
				if(team.getId().getUser().getAccount().equals(user.getAccount())) {
					mark = 1;
				}
			}
			if(mark == 0) {
				users.add(user);
			}
		}
		return users;
	}
	
	/**
	 * 返回尚未加入部门用户
	 * @param teamList
	 * @param deptId
	 * @return
	 */
	public List<User> getDeptUser(List<Team> teamList, int deptId) {
		
		//尚未加入部门用户
		List<User> users = new ArrayList<User>();
		List<User> userList;
		//若部门id为0，则查找所有用户
		if(deptId == 0) {
			userList = this.userRepository.findAllUser();
		} else {
			//根据部门id查找用户
			userList = this.userRepository.findByDept(deptId);
		}
		
		for(User user : userList) {
			//标记，若为0则表示尚未在部门内
			int mark = 0;
			//循环判断部门用户是否已加入团队
			for(Team team : teamList) {
				//判断是否已在团队内
				if(team.getId().getUser().getAccount().equals(user.getAccount())) {
					mark = 1;
				}
			}
			if(mark == 0) {
				//判断出不在团队内，则加入users
				users.add(user);
			}
		}
		return users;
	}
}
