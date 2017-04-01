<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<% String assignedTo=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale =1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<title>激活任务</title>
</head>
<body>
	<form action="" method ="post" onsubmit="return check()">
		<div class="title">
			<h2>${task.id} ${task.name}</h2>
		</div>
		<div class="main-wrap">
		<!-- 	指派给 -->
			<div class="info">
				<label>指派给</label>
				<select class="chosen-select form-control" id="assignedTo" name="assignedTo" style="width:100%">
					<option value=""></option>
					<c:forEach items="${teamList}" var="team">
						<option value="${team.id.user.account}" <c:if test="${team.id.user.account == task.assignedTo }">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="assignedDate" value="<%=assignedTo%>"/> 
				<input type="hidden" name="lastEditedBy" value="${userAccount}"/>
				<input type="hidden" name="lastEditedDate" value="<%=assignedTo%>"/>
			</div>
			<!-- 预计剩余 -->
			<div class="info">
				<label>预计剩余<small>(必填项)</small></label>
				<div class="input-group inpt">
				  <input type="text" class="form-control" name="remain" id="remain">	  
				  <span class="input-group-addon">小时</span>
				</div>
			</div>
			<!-- 备注 -->
			<div class="info">
				<label>备注</label>
				<textarea id="comment" name="comment" class="form-control kindeditor"></textarea>
			</div>
		</div>
		<!--  	按钮 -->
		<div class="btn1"> 
			<button type="submit"  data-loading="稍候..." class="btn-save">激活</button>
			<button type="button"  data-loading="稍候..." class="btn-save" onclick="history.go(-1)">返回</button>
		</div>
	</form>
</body>

<script type="text/javascript">
	$(function() {
		//单项选择
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
		    disable_search_threshold: 10, // 10 个以下的选择项则不显示检索框
		    search_contains: true,         // 从任意位置开始检索
		    allow_single_deselect:true,
		});
	});
	
	//检查是否可以提交
	function check() {
		var remain = $("#remain").val();
		if(!remain) {
			alert('“预计剩余”不能为空！');
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