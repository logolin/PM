package com.projectmanager.service;

import java.beans.FeatureDescriptor;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Stream;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

/**
 * @author li
 * @Description: MyUti类封装了合并对象以及对字符串的一些操作
 */
public final class MyUtil {

	/**
	 * @Description: 将两个对象非Null属性合并
	 * @param source 源对象
	 * @param target 目标对象
	 */
	public static void copyProperties(Object source, Object target) {
		
		BeanWrapper wrappedSource = new BeanWrapperImpl(source);
		String[] nullPropertyNames = Stream.of(wrappedSource.getPropertyDescriptors())
		            .map(FeatureDescriptor::getName)
		            .filter(propertyName -> wrappedSource.getPropertyValue(propertyName) == null)
		            .toArray(String[]::new);
		
		BeanUtils.copyProperties(source, target, nullPropertyNames);
	}
	
	/**
	 * @Description: 将字符串分割成整型集合
	 * @param splitStr 被分隔字符串
	 * @param splitChar 分隔符
	 * @return 整型集合
	 */
	public static List<Integer> convertStrToList(String splitStr, String splitChar) {
		
		if (splitStr == null) 
			splitStr = "";
			
		List<Integer> list = new LinkedList<Integer>();
		list.add(0);       //Story view的childstories需要0
		
		Stream.of(splitStr.split(splitChar)).forEach(a->{if(!a.equals("")) list.add(Integer.valueOf(a));});
	
		return list;
	}
	
	/**
	 * @Description: 将字符串分割成整型数组
	 * @param splitStr 被分隔字符串
	 * @param splitChar 分隔符
	 * @return 整型集合
	 */
	public static Integer[] convertStrToArr(String splitStr, String splitChar) {
		
		List<Integer> list = convertStrToList(splitStr, splitChar);
		
		return list.toArray(new Integer[list.size()]);
	}
}
