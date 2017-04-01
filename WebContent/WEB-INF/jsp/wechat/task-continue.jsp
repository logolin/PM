<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<% String Start=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
<% String lastEditedDate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name = "viewport" content = "width = device-width , minimum-scale = 1.0 ,maximum-scale = 1.0 , user-scalable = no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.js"></script>

<title>继续任务</title>
</head>
<body>
	<form action="" method ="post" onsubmit="return check()">
		<div class="title">
			<h2>${task.id} ${task.name}</h2>
		</div>
		<div class="main-wrap">
			<div class="info">
				<label>实际开始</label>
				<div class="input-group inpt" >
				  <input type="text" class="form-control form-date" name="realStarted" id="realStarted" value="${task.realStarted}"/>
				  <span class="input-group-addon"><i class="icon icon-calendar"></i></span>
				</div>
			</div>
			<input type="hidden" name="lastEditedBy" value="${userAccount}"/>
			<input type="hidden" name="lastEditedDate" value="<%=lastEditedDate%>"/>
			<div class="info">
				<label>总消耗</label>
				<div class="input-group inpt">
				  <input type="text" class="form-control" name="consumed" id="consumed" value ="<fmt:formatNumber type="number" value="${task.consumed}"></fmt:formatNumber>">
				  <span class="input-group-addon">小时</span>
				</div>
			</div>
			<div class="info">
				<label>预计剩余</label>
				<div class="input-group inpt">
				  <input type="text" class="form-control" name="remain" id="remain" value="<fmt:formatNumber type="number" value="${task.remain}"></fmt:formatNumber>">
				  <span class="input-group-addon">小时</span>
				</div>
			</div>
			<div class = "info">
				<label>备注</label>
				<textarea id="comment" name="comment" class="form-control kindeditor"></textarea>
			</div>
		</div>
		<!--  	按钮 -->
		<div class="btn1"> 
			<button type="submit"  data-loading="稍候..." class="btn-save">继续</button>
			<button type="button"  data-loading="稍候..." class="btn-save" onclick="history.go(-1)">返回</button>
		</div>
		
	</form>
</body>

<script type="text/javascript">
	$(function(){
		$(".form-date").datetimepicker(
				{
				    language:  "zh-CN",
				    weekStart: 1,
				    todayBtn:  1,
				    autoclose: 1,
				    todayHighlight: 1,
				    startView: 2,
				    minView: 2,
				    forceParse: 0,
				    format: "yyyy-mm-dd"
				});
	})
	//检查
	function check() {
		if(checkStarted() == false) {
			return false;
		}	
		else if(checkConsumed() == false) {
			return false;
		}
		else if(checkRemain() == false) {
			return false;
		}
	}
	//检查实际开始时间
	function checkStarted() {
		var reg = /^(\d{4})-(\d{2})-(\d{2})$/;
		var realStarted = $('#realStarted').val();
		if(!reg.test(realStarted)) {
			alert("“开始时间”格式不正确!") 
			return false;
		}
	}
	//检查总消耗
	function checkConsumed() {
		var consumed = $('#consumed').val();
		var oldConsumed = ${task.consumed};
		if(!consumed || consumed < oldConsumed){
			alert('“已经消耗”必须大于之前消耗！');
			return false;
		}
	}
	//检查预计剩余，禅道不同点在于：当“预计剩余”为空或为0时，提示信息为：“预计剩余”为0，确定将任务状态改为“已完成”？
	function checkRemain(){
		var remain = $('#remain').val();
		if(!remain || remain == 0){
			var r=alert("“预计剩余”不能为0！");
			return false;
		}
	}	
	
	//富文本框
	var editor;
	KindEditor.ready(function(K) {
		editor = K.create('textarea', {
	           width:'100%',
			resizeType : 1,
			urlType:'relative',
			afterBlur: function(){this.sync();},
			allowFileManager : true,
			items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
			          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
			          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
		});
	});

</script>

</html>