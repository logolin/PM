package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Product;

/**
 * @Description: ProductRepository类用于操作数据库的产品表，类方法返回值一般为多个产品对象，特殊返回值在方法注释说明
 */
public interface ProductRepository extends CrudRepository<Product, Integer>{

	/**
	 * @Description: 根据产品状态和产品ID查找状态和ID不是参数值的产品
	 * @param status 状态
	 * @param id 产品ID
	 * @return
	 */
	List<Product> findByStatusNotAndIdNot(String status, Integer id);
	
	List<Product> findByDeleted(String deleted);
	
	/**
	 * @Description: 根据用户名和产品名称查找该用户有权限的产品ID和产品名称、产品状态、产品负责人
	 * @param account 用户名
	 * @param name 产品名称
	 * @return 产品ID和产品名称、产品状态、产品负责人
	 */
	@Query(value="select distinct proj_product.id,proj_product.name,proj_product.status,proj_product.po from proj_product left join proj_projectproduct on proj_product.id = proj_projectproduct.product_id left join proj_team on proj_projectproduct.project_id = proj_team.project_id left join proj_project on proj_projectproduct.project_id = proj_project.id where (instr(concat(',',proj_product.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_product.acl = 'open' or proj_product.po = ?1 or proj_product.qd = ?1 or proj_product.rd = ?1 or proj_product.createdBy = ?1) and proj_product.name like %?2% order by proj_product.po = ?1 desc,id",nativeQuery=true)
	List<Object[]> findByPrivAndNameContaining(String account, String name);
	
	/**
	 * @Description: 根据用户名和产品名称查找该用户有权限的产品
	 * @param account 用户名
	 * @param name 产品名称
	 * @return
	 */
	@Query(value="select distinct proj_product from proj_product left join proj_projectproduct on proj_product.id = proj_projectproduct.product_id left join proj_team on proj_projectproduct.project_id = proj_team.project_id left join proj_project on proj_projectproduct.project_id = proj_project.id where (instr(concat(',',proj_product.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or proj_team.account = ?1 or proj_product.acl = 'open' or proj_product.po = ?1 or proj_product.qd = ?1 or proj_product.rd = ?1 or proj_product.createdBy = ?1) and proj_product.name like %?2% order by proj_product.po = ?1 desc,id",nativeQuery=true)
	List<Product> findByPrivAndName(String account, String name);
	
	/**
	 * @Description: 根据用户名和产品状态查找该用户有权限的产品ID、产品名称、产品序号并进行分页排序
	 * @param account 用户名
	 * @param status 产品状态
	 * @param pageable 分页条件
	 * @return 产品ID、产品名称、产品序号
	 */
	@Query(value="select distinct A.id,A.name,A.sort from proj_product A left join proj_projectproduct B on A.id = B.product_id left join proj_team C on B.project_id = C.project_id left join proj_project D on B.project_id = D.id where (instr(concat(',',A.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or C.account = ?1 or A.acl = 'open' or A.po = ?1 or A.qd = ?1 or A.rd = ?1 or A.createdBy = ?1) and A.status != ?2 \n#pageable\n",
			countQuery="select count(distinct A.id) from proj_product A left join proj_projectproduct B on A.id = B.product_id left join proj_team C on B.project_id = C.project_id left join proj_project D on B.project_id = D.id where (instr(concat(',',A.whitelist,','),concat(',',(select proj_group.id from proj_group inner join proj_user on proj_group.role = proj_user.role where proj_user.account = ?1),',')) > 0 or C.account = ?1 or A.acl = 'open' or A.po = ?1 or A.qd = ?1 or A.rd = ?1 or A.createdBy = ?1) and A.status != ?2 \n#pageable\n",
			nativeQuery=true)
	Page<Object[]> findByPrivAndStatus(String account, String status, Pageable pageable);
	
	/**
	 * @Description: 根据产品ID集合查找不在集合中的产品
	 * @param ids 产品ID集合
	 * @return
	 */
	List<Product> findByIdIn(Integer[] ids);
	
	/**
	 * @Description: 根据用户名查找有权限的产品
	 * @param account 用户名
	 * @return
	 */
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
