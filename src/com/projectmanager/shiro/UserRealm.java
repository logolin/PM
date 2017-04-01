package com.projectmanager.shiro;

import java.util.ArrayList;
import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationException;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.projectmanager.entity.Group;
import com.projectmanager.entity.GroupPriv;
import com.projectmanager.entity.User;
import com.projectmanager.entity.UserGroup;
import com.projectmanager.repository.GroupPrivRepository;
import com.projectmanager.repository.GroupRepository;
import com.projectmanager.repository.UserGroupRepository;
import com.projectmanager.repository.UserRepository;

public class UserRealm extends AuthorizingRealm {
	
	private static Logger logger = LoggerFactory.getLogger(UserRealm.class);
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private GroupRepository groupRepository;
	
	@Autowired
	private GroupPrivRepository groupPrivRepository;
	
	@Autowired
	private UserGroupRepository userGroupRepository;

	
	/**
	 * 授权操作
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		//获取当前登录的用户名,等价于(String)principals.fromRealm(this.getName()).iterator().next()  
        String username = (String)super.getAvailablePrincipal(principals);  
       //角色(用于视图权限)
        List<String> roleList = new ArrayList<String>();
        //权限
        List<String> permissionList = new ArrayList<String>();
        //从数据库中获取当前登录用户的详细信息  
        User user = this.userRepository.findByAccount(username);
        if(null != user) {
        	//用户分组
        	List<UserGroup> ugList = this.userGroupRepository.findByUserAccount(username);
        	//分组id数组
        	List<Integer> groupIds = new ArrayList<Integer>();
        	
        	for(UserGroup ug : ugList) {
//        		roleList.add(ug.getGroup().getRole());
        		groupIds.add(ug.getGroup().getId());
        	}
        	
    		List<Group> groupList = this.groupRepository.findByIdIn(groupIds);
    		for(Group group : groupList) {
    			if(group.getAcl() == null || group.getAcl() == "") {
    				roleList.add("allview");
    			} else {
    				for(String view : group.getAcl().split(",")) {

            			//获取角色
            			roleList.add(view);
            		}
    			}
    		}
    		
        	//分组权限
        	List<GroupPriv> gpriList = this.groupPrivRepository.findByGroupIdIn(groupIds);
        	if(null != gpriList && gpriList.size() > 0) {
        		//获取权限
        		for(GroupPriv gpri : gpriList) {
        			permissionList.add(gpri.getModule() + ":" + gpri.getMethod());
            	}
        	}
        	
        } else{  
          throw new AuthorizationException();
      }
      //为当前用户设置角色和权限  
      SimpleAuthorizationInfo simpleAuthorInfo = new SimpleAuthorizationInfo();  
      simpleAuthorInfo.addRoles(roleList);  
      simpleAuthorInfo.addStringPermissions(permissionList);  
      return simpleAuthorInfo;
  
	}

	/**
	 * 身份验证操作
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authcToken) throws AuthenticationException {

		//获取基于用户名和密码的令牌  
        //实际上这个authcToken是从LoginController里面currentUser.login(token)传过来的  
        //两个token的引用都是一样的,本例中是org.apache.shiro.authc.UsernamePasswordToken@...  
        UsernamePasswordToken token = (UsernamePasswordToken)authcToken;  
//        System.out.println("验证当前Subject时获取到token为" + ReflectionToStringBuilder.toString(token, ToStringStyle.MULTI_LINE_STYLE));  
        User user = this.userRepository.findByAccount(token.getUsername());
        if(null != user) {
        	AuthenticationInfo authcInfo = new SimpleAuthenticationInfo(user.getAccount(), user.getPassword(), user.getRealname());
        	//session
        	
        	this.setSession("userPassword", user.getPassword());
        	this.setSession("userAccount", user.getAccount());
        	this.setSession("userName", user.getRealname());
        	
        	return authcInfo;
        } else {
        	return null;
        }
		
	}

	/** 
     * 将一些数据放到ShiroSession中,以便于其它地方使用 
     * @see 比如Controller,使用时直接用HttpSession.getAttribute(key)就可以取到 
     */  
    private void setSession(Object key, Object value){  
        Subject currentUser = SecurityUtils.getSubject();  
        if(null != currentUser){  
            Session session = currentUser.getSession();
            if(null != session){  
                session.setAttribute(key, value);  
            }  
        }  
    }  
    
	@Override  
	public String getName() {  
		return getClass().getName();  
	}  
	
	//系统登出后 会自动清理授权和认证缓存
    @Override
    public void clearCachedAuthorizationInfo(PrincipalCollection principals) {
        super.clearCachedAuthorizationInfo(principals);
    }

    @Override
    public void clearCachedAuthenticationInfo(PrincipalCollection principals) {
        super.clearCachedAuthenticationInfo(principals);
    }

    @Override
    public void clearCache(PrincipalCollection principals) {
        super.clearCache(principals);
    }

    public void clearAllCachedAuthorizationInfo() {
        getAuthorizationCache().clear();
    }

    public void clearAllCachedAuthenticationInfo() {
        getAuthenticationCache().clear();
    }

    public void clearAllCache() {
        clearAllCachedAuthenticationInfo();
        clearAllCachedAuthorizationInfo();
    }
}
