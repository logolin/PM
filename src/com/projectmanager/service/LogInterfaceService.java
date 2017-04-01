package com.projectmanager.service;

public interface LogInterfaceService<T> {

	default void modify(T source, T target, String comment, String action) {
		
		MyUtil.copyProperties(source, target);
	}
}
