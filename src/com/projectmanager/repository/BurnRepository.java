package com.projectmanager.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Burn;
import com.projectmanager.entity.BurnPK;
import com.projectmanager.entity.Project;

public interface BurnRepository extends CrudRepository<Burn, BurnPK>{

	
	List<Burn> findByIdProject(Project project);
	
	/**
	 * 根据project按日期升序查找burnlist
	 * @param project
	 * @return List<Burn>
	 */
	List<Burn> findByIdProjectOrderByIdDateAsc(Project project);
}
