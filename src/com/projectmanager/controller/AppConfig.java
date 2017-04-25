package com.projectmanager.controller;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.mail.MailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

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
	
	@Bean
	public MailSender mailSender(){
		JavaMailSenderImpl javaMailSenderImpl = new JavaMailSenderImpl();
		javaMailSenderImpl.setHost("smtp.gmail.com");
		javaMailSenderImpl.setPort(587);
		javaMailSenderImpl.setUsername("softwareprojectmanage@gmail.com");
		javaMailSenderImpl.setPassword("test12345678");
		
		Properties javaMailProperties = new Properties();
		javaMailProperties.setProperty("mail.smtp.auth", "true");
		javaMailProperties.setProperty("mail.smtp.starttls.enable", "true");
		
		javaMailSenderImpl.setJavaMailProperties(javaMailProperties);
		return javaMailSenderImpl;
	}
}
