package com.wechat.message.req;

public class TextMessage extends BasicMsg {

	private String content;	//文本消息内容

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}
