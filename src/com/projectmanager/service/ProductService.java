package com.projectmanager.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Product;
import com.projectmanager.repository.ProductRepository;

@Service
public class ProductService implements LogInterfaceService<Product>{

	@Autowired
	private ProductRepository productRepository;
	
	public Product create(Product product) {
		
		product = this.productRepository.save(product);
		product.setSort(product.getId() * 5);
		
		return product;
	}
	
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
