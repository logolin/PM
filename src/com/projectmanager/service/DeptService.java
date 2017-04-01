package com.projectmanager.service;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.projectmanager.entity.Dept;
import com.projectmanager.repository.DeptRepository;

@Service
@Transactional
public class DeptService {

	@Autowired
	private DeptRepository deptRepository;
	
	/**
	 * 返回部门树
	 * @return
	 */
	public List<Dept> getDept() {
		
		//查找所有部门
		List<Dept> deptList = (List<Dept>) this.deptRepository.findAll();
		//部门树
		List<Dept> tree = new LinkedList<>();
		//上一级部门id
		int parent;
		for(Dept dept : deptList) {
			//获得上一级部门id赋值给parent
			parent = dept.getParent();
			//判断有没有上级部门
			if(parent != 0) {
				//连接上级部门，使其可以使用个getChildren取得该部门
				deptList.get(deptList.indexOf(new Dept(parent))).getChildren().add(dept);
			} else {
				tree.add(dept);
			}
		}
		return tree;
	}
	
	/**
	 * 编辑部门
	 * @param source （修改后的部门）
	 * @param target （修改前的部门）
	 * @param comment （备注）
	 * @param action （操作）
	 */
	public void alter(Dept source, Dept target, String comment, String action) {
		
		//编辑部门
		MyUtil.copyProperties(source, target);
	}
	
	/**
	 * 创建部门
	 * @param deptId (上级部门id)
	 * @param dept （新创建部门）
	 * @param model
	 */
	public void created(Integer deptId, Dept dept) {
		
		//创建部门
		this.deptRepository.save(dept);
		//默认sort的值等于id的5倍
		dept.setSort(dept.getId()*5);
		//判断创建的部门是否有上级部门
		if(deptId != 0) {
			//获得上级部门
			Dept updateDept = this.deptRepository.findOne(deptId);
			//grade是上级部门的grade + 1
			dept.setGrade(updateDept.getGrade() + 1);
			dept.setPath(updateDept.getPath() + dept.getId() + ",");
			
		} else {
			//没有上级部门，此部门就是1级部门
			dept.setGrade(1);
			dept.setPath("," + dept.getId() +",");
		}
	}
}
