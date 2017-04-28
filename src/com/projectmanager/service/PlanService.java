package com.projectmanager.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Plan;
import com.projectmanager.repository.PlanRepository;
import com.projectmanager.repository.ProductRepository;

/**
 * @Description: PlanService类封装了一些有关产品计划的操作
 */
@Service
public class PlanService implements LogInterfaceService<Plan>{

	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private PlanRepository planRepository;
	
	/**
	 * @Description: 获取产品计划的所有列名集合
	 * @return 所有列名集合
	 */
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
	
	/**
	 * @Description: 创建产品计划
	 * @param productId 产品ID
	 * @param plan 产品对象
	 * @return 已创建的产品计划对象
	 */
	public Plan create(int productId, Plan plan) {
		
		plan.setProduct(this.productRepository.findOne(productId));
		
		return this.planRepository.save(plan);
	}

	/**
	 * @Description: 获取多个产品计划
	 * @param productId 产品ID
	 * @param branchId 分支ID
	 * @return 多个产品计划对象集合
	 */
	public List<Plan> getPlans(int productId, int branchId) {
		
		List<Plan> plans = branchId == 0 ? this.planRepository.findByProductIdOrderByBegin(productId) : this.planRepository.findByProductIdAndBranch_idIsZeroOrOrderByBegin(productId, branchId);
		
		return plans;
	}
	
	/**
	 * @Description: 获取未过期的多个产品集合
	 * @param productId 产品ID
	 * @param branchId 分支ID
	 * @return 多个产品集合
	 */
	public List<Plan> getUnexpiredPlans(int productId, int branchId) {
		
		List<Plan> plans = branchId == 0 ? this.planRepository.findByProductIdAndEndAfterTodayOrderByBegin(productId) : this.planRepository.findByProductIdAndBranch_idInAndEndAfterTodayOrderByBegin(productId, branchId);
		
		return plans;
	}
	
	/**
	 * @Description: 获取计划ID与计划标题映射集合
	 * @param productId 产品ID
	 * @param branchId 分支ID
	 * @return 计划ID与计划标题映射集合
	 */
	public Map<Integer, String> getPlansMappingIdAndTitle(int productId, int branchId) {
		
		Map<Integer, String> map = new HashMap<>();
		List<Plan> list = getPlans(productId, branchId);
		list.forEach(item->map.put(item.getId(), item.getTitle()));
		
		return map;
	}
}
