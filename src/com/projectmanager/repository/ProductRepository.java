package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Product;
import com.projectmanager.entity.User;

public interface ProductRepository extends CrudRepository<Product, Integer>{

	List<Product> findByStatusNotAndIdNot(String status, Integer id);
	
	List<Product> findByDeleted(String deleted);
	
	@Query(value="select distinct proj_product.id,proj_product.name,proj_product.status,proj_product.po from proj_product left join proj_projectproduct on proj_product.id = proj_projectproduct.product_id left join proj_team on proj_projectproduct.project_id = proj_team.project_id left join proj_project on proj_projectproduct.project_id = proj_project.id where (instr(concat(',',proj_product.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_product.acl = 'open' or proj_product.po = ?1 or proj_product.qd = ?1 or proj_product.rd = ?1 or proj_product.createdBy = ?1) and proj_product.name like %?2% order by proj_product.po = ?1 desc,id",nativeQuery=true)
	List<Object[]> findByPrivAndNameContaining(String account, String name);
	
	@Query(value="select distinct proj_product from proj_product left join proj_projectproduct on proj_product.id = proj_projectproduct.product_id left join proj_team on proj_projectproduct.project_id = proj_team.project_id left join proj_project on proj_projectproduct.project_id = proj_project.id where (instr(concat(',',proj_product.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_product.acl = 'open' or proj_product.po = ?1 or proj_product.qd = ?1 or proj_product.rd = ?1 or proj_product.createdBy = ?1) and proj_product.name like %?2% order by proj_product.po = ?1 desc,id",nativeQuery=true)
	List<Product> findByPrivAndName(String account, String name);
	
	@Query(value="select distinct A.id,A.name,A.sort from proj_product A left join proj_projectproduct B on A.id = B.product_id left join proj_team C on B.project_id = C.project_id left join proj_project D on B.project_id = D.id where (instr(concat(',',A.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or C.account = ?1 or A.acl = 'open' or A.po = ?1 or A.qd = ?1 or A.rd = ?1 or A.createdBy = ?1) and A.status != ?2 \n#pageable\n",
			countQuery="select count(distinct A.id) from proj_product A left join proj_projectproduct B on A.id = B.product_id left join proj_team C on B.project_id = C.project_id left join proj_project D on B.project_id = D.id where (instr(concat(',',A.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or C.account = ?1 or A.acl = 'open' or A.po = ?1 or A.qd = ?1 or A.rd = ?1 or A.createdBy = ?1) and A.status != ?2 \n#pageable\n",
			nativeQuery=true)
	Page<Object[]> findByPrivAndStatus(String account, String status, Pageable pageable);
	
	List<Product> findByIdIn(Integer[] ids);
	
	@Query(value="select distinct * from proj_product left join proj_projectproduct on proj_product.id = proj_projectproduct.product_id left join proj_team on proj_projectproduct.project_id = proj_team.project_id left join proj_project on proj_projectproduct.project_id = proj_project.id where (instr(concat(',',proj_product.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_product.acl = 'open' or proj_product.po = ?1 or proj_product.qd = ?1 or proj_product.rd = ?1 or proj_product.createdBy = ?1) and proj_product.status <>'closed'",nativeQuery=true)
	List<Product> findByPrivAccount(String account);
	
	/**
	 * @author 丽桃 2017-1-21
	 * 查找所有未删除的产品
	 * @return
	 */
	@Query("select p from Product p where p.deleted='0'")
	List<Product> findAllproduct();
}
