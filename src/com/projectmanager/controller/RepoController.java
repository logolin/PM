package com.projectmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/repo")
public class RepoController {

	/**
	 * 显示代码浏览页面
	 * @return
	 */
	@RequestMapping("/repo_browse")
	public String viewRepoBrowse() {
		
		return "repo/repo_browse";
	}
	
	/**
	 * 显示创建代码
	 * @return
	 */
	@RequestMapping("/repo_create")
	public String viewRepoEdit() {
		
		return "repo/repo_create";
	}
}
