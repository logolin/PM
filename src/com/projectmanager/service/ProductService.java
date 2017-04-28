package com.projectmanager.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Product;
import com.projectmanager.repository.ProductRepository;

/**
 * @Description: ProductService类封装了一些有关产品的操作
 */
@Service
public class ProductService implements LogInterfaceService<Product>{

	@Autowired
	private ProductRepository productRepository;
	
	/**
	 * @Description: 创建产品
	 * @param product 产品对象
	 * @return 已创建的产品对象
	 */
	public Product create(Product product) {
		
		product = this.productRepository.save(product);
		product.setSort(product.getId() * 5);
		
		return product;
	}
	
	/**
	 * @Description: 获取所有产品列名
	 * @return 列名集合
	 */
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("code", "产品代号");
			put("po", "产品负责人");
			put("qd", "测试负责人");
			put("rd", "发布负责人");
			put("name", "产品名称");
			put("status", "状态");
			put("type", "产品类型");
			put("descript", "产品描述");
			put("acl", "访问控制");
			put("whitelist", "白名单");
		}};
		
		return fieldNameMap;
	}
}
