<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content = "width = device-width , minimum-scale = 1.0 ,maximum-scale = 1.0 , user-scalable = no">
<title>微信端登录界面</title>
<link rel="stylesheet" href="../resources/wxcss/style.css">
<style type = "text/css">
	.header{
		margin-top: 18px;
		 width: 100%; 
/* 		 font-size: 18px; */
		 text-shadow: 0 1px 3px rgba(0,0,0,.2);
	}
</style> 
	
</head>
<body>

<div class="login-container">
	<h1>力德科技</h1>
	<div class="header">
		<p>项&nbsp;目&nbsp;管&nbsp;理&nbsp;系&nbsp; 统</p>
	</div>
	
	<form action="" method="post" id="loginForm">
		<div>
			<input type="text" name="account" class="account" placeholder="用户名" autocomplete="off"/>
		</div>
		<div>
			<input type="password" name="password" class="password" placeholder="密码" oncontextmenu="return false" onpaste="return false" />
		</div>
		<button id="submit" type="submit">登 陆</button>
	</form>

</div>

</body>
<script src="http://www.jq22.com/jquery/1.11.1/jquery.min.js"></script>
<!--背景图片自动更换-->
<script src="../resources/wxjs/supersized.3.2.7.min.js"></script>
<script src="../resources/wxjs/supersized-init.js"></script>
</html>