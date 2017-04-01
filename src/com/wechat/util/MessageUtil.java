package com.wechat.util;

import java.io.InputStream;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.core.util.QuickWriter;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.io.xml.PrettyPrintWriter;
import com.thoughtworks.xstream.io.xml.XppDriver;
import com.wechat.message.resp.TextMessage;

public class MessageUtil {

	public static final String REQ_MESSAGE_TYPE_TEXT = "text";	

	public static final String RESP_MESSAGE_TYPE_TEXT = "text";	
	
    public static final String REQ_MESSAGE_TYPE_EVENT = "event";  //事件类型
     
    public static final String EVENT_TYPE_SUBSCRIBE = "subscribe";  //订阅
  
    public static final String EVENT_TYPE_UNSUBSCRIBE = "unsubscribe";  //取消订阅
    
    public static final String EVENT_TYPE_CLICK = "CLICK";	//click事件
    
	/*
	 * 解析xml
	 */
    @SuppressWarnings("unchecked") 
	public static Map<String, String> parseXml(HttpServletRequest request) throws Exception {
    	//定义map
		Map<String, String> map = new HashMap<String, String>();
		//request获得post数据流
		InputStream inputStream = request.getInputStream();
		
		SAXReader reader = new SAXReader();
		//读取xml，由inputStream转化
		Document document = reader.read(inputStream);
		Element root = document.getRootElement();
		List<Element> list = root.elements();
		for(Element e : list) {
			//将读取的xml数据构造成map
			map.put(e.getName(), e.getText());
		}
		inputStream.close();
		inputStream = null;
		
		return map;
	}
	

	public static String textMessageToXml(TextMessage textMessage) {
		xstream.alias("xml", textMessage.getClass());
		return xstream.toXML(textMessage);
	}
	
	//使能支持生成CDATA
    private static XStream xstream = new XStream(new XppDriver() {  
        public HierarchicalStreamWriter createWriter(Writer out) {  
            return new PrettyPrintWriter(out) {  

                boolean cdata = true;  
  
                @SuppressWarnings("unchecked")  
                public void startNode(String name, Class clazz) {  
                    super.startNode(name, clazz);  
                }  
  
                protected void writeText(QuickWriter writer, String text) {  
                    if (cdata) {  
                        writer.write("<![CDATA[");  
                        writer.write(text);  
                        writer.write("]]>");  
                    } else {  
                        writer.write(text);  
                    }  
                }  
            };  
        }  
    });	
}
