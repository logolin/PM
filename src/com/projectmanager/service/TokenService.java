package com.projectmanager.service;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wechat.pojo.AccessToken;
import com.wechat.pojo.CheckModel;
import com.wechat.tool.EncoderHandler;
import com.wechat.tool.HttpClientUtil;
import com.wechat.tool.JsonMapper;


@Service
public class TokenService {

	private HttpSession session;
	
	private static String token = "logolin";
	
	private static String appid = "wx1fab125958a7e2f7";
	private static String secret = "91c299c64b5329464edfbfd6f73e8f1d";
	
	/**
     * 微信开发者验证
     * @param wxAccount
     *
     * @param signature
     * @param timestamp
     * @param nonce
     * @param echostr
     * @return
     */
    @Transactional
    public String validate(HttpServletRequest request){
    	//签名
        String signature = request.getParameter("signature");
        //时间戳
        String timestamp = request.getParameter("timestamp");
        // 随机数
        String nonce = request.getParameter("nonce");
        // 随机字符串
        String echostr = request.getParameter("echostr");
        System.out.println("token" + token);
        
        if(signature != null && timestamp != null && nonce != null) {
            String[] str = {token, timestamp, nonce};
            Arrays.sort(str); // 字典序排序
            String bigStr = str[0] + str[1] + str[2];
            // SHA1加密    
            String digest = EncoderHandler.encode("SHA1", bigStr).toLowerCase();
            // 确认请求来至微信
            if (digest.equals(signature)) {
                //最好此处将echostr存起来，以后每次校验消息来源都需要用到
//            	session.setAttribute("echostr", echostr);
            	System.out.println("signature:" + signature + "echostr:" + echostr);
                return echostr;
            }
        }
        return "error";
    }
    
    /**
     * 获取全局返回码
     *
     * @param appid        微信appid
     * @param secret    微信secret
     * @return
     * @throws Exception
     */
	public String getAccessToken(){
        String accessToken = "";
        String accessTokenUrl = "https://api.weixin.qq.com/cgi-bin/token";
        AccessToken accessTokenModel = JsonMapper.buildNormalMapper().fromJson(HttpClientUtil.sendGetSSLRequest(accessTokenUrl+"?grant_type=client_credential&appid="+appid+"&secret="+secret, null), AccessToken.class);
        if(StringUtils.isEmpty(accessTokenModel.getAccessToken())){
            return null;
        }else{
            accessToken = accessTokenModel.getAccessToken();
            session.setAttribute("accessToken", accessToken);
        }
        return accessToken;
    }
}
