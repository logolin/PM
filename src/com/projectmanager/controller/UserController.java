package com.projectmanager.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.User;
import com.projectmanager.repository.PermissionRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.service.DynamicService;


@Controller
@RequestMapping("/")
@Transactional
public class UserController {
	
	@Autowired
	private DynamicService dynamicService;
	
	@Autowired
	private PermissionRepository permissionRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private ProductRepository productRepository;
	
	/**
	 * 显示登录页面
	 * @return
	 */
	@RequestMapping("/")
	public String index() {
		
		return "forward:user_login";
	}
	
	@RequestMapping(value = "/user_login", method = RequestMethod.GET)
	public String viewUserlogin(HttpSession session, HttpServletRequest request) {
		Object obj = session.getAttribute("userAccount");  
        if (obj !=null && !"".equals(obj.toString())) {
        	
        	if(session.getAttribute("sessionProductId") != null && session.getAttribute("sessionProductId") != "") {
        		
        		return "redirect:./product/story_browse_" + session.getAttribute("sessionProductId");
        	}
        	//获得所有项目
        	List<Project> projects = this.projectRepository.findByDeleted("0");
        	//判断是否有项目
        	if(projects.size() > 0) {
        		//设置默认的项目id到session
        		session.setAttribute("sessionProjectId", projects.get(0).getId());
        	} else {
        		//设置项目id的session为0
        		session.setAttribute("sessionProjectId", 0);
        	}
        	//查找所有产品
            List<Product> products = this.productRepository.findByDeleted("0");
            
            //判断是否有产品
        	if(products.size() > 0) {
        		//设置产品id的session
            	session.setAttribute("sessionProductId", products.get(0).getId());
            	//获得登陆前的url
            	SavedRequest req = WebUtils.getSavedRequest(request);
            	//判断登录前的是否有访问某个页面
            	if(req != null) {
            		//返回之前的页面
            		return "redirect:.." + req.getRequestUrl();
            	} else {
            		return "redirect:/product/story_browse_" + products.get(0).getId();
            	}
        		
        	} else {
        		//设置产品id的session为0,
            	session.setAttribute("sessionProductId", 0);
        		return "redirect:/product/story_browse_0";
        	}
        }
		return "login";
	}
	
	/**
	 * 用户登录
	 */
	@RequestMapping(value = "/user_login", method = RequestMethod.POST)
	public String userLogin(User curruser, String rememberMe, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		//获取当前的Subject
        Subject currentUser = SecurityUtils.getSubject();
		UsernamePasswordToken token = new UsernamePasswordToken(curruser.getAccount(), curruser.getPassword());  
		if(rememberMe != null && rememberMe.equals("on")) {
			token.setRememberMe(true);
		} else {
			token.setRememberMe(false);
		}
		
        try {
            //在调用了login方法后,SecurityManager会收到AuthenticationToken,并将其发送给已配置的Realm执行必须的认证检查  
            //每个Realm都能在必要时对提交的AuthenticationTokens作出反应  
            //所以这一步在调用login(token)方法时,它会走到MyRealm.doGetAuthenticationInfo()方法中,具体验证方式详见此方法  
            currentUser.login(token);
         	//获得所有项目s
        	List<Project> projects = this.projectRepository.findByDeleted("0");
        	//判断是否有项目
        	if(projects.size() > 0) {
        		//设置默认的项目id到session
        		session.setAttribute("sessionProjectId", projects.get(0).getId());
        	} else {
        		//设置项目id的session为0
        		session.setAttribute("sessionProjectId", 0);
        	}
        	//查找所有产品
            List<Product> products = this.productRepository.findByDeleted("0");
            
            //判断是否有产品
        	if(products.size() > 0) {
        		//设置产品id的session
            	session.setAttribute("sessionProductId", products.get(0).getId());
            	//获得登陆前的url
            	SavedRequest req = WebUtils.getSavedRequest(request);
            	//判断登录前的是否有访问某个页面
            	if(req != null) {
            		//返回之前的页面
            		return "redirect:.." + req.getRequestUrl();
            	} else {
            		return "redirect:/product/story_browse_" + products.get(0).getId();
            	}
        		
        	} else {
        		//设置产品id的session为0,
            	session.setAttribute("sessionProductId", 0);
        		return "redirect:/product/story_browse_0";
        	}
    		
        }catch(UnknownAccountException uae){  
//	            System.out.println("对用户[" + curruser.getAccount() + "]进行登录验证..验证未通过,未知账户");
        	model.addAttribute("err", "账户或密码错误，请重新输入！");
        }catch(IncorrectCredentialsException ice){  
//	            System.out.println("对用户[" + curruser.getAccount() + "]进行登录验证..验证未通过,错误的凭证");
        	model.addAttribute("err", "账户或密码错误，请重新输入！");
        }catch(LockedAccountException lae){  
//	            System.out.println("对用户[" + curruser.getAccount() + "]进行登录验证..验证未通过,账户已锁定");
        }catch(ExcessiveAttemptsException eae){  
//	            System.out.println("对用户[" + curruser.getAccount() + "]进行登录验证..验证未通过,错误次数过多"); 
        }catch(AuthenticationException ae){
            //通过处理Shiro的运行时AuthenticationException就可以控制用户登录失败或密码错误时的情景  
//	            System.out.println("对用户[" + curruser.getAccount() + "]进行登录验证..验证未通过,堆栈轨迹如下");  
            ae.printStackTrace();  
        }  
        //验证是否登录成功  
        if(currentUser.isAuthenticated()){
//	            System.out.println("登录认证通过(这里可以进行一些认证通过后的一些系统参数初始化操作)");
        }else{  
            token.clear();
        }
		return "redirect:user_login"; 
		
	}
	
	/**
	 * 跳到错误提示页面
	 * @return
	 */
	@RequestMapping("/error")
	public String viewError(HttpServletRequest request, Model model) {
		
		String retUrl = request.getHeader("Referer");
		List<String> urlList = new ArrayList<String>();
		List<String> actionList = new ArrayList<String>();
		//将url切分
		for(String url : retUrl.split("/")) {
			urlList.add(url);
		}
		//第二层url拆分
		if(urlList.size() > 5) {
			if(urlList.get(5).indexOf("_") != -1) {
				for(String action : urlList.get(5).split("_")) {
					actionList.add(action);
				}
				String subUrl;
				if(this.permissionRepository.findByModuleAndMethod(actionList.get(0), actionList.get(1)) != null) {
					subUrl = this.permissionRepository.findByModuleAndMethod(actionList.get(0), actionList.get(1));
				} else {
					subUrl = "该";
				}
				//第一层url（product、projct等）
				model.addAttribute("mainUrl", urlList.get(4));
				//第二层
				model.addAttribute("subUrl", subUrl);
			}
		} else {
			//第一层url（product、projct等）
			model.addAttribute("mainUrl", "product");
			//第二层
			model.addAttribute("subUrl", "首页");
		}
		//视图的名称
		model.addAttribute("objectTypeMap", this.dynamicService.getObjectTypeMap());
		return "error";
	}
	
	/**
	 * 退出登录
	 * @return
	 */
	@RequestMapping("/logout")
	public String logout() {
		SecurityUtils.getSubject().logout();
		return "redirect:user_login";
	}
	
}
