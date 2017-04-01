package com.projectmanager.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.projectmanager.entity.Action;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.HistoryRepository;

@Service
public class ActionService {

	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private HistoryRepository historyRepository;
	
	@Autowired
	private DynamicService dynamicService;
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private StoryService storyService;
	
	@Autowired
	private ReleaseService releaseService;
	
	@Autowired
	private PlanService planService;
	
	@Autowired
	private ModuleService moduleService;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private BugService bugService;
	
	public void renderHistory(String objectType, int objectId, Model model) {
		
		List<Action> actions = this.actionRepository.findByObjectTypeAndObjectId(objectType, objectId);
		actions.forEach(action->action.getHistories().addAll(this.historyRepository.findByActionId(action.getId())));
		
		model.addAttribute("actionList", actions);
		model.addAttribute("actionMap", this.dynamicService.getActionMap());
		
		switch (objectType) {
		case "product":
			model.addAttribute("fieldNameMap", this.productService.getFieldNameMap());
			break;
		case "story":
			model.addAttribute("fieldNameMap", this.storyService.getFieldNameMap());
			break;
		case "release":
			model.addAttribute("fieldNameMap", this.releaseService.getFieldNameMap());
			break;
		case "plan":
			model.addAttribute("fieldNameMap", this.planService.getFieldNameMap());
			break;
		case "module":
			model.addAttribute("fieldNameMap", this.moduleService.getFieldNameMap());
			break;
		case "task":
			model.addAttribute("fieldNameMap", this.taskService.getFieldNameMap());
			break;
		case "project":
			model.addAttribute("fieldNameMap", this.projectService.getFieldNameMap());
			break;
		case "bug":
			model.addAttribute("fieldNameMap", this.bugService.getFieldNameMap());
			break;
		default:
			break;
		}
	}
}
