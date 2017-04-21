package com.projectmanager.service;

import java.sql.Date;
import java.time.Clock;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Build;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Release;
import com.projectmanager.repository.BuildRepository;
import com.projectmanager.repository.ProductRepository;
import com.projectmanager.repository.ReleaseRepository;

@Service
public class ReleaseService implements LogInterfaceService<Release>{

	@Autowired
	private ProductRepository productRepository;
	
	@Autowired
	private ReleaseRepository releaseRepository;
	
	@Autowired
	private BuildRepository buildRepository;
	
	@Autowired
	private BuildService buildService;
	
	public Map<String, String> getFieldNameMap() {
		
		@SuppressWarnings("serial")
		Map<String, String> fieldNameMap = new HashMap<String, String>(){{
			put("product", "所属产品");
			put("branch_id", "所属平台/分支");
			put("build", "版本");
			put("date", "发布日期");
			put("name", "发布名称");
			put("status", "状态");
			put("stories", "相关需求");
			put("bugs", "已完成Bug");
			put("leftBugs", "剩余Bug");
			put("descript", "描述");
		}};
		
		return fieldNameMap;
	}
	
	public Release create(int productId, int branchId, Integer buildId, Release release) {
		
		Product product = this.productRepository.findOne(productId);
		Build tempBuild = new Build();
		Build build;
		
		if (buildId == null) {
			tempBuild.setName(release.getName());
			tempBuild.setProduct(product);
			tempBuild.setBranch_id(branchId);
			tempBuild.setProject_id(0);
			tempBuild.setDate(new Date(Clock.systemDefaultZone().millis()));
			build = this.buildService.create(tempBuild);
		} else {
			build = this.buildRepository.findOne(buildId);
		}
		
		release.setBuild(build);
		release.setBranch_id(branchId);
		release.setProduct(product);
		return this.releaseRepository.save(release);
	}
	
	public List<Release> getReleases(int productId, int branchId) {
		
		List<Release> releases = branchId == 0 ? this.releaseRepository.findByProductIdOrderByDate(productId) : this.releaseRepository.findByProductIdAndBranch_idOrderByDate(productId, branchId);
		
		return releases;
	}
	
	public Release getLastRelease(int productId, int branchId) {
		
		return this.releaseRepository.findFirstByProductAndBranch_idOrderByDate(productId, branchId);
	}
	
	public List<Release> getReleasesIncludeBranch0(int productId, int branchId) {
		
		List<Release> releases = getReleases(productId, branchId);
		if(branchId != 0) {
			releases.addAll(this.releaseRepository.findByProductIdAndBranch_idOrderByDate(productId, 0));
		}
		
		return releases;
	}
}
