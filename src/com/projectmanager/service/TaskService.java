package com.projectmanager.service;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.projectmanager.entity.Bug;
import com.projectmanager.entity.Project;
import com.projectmanager.entity.ProjectStory;
import com.projectmanager.entity.Story;
import com.projectmanager.entity.Task;
import com.projectmanager.entity.TaskEstimate;
import com.projectmanager.entity.Tasks;
import com.projectmanager.entity.Team;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ModuleRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.ProjectStoryRepository;
import com.projectmanager.repository.StoryRepository;
import com.projectmanager.repository.StorySpecRepository;
import com.projectmanager.repository.TaskEstimateRepository;
import com.projectmanager.repository.TaskRepository;
import com.projectmanager.repository.TeamRepository;

@Service
@Transactional
public class TaskService {

	@Autowired
	protected TaskRepository taskRepository;
	
	@Autowired
	protected TeamRepository teamRepository;
	
	@Autowired
	private TaskEstimateRepository taskEstimateRepository;
	
	@Autowired
	protected ProjectStoryRepository projectStoryRepository;
	
	@Autowired
	protected StoryRepository storyRepository;
	
	@Autowired
	protected EntityManager entityManager;
	
	@Autowired
	protected ProjectRepository projectRepository;
	
	@Autowired
	protected ModuleRepository moduleRepository;
	
	@Autowired
	protected StorySpecRepository storySpecRepository; 
	
	/**
	 * 创建任务
	 * @param projectId
	 * @param task
	 * @param model
	 */
	public void created(int projectId, Task task) {
		
		Project project = this.projectRepository.findOne(projectId);
		//将前台的预计开始，截止时间为空或空字符串的设为空才能存到数据库
		this.setNullDate(task);
		
		task.setProject(project);
		this.taskRepository.save(task);
		
	}
	
	/**
	 * 编辑任务
	 * @param source
	 * @param taget
	 * @param comment
	 * @param action
	 */
	public void alter(Task source, Task target, String comment, String action) {
		
		//将前台的预计开始，截止时间，完成时间，取消时间，关闭时间等，为空或空字符串的设为空才能存到数据库
		this.setNullDate(source);
		MyUtil.copyProperties(source, target);
	}
	
	/**
	 * 按类型查找任务
	 * @param projectId
	 * @param status
	 * @return
	 */
	public Page<Task> findTaskByStatus(int projectId, String status, int statusId, Pageable pageable, String userAccount) {
		
		switch (status) {
		
		case "unclosed":
			return this.taskRepository.findUncloseTask("closed", projectId, pageable);
		case "all":
			return this.taskRepository.findByProjectId(projectId, pageable);
		case "delayed":
			Date today = new Date(System.currentTimeMillis());
			Page<Task> taskPage = this.taskRepository.findDelayedTask(projectId, today, pageable);
//			for(Task task : this.taskRepository.findDelayedTask(projectId, today, pageable).getContent()) {
//				entityManager.clear();
//				task.setStatus("delay");
//				task.setCh_status("已延期");
//			}
			
			return taskPage;
			
		case "needconfirm":
			return this.taskRepository.findByStoryChange(projectId, pageable);
		case "finishedbyme":
			
			return this.taskRepository.findByFinishedByAndProjectId(userAccount, projectId, pageable);

		case "byModule":
			return this.taskRepository.findByModuleAndProjectId(statusId, projectId, pageable);
			
		case "byProduct":
			return this.taskRepository.findByProduct(projectId, statusId, pageable);
			
		default:
			return this.taskRepository.findByStatus(projectId, status, pageable);
		}
	}
	
