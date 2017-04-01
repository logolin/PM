<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String hiredate=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html>
<html>
<head>
 	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
    <script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
    
<script type="text/javascript">
$(document).ready(function() {
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true
	});
	
}); 	

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
</script>
<title>组织视图首页::部门结构</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
	<div class="wrap">
		<div class="outer" style="min-height: 406px;">
			<div class="container mw-700px" style="margin-top:20px">
				<div id="titlebar">
				    <div class="heading">
				      <span class="prefix"><i class="icon-user"></i></span>
				      <strong><small class="text-muted"><i class="icon-plus"></i></small> 添加用户</strong>
				    </div>
				</div>
				<form class="form-condensed mw-700px" name="user" onsubmit="return check();" method="post" target="_parent" id="userForm">
					<table align="center" class="table table-form"> 
			      		<tbody>
			      			<tr>
						    	<th class="w-120px">所属部门</th>
						        <td class="w-p50">
						        	<select name="dept_id" id="dept" class="form-control chosen">
										<option value="0" selected="selected">/</option>
									</select>
								</td>
			      			</tr>
			      			<tr>
			      				<th>用户名</th>
			      				<td><div class="required required-wrapper"></div>
			      					<input type="text" name="account" id="account" value="" class="form-control" autocomplete="off" placeholder="英文、数字和下划线的组合，三位以上">
			      				</td>
			      			</tr>
			      			<tr>
			      				<th>真实姓名</th>
			      				<td><div class="required required-wrapper"></div>
			      					<input type="text" name="realname" id="realname" value="" class="form-control" autocomplete="off">
			      				</td>
			      			</tr>
			      			<tr>
			      				<th>密码</th>
						        <td><div class="required required-wrapper"></div>
						          <span class="input-group">
						          	<input type="password" name="hidepass" style="display:none">
						          	<input type="password" name="password" id="password1" value="" class="form-control" autocomplete="off" placeholder="六位以上">
						          	<span class="input-group-addon" id="passwordStrength"></span>
						          </span>
						        </td>
			      			</tr>
						    <tr>
			      			<th>请重复密码</th>
				      			<td><div class="required required-wrapper"></div>
				      				<input type="password" name="password2" id="password2" value="" class="form-control" autocomplete="off">
				      			</td>
			      			</tr>
			      			<tr>
			      				<th>职位</th>
			      				<td>
			      					<select name="role" id="role" class="form-control" onchange="changeGroup(this.value)">
										<option value="" selected="selected"></option>
										<option value="dev">研发</option>
										<option value="qa">测试</option>
										<option value="pm">项目经理</option>
										<option value="po">产品经理</option>
										<option value="td">研发主管</option>
										<option value="pd">产品主管</option>
										<option value="qd">测试主管</option>
										<option value="top">高层管理</option>
										<option value="others">其他</option>
									</select>
			      				</td>
			      				<td>职位影响内容和用户列表的顺序。</td>
			      			</tr>
			      			<tr>
						        <th>分组</th>
						        <td>
							        <select name="groupId" id="group" class="form-control chosen-select">
							        	<option ></option>
							        	<c:forEach items="${groupList}" var="group">
							        		<option value="${group.id}">${group.name}</option>
							        	</c:forEach>
									</select>
								</td>
						        <td>分组决定用户的权限列表。</td>
			      			</tr>
			      			<tr>
				      			<th>邮箱</th>
				      			<td><input type="text" name="email" id="email" value="" class="form-control"></td>
			      			</tr>
			      			<tr>
				      			<th>源代码帐号</th>
				      			<td><input type="text" name="commiter" id="commiter" value="" class="form-control" placeholder="版本控制系统(subversion)中的帐号"></td>
			      			</tr>
			      			<tr>
				      			<th>入职日期</th>
				      			<td>
				      				<input type="text" id="hiredate" value="" class="form-control form-date" data-picker-position="top-right">
				      				<input type="hidden" name="hiredate" id="copyhiredate" value="<%=hiredate%>"/>
				      			</td>
			      			</tr>
			      			<tr>
				      			<th>性别</th>
				      			<td>
				      				<label class="radio-inline"><input type="radio" name="gender" value="m" checked="checked" id="genderm"> 男</label>
				      				<label class="radio-inline"><input type="radio" name="gender" value="f" id="genderf"> 女</label>
				      			</td>
			      			</tr>
			      			<tr>
			      				<th>请输入你的密码</th>
				      			<td>
					      			<div class="required required-wrapper"></div>
					      			<input type="password" name="verifyPassword" id="verifyPassword" value="" class="form-control disabled-ie-placeholder" autocomplete="off" placeholder="需要输入你的密码加以验证">
				      			</td>
			      			</tr>
			      			<tr>
			      				<th></th>
			      				<td> <button type="submit" name="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			      				<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
			      				</td>
			      			</tr>
			    		</tbody>
			    	</table>
			  </form>
			</div>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	loadDept();
});
//显示部门
function loadDept() {
	$.ajax({
		url: "../getDept",
		type: 'get',
		async: false,
		success: function(data){
			if(!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			})
		}
	})
}
function iterateTree(data,name) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
// 		s = $(this).data("dept") == data[i].id ? "selected" : "";
		s = "";
		$("#dept").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
		iterateTree(data[i].children,a);
	}
}

function check() {
	if(checkPassword() == false) {
		return false;
	} else if(checkName() == false) {
		return false;
	}
	var password = $("#verifyPassword").val();
	if(password != ${userPassword}) {
		alert("安全验证密码错误，请输入您的登录密码");
		return false;
	}
	if($("#hiredate").val() != null && $("#hiredate").val() != "") {
		$("#copyhiredate").val($("#hiredate").val());
	}
	
	document.getElementById("userForm").submit();
}

function checkPassword() {
	var pass1 = $("#password1").val();
	var pass2 = $("#password2").val();
	if(pass1 !== pass2) {
		
		if(pass1.length<6 && pass2.length<6) {
			alert("两次密码应相等。\n密码应该符合规则，长度至少为六位。");
		} else {
			alert("两次密码应相等。");
		}
		return false;
		
	} else if(!pass1 || !pass2) {
		alert("『密码』不能为空！");
		return false;
	}
}

function checkName() {
	var name = $("#account").val();
	if(!name) {
		alert("『用户名』不能为空！");
		return false;
	}
	$.get("../getAllUser", function(data){
		for(var i = 0; i < data.length; i++) {
			if(data[i].account == name) {
				alert("『用户名』已经有『"+ name +"』这条记录了。如果您确认该记录已删除，请到后台管理-回收站还原。");
				return false;
			}
		}
	})
	
}
</script>
</body>
</html>