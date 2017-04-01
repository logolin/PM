package com.projectmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/")
public class FileController {

	/**
	 * 显示修改文件名
	 * @param fileId
	 * @return
	 */
	@RequestMapping(value = "/editFile_{fileId}", method = RequestMethod.GET)
	public String viewEditFile(@PathVariable int fileId) {
		
		return "";
	}
}
