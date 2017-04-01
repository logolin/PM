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

@Service
public class RoadmapService {

	@Autowired
	private PlanService planService;
	
	@Autowired
	private ReleaseService releaseService;
	
	/*
	 * 获取路线图
	 */
	public Map<String, Map<Integer,List<Object>>> getRoadmap(int productId, int branchId) {
		
		Map<String, Map<Integer,List<Object>>> roadmap = new LinkedHashMap<String, Map<Integer,List<Object>>>();
		List<Object> tempList = new ArrayList<Object>();
		Map<Integer, List<Object>> tempMap = new HashMap<Integer, List<Object>>();
		List<Plan> plans = this.planService.getPlans(productId, branchId);
		List<Release> releases = this.releaseService.getReleases(productId, branchId);
		Integer branch_id;  //branchName
		String year;	
		
		for (Release release : releases) {
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
