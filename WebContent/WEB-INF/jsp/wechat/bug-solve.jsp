<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<% String resolvedDate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/> 
<link href="../resources/zui/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script> 
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.js"></script>
<title>Bug解决</title>
</head>
<body>
	<form action="" method="post" id="solveForm" onsubmit="return check()">
		<div class="title">
			<h2>${bug.id} ${bug.title}</h2>
		</div>
		<div class="main-wrap">
			<div class = "info">
				<label>解决方案<small>(必填项)</small></label>
				<select class="chosen-select form-control" name="resolution" id="resolution">
					<option value="" selected></option>
					<option value="bydesign">设计如此</option>
					<option value="duplicate">重复Bug</option>
					<option value="external">外部原因</option>
					<option value="fixed">已解决</option>
					<option value="notrepro">无法重现</option>
					<option value="postponed">延期处理</option>
					<option value="willnotfix">不予解决</option>
					<option value="tostory">转为需求</option>
				</select>
				<input type="hidden" name="resolvedBy" value="${userAccount}" /> 
			</div>
			<div class="info ">
				<label>解决版本</label>
				<select class ="chosen-select form-control" name="resolvedBuild" id="resolvedBuild">
					<option value="" selected></option>
					<option value="trunk">Trunk</option>
					<option value="module">Module</option>
					<option value="project">Project</option>
				</select>
			</div>
			<div class="info">
				<label>指派给</label>
				<select class="chosen-select form-control" id="assignedTo" name="assignedTo" style="width:100%">
					<option value=""></option>
					<!-- 	遍历整个用户表 -->
					<c:forEach items="${userList}" var="user">
						<option value ="${user.account}" <c:if test="${user.account == bug.assignedTo}">selected</c:if>>${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="assignedDate" value="<%=resolvedDate%>"/> 
				<input type="hidden" name="lastEditedBy" value="${userAccount}"/>
				<input type="hidden" name="lastEditedDate" value="<%=resolvedDate%>"/>
			</div>
			<div class="info">
				<label>解决日期<small>(必填项)</small></label>
				<div class="input-group">
					<input type="hidden" id="oResolvedDate" value="<%=resolvedDate%>"/>
					<input type="text" class="form-control form-datetime" name = "resolvedDate" id="resolvedDate" value="<%=resolvedDate%>"/>
					<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
				</div>
			</div>
<!-- 			<div class = " info panel" > -->
<!-- 				<div class="panel-heading"> -->
<!-- 					<label class = ""><i class="icon icon-file-o"></i>&nbsp;附件</label> -->
<!-- 				</div> -->
<!-- 				<div class=" panel-body"> -->
				  
				 
<!-- 				</div> -->
<!-- 			</div> -->
			<div class="info">
				<label class="">备注</label>
				<textarea id="comment" name="comment" class="form-control kindeditor"></textarea>
			</div>
		</div>
		<!--  	按钮 -->
		<div class="btn1"> 
			<button type="submit"  data-loading="稍候..." class="btn-save">解决</button>
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
	//日期插件
	$(".form-datetime").datetimepicker(
			{
			    language:  "zh-CN",
			    weekStart: 1,
			    todayBtn:  1,
			    autoclose: 1,
			    todayHighlight: 1,
			    startView: 2,
			    minView: 2,
			    forceParse: 0,
			    format: "yyyy-mm-dd hh:mm:ss"
	});
	//检查
	function check() {
		var resolution = $('#resolution').val();
		var reg = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;
		var resolvedDate = $('#resolvedDate').val();
		if(!reg.test(resolvedDate)) {
			alert("“解决日期”格式不正确,正确格式如“2016-01-12 12:30:07”!");
			return false;
		}
		if(resolution == null || resolution == "") {
			alert("“解决方案”不能为空！");
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