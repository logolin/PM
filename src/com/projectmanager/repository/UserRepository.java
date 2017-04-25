package com.projectmanager.repository;

import java.util.Collection;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.User;

public interface UserRepository extends CrudRepository<User, Integer> {

	/**
	 * 根据用户名查找真实姓名
	 * @param account 用户名
	 * @return 真实姓名
	 */
	@Query("select u.realname from User u where u.account = ?1")
	String findRealnameByAccount(String account);
	
//	List<User> findByAccount(String account);
	
	/**
	 * 根据用户名数组查找用户list
	 * @param account
	 * @return
	 */
	List<User> findByAccountIn(Integer[] account);
	
	/**
	 * 根据用户名查找用户
	 * @param account
	 * @return
	 */
	User findByAccount(String account);
	
	/**
	 * 根据多个用户名查找用户名和真实姓名
	 * @param accounts 多个用户名
	 * @return 用户名和真实姓名
	 */
	@Query("select u.account,u.realname from User u where u.account in ?1")
	List<Object[]> findAcountAndRealnameByAccountIn(Collection<String> accounts);
	
	/**
	 * 查找所有用户名和真实姓名
	 * @return 用户名和真实姓名
	 */
	@Query("select u.account,u.realname from User u")
	List<Object[]> findAllAccountAndRealname();
	
	/**
	 * 查找所有未删除用户
	 * @param pageable
	 * @return
	 */
	@Query("select u from User u where u.deleted='0'")
	Page<User> findAllUser(Pageable pageable);
	
	/**
	 * @Description: 查找所有用户
	 * @return 所有用户
	 */
	@Query("select u from User u where u.deleted='0'")
	List<User> findAllUser();
	
	/**
	 * 根据部门查找未删除用户
	 * @param deptId
	 * @param pageable
	 * @return
	 */
	@Query("from User u where u.dept_id=?1 and u.deleted='0'")
	Page<User> findByDept(Integer deptId, Pageable pageable);
	
	/**
	 * @Description: 根据部门ID查找用户
	 * @param deptId 部门ID
	 * @return 用户
	 */
	@Query("from User u where u.dept_id=?1 and u.deleted='0'")
	List<User> findByDept(Integer deptId);
	/**
	 * 删除用户
	 * @param userId
	 */
	@Modifying
	@Query("update User u set u.deleted='1' where u.id=?1")
	void deletedUser(Integer userId);
	
	/**
	 * 根据userids查找userlist
	 * @param userIds
	 * @return
	 */
	List<User> findByIdIn(Integer[] userIds);
	
	/**
	 * 根据openId查找用户
	 * @param openId
	 * @return
	 */
	User findByOpenId(String openId);
	
	/**
	 * @Description: 根据多个用户名查找不为空的email
	 * @param accounts 多个账号
	 * @return 多个email
	 */
	@Query("select u.email from User u where u.account in ?1 and u.email != ''")
	List<String> findEmailByAccountIn(List<String> accounts);
	
}
