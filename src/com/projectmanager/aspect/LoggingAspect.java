package com.projectmanager.aspect;

import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;

import com.projectmanager.entity.Action;
import com.projectmanager.entity.History;
import com.projectmanager.entity.Log;
import com.projectmanager.entity.LogProject;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Story;
import com.projectmanager.repository.ActionRepository;
import com.projectmanager.repository.HistoryRepository;
import com.projectmanager.service.BugService;
import com.projectmanager.service.ProjectService;

@Aspect
public class LoggingAspect {

	@Autowired
	private HttpSession session;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired 
	private HistoryRepository historyRepository;
	
	@Autowired 
	private ProjectService projectService;
	
	@Autowired
	private BugService bugService;
	
	
	@AfterReturning(value="execution(* com.projectmanager.service.*Service.create(..))",returning="result")
	public void logCreateInProductCtl(JoinPoint joinPoint, Log result) {
		
		String className = joinPoint.getTarget().getClass().getSimpleName();
		Action action = new Action();
		action.setAction("create");
		action.setActor(session.getAttribute("userAccount").toString());
		action.setProduct("," + result.overrideGetProductId() +",");
		action.setObjectId(result.OverrideGetId());
		action.setObjectType(className.substring(0, className.length() - 7).toLowerCase());
		this.actionRepository.save(action);
	}
	
	@Before("execution(* com.projectmanager.service.LogInterfaceService.modify(..)) && args(source,target,comment,action)")
	public void logModifyInProductCtl(JoinPoint joinPoint, Log source, Log target, String comment, String action) {
		
		String className = joinPoint.getTarget().getClass().getSimpleName();
		String userAccount = session.getAttribute("userAccount").toString();
		Action act = new Action();
//		action.setAction(joinPoint.getSignature().getName().substring(7).toLowerCase());
		act.setAction(action);
		act.setActor(userAccount);
		act.setProduct("," + target.overrideGetProductId() +",");
		//project_id未知
		act.setObjectId(target.OverrideGetId());
		act.setObjectType(className.substring(0, className.length() - 7).toLowerCase());
		act.setComment(comment);
		List<History> histories = new LinkedList<>();
		
		source.compare(target).forEach((a,b)->{
			History history = new History();
			history.setAction(this.actionRepository.save(act));
			history.setField(a);
			if (String.valueOf(b[0]).equals("null"))
				history.setOldValue("");
			else
				history.setOldValue(String.valueOf(b[0]));
			history.setNewValue(String.valueOf(b[1]));
			histories.add(history);
		});
		if (histories.size() == 0) {
			act.setAction("comment");
			if (!comment.equals("")) 
				this.actionRepository.save(act);
		} else {
			if (target instanceof Story)
				((Story)target).setLastEditedBy(userAccount);
			this.historyRepository.save(histories);
		}
	}
	
	
	/**
	 * 拦截创建操作，建立action
	 * @author logolin
	 * @param joinPoint
	 * @param result
	 */
	@AfterReturning(value="execution(* com.projectmanager.service.*Service.created(..))",returning="result")
	public void logCreateInProjectCtl(JoinPoint joinPoint, LogProject result) {
		
		//获得*Service的名字
		String className = joinPoint.getTarget().getClass().getSimpleName();
		//对象type，例如获得TaskService的Task并转换成小写
		String objectType = className.substring(0, className.length() - 7).toLowerCase();
		Action action = new Action();
		action.setAction("create");
		action.setActor(session.getAttribute("userAccount").toString());
		if(objectType.equals("story")) {
			//保存projectid
			action.setProject(result.overrideGetProjectId());
		} else {
			//保存projectid
			action.setProject(result.overrideGetProjectId());
		}
		//操作对象所属产品
		action.setProduct(this.projectService.getLinkProductIds(action.getProject()));
		action.setObjectId(result.OverrideGetId());
		action.setObjectType(objectType);
		
		this.actionRepository.save(action);
		
	}
	
	/**
	 * 拦截修改操作，建立history
	 * @author logolin
	 * @param joinPoint
	 * @param source
	 * @param target
	 * @param comment
	 * @param action
	 */
	@Before("execution(* com.projectmanager.service.*Service.alter(..)) && args(source,target,comment,action)")
	public void logModifyInProjectCtl(JoinPoint joinPoint, LogProject source, LogProject target, String comment, String action) {
		
		//类名（例如：taskService）
		String className = joinPoint.getTarget().getClass().getSimpleName();
		//objectType （例如：task）
		String objectType = className.substring(0, className.length() - 7).toLowerCase();
		//当前用户名
		String userAccount;
		//取得session
		if(session.getAttribute("userAccount") == null || session.getAttribute("userAccount").toString().equals("")) {
			userAccount = "admin";
		} else {
			userAccount = session.getAttribute("userAccount").toString();
		}
		//action
		Action act = new Action();
		act.setAction(action);
		act.setActor(userAccount);
		if(objectType.equals("bug")) {
			act.setProduct("," + this.bugService.getBugerProductId(target.OverrideGetId()) + ",");
		} else {
			act.setProduct(this.projectService.getLinkProductIds(target.overrideGetProjectId()));
		}
		//project_id
		act.setProject(target.overrideGetProjectId());
		act.setObjectId(target.OverrideGetId());
		act.setObjectType(objectType);
		act.setComment(comment);
		List<History> histories = new LinkedList<>();
		
		source.compare(target).forEach((a,b)->{
			History history = new History();
			history.setAction(this.actionRepository.save(act));
			history.setField(a);
			if (String.valueOf(b[0]).equals("null"))
				history.setOldValue("");
			else
				history.setOldValue(String.valueOf(b[0]));
			history.setNewValue(String.valueOf(b[1]));
			histories.add(history);
		});
		if (histories.size() == 0) {
			act.setAction("comment");
			if (!comment.equals(""))
				this.actionRepository.save(act);
		} else {
			if (target instanceof Story)
				((Story)target).setLastEditedBy(userAccount);
			this.historyRepository.save(histories);
		}
	}
	
}
