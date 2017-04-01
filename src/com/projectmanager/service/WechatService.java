package com.projectmanager.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.projectmanager.repository.UserRepository;
import com.wechat.message.resp.TextMessage;
import com.wechat.pojo.TicketInfo;
import com.wechat.tool.HttpClientUtil;
import com.wechat.tool.JsonMapper;
import com.wechat.util.MessageUtil;


@Service
public class WechatService {

	private HttpSession session;
	
	public static TextMessage textMessage;
	
	@Autowired
	private TokenService tokenService;
	
	@Autowired
	private UserRepository userRepository;
	
	/**
	 * 根据access_token和next_openid查找next_openid后面的用户
	 * 没有next_openid默认查找前10000个用户
	 * @param access_token
	 * @param next_openid
	 * @return
	 */
	public String getNextUser(String access_token, String next_openid) {
		String reqUrl = "https://api.weixin.qq.com/cgi-bin/user/get";
		String openids = HttpClientUtil.sendGetSSLRequest(reqUrl + "?access_token="+ access_token +"&next_openid=" + next_openid, null);
		return openids;
	}
	
	/**
	 * 创建二维码
	 * @return
	 */
	public String createTicket() {
		
		
		String reqUrl = "https://api.weixin.qq.com/cgi-bin/qrcode/create";
		// 构建 json 串  
		StringBuffer json = new StringBuffer(); 
		json.append("{");  

		json.append("\"expire_seconds\":\"").append("604800").append("\",");
 
		json.append("\"action_name\":\"").append("QR_SCENE").append("\",");

		json.append("\"action_info\":{\"").append("sence\"").append(":{\"");
		
		json.append("scene_id\":\"").append("1\"");
		
		json.append("}}}");

		TicketInfo ticketInfo = JsonMapper.buildNormalMapper().fromJson(HttpClientUtil.sendPostRequestByJava(reqUrl + "?access_token=xLpC0rNkE2hpUBzP4kzKMWkIyEDEKivFFKuJlYOZHBMFVI6GwYUZMqSLcC5r5jPr1sgZOvduF-7x185vIzy8Km4aoaIIyM0rW0zvvtxKotdBIZRfALD_9eLGqM5FmbrvYCCbAEASWW", json.toString()), TicketInfo.class);
		System.out.println("ticket :" + ticketInfo.getTicket());
		return ticketInfo.getTicket();
	}
	
	
	/**
	 * 处理微信发来的请求 
	 * @param request
	 * @return
	 * @throws IOException 
	 */
	public void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String respMessage = null;
		
		try {
			// 默认返回的文本消息内容 
			String respContent = "请求处理异常";
			
			// xml请求解析  
			Map<String, String> requestMap = MessageUtil.parseXml(request);
			
			// 发送方帐号（open_id）  
            String fromUserName = requestMap.get("FromUserName");  
            // 公众帐号  
            String toUserName = requestMap.get("ToUserName");  
            // 消息类型  
            String msgType = requestMap.get("MsgType");  
			//消息内容
            String content = requestMap.get("Content");
			
			// 回复文本消息  
            TextMessage textMessage = new TextMessage();
            //收发方调转
			textMessage.setFromUserName(toUserName);
			textMessage.setToUserName(fromUserName);
			//发送时获取系统时间
			textMessage.setCreateTime(new Date().getTime());
			//类型为文本消息
			textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);
			textMessage.setFunFlag(0);
			
			//普通文本消息
			if(msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_TEXT)){
//                respContent = "已接收到您发送的：" + content;
				respContent = "请点击链接测试任务列表：http://weixin.jmlide.com/ProjectManager/wechat/task_list";
			}
            // 事件推送  
            else if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
                // 事件类型  
                String eventType = requestMap.get("Event");  
                // 订阅  
                if (eventType.equals(MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
                    respContent = "谢谢您的关注！";  
                }  
                // 取消订阅  
                else if (eventType.equals(MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
                    // TODO 取消订阅后用户再收不到公众号发送的消息，因此不需要回复消息  
                }  
                // 自定义菜单点击事件
                else if (eventType.equals(MessageUtil.EVENT_TYPE_CLICK)) {
                    // 事件KEY值，与创建自定义菜单时指定的KEY值对应  
                    String eventKey = requestMap.get("EventKey");
                    //绑定账号事件
                    if (eventKey.equals("Bind_account")) {
//                    	//判断是否已经绑定账号
                    	if(null == this.userRepository.findByOpenId(fromUserName)) {
                    		respContent = "请点击链接绑定账号：http://weixin.jmlide.com/ProjectManager/wechat/wechat_login/" + fromUserName;
                    	} else {
                    		respContent = "您已绑定账号，不用重新绑定，若需绑定其他账号，请先解绑此账号！";
                    	}
                    } //解绑事件
                    else if(eventKey.equals("Unbundling")) {
                    	//判断是否已经绑定账号
                    	if(null != this.userRepository.findByOpenId(fromUserName)) {
                    		respContent = "请点击链接解绑账号：http://weixin.jmlide.com/ProjectManager/wechat/unbundling/" + fromUserName;
                    	} else {
                    		respContent = "您还未绑定账号！";
                    	}
                    }
                }
            }  
			//返回主体内容
			textMessage.setContent(respContent);
			//将
			respMessage = MessageUtil.textMessageToXml(textMessage);			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PrintWriter out = response.getWriter();
		out.print(respMessage);
		out.close();
	}
}
