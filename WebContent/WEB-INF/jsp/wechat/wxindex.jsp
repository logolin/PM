<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0"/> 
		<title>微信端首页</title>
		<style type="text/css">
			* { 
				margin:0;
				padding: 0;
				box-sizing: border-box;
			}
			body {
				background:url('../resources/wximg/b1.jpg');
				background-size: cover;
/* 				background-position: center; */
			}
			.content-wrap {
				/*margin:10px;*/
				text-align: center;
				position: absolute;
				top:3%;
			}
			.btn-group {
 				width: 150px; 
				display: inline-block;
				position: relative;
			}
			.content-wrap .btn-group span {
				position: absolute;
				bottom: 10%;
				left:20%;
				right: 20%;
				text-align: center;
				color: #FFFFFF;
				font-family:Arial,Helvetica,sans-serif;
			}
			.content-wrap .btn-group img {
				width: 100%;
				height: 100%;
				border: 4px solid #FFFFFF;
			}
			@media screen and (min-width: 320px) {
			    html {font-size: 14px;}
			    .btn-group {width: 150px;}
			}
			@media screen and (min-width: 360px) {
			    html {font-size: 16px;}
			    .btn-group {width: 150px;}
			}
			@media screen and (min-width: 400px) {
			    html {font-size: 18px;}
			    .btn-group {width: 160px;}
			}
			@media screen and (min-width: 440px) {
			    html {font-size: 20px;}
			    .btn-group {width: 190px;}
			}
			@media screen and (min-width: 480px) {
			    html {font-size: 22px;}
			     .btn-group {width: 190px;}
			}
			@media screen and (min-width: 640px) {
			    html {font-size: 28px;}
			     .btn-group {width: 250px;}
			}
		</style>
	</head>
	<body>
<!-- 		<div class="header"> -->
<!-- 			<img src="../resources/wximg/b1.jpg" style="width: 100%;" /> -->
<!-- 		</div> -->
		<div class="content-wrap">
			<div class="btn-group" onclick="window.location.href='task-list-finish'">
				<img src="../resources/wximg/finishtask1.png" />
				<span>已完成任务</span>
			</div>
			<div class="btn-group" onclick="window.location.href='task-list-unfinish'">
				<img src="../resources/wximg/unfinishtask1.png" />
				<span>未完成任务</span>
			</div>
			<div class="btn-group" onclick="window.location.href='bug-list-finish'">
				<img src="../resources/wximg/finishbug1.png" />
				<span>已完成BUG</span>
			</div>
			<div class="btn-group" onclick="window.location.href='bug-list-unfinish'">
				<img src="../resources/wximg/unfinishbug1.png" />
				<span>未完成BUG</span>
			</div>
		</div>
	</body>
</html>
