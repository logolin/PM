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
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/> 
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/> 
<link href="../resources/zui/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script> 
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<title>建任务</title>
</head>
<body>
	<form action="" method="post" onsubmit="return check()" id="createForm">
		<div class="title">
			<h2>建任务</h2>
		</div>
		<div class="main-wrap">
			<!-- 所属模块 -->
			<div class="info" id="moduleIdBox">
		  		<label>所属模块</label> 
			    <select class="chosen-select chose form-control" name="module_id" id="module" onchange="getStorysForModules(this.value)">  	
			    </select>
		  	</div>
			<!-- 任务类型 -->
		  	<div class="info">
		  		<label>任务类型<small>(必填项)</small></label> 
			    <select class="chosen-select  form-control" name="type" id="type">
			    	<option value="design"  <c:if test="${task.type == 'design'}">selected</c:if>>设计</option>
			    	<option value="devel"   <c:if test="${task.type == 'devel'}">selected</c:if>>开发</option>
			    	<option value="test"    <c:if test="${task.type == 'test'}">selected</c:if>>测试</option>
			    	<option value="study"   <c:if test="${task.type == 'study'}">selected</c:if>>研究</option>
			    	<option value="discuss" <c:if test="${task.type == 'discuss'}">selected</c:if>>讨论</option>
			    	<option value="ui"      <c:if test="${task.type == 'ui'}">selected</c:if>>界面</option>
			    	<option value="affair"  <c:if test="${task.type == 'affair'}">selected</c:if>>事务</option>
			    	<option value="misc"    <c:if test="${task.type == 'misc'}">selected</c:if>>其他</option>
			    </select>
		  	</div>
			<!-- 	指派给 -->
			<div class="assginedTo info">
				<label>指派给</label>
				<select class="chosen-select form-control " id="assignedTo" name="assignedTo" style="width:100%">
					<option value=""></option>
					<c:forEach items="${teamList}" var="team">
						<option value="${team.account}" <c:if test="${team.account == task.assignedTo }">selected</c:if>>${fn:toUpperCase(team.account.toCharArray()[0])}:${team.realname}</option>
					</c:forEach>
				</select>
			</div>
			<input type="hidden" name="assignedDate" value="<%=assignedTo%>"/> 
			<input type="hidden" name="openedBy" value="${userAccount}"/> 
			<input type="hidden" name="openedDate" value="<%=assignedTo%>"/> 
			<!-- 	相关需求 -->
			<div class="info" id="storyIdBox">
		  		<label>相关需求</label> 
			    <select class="chosen-select  chosen form-control" name="story_id" id="story" >
			    </select>
		  	</div>
			<!-- 	任务名 -->
			<div class="info">
		  		<label>任务名称</label> 
			    <input type="text" class="form-control" id="name" name="name" value="${task.name}"/>
		  	</div>
			<!-- 	优先级 -->
		  	<div class="info">
		  		<label>优先级</label> 
			    <select class="chosen-select form-control" name="pri" id="pri">
			    	<option value="0" <c:if test="${task.pri == '0' }">selected</c:if>></option>
			    	<option value="1" <c:if test="${task.pri == '1' }">selected</c:if>>1</option>
			    	<option value="2" <c:if test="${task.pri == '2' }">selected</c:if>>2</option>
			    	<option value="3" <c:if test="${task.pri == '3' }">selected</c:if>>3</option>
			    	<option value="4" <c:if test="${task.pri == '4' }">selected</c:if>>4</option>
			    </select>
		  	</div>
			<!-- 	最初预计 -->
			<div class="info">
	 			<label>最初预计<small>(必填项)</small></label> 
				  <div class="input-group " >
					  <input type="text" class="form-control" name="estimate" id="estimate" value="<fmt:formatNumber type="number" value = "${task.estimate}"></fmt:formatNumber>">
					  <span class="input-group-addon"><i class="icon icon-time "></i></span>
				  </div>
	 		</div>
			<!-- 	任务描述 -->
		  	<div class="info">
				<label>任务描述 </label>
				<textarea id="descript" name="descript" id="descript" class="form-control kindeditor"></textarea>
			</div>
			<!-- 	日程规划 -->
			<div class="info">
				<label>日程规划</label>
				<div class="input-group " >
					<input type="text" class="form-control form-date" name="estStarted" id="estStarted" placeholder="预计开始" value="${task.estStarted}"/>
					<span class="input-group-addon" style="background: #6495ED;border:none;">~</span>
					<input type="text" class="form-control form-date" name="deadline" id="deadline" placeholder="截止日期"  value="${task.deadline}"/>
				</div>
			</div>
			<!-- 	抄送给 -->
			<div class="info">
		  		<label>抄送给</label> 
		  		<select class="chosen-select form-control" name="mailto" id="mailto">
		  			<option value=""></option>
					<c:forEach items="${teamList}" var="team">
						<option value="${team.account}" <c:if test="${team.account == task.assignedTo }">selected</c:if>>${fn:toUpperCase(team.account.toCharArray()[0])}:${team.realname}</option>
					</c:forEach>
		  		</select>
		  	</div>
 				<!-- 	附件 -->
<!-- 			<div class="info panel"> -->
<!-- 				<div class="panel-heading" style="color: #31708f; padding: 2px 4px;"> -->
<!-- 					<label><i class="icon icon-file-o"></i>&nbsp;附件</label> -->
<!-- 				</div> -->
<!-- 				<div class="panel-body"> -->
				  
				 
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
		<!--  	按钮 -->
		<div class="btn1"> 
			<button type="submit"  data-loading="稍候..." class="btn-save">保存</button>
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
		
		//日期插件
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
		//获取模块列表
		getProjectModules("${task.project.id}");
		//根据模块，获取相关需求列表
		getStorysForModules("${task.module_id}");
	});
	//获得模块list
	function getProjectModules(projectId) {	
		//通过连接获取方法返回值(tree)
		$.get("../ajaxGetModules/" + projectId,function(data){
			//移去原模块list
			$("#module, #module + div, #module + div + span").remove();
			//添加新模块list
			$("#moduleIdBox").append("<select name='module_id' id='module' class='chosen-select chose form-control' onchange='getStorysForModules(this.value)'></select>");
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
	function getStorysForModules(moduleId) {
		$.get("../ajaxGetStoryForModule/"+moduleId,function(data){
			//当没有找到相应需求的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#story").remove();
			//添加需求list
			$("#storyIdBox").append("<select name='story_id' id='story' class='chosen-select chose form-control'></select>");
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
	//判断必填项是否为空
	function check() {
		var name = $("#name").val();
		var type = $("#type").val();
		var estimate = $("#estimate").val();
		if(name == null || name == "") {
			alert("“任务名称”不能为空！");
			return false;
		}else if(type == null || type == "") {
			alert("“任务类型”不能为空！");
			return false;
		}else if(estimate == null || estimate == "") {
			alert("“最初预计”不能为空！");
			return false;
		}else if(checkSchedule() == false) {
			return false;
		}
	}
	//规划日程的判断
	function checkSchedule() {
		var estStarted = new Date($('#estStarted').val().replace(/-/g,"/"));
		console.log(estimate);
		var deadline = new Date($('#deadline').val().replace(/-/g,"/"));
		console.log(estimate);
		if(estStarted >= deadline) {
			alter("“最初预计”不能大于“截止时间”！");
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