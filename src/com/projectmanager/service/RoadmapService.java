package com.projectmanager.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Plan;
import com.projectmanager.entity.Release;

/**
 * @Description: RoadmapService类主要是生成路线图所需的数据Map
 */
@Service
public class RoadmapService {

	@Autowired
	private PlanService planService;
	
	@Autowired
	private ReleaseService releaseService;
	
	/**
	 * @Description: 生成多层结构Map路线图，第一层Map键为年份，值为Map，第二层Map键为分支ID，值为计划对象集合或发布对象集合
	 * @param productId 产品ID
	 * @param branchId 分支ID
	 * @return
	 */
	public Map<String, Map<Integer,List<Object>>> generateRoadmap(int productId, int branchId) {
		
		Map<String, Map<Integer,List<Object>>> roadmap = new LinkedHashMap<String, Map<Integer,List<Object>>>();
		List<Object> tempList = new ArrayList<Object>();
		Map<Integer, List<Object>> tempMap = new HashMap<Integer, List<Object>>();
		List<Plan> plans = this.planService.getPlans(productId, branchId);
		List<Release> releases = this.releaseService.getReleases(productId, branchId);
		Integer branch_id;  //branchName
		String year;	
		
		for (Release release : releases) {
			//获得发布的发布年份用作第一层的键，值则是分支名称和发布或计划对象的键值对Map
			year = release.getDate().toString().substring(0, 4);
			branch_id = release.getBranch_id();
			if (roadmap.containsKey(year)) {
				if (roadmap.get(year).containsKey(branch_id)) {
					roadmap.get(year).get(branch_id).add(release);
				} else {
					tempList = new ArrayList<Object>();
					tempList.add(release);		
					roadmap.get(year).put(branch_id, tempList);
				}
			} else {
				tempMap = new HashMap<Integer, List<Object>>();
				tempList = new ArrayList<Object>();
				tempList.add(release);
				tempMap.put(branch_id, tempList);
				roadmap.put(year, tempMap);
			}
		}
		
		for (Plan plan : plans) {
			year = plan.getEnd().toString().substring(0, 4);
			branch_id = plan.getBranch_id();
			if (roadmap.containsKey(year)) {
				if (roadmap.get(year).containsKey(branch_id)) {
					roadmap.get(year).get(branch_id).add(plan);
				} else {
					tempList = new ArrayList<Object>();
					tempList.add(plan);		
					roadmap.get(year).put(branch_id, tempList);
				}
			} else {
				tempMap = new HashMap<Integer, List<Object>>();
				tempList = new ArrayList<Object>();
				tempList.add(plan);
				tempMap.put(branch_id, tempList);
				roadmap.put(year, tempMap);
			}			
		}
		
		return roadmap;
	}
}
