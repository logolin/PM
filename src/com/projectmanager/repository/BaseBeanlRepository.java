package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import com.projectmanager.entity.BaseBean;

@NoRepositoryBean
public interface BaseBeanlRepository<T extends BaseBean> extends CrudRepository<T, Integer>{

	@Modifying
	@Query("update #{#entityName} t set t.module_id = ?1 where t.module_id in ?2")
	int setModule_idForByModule_idIn(Integer module_id, Integer[] module_ids);
	
	@Query("select t from #{#entityName} t where t.module_id in ?1")
	List<T> findByModule_idIn(List<Integer> ids);
}
