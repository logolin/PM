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
<title>${bug.id}::${bug.title}&nbsp;>&nbsp;编辑</title>
</head>
<body>
	<form action="" id="editForm" method="post" onsubmit="return check()">
		<div class="title">
			<h2>编辑 <small>(id:${bug.id})</small></h2>
		</div>
		<div class="main-wrap">
			<!-- 名称 -->
			<div class="" style="line-height:34px;vertical-align:middle;">
				<label class="col-xs-4">Bug标题<small>*</small></label>
				<div class="input-group col-xs-8" >
					<input type="text" class="form-control" name="title" id="title" value="${bug.title}"/>
				</div>
			</div>
			<div class="panel">
				<div class="panel-heading">基本信息</div>
				<div class="panel-body">
					<div class="panel-body-info">
				  		<label class="col-xs-4">所属产品 </label> 
						<select class="chosen-select chosen col-xs-8" name="product" id="product" onchange="getChange(this.value)">
							<option value=""></option>
							<c:forEach items="${productList}" var ="pro">
								<option value="${pro.id}" <c:if test="${pro.id == bug.product.id}">selected</c:if>>${pro.name}</option>
							</c:forEach>
						</select>
				  	</div>
				  	<div class="panel-body-info" id="branchIdBox">
				  		<label class="col-xs-4">所属平台 </label> 
						<select class="chosen-select chosen col-xs-8" name="branch_id" id="branch">
							<option></option>
					    </select>
				  	</div>
				  	<div class="panel-body-info" id="moduleIdBox">
				  		<label class="col-xs-4">所属模块 </label> 
						<select class="chosen-select chosen col-xs-8" name="module_id" id="module">
							<option></option>
					    </select>
				  	</div>
				  	<div class="panel-body-info" id="planIdBox">
				  		<label class="col-xs-4">所属计划 </label> 
						<select class="chosen-select chosen col-xs-8" name="plan_id" id="plan">
						    <option></option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">Bug类型</label> 
					    <select class="chosen-select  col-xs-8" name="type" id="type">
					    	<option value="" ></option>
					    	<option value="codeerror" 		<c:if test="${bug.type == 'codeerror'}">selected</c:if>>代码错误</option>
					    	<option value="interface" 		<c:if test="${bug.type == 'interface'}">selected</c:if>>界面优化</option>
					    	<option value="designdefect" 	<c:if test="${bug.type == 'designdefect'}">selected</c:if>>设置缺陷</option>
					    	<option value="config" 			<c:if test="${bug.type == 'config'}">selected</c:if>>设计相关</option>
					    	<option value="install" 		<c:if test="${bug.type == 'install'}">selected</c:if>>安装部署</option>
					    	<option value="security" 		<c:if test="${bug.type == 'security'}">selected</c:if>>安全相关</option>
					    	<option value="performance" 	<c:if test="${bug.type == 'performance'}">selected</c:if>>性能问题</option>
					    	<option value="standard" 		<c:if test="${bug.type == 'standard'}">selected</c:if>>标准规范</option>
					    	<option value="automation" 		<c:if test="${bug.type == 'automation'}">selected</c:if>>测试脚本</option>
					    	<option value="codeimprovement" <c:if test="${bug.type == 'codeimprovement'}">selected</c:if>>代码改进</option>
					    	<option value="others" 			<c:if test="${bug.type == 'others'}">selected</c:if>>其他</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">严重程度</label> 
					    <select class="chosen-select  col-xs-8" name="severity" id="severity">
					    	<option value="1" <c:if test="${bug.severity == '1' }">selected</c:if>>1</option>
					    	<option value="2" <c:if test="${bug.severity == '2' }">selected</c:if>>2</option>
					    	<option value="3" <c:if test="${bug.severity == '3' }">selected</c:if>>3</option>
					    	<option value="4" <c:if test="${bug.severity == '4' }">selected</c:if>>4</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">优先级</label> 
					    <select class="chosen-select  col-xs-8" name="pri" id="pri">
					    	<option value="0" <c:if test="${bug.pri == '0'}">selected</c:if>></option>
					    	<option value="1" <c:if test="${bug.pri == '1'}">selected</c:if>>1</option>
					    	<option value="2" <c:if test="${bug.pri == '2'}">selected</c:if>>2</option>
					    	<option value="3" <c:if test="${bug.pri == '3'}">selected</c:if>>3</option>
					    	<option value="4" <c:if test="${bug.pri == '4'}">selected</c:if>>4</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">Bug状态</label> 
					    <select class="chosen-select  col-xs-8" name="status" id="status">
					    	<option value="" ></option>
					    	<option value="active" <c:if test="${bug.status == 'active'}">selected</c:if>>激活</option>
					    	<option value="resolved" <c:if test="${bug.status == 'resolved'}">selected</c:if>>已解决</option>
					    	<option value="closed" <c:if test="${bug.status == 'closed'}">selected</c:if>>已关闭</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">是否确认</label> 
					    <div class="col-xs-8 no-edit" id="confirm" name="confirm">
					    	<c:if test="${bug.confirmed == 1}">已确认</c:if>
					    	<c:if test="${bug.confirmed == 0}">未确认</c:if>
					    </div>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">指派给</label> 
					    <select class="chosen-select  col-xs-8" name="assignedTo" id="assignedTo">
					    	<option value=""></option>
					    	<c:forEach items="${userList}" var = "user">
					    		<option value = "${user.account}" <c:if test="${user.account == bug.assignedTo }">selected</c:if>>
					    			${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
					    		</option>
					    	</c:forEach>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">操作系统</label> 
					    <select class="chosen-select  col-xs-8" name="os" id="os">
					    	<option value="" selected="selected"></option>
					    	<option value="all" <c:if test="${bug.os == 'all'}">selected</c:if>>全部</option>
					    	<option value="windows" <c:if test="${bug.os == 'windows'}">selected</c:if>>Windows</option>
					    	<option value="win8" 	<c:if test="${bug.os == 'win8'}">selected</c:if>>Windows 8</option>
					    	<option value="win7" 	<c:if test="${bug.os == 'win7'}">selected</c:if>>Windows 7</option>
					    	<option value="vista" 	<c:if test="${bug.os == 'vista'}">selected</c:if>>Windows Vista</option>
					    	<option value="winxp" 	<c:if test="${bug.os == 'winxp'}">selected</c:if>>Windows XP</option>
					    	<option value="win2012" <c:if test="${bug.os == 'win2012'}">selected</c:if>>Windows 2012</option>
					    	<option value="win2008" <c:if test="${bug.os == 'win2008'}">selected</c:if>>Windows 2008</option>
					    	<option value="win2003" <c:if test="${bug.os == 'win2003'}">selected</c:if>>Windows 2003</option>
					    	<option value="win2000" <c:if test="${bug.os == 'win2000'}">selected</c:if>>Windows 2000</option>
					    	<option value="android" <c:if test="${bug.os == 'android'}">selected</c:if>>Android</option>
					    	<option value="ios" 	<c:if test="${bug.os == 'ios'}">selected</c:if>>IOS</option>
					    	<option value="wp8" 	<c:if test="${bug.os == 'wp8'}">selected</c:if>>WP8</option>
					    	<option value="wp7" 	<c:if test="${bug.os == 'wp7'}">selected</c:if>>WP7</option>
					    	<option value="symbian" <c:if test="${bug.os == 'symbian'}">selected</c:if>>Symbian</option>
					    	<option value="linux" 	<c:if test="${bug.os == 'linux'}">selected</c:if>>Linux</option>
					    	<option value="freebsd" <c:if test="${bug.os == 'freebsd'}">selected</c:if>>FreeBSD</option>
					    	<option value="osx" 	<c:if test="${bug.os == 'osx'}">selected</c:if>>OS X</option>
					    	<option value="unix" 	<c:if test="${bug.os == 'unix'}">selected</c:if>>Unix</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">浏览器</label> 
					    <select class="chosen-select  col-xs-8" name="browser" id="browser">
					    	<option value="" selected="selected"></option>
					    	<option value="all" 	<c:if test="${bug.browser == 'all'}">selected</c:if>>全部</option>
					    	<option value="ie"  	<c:if test="${bug.browser == 'ie'}">selected</c:if>>IE系列</option>
					    	<option value="ie11"  	<c:if test="${bug.browser == 'ie11'}">selected</c:if>>IE 11</option>
					    	<option value="ie10"  	<c:if test="${bug.browser == 'ie10'}">selected</c:if>>IE 10</option>
					    	<option value="ie9"  	<c:if test="${bug.browser == 'ie9'}">selected</c:if>>IE 9</option>
					    	<option value="ie8"  	<c:if test="${bug.browser == 'ie8'}">selected</c:if>>IE 8</option>
					    	<option value="ie7"  	<c:if test="${bug.browser == 'ie7'}">selected</c:if>>IE 7</option>
					    	<option value="ie6"     <c:if test="${bug.browser == 'ie6'}">selected</c:if>>IE 6</option>
					    	<option value="chrome"  <c:if test="${bug.browser == 'chrome'}">selected</c:if> >Chrome</option>
					    	<option value="firefox" <c:if test="${bug.browser == 'firefox'}">selected</c:if>>Firefox系列</option>
					    	<option value="firefox4"<c:if test="${bug.browser == 'firefox4'}">selected</c:if>>Firefox 4</option>
					    	<option value="firefox3"<c:if test="${bug.browser == 'firefox3'}">selected</c:if>>Firefox 3</option>
					    	<option value="firefox2"<c:if test="${bug.browser == 'firefox2'}">selected</c:if>>Firefox 2</option>
					    	<option value="opera"   <c:if test="${bug.browser == 'opera'}">selected</c:if>>Opera系列</option>
					    	<option value="opera11" <c:if test="${bug.browser == 'opera11'}">selected</c:if>>Odpera 11</option>
					    	<option value="opera10" <c:if test="${bug.browser == 'opera10'}">selected</c:if>>Opera 10</option>
					    	<option value="opera9"  <c:if test="${bug.browser == 'opera9'}">selected</c:if>>Opera 9</option>
					    	<option value="safari"  <c:if test="${bug.browser == 'safari'}">selected</c:if>>Safari</option>
					    	<option value="maxthon" <c:if test="${bug.browser == 'maxthon'}">selected</c:if>>遨游</option>
					    </select>
				  	</div>
				  	<div class="panel-body-info">
				  		<label class="col-xs-4">关键字</label> 
					    <div class="input-group col-xs-8">
						  <input type="text" class="form-control" name="keywords" id="keywords"  value="${bug.keywords}"/>
						</div>
			 		</div>
			 		<div class="panel-body-info">
				  		<label class="col-xs-4">抄送给</label> 
				  		<select class="chosen-select col-xs-8" name="mailto" id="mailto">
				  			<option value=""></option>
				  			<c:forEach items="${userList}" var = "user">
					    		<option value = "${user.account}" <c:if test="${user.account == bug.mailto }">selected</c:if>>
					    		${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
					    		</option>
					    	</c:forEach>
				  		</select>
				  	</div>
				</div>
			</div>
			<div class="panel">
				<div class="panel-heading">项目/需求/任务</div>
				<div class="panel-body">
					<div class="panel-body-info">
						<div class="panel-body-info" id="projectIdBox" onchange="getProjectTask(this.value)">
					  		<label class="col-xs-4">所属项目</label> 
							    <select class="chosen-select chosen col-xs-8" name="project_id" id="project">
							    <option></option>
						    </select>
					  	</div>
					</div>
					<div class="panel-body-info" id="storyIdBox">
				  		<label class="col-xs-4">相关需求</label> 
						    <select class="chosen-select chosen col-xs-8" name="story_id" id="story">
						    <option></option> 
					    </select>
				  	</div>
				  	<div class="panel-body-info" id="taskIdBox" >
				  		<label class="col-xs-4">相关任务</label> 
						    <select class="chosen-select chosen col-xs-8" name="task_id" id="task">
						    <option></option>
					    </select>
				  	</div>
				</div>
			</div>
			<div class="panel">
				<div class="panel-heading">BUG的一生</div>
				<div class="panel-body">
					<div class="panel-body-info">
				  		<label class="col-xs-4">由谁创建</label> 
					    <div class="col-xs-8 no-edit" name="openedBy" id="openedBy">${userMap[bug.openedBy]}</div>
				  	</div>
				  	<div class="panel-body-info">
						<label class="col-xs-4">影响版本<small>*</small></label>
						<select class="chosen-select col-xs-8" name="openedBuild" id="openedBuild">
							<option value= "" selected></option>
							<option value= "trunk"   <c:if test="${bug.openedBuild == 'trunk'}">selected</c:if>>Trunk</option>
							<option value= "module"  <c:if test="${bug.openedBuild == 'module'}">selected</c:if>>Module</option>
							<option value= "project" <c:if test="${bug.openedBuild == 'project'}">selected</c:if>>Project</option>
						</select>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">解决者</label> 
						<select class="chosen-select col-xs-8" name="resolvedBy" id="resolvedBy">
						 	<option value=""></option>
				  			<c:forEach items="${userList}" var = "user">
					    		<option value = "${user.account}" <c:if test="${user.account == bug.assignedTo}">selected</c:if>>
					    		${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
					    		</option>
					    	</c:forEach>
						</select>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">解决日期</label> 
						<div class="input-group col-xs-8" >
							<input type="text" class="form-control form-datetime" name="resolvedDate" id="resolvedDate" value="<fmt:formatDate value="${bug.resolvedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"/>
							<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">解决版本</label>
						<select class="chosen-select col-xs-8" name="resolvedBuild" id="resolvedBuild" >
							<option value= "" selected></option>
							<option value= "trunk"   <c:if test="${bug.resolvedBuild == 'trunk'}">selected</c:if>>Trunk</option>
							<option value= "module"  <c:if test="${bug.resolvedBuild == 'module'}">selected</c:if>>Module</option>
							<option value= "project" <c:if test="${bug.resolvedBuild == 'project'}">selected</c:if>>Project</option>
						</select>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">解决方案 </label>
						<select class="chosen-select  col-xs-8" name="resolution" id="resolution" onchange="showBugId()">
							<option value="" selected></option>
							<option value="bydesign"   <c:if test="${bug.resolution == 'bydesign'}">selected</c:if>>设计如此</option>
							<option value="duplicate"  <c:if test="${bug.resolution == 'duplicate'}">selected</c:if>>重复Bug</option>
							<option value="external"   <c:if test="${bug.resolution == 'external'}">selected</c:if>>外部原因</option>
							<option value="fixed"      <c:if test="${bug.resolution == 'fixed'}">selected</c:if>>已解决</option>
							<option value="notrepro"   <c:if test="${bug.resolution == 'notrepro'}">selected</c:if>>无法重现</option>
							<option value="postponed"  <c:if test="${bug.resolution == 'postponed'}">selected</c:if>>延期处理</option>
							<option value="willnotfix" <c:if test="${bug.resolution == 'willnotfix'}">selected</c:if>>不予解决</option>
							<option value="tostory"    <c:if test="${bug.resolution == 'tostory'}">selected</c:if>>转为需求</option>
						</select>
					</div>
					<div class="panel-body-info duplicateBug" style="display:none;">
						<label class="col-xs-4">重复ID<small>*</small></label> 
						<div class="input-group col-xs-8" >
							<input type="text" class="form-control" name="duplicateBug" id="duplicateBug" value="0"/>
						</div>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">由谁关闭</label> 
						<select class="chosen-select  col-xs-8" name="closedBy" id="closedBy">
						 	<option value=""></option>
				  			<c:forEach items="${userList}" var = "user">
					    		<option value = "${user.account}" <c:if test="${user.account == bug.closedBy}">selected</c:if>>
					    		${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
					    		</option>
					    	</c:forEach>
						</select>
					</div>
					<div class="panel-body-info">
						<label class="col-xs-4">关闭日期</label> 
						<div class="input-group col-xs-8" >
							<input type="text" class="form-control form-datetime" name="closedDate" id="closedDate" value="<fmt:formatDate value="${bug.closedDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"/>
							<span class="input-group-addon"><i class="icon icon-calendar"></i></span>
						</div>
					</div>
				</div>
			</div>
			<div class = "panel">
				<div class="panel-heading">其他相关</div>
				<div class="panel-body">	
				</div>
			</div>
			<div class = "panel">
				<div class="panel-heading">重要步骤</div>
				<div class="panel-body" style="padding:0;">
					<textarea name="step" id="step"></textarea>
				</div>
			</div>
			<div class = "panel">
				<div class="panel-heading">备注</div>
				<div class="panel-body" style="padding:0;">
					<textarea name="comment" id="comment"></textarea>
				</div>
			</div>	
<!-- 			<div class="panel" > -->
<!-- 				<div class="panel-heading"> -->
<!-- 					<label style="font-weight:normal;"><i class="icon icon-file-o"></i>&nbsp;附件</label> -->
<!-- 				</div> -->
<!-- 				<div class="panel-body"> -->
<!-- 				</div> -->
<!-- 			</div>	 -->
		</div>
		<input type="hidden" name="lastEditedBy" id="lastEditedBy" value="${currentUser.account}">
       	<input type="hidden" name="lastEditedDate" id="lastEditedDate" value="<%=lastEditedDate%>">
		<div class="btn1"> 
		  <button type ="submit"  data-loading="稍候..."class="btn btn-lg btn-save">保存</button>
		  <button type ="button"  data-loading="稍候..."class="btn btn-lg btn-save" onclick="history.go(-1)">返回</button>
		</div>
	</form>

</body>
<script type="text/javascript">
	$(function() {
		showBugId();
		var resolution = $('#resolution').val();
		if(resolution == 'duplicate') {
			$('.duplicateID').show();
		}
		//单项选择
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
		    disable_search_threshold: 10, // 10 个以下的选择项则不显示检索框
		    search_contains: true,         // 从任意位置开始检索
		    allow_single_deselect:true,
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
		getChange("${bug.product.id}");
		getProjectTask("${bug.project_id}");
	});
	function getChange(productId) {
		//获取平台列表
		getProductBranch(productId);
		//获取模块列表
		getProductModules(productId);
		//获取计划列表
		getProductPlan(productId);
		//获取需求列表
		getProductStorys(productId);
		//获取项目列表
		getProductProjects(productId);
	}
	//获取相关平台list
	function getProductBranch(productId) {
		$.get("../getPdBranch/"+ productId,function(data){
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去平台list
			$("#branch").remove();
			//添加平台list
			$("#branchIdBox").append("<select name='branch_id' id='branch' class='chosen-select chosen col-xs-8'></select>");
			//添加平台list默认值
			$("#branch").append("<option value='0' selected></option>");
			//若平台list不为空，执行循环，添加平台list显示出来
			if (!$.isEmptyObject(data)) {
				var branchId = ${bug.branch_id};
				for (var i = 0; i < data.length; i++) {
					b = branchId == data[i].id ? "selected" : "";
					$("#branch").append("<option value='" + data[i].id + "' "+ b +">" + data[i].name +"</option>");
				}
			}
		})
	}
	//根据productId获取模块
	function getProductModules(productId) {
		//通过链接获取方法返回值（tree）
		$.get("../ajaxGetModulesForproduct/" + productId, function(data) {
			//移去原模块list
			$("#module, #module + div, #module + div +span").remove();
			//添加新模块list
			$("#moduleIdBox").append("<select name='module_id' id='module' class='chosen-select chosen col-xs-8'></select>");
			//添加模块list默认值"/"
			$("#module").append("<option value='0' select>/</option>");
			//若模块list不为空，执行循环
			if(!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			$("select.chosen").chosen ({
				no_results_text:'没有找到',
				search_contains:true,
			});
		})
	}
	//模块list分隔显示出来
	function iterateTree(data,name) {
		var modId = ${bug.module_id};
		for (var i = 0; i < data.length; i++) {
			a = name + "/" + data[i].name;
			s = modId == data[i].id ? "selected" : "";
			$("#module").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
			iterateTree(data[i].children,a);
		}
	} 
	//获取相关计划list
	function getProductPlan(productId) {
		console.log('1');
		$.get("../getPdPlan/"+ productId,function(data){
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去计划list
			$("#plan").remove();
			//添加计划list
			$("#planIdBox").append("<select name='plan_id' id='plan' class='chosen-select chosen col-xs-8'></select>");
			//添加计划list默认值
			$("#plan").append("<option value='0' selected></option>");
			//若计划list不为空，执行循环，添加计划list显示出来
			if (!$.isEmptyObject(data)) {
				var planId = ${bug.plan_id};
				for (var i = 0; i < data.length; i++) {
					p = planId == data[i].id ? "selected" : "";
					$("#plan").append("<option value='" + data[i].id + "' "+ p +">" + data[i].title +"</option>");
				}
			}
		})
	}
	//获取相关需求list
	function getProductStorys(productId) {
		$.get("../getPdStorys/"+productId,function(data){
			//当没有找到相应需求的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#story").remove();
			//添加需求list
			$("#storyIdBox").append("<select name='story_id' id='story' class='chosen-select chosen col-xs-8'></select>");
			//添加需求list默认值
			$("#story").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var styId = ${bug.story_id};
				for (var i = 0; i < data.length; i++) {
					s = styId == data[i].id ? "selected" : "";
					$("#story").append("<option value='" + data[i].id + "' "+ s +">" + data[i].id + ":"+ data[i].title +" (优先级："+data[i].pri+","+"预计工时："+data[i].estimate+")</option>");
				}
			}
		})
	}
	//获取相关需求list
	function getProductProjects(productId) {
		$.get("../getPdProject/"+productId,function(data){
			//当没有找到相应需求的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#project").remove();
			//添加需求list
			$("#projectIdBox").append("<select name='project_id' id='project' class='chosen-select chosen col-xs-8'></select>");
			//添加需求list默认值
			$("#project").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var styId = ${bug.project_id};
				for (var i = 0; i < data.length; i++) {
					s = styId == data[i].id ? "selected" : "";
					$("#project").append("<option value='" + data[i].id + "' "+ s +">" + data[i].id + ":"+ data[i].name +"</option>");
				}
			}
		})
	}
	//获取任务list
	function getProjectTask(projectId) {
		$.get("../getProTask/"+projectId,function(data){
			//当没有找到相应需求的时候，显示“没有找到”
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#task").remove();
			//添加需求list
			$("#taskIdBox").append("<select name='task_id' id='task' class='chosen-select chosen col-xs-8'></select>");
			//添加需求list默认值
			$("#task").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var styId = ${bug.task_id};
				for (var i = 0; i < data.length; i++) {
					s = styId == data[i].id ? "selected" : "";
					$("#task").append("<option value='" + data[i].id + "' "+ s +">" + data[i].id + ":"+ data[i].name +"</option>");
				}
			}
		})
	}
	//检查
	function check() {
		var title = $('#title').val();
		var resolution = $('#resolution').val();
		var duplicateBug = $('#duplicateBug').val();
		var openedBuild = $('#openedBuild').val();
		if(title == null || title == "") {
			alert('“Bug标题”不能为空！');
			return false;
		}
		if(resolution == "duplicate") {
			if(duplicateBug == null || duplicateBug == "" || duplicateBug == 0) {
				alert('“重复ID”不能为空！');
				return false;
			}
		}
		if(openedBuild == null || openedBuild == "") {
			alert('“影响版本”不能为空！');
			return false;
		}
	}
	function showBugId() {
		var resolution = $('#resolution').val();
		if(resolution == "duplicate") {
			$('.duplicateBug').show();
		}
	}
</script>
</html>