	/**
	 * 侧边栏根据product查找任务
	 */
	public List<Task> getTaskForProduct(int productId, int projectId) {
		List<Task> taskList = this.taskRepository.findByProjectAndStory(projectId);
		List<Task> tasks = new ArrayList<Task>();
		for(Task task : taskList) {
			if(this.storyRepository.findOne(task.getStory_id()).getProduct().getId() == productId) {
				tasks.add(task);
			}
		}
		return tasks;
	}
	/**
	 * 将任务列表里的状态转换成中文输出
	 * @param taskList
	 */
	public void alterCh(List<Task> taskList) {
		for(Task task : taskList) {
			alterCh(task);
		}
	}
	/**
	 * 将单个任务的状态转换成中文输出
	 * @param task
	 */
	public void alterCh(Task task) {
		
		//判断是否需求变动
		if(task.getStory_id() != null && task.getStory_id() != 0 && task.getStoryVersion() < this.storyRepository.findOne(task.getStory_id()).getVersion()) {
			task.setCh_status("需求变更");
			Date today = new Date(System.currentTimeMillis());
			if(task.getStatus().equals("wait") || task.getStatus().equals("doing")) {
				if (task.getDeadline() != null && !task.getDeadline().equals("") && today.compareTo(task.getDeadline()) > 0) {
					entityManager.clear();
					task.setStatus("delay");
				}
			}
		} else {
			Date today = new Date(System.currentTimeMillis());
			String status = task.getStatus();
			switch (status) {
			case "wait":
				if(task.getDeadline() == null || task.getDeadline().equals("")) {
					task.setCh_status("未开始");
					break;
				}
				if (today.compareTo(task.getDeadline()) > 0) {
					task.setCh_status("未开始");
					entityManager.clear();
					task.setStatus("delay");
				}
				else
					task.setCh_status("未开始");
				break;
			case "doing":
				if(task.getDeadline() == null || task.getDeadline().equals("")) {
					task.setCh_status("进行中");
					break;
				}
				try {
					if (today.compareTo(task.getDeadline()) > 0) {
						task.setCh_status("进行中");
						entityManager.clear();
						task.setStatus("delay");
					}
					else
						task.setCh_status("进行中");
					
				} catch (Exception e) {
				
				}
				break;
			case "done":
					task.setCh_status("已完成");
				break;
			case "pause":
					task.setCh_status("已暂停");
				break;
			case "closed":
					task.setCh_status("已关闭");
				break;

			case "cancel":
					task.setCh_status("已取消");
				break;
			default:
				break;
			}
		}
	}
	/**
	 * 根据project查找团队成员
	 * @param projectId
	 * @return
	 */
	public List<User> getUserForProject(int projectId) {
		List<User> userList = new ArrayList<User>();
		List<Team> teamList = this.teamRepository.findByProject(projectId);
		for(Team team : teamList) {
			User user = team.getId().getUser();
			userList.add(user);
		}
		return userList;
	}
	
	
	/**
	 * 根据project获取story
	 * @param projectId
	 * @return storyList
	 */
	public List<Story> getStory(Integer projectId) {
		List<Story> storyList = new ArrayList<Story>();
		List<ProjectStory> projectStoryList = this.projectStoryRepository.findByProject(projectId);
		for(ProjectStory pstory : projectStoryList) {
			Story story = this.storyRepository.findOne(pstory.getStory_id());
			storyList.add(story);
		}
		return storyList;
	}
	
	/**
	 * 根据story返回所有状态的task
	 * @param storyId
	 * @param projectId
	 * @param status
	 * @return
	 */
	public Map<String, List<Task>> getTaskForStory(Integer storyId, Integer projectId) {
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		
			List<Task> waitTask = this.taskRepository.findByStoryAndProjectAndStatus(storyId, projectId, "wait");

			List<Task> doingTask = this.taskRepository.findByStoryAndProjectAndStatus(storyId, projectId, "doing");

			List<Task> doneTask = this.taskRepository.findByStoryAndProjectAndStatus(storyId, projectId, "done");

			List<Task> closedTask = this.taskRepository.findByStoryAndProjectAndStatus(storyId, projectId, "closed");

			List<Task> cancelTask = this.taskRepository.findByStoryAndProjectAndStatus(storyId, projectId, "cancel");
			
			taskMap.put("waitTask", waitTask);
			taskMap.put("doingTask", doingTask);
			taskMap.put("doneTask", doneTask);
			taskMap.put("closedTask", closedTask);
			taskMap.put("cancelTask", cancelTask);
		return taskMap;
	}
	
