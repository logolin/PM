package com.wechat.pojo;

public class Ticket {

	//该二维码有效时间，以秒为单位。 最大不超过2592000（即30天），此字段如果不填，则默认有效期为30秒。
	private long expire_seconds;
	
	//二维码类型，QR_SCENE为临时,QR_LIMIT_SCENE为永久,QR_LIMIT_STR_SCENE为永久的字符串参数值
	private String action_name;
	
	//二维码详细信息
	private String action_info;

	public long getExpire_seconds() {
		return expire_seconds;
	}

	public void setExpire_seconds(long expire_seconds) {
		this.expire_seconds = expire_seconds;
	}

	public String getAction_name() {
		return action_name;
	}

	public void setAction_name(String action_name) {
		this.action_name = action_name;
	}

	public String getAction_info() {
		return action_info;
	}

	public void setAction_info(String action_info) {
		this.action_info = action_info;
	}
}
