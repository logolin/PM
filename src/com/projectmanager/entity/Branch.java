package com.projectmanager.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonView;

@Entity
@Table(name="proj_branch")
public class Branch implements Log{
	
	public interface Public{};
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@JsonView(Public.class)
	private Integer id;
	
	@ManyToOne
	private Product product;
	
	@JsonView(Public.class)
	private String name;
	
	private String deleted;
	
	public Branch() {
		this.deleted = "0";
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	@Override
	public int OverrideGetId() {
		return this.id;
	}

	@Override
	public int overrideGetProductId() {
		return this.product.getId();
	}
}
