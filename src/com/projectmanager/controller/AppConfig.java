package com.projectmanager.controller;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import com.projectmanager.entity.Module;
import com.projectmanager.entity.Story;

@ComponentScan(basePackages="com.projectmanager.entity")
@Configuration
public class AppConfig {

	@Bean
	@Scope("prototype")
	public Module module() {
		return new Module();
	}
	
	@Bean 
	public Story story() {
		return new Story();
	}
}
