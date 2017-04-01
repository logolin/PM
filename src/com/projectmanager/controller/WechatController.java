package com.projectmanager.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.catalina.connector.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.projectmanager.entity.Action;
import com.projectmanager.entity.Branch;
import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Module;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.TaskEstimate;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.BugRepository;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.TaskEstimateRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.TeamRepository;
import com.projectmanager.repository.UserRepository;
import com.projectmanager.service.ActionService;
import com.projectmanager.service.BugService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.MyUtil;
import com.projectmanager.service.StoryService;
import com.projectmanager.service.TaskService;
import com.projectmanager.service.TokenService;
import com.projectmanager.service.UserService;
import com.projectmanager.service.WechatService;

@Controller
@Transactional
@RequestMapping("/wechat")
@SessionAttributes("userAccount")
public class WechatController {
	
	@Autowired
	private TokenService tokenService;
	
	@Autowired
	private WechatService wechatService;
	
	@Autowired
	private UserRepository userRepository;
	     
	@Autowired
	private TaskRepository taskRepository;

	@Autowired
	private TaskService  taskService;
	
	@Autowired
	private TeamRepository  teamRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	 
	@Autowired
	private BugRepository bugRepository;
	
	@Autowired
	private BugService bugService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private StoryRepository storyRepository;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private StoryService storyService;
	
	@Autowired
	private TaskEstimateRepository taskEstimateRepository;
	
	@Autowired
	private ModuleRepository moduleRepository;
	;
    /**
     * 开发者模式token校验
     *
     * @param wxAccount 开发者url后缀
     * @param response
     * @param tokenModel
     * @throws ParseException
     * @throws IOException
     */
	@RequestMapping(method = RequestMethod.GET)/*, produces = "text/plain"*/
	@ResponseBody
	public String validate(HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {
		  
		return this.tokenService.validate(request);
    }
	   
   /**
    * 接收微信消息
    * @param request
    * @param response
    * @throws ParseException
    * @throws IOException
    */
   @RequestMapping(method = RequestMethod.POST)/*, produces = "text/plain"*/
   @ResponseBody
   public void getMessage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	   
	   request.setCharacterEncoding("UTF-8"); 
	   response.setCharacterEncoding("UTF-8");
	   // 处理接收消息 
//		   return respMessage;
	   this.wechatService.processRequest(request, response);
    }
   
