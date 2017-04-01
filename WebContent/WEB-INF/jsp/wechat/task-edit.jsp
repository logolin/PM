<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<% String lastEditedDate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/edit.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<title>编辑任务</title>
</head>
<body>
	<form action="" method="post" onsubmit="return check()">
		<div class="title">
			<h2>编辑 <small>(id:${task.id})</small></h2>
		</div>
		<div class="main-wrap">
			<div class="" style="line-height:34px;vertical-align:middle;">
				<label class="col-xs-4">任务名称<small>*</small></label>
				<div class="input-group col-xs-8" >
					<input type="text" class="form-control" name="name" id="name" value="${task.name}"/>
				</div>
			</div>
			<!-- 	基本信息 -->
			<div class="panel">
				<div class="panel-heading">基本信息</div>
			  	<div class="panel-body">
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">所属项目</label> 
						    <select class="chosen-select col-xs-8" name="project_id" id="project" onchange="getModulesAndStory(this.value)">
						    <option value=""></option>
						    <c:forEach items="${proList}" var="proList">
					    		<option value="${proList.id}" <c:if test="${proList.id == task.project.id}">selected</c:if>>${proList.name}</option>
					    	</c:forEach>
					    </select>
				  	</div>
				    <div class="panel-body-info" id="moduleIdBox">
				  		<label class="col-xs-4">所属模块</label> 
					    <select class="chosen-select  col-xs-8" name="module_id" id="module">
					    </select>
				  	</div>
				    <div class="panel-body-info" class="storyIdBox" id="storyIdBox">
				  		<label class="col-xs-4" >相关需求</label> 
					    <select class="chosen-select  col-xs-8" name="story_id" id="story" >
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">指派给</label> 
					    <select class="chosen-select  col-xs-8" name="assignedTo" id="assignedTo">
					    	<option value=""></option>
					    	<c:forEach items="${teamList}" var="team">
					    		<option value="${team.id.user.account}" <c:if test="${team.id.user.account == task.assignedTo}">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					    	</c:forEach>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">任务类型<small>*</small></label> 
					    <select class="chosen-select  col-xs-8" name="type" id="type">
					    	<option value="design" <c:if test="${task.type == 'design'}">selected</c:if>>设计</option>
					    	<option value="devel"  <c:if test="${task.type == 'devel'}">selected</c:if>>开发</option>
					    	<option value="test"   <c:if test="${task.type == 'test'}">selected</c:if>>测试</option>
					    	<option value="study"  <c:if test="${task.type == 'study'}">selected</c:if>>研究</option>
					    	<option value="discuss"<c:if test="${task.type == 'discuss'}">selected</c:if>>讨论</option>
					    	<option value="ui"     <c:if test="${task.type == 'ui'}">selected</c:if>>界面</option>
					    	<option value="affair" <c:if test="${task.type == 'affair'}">selected</c:if>>事务</option>
					    	<option value="misc"   <c:if test="${task.type == 'misc'}">selected</c:if>>其他</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">任务状态</label> 
					    <select class="chosen-select  col-xs-8" name="status">
					    	<option value="wait" <c:if test="${task.status == 'wait'}">selected</c:if>>未开始</option>
					    	<option value="doing" <c:if test="${task.status == 'doing'}">selected</c:if>>进行中</option>
					    	<option value="done" <c:if test="${task.status == 'done'}">selected</c:if>>已完成</option>
					    	<option value="pause" <c:if test="${task.status == 'pause'}">selected</c:if>>已暂停</option>
					    	<option value="cancel" <c:if test="${task.status == 'cancel'}">selected</c:if>>已取消</option>
					    	<option value="closed" <c:if test="${task.status == 'closed'}">selected</c:if>>已关闭</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">优先级</label> 
					    <select class="chosen-select  col-xs-8" name="pri">
					    	<option value="0" <c:if test="${task.pri == '0' }">selected</c:if>></option>
					    	<option value="1" <c:if test="${task.pri == '1' }">selected</c:if>>1</option>
					    	<option value="2" <c:if test="${task.pri == '2' }">selected</c:if>>2</option>
					    	<option value="3" <c:if test="${task.pri == '3' }">selected</c:if>>3</option>
					    	<option value="4" <c:if test="${task.pri == '4' }">selected</c:if>>4</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">抄送给</label> 
				  		<select class="chosen-select col-xs-8" name="mailto">
				  			<option value=""></option>
				  			<c:forEach items="${teamList}" var="team">
					    		<option value="team.id.user.account" <c:if test="${team.id.user.account == task.mailto}">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					    	</c:forEach>
				  		</select>
				  	</div>
			 	</div>				
			 </div>
			<div class="panel">
			 	<div class="panel-heading">工时信息</div>
			 	<div class="panel-body">
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">预计开始</label> 
					    <div class="input-group col-xs-8" >
							<input type="text" class="form-control form-date" name="estStarted" id="estStarted" value="${task.estStarted}"/>
							<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			 		</div>
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">实际开始</label> 
					    <div class="input-group col-xs-8">
							<input type="text" class="form-control form-date" name="realStarted" id="realStarted" value="${task.realStarted}"/>
							<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			 		</div>
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">截止时间</label> 
					    <div class="input-group col-xs-8" >
							<input type="text" class="form-control form-date" name="deadline" id="deadline" value="${task.deadline}"/>
							<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			 		</div>
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">最初预计</label> 
					    <div class="input-group col-xs-8" >
							<input type="text" class="form-control" name="estimate" id="estimate" value="<fmt:formatNumber type="number" value="${task.estimate}"></fmt:formatNumber>"/>
							<span class="input-group-addon"><i class="icon icon-time"></i></span>
						</div>
			 		</div>
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">总消耗</label> 
					    <div class="input-group col-xs-8" >
							<input type="text" class="form-control" name="consumed" id="consumed" value="<fmt:formatNumber type="number" value="${task.consumed}"></fmt:formatNumber>"/>
							<span class="input-group-addon"><i class="icon icon-time "></i></span>
						</div>
			 		</div>
			 		<div class="panel-body-info">
			 			<label class="col-xs-4">预计剩余<small>*</small></label> 
					    <div class="input-group col-xs-8" >
							<input type="text" class="form-control" name="remain" id="remain" value="<fmt:formatNumber type="number" value="${task.remain}"></fmt:formatNumber>"/>
							<span class="input-group-addon"><i class="icon icon-time"></i></span>
						</div>
			 		</div>
			 	</div>
			</div>
			<div class="panel">
				<div class="panel-heading">任务的一生</div>
				<div class="panel-body">
					<div class="panel-body-info">
				  		<label class="col-xs-4">由谁创建</label> 
				  		<div class="col-xs-8 no-edit" name="openedBy" id="openedBy">${userMap[task.openedBy]}</div>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">由谁完成</label> 
					    <select class="chosen-select  col-xs-8" name="finishedBy" id="finishedBy">
					    	<option value=""></option>
				  			<c:forEach items="${teamList}" var="team">
					    		<option value="team.id.user.account" <c:if test="${team.id.user.account == task.finishedBy}">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					    	</c:forEach>
					    </select>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">完成时间</label> 
					    <div class="input-group col-xs-8" >
						  <input type="text" class="form-control form-datetime" name="finishedDate" id="finishedDate" value="<fmt:formatDate value="${task.finishedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"/>
						  <span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">由谁取消</label> 
					    <select class="chosen-select  col-xs-8" name="canceledBy" id="canceledBy">
					    	<option value=""></option>
				  			<c:forEach items="${teamList}" var="team">
					    		<option value="team.id.user.account" <c:if test="${team.id.user.account == task.canceledBy}">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					    	</c:forEach>
					    </select>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">取消时间</label> 
					    <div class="input-group col-xs-8" >
						  <input type="text" class="form-control form-datetime" name="canceledDate" id="canceledDate" value="<fmt:formatDate value="${task.canceledDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"/>
						  <span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">由谁关闭</label> 
					    <select class="chosen-select  col-xs-8" name="closedBy" id="closedBy">
					    	<option value=""></option>
				  			<c:forEach items="${teamList}" var="team">
					    		<option value="team.id.user.account" <c:if test="${team.id.user.account == task.closedBy}">selected</c:if>>${fn:toUpperCase(team.id.user.account.toCharArray()[0])}:${team.id.user.realname}</option>
					    	</c:forEach>
					    </select>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">关闭原因</label> 
					    <select class="chosen-select  col-xs-8" name="closedReason" id="closedReason">
					    	<option value="done" <c:if test="${task.closedReason == 'done'}">selected</c:if>>已完成</option>
					    	<option value="cancel" <c:if test="${task.closedReason == 'cancel'}">selected</c:if>>已取消</option>
					    </select>
			  		</div>
			  		<div class="panel-body-info">
				  		<label class="col-xs-4">关闭时间</label> 
					    <div class="input-group col-xs-8" >
						  <input type="text" class="form-control form-datetime" name="closedDate" id="closedDate" value="<fmt:formatDate value="${task.closedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"/>
						  <span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
			  		</div>
				</div>
			</div>
			<div class="panel">
				<div class="panel-heading">任务描述</div>
				<div class="panel-body" style="padding:0;">	
					<textarea name="descript" id="descript" >${task.descript}</textarea>
				</div>
			</div>
			<div class="panel">
				<div class="panel-heading">备注</div>
				<div class="panel-body" style="padding:0;">	
					<textarea name="comment" id="comment"></textarea>
				</div>
			</div>
<!-- 			<div class="panel"> -->
<!-- 				<div class="panel-heading">附件</div> -->
<!-- 				<div class="panel-body" >	 -->
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
		<input type="hidden" name="lastEditedBy" id="lastEditedBy" value="${userAccount}">
       	<input type="hidden" name="lastEditedDate" id="lastEditedDate" value="<%=lastEditedDate%>">
<%--        	<input type="hidden" name="" id="oEstStarted" value="${task.estStarted}"> --%>
<%--        	<input type="hidden" name="" id="oRealStarted" value="${task.realStarted}"> --%>
<%--        	<input type="hidden" name="" id="oDeadline" value="${task.deadline}"> --%>
<%--        	<input type="hidden" name="" id="oFinishedDate" value="<fmt:formatDate value="${task.finishedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"> --%>
<%--        	<input type="hidden" name="" id="oCanceledDate" value="<fmt:formatDate value="${task.canceledDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"> --%>
<%--        	<input type="hidden" name="" id="oClosedDate" value="<fmt:formatDate value="${task.closedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>">	 --%>
		<!-- 	按钮 -->
		<div class="btn1"> 
			<button type ="submit"  data-loading="稍候..."class="btn btn-lg btn-save">保存</button>
			<button type ="button"  data-loading="稍候..."class="btn btn-lg btn-save" onclick="history.go(-1)">返回</button>
		</div>
	</form>
</body>
<script type="text/javascript">
	$(function() {	
		getModulesAndStory("${task.project.id}");
		//单项选择
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
		    disable_search_threshold: 10, // 10 个以下的选择项则不显示检索框
		    search_contains: true,         // 从任意位置开始检索
		    allow_single_deselect:true,
		}); 
		
		//日期插件，form-date
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
		//日期插件，form-datetime
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
	});
	//根据projectId获取模块和相关需求
	function getModulesAndStory(projectId){
		//所属模块js代码实现,获取模块列表
		getProjectModules(projectId);
		//相关需求js代码实现，获取相关需求列表
		getStorys(projectId);
	}
	//获得模块list
	function getProjectModules(projectId) {	
		//通过连接获取方法返回值(tree)
		$.get("../ajaxGetModules/" + projectId,function(data){
			//移去原模块list
			$("#module, #module + div, #module + div + span").remove();
			//添加新模块list
			$("#moduleIdBox").append("<select name='module_id' id='module' class='chosen-select chosen col-xs-8'></select>");
			//添加模块list默认值"/"
			$("#module").append("<option value='0' selected>/</option>");
			//若模块list不为空，执行循环
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			//当没有找到模块的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
		})
	}
	//模块list分隔显示出来
	function iterateTree(data,name) {
		var modId = ${task.module_id};
		for (var i = 0; i < data.length; i++) {
			a = name + "/" + data[i].name;
			s = modId == data[i].id ? "selected" : "";
			$("#module").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
			iterateTree(data[i].children,a);
		}
	} 
	//获取相关需求list
	function getStorys(projectId) {
		$.get("../getStorys/"+projectId,function(data){
			//当没有找到相应需求的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#story").remove();
			//添加需求list
			$("#storyIdBox").append("<select name='story_id' id='story' class='chosen-select col-xs-8'></select>");
			//添加需求list默认值
			$("#story").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var styId = ${task.story_id};
				for (var i = 0; i < data.length; i++) {
					s = styId == data[i].id ? "selected" : "";
					$("#story").append("<option value='" + data[i].id + "' "+ s +">" + data[i].id + ":"+ data[i].title +" (优先级："+data[i].pri+","+"预计工时："+data[i].estimate+")</option>");
				}
			}
		})
	}
	//检测
	function check() {
		var name = $("#name").val();
		var type = $("#type").val();
		var estimate = $("#estimate").val();
		if(name == null || name == "") {
			alert("“任务名称”不能为空！");
			return false;
		}
		if(type == null || type == "") {
			alert("“任务类型”不能为空！");
			return false;
		}
		if(estimate == null || estimate == "") {
			alert("“最初预计”不能为空！");
			return false;
		}else if(isNaN(estimate)) {
			alert("“最初预计”应当为数字");
			return false;
		}
		getTime();
	}
	//检查日期时间是否
	function getTime() {
		//原日期
// 		var oEstStarted = $('#oEstStarted').val();
// 		var oRealStarted = $('#oRealStarted').val();
// 		var oDeadline = $('#oDeadline').val();
// 		var oFinishedDate = $('#oFinishedDate').val();
// 		var oCanceledDate = $('#oCanceledDate').val();
// 		var oClosedDate = $('#oClosedDate').val();
		//用户可能设置后的日期
		var estStarted = $('#estStarted').val();
		var realStarted = $('#realStarted').val();
		var deadline = $('#deadline').val();
		var finishedDate = $('#finishedDate').val();
		var canceledDate = $('#canceledDate').val();
		var closedDate = $('#closedDate').val();
		if(estStarted == null || estStarted == "") {
			$("#estStarted").val("1970-01-01");
		}
		if(realStarted == null || realStarted == "") {
			$("#realStarted").val("1970-01-01");
		}
		if(deadline == null || deadline == "") {
			$("#deadline").val("1970-01-01");
		}
		if(realStarted == null || realStarted == "") {
			$("#finishedDate").val("1970-01-01 00:00:00");
		}
		if(realStarted == null || realStarted == "") {
			$("#canceledDate").val("1970-01-01 00:00:00");
		}
		if(realStarted == null || realStarted == "") {
			$("#closedDate").val("1970-01-01 00:00:00");
		}
	}
</script>
</html>