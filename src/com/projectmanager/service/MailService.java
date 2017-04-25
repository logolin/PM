package com.projectmanager.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import com.projectmanager.controller.AppConfig;
import com.projectmanager.repository.UserRepository;

/**
 * 
 * MailService用于向用户发送电子邮件
 *
 */
@Service
public class MailService {
	
	@Autowired
	private UserRepository userRepository;

	private MailSender mailSender;

	public MailService() {
		super();
		ApplicationContext applicationContext = new AnnotationConfigApplicationContext(AppConfig.class);
		this.mailSender = (JavaMailSenderImpl) applicationContext.getBean("mailSender");
	}
	
	/**
	 * @Description: 发送邮件
	 * @param from 发送人邮件地址
	 * @param to 收件人邮件地址
	 * @param subject 邮件标题
	 * @param msg 邮件内容
	 */
	public void sendMail(String from, String to, String subject, String msg) {

		SimpleMailMessage message = new SimpleMailMessage();

		message.setFrom(from);
		message.setTo(to);
		message.setSubject(subject);
		message.setText(msg);
		Thread t = new Thread(()->{
			mailSender.send(message);
			
		});
		t.start();
	}
	
	/**
	 * @Description: 抄送邮件都多个用户
	 * @param accountList 目标用户名
	 * @param subject
	 * @param msg
	 */
	public void mailTo(List<String> accountList, String subject, String msg) {

		
		//获取抄送email列表
		List<String> mailtoList = this.userRepository.findEmailByAccountIn(accountList);
		
		//发送邮件
		mailtoList.forEach(item->{
			
			sendMail("softwareprojectmanage@gmail.com", item, subject, msg);
		});
	}
}
