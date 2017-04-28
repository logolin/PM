package com.projectmanager.service;

/**
 * @author li
 * @Description: LogInterfaceService接口用于作为记录操作记录的AOP切面
 * @param <T>
 */
public interface LogInterfaceService<T> {

	default void modify(T source, T target, String comment, String action) {
		
		MyUtil.copyProperties(source, target);
	}
}
