package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import com.projectmanager.entity.BaseBean;

/**
 * @Description: BaseBeanlRepository类用于将Story、Case、Bug类的共有字段封装以便复用
 */
@NoRepositoryBean
public interface BaseBeanlRepository<T extends BaseBean> extends CrudRepository<T, Integer>{

	/**
	 * @Description: 根据模块ID集合查找T对象并修改其模块ID
	 * @param module_id 模块ID
	 * @param module_ids 模块ID集合
	 * @return 被修改对象T的ID
	 */
	@Modifying
	@Query("update #{#entityName} t set t.module_id = ?1 where t.module_id in ?2")
	int setModule_idForByModule_idIn(Integer module_id, Integer[] module_ids);
	
	/**
	 * @Description: 根据模块ID集合查找T对象
	 * @param ids 模块ID集合
	 * @return 多个T对象
	 */
	@Query("select t from #{#entityName} t where t.module_id in ?1")
	List<T> findByModule_idIn(List<Integer> ids);
}
