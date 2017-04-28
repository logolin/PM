package com.projectmanager.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.projectmanager.entity.Branch;
import com.projectmanager.entity.BranchMap;
import com.projectmanager.entity.Product;
import com.projectmanager.repository.BranchRepository;
import com.projectmanager.repository.ProductRepository;

/**
 * @Description: BranchService类封装了一些有关分支的操作
 */
@Service
@Transactional
public class BranchService implements LogInterfaceService<Branch>{

	@Autowired
	private BranchRepository branchRepository;
	
	@Autowired
	private ProductRepository productRepository;
	
	/**
	 * @Description: 获取分支的所有列名
	 * @return 列名集合
	 */
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("product", "所属产品");
			put("name", "名称");
		}};
		
		return fieldNameMap;
	}
	
	/**
	 * @Description: 创建分支
	 * @param product 所属产品
	 * @param name 分支名称
	 * @return 已创建的分支对象
	 */
	public Branch create(Product product, String name) {
		
		Branch branch = new Branch();
		branch.setProduct(product);
		branch.setName(name);
		return this.branchRepository.save(branch);
	}
	
	/**
	 * @Description: 创建和修改分支
	 * @param productId 所属产品对象
	 * @param newbranch 创建的分支名称
	 * @param modifiedBranch 修改的分支名称
	 */
	public void createAndUpadateBranch(int productId, String newbranch[], BranchMap modifiedBranch) {
		
		Product product = this.productRepository.findOne(productId);
		Branch source = new Branch();
		
		for (String newBranchName : newbranch) {
			if (!newBranchName.equals(""))
				((BranchService)AopContext.currentProxy()).create(product, newBranchName);
		}
		
		modifiedBranch.getBranch().forEach((a,b)->{
			source.setName(b);
			((BranchService)AopContext.currentProxy()).modify(source, this.branchRepository.findOne(a), "", "edit");
		});			
	}
	
	/**
	 * @Description: 获取对应分支ID的分支名称
	 * @param productId 所属产品ID
	 * @param branchId 分支ID
	 * @return 分支名称
	 */
	public String getBranchNameById(int productId, int branchId) {
		
		Product product = this.productRepository.findOne(productId);
		
		if(branchId == 0) {
			if (product.getType().equals("platform")) {
				return "所有平台";
			} else {
				return "所有分支";
			}
		} else {
			return this.branchRepository.findOne(branchId).getName();	
		}
	}
	
	/**
	 * @Description: 获取某产品下的分支ID和分支名称集合
	 * @param productId 所属产品ID
	 * @return 分支ID和分支名称的映射集合
	 */
	public Map<Integer, String> getBranchesByProductIdMappingIdAndName(Integer productId) {
		
		Map<Integer, String> map = new HashMap<Integer, String>();
		String productType = this.productRepository.findOne(productId).getType();
		List<Object[]> list = this.branchRepository.findIdAndNameByProductId(productId);
		if (productType.equals("branch")) {
			map.put(0, "分支");
		} else if (productType.equals("platform")) {
			map.put(0, "平台");
		} else {
			map.put(0, "");
		}
		for (Object[] branch : list) {
			map.put((Integer) branch[0], branch[1].toString());
		}
		
		return map;
	}
}
