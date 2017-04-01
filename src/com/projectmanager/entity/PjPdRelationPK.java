package com.projectmanager.entity;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Embeddable
public class PjPdRelationPK implements Serializable{

	public static final long serialVersionUID = 1L;
	
	@ManyToOne
	@JoinColumn(name="project_id",referencedColumnName="id")
	private Project project;

	@ManyToOne
	private Product product;
	
	@Override
	public boolean equals(Object o) {
		if(this == o) return true;
		if(!(o instanceof PjPdRelationPK)) return false;
		
		PjPdRelationPK pjPdRelationPK = (PjPdRelationPK) o;
		return Objects.equals(pjPdRelationPK.project, project) && Objects.equals(pjPdRelationPK.product, product);
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(project,product);
	}	

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}
	
}
