package com.projectmanager.entity;

import java.util.List;

import org.springframework.util.AutoPopulatingList;

public class Products {

	private List<Product> products = new AutoPopulatingList<Product>(Product.class);

	public List<Product> getProducts() {
		return products;
	}

	public void setProducts(List<Product> products) {
		this.products = products;
	}
}
