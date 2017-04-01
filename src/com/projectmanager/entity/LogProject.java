package com.projectmanager.entity;

import java.beans.FeatureDescriptor;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

public interface LogProject {

	int OverrideGetId();

	int overrideGetProjectId();
	
	default Map<String, Object[]> compare(LogProject target) {
		
		Map<String, Object[]> map = new HashMap<>();
		
		BeanWrapper thisObject = new BeanWrapperImpl(this);
		BeanWrapper compareObject = new BeanWrapperImpl(target);
		
		Stream.of(thisObject.getPropertyDescriptors())
		.map(FeatureDescriptor::getName)
		.filter(name->thisObject.getPropertyValue(name) != null && !(String.valueOf(thisObject.getPropertyValue(name))).equals(String.valueOf(compareObject.getPropertyValue(name))))
		.forEach(name->map.put(name, new Object[]{compareObject.getPropertyValue(name), thisObject.getPropertyValue(name)}));
		
		return map;
	}
}
