package com.projectmanager.repository;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Module;

public interface ModuleRepository extends CrudRepository<Module, Integer> {

	@Query("select m from Module m where m.root = ?1 and m.branch_id = ?2 and m.type = ?3 order by m.grade desc")
	List<Module> findByRootAndBranch_idAndTypeOrderByGradeDesc(Integer root, Integer branch_id, String type);
	
	@Query("select m from Module m where m.root = ?1 and m.type = ?2 order by m.branch_id asc, m.grade desc")
	List<Module> findByRootAndTypeOrderByBranch_idAscGradeDesc(Integer root, String type);
	
	@Query("select m.id,m.name from Module m where m.id in ?1")
	List<Object[]> findIdAndNameByIn(Collection<Integer> moduleIds);
	
	List<Module> findByRootAndParent(Integer root, Integer parent);
	
	@Query("select m from Module m where m.root = ?1 and m.branch_id = ?2 and m.parent = 0")
	List<Module> findByRootAndBranch_id(Integer root, Integer branch_id);
	
	@Query("select m.path from Module m where m.id = ?1")
	String findPathBy(Integer id);
	
	//由产品id查找模块
	List<Module> findByRoot(Integer productId);
	
	@Query("select m.id from Module m where m.path like %?1%")
	Integer[] findIdByPathContaining(String path);
	
	void deleteByIdIn(Integer[] ids);
}
