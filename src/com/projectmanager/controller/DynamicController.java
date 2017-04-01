package com.projectmanager.controller;

import java.sql.Timestamp;
import java.util.Calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.projectmanager.entity.Action;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.service.DynamicService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@Transactional
public class DynamicController {

	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private DynamicService dynamicService;
	
	@Autowired
	private UserService userService;
	
	/**
	 * 显示动态列表
	 * @param projectId
	 * @return
	 */
	@RequestMapping(value = "/project_dynamic_{projectId:\\d+}", method = RequestMethod.GET)
	public String viewDynamic(@PathVariable int projectId) {
		return "forward:project_dynamic_" + projectId +"_today_date_up_10_1";
	}
	
	/**
	 * 显示（按日期等）动态列表
	 * @param projectId
	 * @param type
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/project_dynamic_{projectId}_{condition}_{orderBy}_{ascOrDesc}_{recPerPage}_{page}", method = RequestMethod.GET)
	public String viewDynamicType(@PathVariable int projectId, @PathVariable String condition, 
			@PathVariable String orderBy, @PathVariable String ascOrDesc, @PathVariable int recPerPage, @PathVariable int page, Model model) {
		
		Sort sort = ascOrDesc.equals("up") ? new Sort(Sort.Direction.DESC, orderBy) : new Sort(Sort.Direction.ASC, orderBy);
		PageRequest pageRequest = new PageRequest(page - 1, recPerPage, sort);
		Page<Action> actions = null;
		Timestamp start = null, end = null;
		Calendar calendar = Calendar.getInstance();
		calendar.setFirstDayOfWeek(Calendar.MONDAY);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		
		switch (condition) {
		case "today":
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "yesterday":
			calendar.add(Calendar.DAY_OF_MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "twodaysago":
			calendar.add(Calendar.DAY_OF_MONTH, -2);
			start = new Timestamp(calendar.getTimeInMillis());
			break;
		case "thisweek":
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "lastweek":
			calendar.add(Calendar.WEEK_OF_MONTH, -1);
			calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.DAY_OF_MONTH, 6);
			break;
		case "thismonth":
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.MONTH , 1);
			end = new Timestamp(calendar.getTimeInMillis());
			break;
		case "lastmonth":
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			calendar.add(Calendar.MONTH, -1);
			start = new Timestamp(calendar.getTimeInMillis());
			calendar.add(Calendar.MONTH , 1);
			end = new Timestamp(calendar.getTimeInMillis());
			break;
		case "all":
			actions = this.actionRepository.findByProject(projectId, pageRequest);
			break;
		default:
			//按操作者查找
			actions = this.actionRepository.findByProjectAndActor(projectId, condition, pageRequest);
			break;
		}
		if (actions == null) {
			if(!condition.equals("lastmonth") && !condition.equals("thismonth")) {
				calendar.add(Calendar.DAY_OF_MONTH , 1);
				end = new Timestamp(calendar.getTimeInMillis());
			}
			actions = this.actionRepository.findByProjectAndDateBetween(projectId, start, end, pageRequest);
		}
		//获得对象名称的name或title
		actions.getContent().forEach(action->action.setObjectName(this.dynamicService.getObjectNameOrTitle(action.getObjectType(), action.getObjectId())));

		model.addAttribute("project", this.projectRepository.findOne(projectId));
		model.addAttribute("actionPage", actions);
		//将操作动作转为中文
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		//将对象类型转为中文
		model.addAttribute("objectTypeMap", this.dynamicService.getObjectTypeMap());
		//将操作者转为中文
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		return "project/project_dynamic";
	}
	
}
