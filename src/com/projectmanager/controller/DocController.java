package com.projectmanager.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.projectmanager.entity.Doc;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Project;
import com.projectmanager.repository.DocRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ProjectRepository;
import com.projectmanager.service.DocService;
import com.projectmanager.service.FileService;
import com.projectmanager.service.UserService;

@Controller
@RequestMapping(value = "/project")
@SessionAttributes("userAccount")
@Transactional
public class DocController {

	@Autowired
	private DocRepository docRepository;
	
	@Autowired
	private ProjectRepository projectRepository;
	
	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private DocService docService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private UserService userService;
	
	/**
	 * 显示文档列表
	 */
	@RequestMapping(value = "/project_doc_{projectId}", method = RequestMethod.GET)
	public String viewDoc(@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		List<Doc> docList = this.docRepository.findByProject(projectId);
		
		model.addAttribute("userMap", this.userService.getAllUsersMappingAccountAndRealname());
		model.addAttribute(project);
		model.addAttribute(docList);
		return "project/project_doc";
	}
	
	/**
	 * 显示创建文档
	 * @param projectId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/doc_create_project_{projectId}", method = RequestMethod.GET)
	public String viewCreateDoc(@PathVariable("projectId") int projectId, Model model) {
		Project project = this.projectRepository.findOne(projectId);
		model.addAttribute("projectList", this.projectRepository.findByDeleted("0"));
		model.addAttribute(project);
		return "project/doc_create";
	}
	
	/**
	 * 创建文档
	 * @param projectId
	 * @param doc
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/doc_create_project_{projectId}", method = RequestMethod.POST)
	public String createDoc(@RequestParam(value="files", required=false) MultipartFile[] files, String[] titles,
			@PathVariable("projectId") int projectId, Doc doc, @ModelAttribute("userAccount") String userAccount, Model model) throws IOException {
		Project project = this.projectRepository.findOne(projectId);
		Doc docSave = this.docService.created(doc);
		this.fileService.createFile(files, titles, "doc", docSave.getId(), userAccount);
		model.addAttribute(project);
		return "redirect:/project/project_doc_"+projectId;
	}
	
}
