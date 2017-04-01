<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../resources/zui/assets/jquery.js"></script>
<title>生成一个临时二维码</title>
<style>
	body{margin: 0;padding: 0;}
	#mask{background: #000;opacity: 0.3;filter: alpha(opacity=30);position:absolute;left:0;top:0;display: none;}
	#content{width: 250px;height:260px;position: absolute;display: none;}
</style>
</head>
<body>
	<form method="post">
		<input type="button" id="btn" value="登录" />
		<div id="mask"></div>
		<div id="content">
			<img alt="" src="${ticketimg}">
		</div>
	</form>
<script>
$(function(){
	
	var oLogin=$('#content');
	
	$('#btn').click(function(){
		$('#mask').css('display','block');
		$('#mask').css('width',$(document).width());
		$('#mask').css('height',$(document).height());
		
		oLogin.css('display','block');
		oLogin.css('left',($(window).width()-oLogin.outerWidth())/2+$(window).scrollLeft());
		oLogin.css('top',($(window).height()-oLogin.outerHeight())/2+$(window).scrollTop());
	});
	
	$('#close').click(function(){
		$('#mask').remove();
		oLogin.remove();
	});
	
	//由于触发滚动条和改变窗口大小的执行内容一样，所以可将这两个事件同时绑定
	
	$(window).on('scroll resize',function(){
		oLogin.css('left',($(window).width()-oLogin.outerWidth())/2+$(window).scrollLeft());
		oLogin.css('top',($(window).height()-oLogin.outerHeight())/2+$(window).scrollTop());
	})
})
</script>
</body>
</html>