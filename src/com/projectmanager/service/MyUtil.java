package com.projectmanager.service;

import java.beans.FeatureDescriptor;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Stream;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

public final class MyUtil {

	public static void copyProperties(Object source, Object target) {
		
		BeanWrapper wrappedSource = new BeanWrapperImpl(source);
		String[] nullPropertyNames = Stream.of(wrappedSource.getPropertyDescriptors())
		            .map(FeatureDescriptor::getName)
		            .filter(propertyName -> wrappedSource.getPropertyValue(propertyName) == null)
		            .toArray(String[]::new);
		
		BeanUtils.copyProperties(source, target, nullPropertyNames);
	}
	
	public static List<Integer> convertStrToList(String splitStr, String splitChar) {
		
		if (splitStr == null) 
			splitStr = "";
			
		List<Integer> list = new LinkedList<Integer>();
		list.add(0);       //Story view的childstories需要0
		
		Stream.of(splitStr.split(splitChar)).forEach(a->{if(!a.equals("")) list.add(Integer.valueOf(a));});
	
		return list;
	}
	
	public static Integer[] convertStrToArr(String splitStr, String splitChar) {
		
		List<Integer> list = convertStrToList(splitStr, splitChar);
		
		return list.toArray(new Integer[list.size()]);
	}
}
