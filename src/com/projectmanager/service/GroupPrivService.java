package com.projectmanager.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.GroupPriv;
import com.projectmanager.repository.GroupPrivRepository;
import com.projectmanager.repository.GroupRepository;

@Service
public class GroupPrivService {

	@Autowired
	private GroupPrivRepository groupPrivRepository;
	
	@Autowired
	private GroupRepository groupRepository;
	
	
	/**
	 * 根据几个groupId查找所有的module和method
	 * @param groupId
	 * @return
	 */
	
	public Map<String, String> getAllModuleAndMethod(List<Integer> groupId) {
		
		return mappingModuleAndMethod(this.groupPrivRepository.findAllModuleAndMethodBygroupIdIn(groupId));
	}
	
	/**
	 * 返回map
	 * @param grouppris
	 * @return
	 */
	public Map<String, String> mappingModuleAndMethod(List<Object[]> grouppris) {
		
		Map<String, String> map = new HashMap<String, String>();
		
		Iterator<Object[]> it = grouppris.iterator();
		
		Object[] grouppri;
		
		while (it.hasNext()) {
			grouppri = it.next();
			map.put(grouppri[0].toString()+":"+grouppri[1].toString(), "have");
		}
		
		return map;
	}
	
	/**
	 * 权限维护
	 * @param groupId （分组id）
	 * @param status （状态）
	 * @param actions （已选权限字符型数组）
	 */
	public void managePriv(int groupId, String status, String[] actions) {
		
		//根据groupId和status清空原有权限
		this.deleteByModuleAndGroupId(groupId, status);
		//判断是否选中权限，选中权限才执行下面保存权限操作
		if(actions != null) {
			//添加权限
			for(String priv : actions) {
				List<String> modmeth = new ArrayList<String>();
				//以"-"分割前端传来的module和method
				for(String method : priv.split("-")) {
					modmeth.add(method);
				}
				//分组权限对象
				GroupPriv gpriv = new GroupPriv();
				//赋值给分组权限
				gpriv.setGroup(this.groupRepository.findOne(groupId));
				gpriv.setModule(modmeth.get(0));
				gpriv.setMethod(modmeth.get(1));
				//保存分组权限
				this.groupPrivRepository.save(gpriv);
			}
		}
	}
	
	/**
	 * 根据groupId和status清空原有权限
	 * @param groupId （分组id）
	 * @param status （状态：产品、项目等等）
	 */
	public void deleteByModuleAndGroupId(int groupId, String status) {
		
		//根据状态添加对应的module，再根据module来删除权限
		List<String> moduleList = new ArrayList<String>();
		switch (status) {
		//"所有"权限（数据库有些暂时没用到，就不添加全部权限了）
		case "all":
//			moduleList = this.permissionRepository.findAllModule();
			moduleList.add("product");
			moduleList.add("story");
			moduleList.add("productplan");
			moduleList.add("release");
			moduleList.add("branch");
			moduleList.add("build");
			moduleList.add("task");
			moduleList.add("project");
			moduleList.add("bug");
			moduleList.add("case");
			moduleList.add("testtask");
			moduleList.add("company");
			moduleList.add("dept");
			moduleList.add("group");
			moduleList.add("user");
			break;
		//产品权限
		case "product":
			moduleList.add("product");
			moduleList.add("story");
			moduleList.add("productplan");
			moduleList.add("release");
			moduleList.add("branch");
			
			break;
		//项目权限
		case "project":
			moduleList.add("build");
			moduleList.add("task");
			moduleList.add("project");
			
			break;
		//测试权限
		case "qa":
			moduleList.add("bug");
			moduleList.add("case");
			moduleList.add("testtask");
			
			break;
		//组织权限
		case "company":
			moduleList.add("company");
			moduleList.add("dept");
			moduleList.add("group");
			moduleList.add("user");
			
			break;

		default:
			break;
		}
		
		//删除权限
		this.groupPrivRepository.deleteByGroupIdAndModuleIn(groupId, moduleList);
	}
}
