package com.wechat.pojo;

public class AccessToken extends ErrorCode {

	private String accessToken;	//收到的凭证
	
	private String expires;	//凭证有效时间

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public String getExpires() {
		return expires;
	}

	public void setExpires(String expires) {
		this.expires = expires;
	}
	
}
