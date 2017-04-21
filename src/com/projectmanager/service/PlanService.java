package com.projectmanager.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Plan;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProductRepository;

@Service
public class PlanService implements LogInterfaceService<Plan>{

	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("product", "所属产品");
			put("branch_id", "所属平台/分支");
			put("begin", "开始日期");
			put("end", "结束日期");
			put("title", "名称");
			put("descript", "描述");
		}};
		
		return fieldNameMap;
	}
	
	public Plan create(int productId, Plan plan) {
		
		plan.setProduct(this.productRepository.findOne(productId));
		
		return this.planRepository.save(plan);
	}

	public List<Plan> getPlans(int productId, int branchId) {
		
		List<Plan> plans = branchId == 0 ? this.planRepository.findByProductIdOrderByBegin(productId) : this.planRepository.findByProductIdAndBranch_idIsZeroOrOrderByBegin(productId, branchId);
		
		return plans;
	}
	
	/*
	 * 获取未过期计划
	 */
	public List<Plan> getUnexpiredPlans(int productId, int branchId) {
		
		List<Plan> plans = branchId == 0 ? this.planRepository.findByProductIdAndEndAfterTodayOrderByBegin(productId) : this.planRepository.findByProductIdAndBranch_idInAndEndAfterTodayOrderByBegin(productId, branchId);
		
		return plans;
	}
	
	public Map<Integer, String> getPlansMappingIdAndTitle(int productId, int branchId) {
		
		Map<Integer, String> map = new HashMap<>();
		List<Plan> list = getPlans(productId, branchId);
		list.forEach(item->map.put(item.getId(), item.getTitle()));
		
		return map;
	}
}
