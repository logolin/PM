package com.projectmanager.entity;

import java.sql.Date;

import javax.persistence.*;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.fasterxml.jackson.annotation.JsonView;


@Entity
@DynamicUpdate
@DynamicInsert
@Table(name="proj_productplan")
public class Plan implements Log{
	
	public interface Public{};
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@JsonView(Public.class)
	private Integer id;	
	
	@ManyToOne
	private Product product;
	
	@JsonView(Public.class)
	private Integer branch_id;
	
	@JsonView(Public.class)
	private String title;
	
	private String descript;
	
	@JsonView(Public.class)
	private Date begin;
	
	@JsonView(Public.class)
	private Date end;
	
	private String deleted;
	
	@Transient
	private String branchName;

	public Plan() {
		
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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescript() {
		return descript;
	}

	public void setDescript(String descript) {
		this.descript = descript;
	}

	public Date getBegin() {
		return begin;
	}

	public void setBegin(Date begin) {
		this.begin = begin;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	public Integer getBranch_id() {
		return branch_id;
	}

	public void setBranch_id(Integer branch_id) {
		this.branch_id = branch_id;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
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
