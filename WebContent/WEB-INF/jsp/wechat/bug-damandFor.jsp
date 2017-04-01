<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<title>&nbsp;>&nbsp;提需求</title>
</head>
<body>
	<form action="" method="post" id="damandForForm" onsubmit="return check()">
		<div class="title">
			<h2>提需求</h2>
		</div>
		<div class="main-wrap">
			<div class="info">
				<label>所属产品</label>
				<select class="chosen-select form-control" name="product" id="product" onchange="getChange(this.value)">
					<option value=""></option>
					<c:forEach items="${productList}" var ="pro">
						<option value="${pro.id}" <c:if test="${pro.id == bug.product.id}">selected</c:if>>${pro.name}</option>
					</c:forEach>
				</select>
			</div>
			<div class="info" id="branchIdBox">
				<label>所属平台</label>
				<select class="chosen-select chosen form-control" name="branch_id" id="branch">
					<option></option>
				</select>
			</div>
			<div class="info" id="moduleIdBox" >
				<label>所属模块</label>
				<select class="chosen-select chosen form-control" name="module_id" id="module">
					<option></option>
				</select>
			</div>
			<div class="info" id="planIdBox">
				<label>所属计划</label>
				<select class="chosen-select chosen form-control" name="plan_id" id="plan">
					<option></option>
				</select>
			</div>
			<div class="info">
				<label>需求来源</label>
				<select class="chosen-select chosen form-control" name="source" id="source">
					<option value="" ></option>
					<option value="customer" >客户</option>
					<option value="user" >用户</option>
					<option value="po" >产品经理</option>
					<option value="market" >市场</option>
					<option value="service" >客服</option>
					<option value="operation" >运营</option>
					<option value="support" >技术支持</option>
					<option value="competitor" >竞争对手</option>
					<option value="partner" >合作伙伴</option>
					<option value="dev" >开发人员</option>
					<option value="tester" >测试人员</option>
					<option value="bug" selected >Bug</option>
					<option value="other" >其他</option>
				</select>
			</div>
			<div class="info">
				<label>备注</label>
				<input type="text" name="comment" id="comment" class="form-control">
			</div>
			<div class="info">
				<label>由谁评审</label>
				<select class="chosen-select chosen form-control" name="assignedTo" id="assignedTo">
					<option value=""></option>
		  			<c:forEach items="${userList}" var="user">
			    		<option value = "${user.account}" >
			    		${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
			    		</option>
			    	</c:forEach>
				</select>
			</div>
			<div class="info">
				<label>需求名称</label>
				<input type="text" class="form-control" name="title" id="title" value="${bug.title}">
			</div>
			<div class="info">
				<label>优先级</label>
				<select class="chosen-select form-control" name="pri" id="pri">
					<option value="0" <c:if test="${bug.pri == '0'}">selected</c:if>></option>
					<option value="1" <c:if test="${bug.pri == '1'}">selected</c:if>>1</option>
					<option value="2" <c:if test="${bug.pri == '2'}">selected</c:if>>2</option>
					<option value="3" <c:if test="${bug.pri == '3'}">selected</c:if>>3</option>
					<option value="4" <c:if test="${bug.pri == '4'}">selected</c:if>>4</option>
				</select>
			</div>
			<div class="info">
				<label>预计工时</label>
				<input type="text" class="form-control" name="estimate" id="estimate">
			</div>
			<div class="info">
				<label>需求描述</label>
				<textarea name="spec" id="spec"></textarea>
			</div>
			<div class="info">
				<label>验收标准</label>
				<textarea name="verify" id="verify"></textarea>
			</div>
			<div class="info">
				<label>抄送给</label>
				<select class="chosen-select chosen form-control" name="mailto" id="mailto" >
					<option value=""></option>
		  			<c:forEach items="${userList}" var="user">
			    		<option value = "${user.account}">
			    		${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}
			    		</option>
			    	</c:forEach>
				</select>
			</div>
			<div class="info">
				<label>关键字</label>
				<input type="text" class="form-control" name="keywords" id="keywords">
			</div>
<!-- 			<div class="info panel"> -->
<!-- 				<div class="panel-heading"> -->
<!-- 					<label><i class="icon icon-file-o"></i>&nbsp;附件</label> -->
<!-- 				</div> -->
<!-- 				<div class=" panel-body"> -->
				  
				 
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
		<!-- 	按钮 -->
		<div class="btn1"> 
		  <button type="submit" data-loading="稍候..." class="btn btn-lg btn-save">保存</button>
		  <button type="button" data-loading="稍候..." class="btn btn-lg btn-save" onclick="history.go(-1)">返回</button>
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
		getChange("${bug.product.id}");
	});
	function getChange(productId) {
		//获取模块列表
		getProductModules(productId);
		//获取平台列表
		getProductBranch(productId);
		//获取计划列表
		getProductPlan(productId);
	}
	//根据productId获取模块
	function getProductModules(productId) {
		//通过链接获取方法返回值（tree）
		$.get("../ajaxGetModulesForproduct/" + productId, function(data) {
			//移去原模块list
			$("#module, #module + div, #module + div +span").remove();
			//添加新模块list
			$("#moduleIdBox").append("<select name='module_id' id='module' class='chosen-select chosen form-control'></select>");
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
			$("#branchIdBox").append("<select name='branch_id' id='branch' class='chosen-select chosen form-control'></select>");
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
	//获取相关计划list
	function getProductPlan(productId) {
		$.get("../getPdPlan/"+ productId,function(data){
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去计划list
			$("#plan").remove();
			//添加计划list
			$("#planIdBox").append("<select name='plan_id' id='plan' class='chosen-select chosen form-control'></select>");
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