	/**
	 * 按需求显示看板
	 * @param projectId
	 * @return
	 */
	public Map<Story, Map<String,List<Task>>> getTaskForStory(Integer projectId, String sort) {
		//key为story，value为可以为状态，value为taskList 的map
		Map<Story, Map<String,List<Task>>> map = new LinkedHashMap<Story, Map<String,List<Task>>>();
		//key为状态，value为taskList （存放状态对应的任务）
		Map<String,List<Task>> mapStatus = new HashMap<String,List<Task>>();
		//任务关联的所有需求
		List<Story> storyList = new ArrayList<Story>();
		//此项目的所有任务
		List<Task> taskl = this.taskRepository.findByProjectId(projectId);
		//根据taskList获取storyList
		for(Task task : taskl) {
			//判断任务是否关联需求
			if(task.getStory_id() != 0) {
				Story story = this.storyRepository.findOne(task.getStory_id());
				//添加一个新需求
				storyList.add(story);
			}
		}
		this.sortStory(storyList, projectId, sort);
		
		//根据需求来获取taskList
		for(Story story : storyList) {
			mapStatus = this.getTaskForStory(story.getId(), projectId);
			
			map.put(story, mapStatus);
		}
		Story story = new Story();
		//返回无需求任务
		mapStatus = this.getTaskForStory(0, projectId);
		map.put(story, mapStatus);
		return map;
	}
	