   /**
    * 创建二维码
    */
   @RequestMapping(value = "/create_ticket", method = RequestMethod.GET)
   public String viewCreateTicket(Model model) {
	   
	   //返回二维码图片
	   model.addAttribute("ticketimg", "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + this.wechatService.createTicket());
	   return "wechat/create_ticket";
   }
   
   /**
    * 显示微信绑定账号
    * @return
    */
   @RequestMapping(value = "/wechat_login/{openId}", method = RequestMethod.GET)
   public String getWechatBind() {
	   
	   return "login";
   }
   
   /**
    * 登录成功后绑定openid，跳转到相应页面
    * @return
    */
   @RequestMapping(value = "/wechat_login/{openId}", method = RequestMethod.POST)
   public String wechatBind(@PathVariable String openId, User currUser, HttpSession session) {
	   try {
		   User user = this.userRepository.findByAccount(currUser.getAccount());
		   if(user != null && user.getPassword().equals(currUser.getPassword())) {
			   user.setOpenId(openId);
			   this.userRepository.save(user);
			   session.setAttribute("testsession", user.getRealname());
			   return "redirect:wechat/index";
		   }
		   System.out.println("密码错误！");
	   } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	   
	   return "err";
   }
   
   /**
    * 微信首页
    * @return
    */
   @RequestMapping(value = "index", method = RequestMethod.GET)
   public String viewIndex() {
	   
	   return "wechat/wxindex";
   }
   
   /**
    * 显示解绑页面
    * @return
    */
   @RequestMapping(value = "unbundling/{openId}", method = RequestMethod.GET)
   public String viewUnbundling() {
	   
	   return "login";
   }
   
   /**
    * 解绑账号
    * @param openId 
    * @param currUser (用户)
    * @return
    */
   @RequestMapping(value = "unbundling/{openId}", method = RequestMethod.POST)
   public String unbundling(@PathVariable String openId, User currUser) {
	   
	   //取得openid
	   User user = this.userRepository.findByOpenId(openId);
	   //验证账户、密码
	   if(user.getAccount().equals(currUser.getAccount()) && user.getPassword().equals(currUser.getPassword())) {
		   //解绑账号
		   user.setOpenId("");
		   this.userRepository.save(user);
	   }else {
		   return "error";
	   }
	   //跳转到绑定账号页面
	   return "wechat/wechat_login/" + openId;
   }
   
   /**
    * 获取Accesstoken
    */
   @RequestMapping("getAccesstoken")
   public void getAccesstoken() {
	   //获取Accesstoken
	   this.tokenService.getAccessToken();
   }
   
   /**
    * 显示任务列表
    * 已完成任务列表界面-查到数据（根据指派给、状态查询）
    */
   @RequestMapping(value = "task-list-{type}", method = RequestMethod.GET)
   public String getTask_finish(@PathVariable String type, @ModelAttribute("userAccount") String account, Model model) {
	   //type=finish
	   if(type.equals("finish")) {
		   String[] statusArr = {"done"};
		   List<Task> taskList = this.taskRepository.findByAssignedToAndStatusInAndDeleted(account,statusArr, "0");
		   //将状态转成中文输出
		   this.taskService.alterCh(taskList);
		   model.addAttribute("taskList", taskList);
	   } else  {//type=finish
		   String[] statusArr = {"doing","pause","wait"};
		   List<Task> taskList = this.taskRepository.findByAssignedToAndStatusInAndDeleted(account,statusArr, "0");
		   //将状态转成中文输出
		   this.taskService.alterCh(taskList);
		   model.addAttribute("taskList", taskList);
	   }
	   //查找所有用户
	   model.addAttribute("userList", this.userRepository.findAllUser());
	   return "wechat/task-list";
	  
   }
   
   /**
    * 批量关闭、删除、指派任务
    * @param taskIds
    * @param fieldName
    * @param fieldVal
    */
   @ResponseBody
   @RequestMapping(value="task-massHandle", method = RequestMethod.POST)
   public void gTaskMassHandle(@RequestParam Integer[] taskIds, @RequestParam String fieldName, @RequestParam String fieldVal,  @ModelAttribute("userAccount") String account) {
	   this.taskService.massHandle(fieldName, fieldVal, taskIds, account);
   }
   
   /**
    * 显示任务的的详细信息
    * 获取任务列表的任务id
    */
   @RequestMapping(value = "task-detail-{taskId}", method = RequestMethod.GET)
   public String getTaskid (@PathVariable Integer taskId, Model model) {
	   //根据taskId查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回task
	   model.addAttribute("task",task);
	   //将操作者转为中文
	   model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
	   //将类型转成中文输出
	   model.addAttribute("typeMap", this.taskService.getTypeNameMap());
	   //将状态转成中文输出
	   this.taskService.alterCh(task);
	   //返回模块、需求、需求描述
	   this.taskService.getModuleAndStoryAndStorySpec(task, model);
	   //返回task的字段的中文名称
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-detail";
   }	   
   
   /**
    * 显示指派任务 
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-assign-{taskId}", method =  RequestMethod.GET)
   public String getTaskassgin(@PathVariable Integer taskId, Model model) {
	   //根据taskId查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task",task);
	   //查找项目团队表
	   List <Team> teamList = this.teamRepository.findByProject(task.getProject().getId());
	   //返回团队列表
	   model.addAttribute("teamList",teamList);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-assign";
   }
   
   /**
    * 指派任务
    * @param taskId
    * @param assignedTo
    * @param remain
    * @return
    */
   @RequestMapping(value = "task-assign-{taskId}", method =  RequestMethod.POST)
   public String postTaskassgin(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据taskId查找任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //根据前台的数据来设置后台数据库
	   this.taskService.alter(task, oTask, comment, "assign");
	   return "redirect:task-detail-{taskId}";   
   }
   
   
   /**
    * 显示开始任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-begin-{taskId}" , method = RequestMethod.GET)
   public String getTaskbegin(@PathVariable Integer taskId,Model model) {
	   //根据taskId获取任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task",task);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-begin";
   }
    
   /**
    * 开始任务
    * @param taskId
    * @param realStarted
    * @param consumed
    * @param remain
    * @return
    */
   @RequestMapping(value = "task-begin-{taskId}", method = RequestMethod.POST)
   public String pTaskbegin(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据taskId获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //设置task状态为doing
	   task.setStatus("doing");
	   //根据前台的数据来设置后台数据库
	   this.taskService.alter(task, oTask, comment, "start");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示继续任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-continue-{taskId}" , method = RequestMethod.GET)
   public String getTaskcontinue(@PathVariable Integer taskId,Model model) {
	   //根据taskId获取任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task",task);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-continue";
   }
    
  /**
   * 继续任务
   * @param taskId
   * @param realStarted
   * @param consumed
   * @param remain
   * @return
   */
   @RequestMapping(value = "task-continue-{taskId}",method = RequestMethod.POST)
   public String postTaskcontinue(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据taskId获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //设置task的状态是"doing"
	   task.setStatus("doing");
	   //根据前台的数据来设置后台数据库
	   this.taskService.alter(task, oTask, comment, "restart");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示完成任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-finish-{taskId}" , method =  RequestMethod.GET)
   public String getTaskfinish(@PathVariable Integer taskId,Model model) {
	   //根据taskId获取任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task",task);
	   //查找项目团队
	   List<Team> teamList = this.teamRepository.findByProject(task.getProject().getId());
	   //返回团队列表
	   model.addAttribute("teamList",teamList);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-finish";
   }
   
   /**
    * 完成任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-finish-{taskId}", method = RequestMethod.POST)
   public String pTaskFinish(@PathVariable Integer taskId, Task task, String comment) {
	   System.out.println("任务"+taskId);
	   //根据taskId获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //把任务状态设为“已完成”
	   task.setStatus("done");
	   //根据前台数据编辑后台数据
	   this.taskService.alter(task, oTask, comment, "finish");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示取消任务
    * @return
    */
   @RequestMapping(value = "task-cancel-{taskId}", method =  RequestMethod.GET)
   public String getTaskcancel(@PathVariable Integer taskId, Model model) {  
	   //根据任务id查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回task
	   model.addAttribute("task", task);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-cancel";
   }
   
   /**
    * 取消任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-cancel-{taskId}", method = RequestMethod.POST)
   public String pTaskcancel(@PathVariable Integer taskId, Task task, Model model, String comment) {  
	   //根据id获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //将task的状态设为"cancel"
	   task.setStatus("cancel");
	   //根据前台的数据编辑任务，完成操作
	   this.taskService.alter(task, oTask, comment, "cancel");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示暂停任务
    * @return
    */
   @RequestMapping(value = "task-pause-{taskId}",method=RequestMethod.GET)
   public String getTaskpause(@PathVariable Integer taskId, Model model) {
	   //根据任务id查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回task
	   model.addAttribute("task", task);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-pause";
   }
   
  /**
   * 暂停任务
   * @param taskId
   * @return
   */
   @RequestMapping(value = "task-pause-{taskId}",method=RequestMethod.POST)
   public String pTaskpause(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据id获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //将task的状态设为"cancel"
	   task.setStatus("pause");
	   //预计剩余值不改变
	   this.taskService.copyRemain(task, oTask);
	   //根据前台的数据编辑任务，完成操作
	   this.taskService.alter(task, oTask, comment, "pause");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示关闭任务
    * @return
    */
   @RequestMapping(value = "task-close-{taskId}",method=RequestMethod.GET)
   public String getTaskclose(@PathVariable Integer taskId, Model model) {
	   //根据任务id查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回task
	   model.addAttribute("task", task);
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-close";
   }
   
   /**
    * 关闭任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-close-{taskId}",method=RequestMethod.POST)
   public String pTaskclose(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据id获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //将task的状态设为"cancel"
	   task.setStatus("closed");
	   //预计剩余值不改变
	   this.taskService.copyRemain(task, oTask);
	   //根据前台的数据编辑任务，完成操作
	   this.taskService.alter(task, oTask, comment,  "close");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示激活任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-actived-{taskId}",method=RequestMethod.GET)
   public String getTaskactived(@PathVariable Integer taskId,Model model) {
	   //根据taskId获取任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task",task);
	   //根据项目id查找项目团队，返回团队列表
	   model.addAttribute("teamList",this.teamRepository.findByProject(task.getProject().getId()));
	   //返回task中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-actived";
   }
   
   /**
    * 激活任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-actived-{taskId}",method=RequestMethod.POST)
   public String pTaskactived(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据id获取任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //把task的状态设为“进行中”
	   task.setStatus("doing");
	   //激活任务，完成者、完成时间、取消者、取消时间、关闭者、关闭时间、关闭原因都应设为空
	   oTask.setFinishedBy(null);
	   oTask.setFinishedDate(null);
	   oTask.setCanceledBy(null);
	   oTask.setCanceledDate(null);
	   oTask.setClosedBy(null);
	   oTask.setClosedDate(null);
	   oTask.setClosedReason(null);
	   //根据前台的数据编辑后台数据库
	   this.taskService.alter(task, oTask, comment, "activate");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示编辑任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-edit-{taskId}", method = RequestMethod.GET)
   public String getTaskedit(@PathVariable Integer taskId, @ModelAttribute("userAccount") String account, Model model) {
	   //根据id查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回任务
	   model.addAttribute("task", task);
	   //根据项目id查找团队,返回团队
	   model.addAttribute("teamList", this.teamRepository.findByProject(task.getProject().getId()));
	   //查找所有未删除（delete为“0”代表未删除，“1”代表删除）的project
//	   List <Project> proList = this.projectRepository.findByDeleted("0");
	   //查看有权限的project
	   model.addAttribute("proList", this.projectRepository.findByPriv(account));
	   //将操作者转为中文
	   model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
	   //返回task的中文字段
	   this.actionService.renderHistory("task", taskId, model);
	   return "wechat/task-edit";
   }
   
   /**
    * 编辑任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-edit-{taskId}", method = RequestMethod.POST)
   public String pTaskedit(@PathVariable Integer taskId, Task task, Model model, String comment) {
	   //根据taskId查找编辑前任务
	   Task oTask = this.taskRepository.findOne(taskId);
	   //编辑任务
	   this.taskService.alter(task, oTask, comment, "edit");
	   return "redirect:task-detail-{taskId}";
   }
   
   /**
    * 显示创建任务
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value = "task-create-{projectId}-{taskId}",method = RequestMethod.GET)
   public String getTaskcreate(@PathVariable Integer projectId, @PathVariable Integer taskId, Model model) {
	   	//根据id查找项目
	   	Project project = this.projectRepository.findOne(projectId);
	   	//根据id查找任务
	   	Task task = this.taskRepository.findOne(taskId);
		//团队成员
		List<User> teamList = this.taskService.getUserForProject(projectId);
		model.addAttribute("task",task);
		model.addAttribute("teamList", teamList);
		model.addAttribute(project);
		return "wechat/task-create";
   }
   
   /**
    * 创建任务
    * @param projectId
    * @param task
    * @param model
    * @return
    */
   @RequestMapping(value = "task-create-{projectId}-{taskId}", method = RequestMethod.POST)
   public String pTaskcreate(@PathVariable Integer projectId, Task task, Model model) {
	   //创建任务
	   this.taskService.created(projectId, task);
	   return "redirect:task-list-unfinish";
   }
   
   /**
    * 删除任务
    * @param taskId
    * @return
    */
   @RequestMapping(value = "task-delete-{taskId}")
   public String gTaskdelect(@PathVariable Integer taskId, @ModelAttribute("userAccount") String account){
	   //根据taskId查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //设置delete字段为 "1"
	   task.setDeleted("1");
	   task.setLastEditedBy(account);
	   task.setLastEditedDate(new Timestamp(System.currentTimeMillis()));
	   this.taskService.alter(task, this.taskRepository.findOne(taskId), "", "delete");
	   String type = null;
	   //获取当前任务的状态
	   String status = task.getStatus();
	   //返回原来的任务列表
	   if(status.equals("doing") || status.equals("pause") || status.equals("wait")){
		   type ="unfinish";
	   }else if(status.equals("done")) {
		   type = "finish";
	   }
	   return "redirect:task-list-" + type;
   }
   
   /**
    * 显示记录任务工时
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value="task-record-{taskId}", method = RequestMethod.GET)
   public String gTaskRecord(@PathVariable Integer taskId, Model model) {
	   //根据taskId查找任务
	   Task task = this.taskRepository.findOne(taskId);
	   //返回task
	   model.addAttribute("task", task);
	   //根据任务查找已经录的工时信息
	   List<TaskEstimate> taskEstimateList = this.taskEstimateRepository.findByTaskId(taskId);
	   //返回工时信息
	   model.addAttribute("taskEstimateList", taskEstimateList);
	   return "wechat/task-record";
   }
   
   /**
    * 记录任务工时
    * @param taskId
    * @return
    */
   @RequestMapping(value="task-record-{taskId}", method = RequestMethod.POST)
   public String pTaskRecord(@PathVariable Integer taskId, String[] dates, String[] consumed, String[] remain, String[] work, @ModelAttribute("userAccount") String account, Model model) throws ParseException{
//	   float nconsumed = Float.parseFloat(consumed);
//	   float nremain = new Float(remain);
	   //批量记录工时
//	   this.taskService.batchCreateEstimateTask(dates, nconsumed, nremain, work, taskId, account);
	   return "redirect:task-detail-"+taskId;
   }
   
   /**
    * 删除工时
    * @return
    */
   @RequestMapping(value="deleteRecord-{taskId}-{recordId}", method = RequestMethod.GET)
   public String deleteRecord(@PathVariable Integer recordId, Model model) {
	   
	   return "wechat/task-record";
   }
   
   /**
    * 显示bug列表
    * @param type
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-list-{type}", method =  RequestMethod.GET)
   public String getBuglist(@PathVariable String type, @ModelAttribute("userAccount") String userAccount, Model model) {
	   //type=finish
	   if (type.equals("finish")) {
		   String[] statusArr = {"resolved"};
		   //根据用户名、已解决bug、是否删除查找bug
		   List<Bug> bugList = this.bugRepository.findByAssignedToAndStatusInAndDeleted(userAccount, statusArr,  "0");
		   //返回bugList
		   model.addAttribute("bugList",bugList);
	   }else {
		   //type=unfinish
		   String[] statusArr = {"active","closed"};
		   //根据用户名、未解决bug（active 、closed）、是否删除查找bug
		   List<Bug> bugList = this.bugRepository.findByAssignedToAndStatusInAndDeleted(userAccount, statusArr,  "0");
		   //返回bugList
		   model.addAttribute("bugList",bugList);
	   }
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   //查找同一团队下的用户
	   //model.addAttribute("teamList", this.teamRepository.findByProject(projectId)));
	   //将状态转成中文输出
	   model.addAttribute("statusMap",this.bugService.getMStatusName());
	   return "wechat/bug-list";
   }
   
   /**
    * 批量指派bug
    * @param bugIds
    * @param fieldVal
    */
   @ResponseBody
   @RequestMapping(value = "bug-massAssign", method = RequestMethod.POST)
   public void gBugMassAssign(@RequestParam Integer[] bugIds, @RequestParam String fieldName, @RequestParam String fieldVal,  @ModelAttribute("userAccount") String account) {  
	   //bug批量指派
	   this.bugService.massAssignBug(fieldName, fieldVal, bugIds, account);
   }
   
   /**
    * 显示删除bug
    * @param bugId
    * @return
    */
   @RequestMapping(value = "bug-delete-{bugId}", method = RequestMethod.GET)
   public String gBugdelect(@PathVariable Integer bugId, @ModelAttribute("userAccount") String account){
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //设置delete字段为 "1"
	   bug.setDeleted("1");	
	   bug.setLastEditedBy(account);
	   bug.setLastEditedDate(new Timestamp(System.currentTimeMillis()));
	   this.bugService.alter(bug, this.bugRepository.findOne(bugId), "", "delete");
	   String type = null;
	   //获取当前bug的状态
	   String status=bug.getStatus();
	   //返回原来的bug列表
	   if(status.equals("closed") || status.equals("active")){
		   type ="unfinish";
	   }else if(status.equals("resolved")) {   
		   type = "finish";
	   }
	   return "redirect:bug-list-" + type;
   }
   
   /**
	*显示bug的详细信息
	*/
	@RequestMapping(value = "bug-detail-{bugId}", method =  RequestMethod.GET)
	public String getBugdetail(@PathVariable Integer bugId,Model model) {
		  //根据bugId查找Bug
		  Bug bug = this.bugRepository.findOne(bugId);
		  //返回bug
		  model.addAttribute("bug",bug);
		  //调用方法getBMPTS(bug, model),返回Branch、Module、Plan、Task、Story
		  this.bugService.getBMPTS(bug, model);
		  //将bug类型转成中文
		  model.addAttribute("typeMap", this.bugService.getBugTypeName());
		  //将操作者转为中文
		  model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		  //将状态转成中文输出
		  model.addAttribute("statusMap",this.bugService.getMStatusName());
		  //将解决方案转换成中文输出
		  model.addAttribute("resolutionMap",this.bugService.getResolutionName());
		  //将操作系统转换成完整输出
		  model.addAttribute("osMap", this.bugService.getOSName());
		  //将浏览器类型转换为完整输出
		  model.addAttribute("browserMap", this.bugService.getBrowserName());
		  this.actionService.renderHistory("bug", bugId, model);
		  return "wechat/bug-detail";
	}   
   
   /**
    * 显示指派bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-assign-{bugId}", method = RequestMethod.GET)
   public String getBugassign(@PathVariable Integer bugId, Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug",bug);
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   //返回bug的字段的中文名称
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-assign";
   }
   
   /**
    * 指派bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-assign-{bugId}", method = RequestMethod.POST)
   public String pBugassign(@PathVariable Integer bugId,Bug bug,Model model, String comment) {
	   //根据bugId查找bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //编辑bug，根据前台传来的数据编辑后台数据
	   this.bugService.alter(bug, oBug, comment, "assign");
	   return "redirect:bug-detail-" + bugId;
   }
   
   /**
    * 显示关闭bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-close-{bugId}", method = RequestMethod.GET)
   public String getBugclose(@PathVariable Integer bugId,Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   model.addAttribute("bug", bug);
	   //返回bug字段的中文字段
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-close";
   }
   
   /**
    * 关闭bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-close-{bugId}", method = RequestMethod.POST)
   public String pBugclose(@PathVariable Integer bugId, Bug bug, Model model, String comment) {
	   //根据bugId查找bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //设置bug状态为 "closed"
	   bug.setStatus("closed");
	   //指派给closed
	   bug.setAssignedTo("closed");
	   //关闭bug
	   this.bugService.alter(bug, oBug, comment, "close");
	   return "redirect:bug-detail-" + bugId;
   }
   
   /**
    * 显示解决bug页面
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-solve-{bugId}", method = RequestMethod.GET)
   public String getBugsolve(@PathVariable Integer bugId, Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug",bug);
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   //返回bug字段的中文字段
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-solve";
   }
   
  /**
   * 解决bug
   * @param bugId
   * @param model
   * @return
   */
   @RequestMapping(value = "bug-solve-{bugId}", method = RequestMethod.POST)
   public String pBugsolve(@PathVariable Integer bugId, Bug bug, Model model, String comment) {
	   //根据bugId查找bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //设置bug状态为 "resolved"
	   oBug.setStatus("resolved");
	   //解决bug，根据前台传来的数据编辑后台数据
	   this.bugService.alter(bug, oBug, comment, "resolved");  
	   return "redirect:bug-detail-" + bugId;
   }
   
   /**
    * 显示激活bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-active-{bugId}", method = RequestMethod.GET)
   public String getBugactive(@PathVariable Integer bugId, Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug",bug);
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   //返回bug中文字段
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-active";
   }
  
   /**
    * 激活bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-active-{bugId}", method = RequestMethod.POST)
   public String pBugactive(@PathVariable Integer bugId,Bug bug,Model model, String comment) {
	   //根据bugId查找源bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //设置bug状态为 "active"
	   oBug.setStatus("active");
	   //当bug状态为"active"时，把以下值设为null
	   oBug.setClosedBy(null);
	   oBug.setClosedDate(null);
	   oBug.setResolvedBy(null);
	   oBug.setResolvedDate(null);
	   oBug.setResolvedBuild(null);
	   oBug.setResolution(null);
	   //激活次数+1
//	   bug.setActivatedCount(bug.getActivatedCount() + 1);
	   //激活bug，根据前台传来的数据编辑后台数据库
	   this.bugService.alter(bug, oBug, comment, "activate");
	   return "redirect:bug-detail-" + bugId;
   }
   
   /**
    *显示建用例
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-buildCase-{bugId}", method = RequestMethod.GET)
   public String getBuildCase(@PathVariable Integer bugId,Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug",bug);
	   //查找所有未删除的产品
	   List<Product> productList = this.productRepository.findAllproduct();
	   //返回product
	   model.addAttribute("productList", productList);
	   //返回bug中文字段
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-buildCase";
   }
   
   /**
    * 建用例
    * @param bugId
    * @param bug
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-buildCase-{bugId}", method = RequestMethod.POST)
   public String pBuildCase(@PathVariable Integer bugId,Bug bug,Model model) {
	   //根据bugId查找源bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //建用例
	   MyUtil.copyProperties(bug, oBug);
//	   this.storyService.alter(bug, oBug, comment, "opened");
	   return "redirect:bug-detail-" + bugId;
   }
  
   /**
    * 显示提需求
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-damandFor-{bugId}", method = RequestMethod.GET)
   public String getBugDamandFor(@PathVariable Integer bugId,Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug",bug);
	   //查找所有未删除的产品
	   List<Product> productList = this.productRepository.findAllproduct();
	   //返回product
	   model.addAttribute("productList", productList);
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   //返回bug中文字段
	   this.actionService.renderHistory("bug", bugId, model);
	   return "wechat/bug-damandFor";
   }
   
   /**
    * 提需求
    * @param bugId
    * @param bug
    * @param model
    * @return
    */
   @RequestMapping(value ="bug-damandFor-{bugId}", method = RequestMethod.POST)
   public String pBugDamandFor(@PathVariable Integer bugId,Bug bug,Model model, String comment) {
	   //根据bugId查找源bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   //提需求
	   MyUtil.copyProperties(bug, oBug);
//	   this.storyService.alter(bug, oBug, comment, "frombug");
	   return "redirect:bug-detail-" + bugId;
   }
   
   /**
    * 显示编辑bug
    * @param bugId
    * @param model
    * @return
    */
   @RequestMapping(value = "bug-edit-{bugId}", method = RequestMethod.GET)
   public String gBugEdit(@PathVariable Integer bugId, Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug", bug);
	   //查找所有未删除的产品，并返回productList
	   model.addAttribute("productList", this.productRepository.findAllproduct());
	   //将操作者转为中文
	   model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
	   //查找所有的用户
	   model.addAttribute("userList",this.userRepository.findAllUser());
	   return "wechat/bug-edit";
   }
   
   /**
    * 编辑bug
    * @param bugId
    * @param bug
    * @param comment
    * @return
    */
   @RequestMapping(value = "bug-edit-{bugId}", method = RequestMethod.POST)
   public String pBugEdit(@PathVariable Integer bugId, Bug bug, String comment) {
	   //根据bugId查找bug
	   Bug oBug = this.bugRepository.findOne(bugId);
	   this.bugService.alter(bug, oBug, comment, "edit");
	   return "redirect:task-detail-{bugId}";
   }
   
   /**
    * 显示记录工时
    * @param taskId
    * @param model
    * @return
    */
   @RequestMapping(value="bug-record-{bugId}", method = RequestMethod.GET)
   public String gBugRecord(@PathVariable Integer bugId, Model model) {
	   //根据bugId查找bug
	   Bug bug = this.bugRepository.findOne(bugId);
	   //返回bug
	   model.addAttribute("bug", bug);
	   
	   return "wechat/bug-record";
   }
   
   /**
    * 修改备注
    * @param bugOrTask （判断修改bug的还是task的备注）
    * @param actionId 
    * @param lastComment （修改后的备注）
    * @return
    */
   @RequestMapping(value = "/action-edit{bugOrTask}Comment-{actionId}", method = RequestMethod.POST)
	public String editActionComment(@PathVariable String bugOrTask, @PathVariable int actionId, String lastComment) {
		
		Action action = this.actionRepository.findOne(actionId);
		//修改备注
		action.setComment(lastComment);
		//返回到任务详情或者bug详情
		if (bugOrTask.equals("Bug")) {
			return "redirect:bug-detail-" + action.getObjectId();
		} else if (bugOrTask.equals("Task")) {
			return "redirect:task-detail-" + action.getObjectId();
		} else {
			return "";
		}
	}
   
}
