package com.projectmanager.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.Service;

import com.projectmanager.controller.AppConfig;
import com.projectmanager.entity.Module;
import com.projectmanager.entity.Modules;
import com.projectmanager.repository.ModuleRepository;

@Service
public class ModuleService implements LogInterfaceService<Module>{

	@Autowired
	private ModuleRepository moduleRepository;
	
	@Autowired
	private BranchService branchService;
	
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("root", "所属产品");
			put("branch_id", "所属分支/平台");
			put("parent", "父模块");
			put("name", "名称");
			put("path", "路径");
			put("grade", "层级");
			put("shortname", "简称");
		}};
		
		return fieldNameMap;
	}
	
	public Module create(Module module, String path) {
		
		module = this.moduleRepository.save(module);
		module.setPath(path + module.getId() + ",");
		
		return module;
	}
	
	public void createModules(int root, String[] names, Integer[] branch_ids, int parent, String type, String[] shortnames) {
		
		Module module;
		ApplicationContext applicationContext = new AnnotationConfigApplicationContext(AppConfig.class);
		String path;
		int grade;
		if (parent == 0) {
			grade = 1;
			path = ",";
		} else {
			path = this.moduleRepository.findPathBy(parent);
			grade = path.split(",").length;
		}
		
		for (int i = 0, l = names.length; i < l; i++) {
			if (names[i].equals("")) {
				continue;
			}
			module = applicationContext.getBean(Module.class);
			module.setName(names[i]);
			module.setParent(parent);
			module.setRoot(root);
			module.setBranch_id(branch_ids[i]);
			module.setType(type);
			module.setGrade(grade);
			module.setShortname(shortnames[i]);
			((ModuleService)AopContext.currentProxy()).create(module, path);
		}
		((ConfigurableApplicationContext)applicationContext).close();
	}
	
	public void modifyModules(Modules modules) {
		
		for (Module source : modules.getModules()) {
			((ModuleService)AopContext.currentProxy()).modify(source, this.moduleRepository.findOne(source.getId()), "", "edit");
		}
	}
	
	public Map<Integer, String> getModulesByIdInMappingIdAndName(Collection<Integer> moduleIds) {
		
		return mappingIdAndName(this.moduleRepository.findIdAndNameByIn(moduleIds));
	}
	
	public Map<Integer, String> mappingIdAndName(List<Object[]> modules) {
		
		Map<Integer, String> map = new HashMap<>();
		
		modules.forEach(list->map.put((Integer) list[0], list[1].toString()));
		
		return map;
	}
	
	public List<Module> getModuleTree(int productId, int branchId) {
		
		List<Module> modules;
		
		if (branchId == 0) {
			modules = this.moduleRepository.findByRootAndTypeOrderByBranch_idAscGradeDesc(productId, "story");
		} else {
			modules = this.moduleRepository.findByRootAndBranch_idAndTypeOrderByGradeDesc(productId, 0, "story");
			modules.addAll(this.moduleRepository.findByRootAndBranch_idAndTypeOrderByGradeDesc(productId, branchId, "story"));
		}		
		
//		List<Module> modules = this.moduleRepository.findByRootAndBranch_idAndTypeOrderByGradeDesc(productId, branchId, "story");
		
		List<Module> tree = new LinkedList<>();
		Map<Integer, String> branchMap = this.branchService.getBranchesByProductIdMappingIdAndName(productId);
		int parent;
		
		for (Module module : modules) {
			parent = module.getParent();
//			module.setBranchName(this.branchService.getBranchNameById(productId, module.getBranch_id()));
			module.setBranchName(branchMap.get(module.getBranch_id()));
			if (parent != 0) {
				modules.get(modules.indexOf(new Module(parent))).getChildren().add(module);
			} else {
				tree.add(module);
			}
		}
		
		return tree;
	}
	
	public Map<Integer, String> getModulesMappingIdAndName(int productId, int branchId) {
		
		List<Module> tree = getModuleTree(productId, branchId);
		Map<Integer, String> map = new LinkedHashMap<>();
		map.put(0, "/");
		
		iterateTree(tree, "", map);
		
		return map;
	}
	
	/*
	 * 遍历模块树
	 */
	private void iterateTree(List<Module> children, String name, Map<Integer, String> map) {
		String nameWithoutBranch, nameWithBranch,branchName;
		for (Module module : children) {
			nameWithoutBranch = name + "/" + module.getName();
			branchName = module.getBranchName();
			if (branchName.equals("") || branchName.equals("分支") || branchName.equals("平台")) {
				map.put(module.getId(), nameWithoutBranch);
			} else {
				nameWithBranch = branchName + nameWithoutBranch;
				map.put(module.getId(), nameWithBranch);
			}
			iterateTree(module.getChildren(), nameWithoutBranch, map);
		}
	}
}