	/**
	 * 按要求给storylist排序
	 */
	public void sortStory(List<Story> storyList, Integer projectId, String sort) {
		switch (sort) {
		case "pri_asc":
			//对storylist按pri升序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story pri1, Story pri2) {
				return pri1.getPri().compareTo(pri2.getPri());
				}
			});
			break;

		case "pri_desc":
			//对storylist按pri倒序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story pri1, Story pri2) {
				return new Double(pri2.getPri()).compareTo(new Double(pri1.getPri()));
				}
			});
			break;
			
		case "id_asc":
			//对storylist按id升序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story id1, Story id2) {
				return id1.getId().compareTo(id2.getId());
				}
			});
			break;
		case "id_desc":
			//对storylist按id倒序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story id1, Story id2) {
				return id2.getId().compareTo(id1.getId());
				}
			});
			break;
			
		case "stage_asc":
			//对storylist按id升序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story stage1, Story stage2) {
				return stage1.getStage().compareTo(stage2.getStage());
				}
			});
			break;
			
		case "stage_desc":
			//对storylist按id倒序排序
			Collections.sort(storyList, new  Comparator<Story>() {
				@Override
				public int compare(Story stage1, Story stage2) {
				return stage2.getStage().compareTo(stage1.getStage());
				}
			});
			break;
			
		default:
			break;
		}
	}
	
	/**
	 * 分组查找任务
	 * @param projectId
	 * @return
	 */
	public Map<String, List<Task>> getTaskForGroup(Integer projectId, String types, String typeName) {
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//根据projectId获取taskList
		List<Task> taskl = this.taskRepository.findByProjectId(projectId);
		switch (types) {
		//需求分组查找任务
		case "story":
			return this.getTaskForStory(projectId, typeName, taskl);

		//状态分组
		case "status":
			//状态数组
			List<String> statusList = new ArrayList<String>();
			//从task中查找有多少种状态，添加进statusList
			for(Task task : taskl) {
				statusList.add(task.getStatus());
			}
			for(String status : statusList) {
				//由projectId、status查找未删除任务
				List<Task> taskList = this.taskRepository.findByProject_IdAndStatusAndDeleted(projectId, status, "0");
				this.alterCh(taskList);
				//返回中文状态
				status = this.alterCh_Status(status);
				taskMap.put(status, taskList);
			}
			return taskMap;
			
		//优先级分组
		case "pri":
			return this.getTaskForPri(projectId, typeName, taskl);
			
		//指派给分组
		case "assignedTo":
			return this.getTaskForAssignedTo(projectId, typeName, taskl);
		
		//完成者分组
		case "finishedBy":
			return this.getTaskForFinishedBy(projectId, typeName, taskl);

			//关闭者分组
		case "closedBy":
			return this.getTaskForClosedBy(projectId, typeName, taskl);
			
		//类型分组
		case "type":
			List<String> typeList = new ArrayList<String>();
			for(Task task : taskl) {
				//循环查找任务类型，给typeList添加值
				typeList.add(task.getType());
			}
			for(String type : typeList) {
				//根据type查找任务
				List<Task> taskList = this.taskRepository.findByTypeAndProjectIdAndDeleted(type, projectId, "0");
				//将任务的状态转成中文
				this.alterCh(taskList);
				//每个type和所对应的任务添加进map里
				taskMap.put(type, taskList);
			}
			return taskMap;
			
		//截止分组
		case "deadline":
			return this.getTaskForDeadline(projectId, typeName, taskl);
			
		default:
			break;
		}
		return null;
	}
	
	/**
	 * 根据需求分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForStory(Integer projectId, String typeName, List<Task> taskl) {
		
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		if(typeName.equals("all")) {
			//查找无关联需求的任务
			List<Task> notStoryTask = this.taskRepository.findByNotStory(projectId);
			//将任务的status转成中文
			this.alterCh(notStoryTask);
			//map添加无关联需求的任务
			taskMap.put("无需求", notStoryTask);
		}
		//关联需求的任务
		List<Story> storyList = new ArrayList<Story>();
		//根据taskList获取storyList
		for(Task task : taskl) {
			if(task.getStory_id() != 0) {
				//根据需求id查找任务
				Story story = this.storyRepository.findOne(task.getStory_id());
				storyList.add(story);
			}
		}
		
		for(Story story : storyList) {
			//根据需求和项目查找任务
			List<Task> taskList = this.taskRepository.findByStoryAndProject(story.getId(), projectId);
			//将任务的status转成中文
			this.alterCh(taskList);
			//map添加值
			taskMap.put(story.getId()+"::"+story.getTitle(), taskList);
		}
		return taskMap;
	}
	
	/**
	 * 根据优先级分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForPri(Integer projectId, String typeName, List<Task> taskl) {
		
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//priList
		List<Integer> priList = new ArrayList<Integer>();
		//从task中查找有多少种pri，添加进priList
		for(Task task : taskl) {
			//判断是否按已设置优先级分组
			if(typeName.equals("setted")) {
				//不添加尚未设置优先级的进来
				if(task.getPri() != 0) {
					priList.add(task.getPri());
				}
			} else {
				//全部优先级都添加进来
				priList.add(task.getPri());
			}
			
		}
		for(Integer i : priList) {
			//根据pri和project查找未删除的任务
			List<Task> taskList = this.taskRepository.findByPriAndProject_IdAndDeleted(i, projectId, "0");
			//返回中文状态
			this.alterCh(taskList);
			//pri和taskList组成的map
			taskMap.put(i.toString(), taskList);
		}
		return taskMap;
	}
	
	/**
	 * 指派者分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForAssignedTo(Integer projectId, String typeName, List<Task> taskl) {
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//已设置指派者
		List<String> assignedList = new ArrayList<String>();
		//未设置指派者
		List<Task> notAssignedList = new ArrayList<Task>();
		//未完成
		if(typeName.equals("undone")) {
			for(Task task : taskl) {
				//判断任务是否已完成
				if(!task.getStatus().equals("done")) {
					//任务未完成，给已设置指派者添加新值
					assignedList.add(task.getAssignedTo());
				}
			}
			//
			for(String assigned : assignedList) {
				//根据assignedTo、projectId查找未完成的任务
				List<Task> taskList = this.taskRepository.findByAssignedToAndProjectIdAndStatusNotAndDeleted(assigned, projectId, "done", "0");
				//将task的status转成中文状态
				this.alterCh(taskList);
				taskMap.put(assigned, taskList);
			}
		} else {
			for(Task task : taskl) {
				//判断任务是否已指派
				if(task.getAssignedTo() != null && task.getAssignedTo() != "") {
					//已设置指派者添加新值
					assignedList.add(task.getAssignedTo());
				} else {
					//添加未指派的任务
					notAssignedList.add(task);
				}
			}
			//未指派
			taskMap.put("未指派", notAssignedList);
			//
			for(String assigned : assignedList) {
				//根据assignedTo、projectId查找未完成的任务
				List<Task> taskList = this.taskRepository.findByAssignedToAndProjectIdAndDeleted(assigned, projectId, "0");
				//将task的status转成中文状态
				this.alterCh(taskList);
				taskMap.put(assigned, taskList);
			}
		}
		
		return taskMap;
	}
	
	/**
	 * 完成者分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForFinishedBy(Integer projectId, String typeName, List<Task> taskl) {
		
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//完成者
		List<String> finishList = new ArrayList<String>();
		//未完成的任务
		List<Task> unfinishList = new ArrayList<Task>();
		
		for(Task task : taskl) {
			//判断任务是否已完成
			if(task.getFinishedBy() != null && task.getFinishedBy() != "") {
				//将完成者添加进finishList
				finishList.add(task.getFinishedBy());
			} else if(typeName.equals("all")) {
				//若typeName为all，则添加未完成的任务
				unfinishList.add(task);
			}
		}
		//判断是否显示全部任务，若是则给taskMap添加未完成的任务
		if(typeName.equals("all")) {
			taskMap.put("未完成", unfinishList);
		}
		//循环查找每个完成者完成的任务
		for(String finishedBy : finishList) {
			//根据finishedBy和projectId查找未删除的任务
			List<Task> taskList = this.taskRepository.findByFinishedByAndProjectIdAndDeleted(finishedBy, projectId, "0");
			//将task的status转成中文
			this.alterCh(taskList);
			taskMap.put(finishedBy, taskList);
		}
		return taskMap;
	}
	/**
	 * 关闭者分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForClosedBy(Integer projectId, String typeName, List<Task> taskl) {
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//关闭者
		List<String> closedList = new ArrayList<String>();
		//未关闭的任务
		List<Task> notCloseTask = new ArrayList<Task>();
		for(Task task : taskl) {
			//判断任务是否已关闭
			if(task.getStatus().equals("closed")) {
				//add关闭者
				closedList.add(task.getClosedBy());
			} else if(typeName.equals("all")) { //判断是否显示全部任务
				//将未关闭的任务添加到notCloseTask
				notCloseTask.add(task);
				}
		}
		if(typeName.equals("all")) {
			//将task的status转成中文
			this.alterCh(notCloseTask);
			//若是显示全部，则给taskMap添加未关闭任务
			taskMap.put("未关闭", notCloseTask);
		}
		for(String closedBy : closedList) {
			System.out.println("4444" + closedBy);
			//根据closedBy、projectId查找任务
			List<Task> taskList = this.taskRepository.findByClosedByAndProjectIdAndDeleted(closedBy, projectId, "0");
			//将task的status转成中文
			this.alterCh(taskList);
			taskMap.put(closedBy, taskList);
		}
		return taskMap;
	}
	
	/**
	 * 根据截至分组查找任务
	 * @param projectId
	 * @param typeName
	 * @param taskl
	 * @return
	 */
	public Map<String, List<Task>> getTaskForDeadline(Integer projectId, String typeName, List<Task> taskl) {
		Map<String, List<Task>> taskMap = new HashMap<String, List<Task>>();
		//截至时间
		List<Date> deadlineList = new ArrayList<Date>();
		//未设置截至时间的任务
		List<Task> notDeadList = new ArrayList<Task>();
		//从task中查找有多少种pri，添加进priList
		for(Task task : taskl) {
			//判断截至时间是否为空
			if(task.getDeadline() != null) {
				deadlineList.add(task.getDeadline());
			} else if(typeName.equals("all")){
				//当typeName为all的时候，add截至时间为空的任务
				notDeadList.add(task);
			}
			
		}
		if(typeName.equals("all")) {
			taskMap.put("无截至时间", notDeadList);
		}
		for(Date date : deadlineList) {
			//根据截至时间和projectId查找任务
			List<Task> taskList = this.taskRepository.findByDeadlineAndProjectIdAndDeleted(date, projectId, "0");
			//返回中文状态
			this.alterCh(taskList);
			//pri和taskList组成的map
			taskMap.put(date.toString(), taskList);
		}
		return taskMap;
	}
	/**
	 * task的type和对应的中文（map）
	 * @return
	 */
	public Map<String, String> getTypeNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("design", "设计");
			put("devel", "开发");
			put("test", "测试");
			put("study", "研究");
			put("discuss", "讨论");
			put("ui", "界面");
			put("affair", "事务");
			put("misc", "其他");
		}};
		
		return fieldNameMap;
	}
	
	/**
	 * 将status转成中文
	 * @param status
	 * @return
	 */
	public String alterCh_Status(String status) {
		switch (status) {
		case "wait":
			//停止事务
			entityManager.clear();
			status = "未开始";
			return status;

		case "doing":
			entityManager.clear();
			status = "进行中";
			return status;
			
		case "done":
			entityManager.clear();
			status = "已完成";
			return status;
			
		case "cancel":
			entityManager.clear();
			status = "已取消";
			return status;
			
		case "closed":
			entityManager.clear();
			status = "已关闭";
			return status;
			
		case "pause":
			entityManager.clear();
			status = "已暂停";
			return status;
		
		}
		return status;
	}
	
	/**
	 * 批量添加任务
	 */
	public void batchCreateTask(Tasks tasks, int projectId) {
		//页面有“同上”选项的字段
		Integer dittoModule = null, dittoStory = null;
		String dittoType = null, dittoAssign = null;
		Task task;
		//tasklist
		List<Task> taskList = tasks.getTasks();
		
		for (int index = 0; index < taskList.size(); index++) {
			task = taskList.get(index);
			//判断是否同上
			if (task.getModule_id() == -1) {
				//同上则将上一个task的模块赋给此task
				task.setModule_id(dittoModule);
			} else {
				//不是同上，则保存选择的模块
				dittoModule = task.getModule_id();
			}
			//判断是否同上
			if (task.getStory_id() == -1) {
				task.setStory_id(dittoStory);
			} else {
				dittoStory = task.getStory_id();
			}
			//判断是否同上
			if (task.getType().equals("-1")) {
				task.setType(dittoType);
			} else {
				dittoType = task.getType();
			}
			//判断是否同上
			if (task.getAssignedTo().equals("-1")) {
				task.setAssignedTo(dittoAssign);
			} else {
				dittoAssign = task.getAssignedTo();
			}
			//判断是否填写任务名、任务类型等必填项
			if(task.getName() != null && !task.getName().equals("") && task.getType() != null) {
				this.created(projectId, task);
			}
		}
	}
	
	/**
	 * 批量添加工时
	 * @throws ParseException 
	 */
	public void batchCreateEstimateTask(String[] dates, float[] consumed, float[] remain, String[] work, int taskId, String account) throws ParseException {
		
		for(int i = 0; i < 5; i++) {
			if(consumed[i] != 0 && remain[i] != 0) {
				TaskEstimate estimate = new TaskEstimate();
				estimate.setAccount(account);
				java.util.Date  date  =  new SimpleDateFormat("yyyy-MM-dd").parse(dates[i]);     
				java.sql.Date  sqlDate  =  new java.sql.Date(date.getTime());
				estimate.setDate(sqlDate);
				estimate.setConsumed(consumed[i]);
				estimate.setRemain(remain[i]);
				estimate.setWork(work[i]);
				estimate.setTask(this.taskRepository.findOne(taskId));
				this.taskEstimateRepository.save(estimate);
			}
		}
		
	}
	
	/**
	 * 批量编辑任务
	 */
	public void batchEditTask(Tasks tasks) {
		Integer dittoModule = null, dittoPri = null;
		String dittoStatus = null, dittoAssign = null, dittoType = null,
				dittoFinshBy = null, dittoClose = null, dittoCancel = null;
		Task task;
		Task updateTask;
		List<Task> taskList = tasks.getTasks();
		
		for (int index = 0; index < taskList.size(); index++) {
			task = taskList.get(index);
			if (task.getModule_id() == -1) {
				task.setModule_id(dittoModule);
			} else {
				dittoModule = task.getModule_id();
			}
			if (task.getType() == "-1") {
				task.setType(dittoType);
			} else {
				dittoType = task.getType();
			}
			if (task.getStatus() == "-1") {
				task.setStatus(dittoStatus);
			} else {
				dittoStatus = task.getStatus();
			}
			
			if (task.getAssignedTo() == "-1") {
				task.setAssignedTo(dittoAssign);
			} else {
				dittoAssign = task.getAssignedTo();
			}
			if (task.getFinishedBy() == "-1") {
				task.setFinishedBy(dittoFinshBy);
			} else {
				dittoFinshBy = task.getFinishedBy();
			}
			if (task.getClosedBy() == "-1") {
				task.setClosedBy(dittoClose);
			} else {
				dittoClose = task.getClosedBy();
			}
			if (task.getCanceledBy() == "-1") {
				task.setCanceledBy(dittoCancel);
			} else {
				dittoCancel = task.getCanceledBy();
			}
			if (task.getPri() == -1) {
				task.setPri(dittoPri);
			} else {
				dittoPri = task.getPri();
			}
			//保存
			updateTask = this.taskRepository.findOne(task.getId());
			MyUtil.copyProperties(task, updateTask);
			
		}
	}
	
	/**
	 * 批量关闭、指派、关联模块
	 * @param taskIds （任务id数组）
	 * @param fieldName （操作：例如close=关闭）
	 * @param fieldVal （操作目的：例如指派给某个fieldVal）
	 */
	public void modifiedByColumn(String fieldName, String fieldVal, Integer[] taskIds, String account) {
		
		List<Task> tasks = this.taskRepository.findByIdIn(taskIds);
		String status = fieldName;
		for (Task task : tasks) {
			//判断执行哪个操作
			if(status.equals("Module_id")) {
				//设置模块
				task.setModule_id(Integer.valueOf(fieldVal));
			} else if(status.equals("AssignedTo")) {
				//指派给
				task.setAssignedTo(fieldVal);
				task.setAssignedDate(new Timestamp(System.currentTimeMillis()));
				
			} else if(status.equals("close")){
				//关闭
				task.setStatus("closed");
				task.setCanceledBy(account);
				task.setClosedDate(new Timestamp(System.currentTimeMillis()));
			}
			task.setLastEditedBy(account);
			task.setLastEditedDate(new Timestamp(System.currentTimeMillis()));
		}
	}
	
	/**
	 * 将前台的预计开始，截止时间，完成时间，取消时间，关闭时间等，为空或空字符串的设为空才能存到数据库
	 * @param task
	 * @throws Exception 
	 */
	public void setNullDate(Task task) {
		
		try {
			if(task.getEstStarted().toString().equals("1970-01-01")) {
				task.setEstStarted(null);
			}
			if(task.getDeadline().toString().equals("1970-01-01")) {
				task.setDeadline(null);
			}
			if(task.getFinishedDate().toString().equals("1970-01-01 00:00:00")) {
				task.setFinishedDate(null);
			}
			if(task.getClosedDate().toString().equals("1970-01-01 00:00:00")) {
				task.setClosedDate(null);
			}
			if(task.getCanceledDate().toString().equals("1970-01-01 00:00:00")) {
				task.setCanceledDate(null);
			}
		} catch(Exception e) {
			
		}
	}
	
	/**
	 * task里字段对应的中文
	 * @return
	 */
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("project", "所属项目");
			put("name", "任务名称");
			put("module_id", "所属模块");
			put("story_id", "相关需求");
			put("type", "任务类型");
			put("status", "任务状态");
			put("pri", "优先级");
			put("mailto", "抄送给");
			put("estStarted", "预计开始");
			put("realStarted", "实际开始");
			put("deadline", "截止日期");
			put("estimate", "最初预计");
			put("consumed", "总消耗");
			put("remain", "预计剩余");
			put("color", "color");
			put("descript", "任务描述");
			put("openedBy", "由谁创建");
			put("assignedTo", "指派给");
			put("finishedBy", "由谁完成");
			put("finishedDate", "完成时间");
			put("canceledBy", "由谁取消");
			put("canceledDate", "取消时间");
			put("closedBy", "由谁关闭");
			put("closedDate", "关闭时间");
			put("closedReason", "关闭原因");
			put("comment", "备注");
			put("lastEditedBy", "由谁最后编辑");
			put("lastEditedDate", "最后编辑时间");
		}};
		
		return fieldNameMap;
	}
	
	/**
	 * 将预计剩余等值赋给表单传来的task，不然会置零
	 * @param task
	 * @param updateTask
	 */
	public void copyRemain(Task task, Task updateTask) {
		task.setRemain(updateTask.getRemain());
		task.setConsumed(updateTask.getConsumed());
		task.setEstimate(updateTask.getEstimate());
	}
	
	/**
	 * 2017-2-10
	 * 批量关闭、指派、删除任务
	 * @param taskIds （任务id数组）
	 * @param fieldName （操作：例如close=关闭）
	 * @param fieldVal （操作目的：例如指派给某个fieldVal）
	 */
	public void massHandle(String fieldName, String fieldVal, Integer[] taskIds, String account) {
		
		List<Task> tasks = this.taskRepository.findByIdIn(taskIds);
		String flag = fieldName;
		for (Task task : tasks) {
			//判断执行哪个操作
			if(flag.equals("AssignedTo")) {
				//指派给
				task.setAssignedTo(fieldVal);
				task.setAssignedDate(new Timestamp(System.currentTimeMillis()));
			} else if(flag.equals("close")){
				//关闭
				task.setStatus("closed");
				task.setClosedBy(account);
				task.setClosedDate(new Timestamp(System.currentTimeMillis()));
			}else if(flag.equals("delete")) {
				//设置delete字段为 "1"
				task.setDeleted("1");
			}else if(flag.equals("finish")) {
				//设置任务的状态为"done"
				task.setStatus("done");
				task.setFinishedBy(account);
				task.setFinishedDate(new Timestamp(System.currentTimeMillis()));
			}
			task.setLastEditedBy(account);
			task.setLastEditedDate(new Timestamp(System.currentTimeMillis()));
		}
	}
	
	/**
	 * 查找任务模块和相关需求、需求描述
	 * @param task
	 * @param model
	 */
	public void getModuleAndStoryAndStorySpec(Task task, Model model) {
		//根据module_id查找模块
		model.addAttribute("module",this.moduleRepository.findOne(task.getModule_id()));
		//根据story_id查找需求
		model.addAttribute("story",this.storyRepository.findOne(task.getStory_id()));
		//返回需求描述
		model.addAttribute("storyspec", this.storySpecRepository.findByStoryIdAndVersion(task.getStory_id(), task.getStoryVersion()));
	}
}
