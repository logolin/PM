package com.projectmanager.service;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.entity.Build;
import com.projectmanager.entity.Doc;
import com.projectmanager.entity.Product;
import com.projectmanager.entity.Release;
import com.projectmanager.repository.DocRepository;
import com.projectmanager.repository.ProductRepository;

@Service
public class DocService {

	@Autowired
	protected DocRepository docRepository;
	
	@Autowired
	protected ProductRepository productRepository;
	
	public Doc created(Doc doc) {
		//根据文档类型来保存相应数据
		switch (doc.getType()) {
		case "file":
			doc.setUrl("");
			doc.setContent("");
			break;
		case "url":
			doc.setContent("");
			break;
		case "text":
			doc.setUrl("");
			break;
		default:
			break;
		}
		//还没session，所以添加者不能测试
		doc.setAddedBy("admin");
		return this.docRepository.save(doc);
	}

}
