package com.projectmanager.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.projectmanager.entity.Project;
import com.projectmanager.entity.TestTask;
import com.projectmanager.entity.User;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.repository.TestTaskRepository;
import com.projectmanager.repository.UserRepository;

@Controller
@RequestMapping(value = "/test")
public class TestController {
	
	@Autowired
	protected TestTaskRepository testTaskRepository;
	
	@Autowired
	protected ProjectRepository projectRepository;
	
	@Autowired
	protected UserRepository userRepository;
	
	@Autowired
	protected ProductRepository productRepository;
	
	/**
	 * 提交测试任务
	 */
	@RequestMapping(value = "/testtask_create")
	public String testTaskcreate() {
		return "test/testtask_create";
	}
	
	/**
	 * 显示编辑测试任务
	 * @param testtaskId
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/testtask_edit_{projectId}_{testtaskId}", method = RequestMethod.GET)
	public String viewTestTaskEdit(@PathVariable("testtaskId") Integer testtaskId, @PathVariable("projectId") Integer projectId, Model model) {
		TestTask testTask = this.testTaskRepository.findOne(testtaskId);
		Project project = this.projectRepository.findOne(projectId);
		List<User> userList = (List<User>) this.userRepository.findAll();
		model.addAttribute(userList);
		model.addAttribute(testTask);
		model.addAttribute(project);
		return "test/testtask_edit";
	}
	
	/**
	 * 编辑测试任务
	 * @param testtaskId
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/testtask_edit_{projectId}_{testtaskId}", method = RequestMethod.POST)
	public void testTaskEdit(@PathVariable("testtaskId") Integer testtaskId, @PathVariable("projectId") Integer projectId, 
			TestTask testTask, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		testTask.setId(testtaskId);
		testTask.setProduct(this.productRepository.findOne(4));
		this.testTaskRepository.save(testTask);
		model.addAttribute(project);
//		return "test/testtask_view_"+testtaskId;
	}
}
