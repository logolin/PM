package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.GroupPriv;

public interface GroupPrivRepository extends CrudRepository<GroupPriv, Integer> {

	/**
	 * 根据groupId查找分组权限
	 * @param groupId
	 * @return
	 */
	List<GroupPriv> findByGroupId(Integer groupId);
	
	/**
	 * 根据分组id数组查找分组权限
	 * @param groupIds
	 * @return
	 */
	List<GroupPriv> findByGroupIdIn(List<Integer> groupIds);
	
	/**
	 * 删除分组权限
	 * @param groupId
	 */
	void deleteByGroupId(Integer groupId);
	
	/**
	 * 根据modue和groupId查找权限
	 * @param module
	 * @return
	 */
	List<GroupPriv> findByModuleAndGroupId(String module, Integer groupId);
	
	@Query("select g.module,g.method from GroupPriv g where g.group.id in?1")
	List<Object[]> findAllModuleAndMethodBygroupIdIn(List<Integer> groupId);
	
	/**
	 * 根据groupId返回module和method
	 * @param groupId
	 * @return
	 */
	@Query("select g.module,g.method from GroupPriv g where g.group.id =?1")
	List<Object[]> findAllModuleAndMethodBygroupId(Integer groupId);
	
	/**
	 * 根据groupId和module数组删除权限
	 * @param groupId
	 * @param module
	 */
	void deleteByGroupIdAndModuleIn(Integer groupId, List<String> module);
}
