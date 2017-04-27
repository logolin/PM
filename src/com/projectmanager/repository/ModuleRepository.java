package com.projectmanager.repository;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Module;

/**
 * @Description: ModuleRepository类用于操作数据库的产品计划表，类方法返回值一般为多个模块对象，特殊情况在方法注释说明
 */
public interface ModuleRepository extends CrudRepository<Module, Integer> {

	/**
	 * @Description: 根据根模块ID和分支ID、模块类型查找模块并按模块层级降序排序
	 * @param root 根模块ID，例如产品ID或项目ID
	 * @param branch_id 分支ID
	 * @param type 模块类型
	 * @return
	 */
	@Query("select m from Module m where m.root = ?1 and m.branch_id = ?2 and m.type = ?3 order by m.grade desc")
	List<Module> findByRootAndBranch_idAndTypeOrderByGradeDesc(Integer root, Integer branch_id, String type);
	
	/**
	 * @Description: 根据根模块ID和模块类型查找模块并按模块层级降序排序
	 * @param root 根模块ID，例如产品ID或项目ID
	 * @param type 模块类型
	 * @return 
	 */
	@Query("select m from Module m where m.root = ?1 and m.type = ?2 order by m.branch_id asc, m.grade desc")
	List<Module> findByRootAndTypeOrderByBranch_idAscGradeDesc(Integer root, String type);
	
	/**
	 * @Description: 根据模块ID集合查找模块ID和模块名称
	 * @param moduleIds 模块ID集合
	 * @return 模块ID和模块名称
	 */
	@Query("select m.id,m.name from Module m where m.id in ?1")
	List<Object[]> findIdAndNameByIn(Collection<Integer> moduleIds);
	
	/**
	 * @Description: 根据根模块ID和上级模块ID、模块类型查找模块
	 * @param root 根模块ID，例如产品ID或项目ID
	 * @param parent 上级模块ID
	 * @param type 模块类型
	 * @return
	 */
	List<Module> findByRootAndParentAndType(Integer root, Integer parent, String type);
	
	/**
	 * @Description: 根据根模块ID和分支ID、模块类型查找最上级模块
	 * @param root 根模块ID，例如产品ID或项目ID
	 * @param branch_id 分支ID
	 * @param type 模块类型
	 * @return
	 */
	@Query("select m from Module m where m.root = ?1 and m.branch_id = ?2 and m.parent = 0 and m.type = ?3")
	List<Module> findByRootAndBranch_idAndType(Integer root, Integer branch_id, String type);
	
	/**
	 * @Description: 根据模块ID查找模块路径
	 * @param id 模块ID
	 * @return 模块路径
	 */
	@Query("select m.path from Module m where m.id = ?1")
	String findPathBy(Integer id);
	
	/**
	 * @Description: 根据模块路径查找模块路径包含目标模块路径的模块
	 * @param path 目标模块路径
	 * @return
	 */
	@Query("select m.id from Module m where m.path like %?1%")
	Integer[] findIdByPathContaining(String path);
	
	/**
	 * @Description: 根据模块ID集合删除模块
	 * @param ids 模块ID集合
	 */
	void deleteByIdIn(Integer[] ids);
}
