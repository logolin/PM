<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	    allow_single_deselect: true,
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
<title>组织视图::编辑用户</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
		<div id="wrap">
			<div class="outer" style="min-height: 406px;">
				<div class="container mw-800px">
					<div id="titlebar">
					    <div class="heading">
					    	<span class="prefix" title="USER"><i class="icon-user"></i> <strong>${user.id}</strong></span>
					   		<strong><a href="">${user.realname}</a>
					 		(<small>${user.account}</small>)</strong>
					      	<small class="text-muted"> 编辑用户 <i class="icon-pencil"></i></small>
						</div>
					</div>
				  	<form class="form-condensed" method="post" name="user" onsubmit="return check()" id="userForm" target="_parent">
					    <table align="center" class="table table-form">
						      <caption class="text-left text-muted">基本信息</caption>
						      <tbody>
						      	<tr>
							        <th class="w-90px">真实姓名</th>
							        <td class="w-p40"><div class="required required-wrapper"></div>
							        	<input type="text" name="realname" id="realname" value="${user.realname}" class="form-control" autocomplete="off">
									</td>
									<td style="padding-left: 15px;"></td><td></td>
					   			</tr>
					   			<tr>
						   			<th class="w-90px">所属部门</th>
						   			<td class="w-p40">
						   				<select name="dept_id" id="dept" class="form-control chosen">
							   				<option value="0">/</option>
							   			</select>
						   			</td>
						   			<th>职位</th>
						   			<td><select name="role" id="role" class="form-control">
										<option value=""></option>
										<option value="dev" <c:if test="${user.role == 'dev'}">selected</c:if>>研发</option>
										<option value="qa" <c:if test="${user.role == 'qa'}">selected</c:if>>测试</option>
										<option value="pm" <c:if test="${user.role == 'pm'}">selected</c:if>>项目经理</option>
										<option value="po" <c:if test="${user.role == 'po'}">selected</c:if>>产品经理</option>
										<option value="td" <c:if test="${user.role == 'td'}">selected</c:if>>研发主管</option>
										<option value="pd" <c:if test="${user.role == 'pd'}">selected</c:if>>产品主管</option>
										<option value="qd" <c:if test="${user.role == 'qd'}">selected</c:if>>测试主管</option>
										<option value="top" <c:if test="${user.role == 'top'}">selected</c:if>>高层管理</option>
										<option value="others" <c:if test="${user.role == 'others'}">selected</c:if>>其他</option>
										</select>
									</td>
					      		</tr>
					      		<tr>
						        	<th>权限</th>
						        	<td colspan="1">
						        		<select name="group" id="groups" size="3" multiple="multiple" class="form-control chosen">
											<option></option>
											<c:forEach items="${groupList}" var="group">
												<c:set var="sele" value="" />
												<c:forEach items="${ugList}" var="ug">
													<c:if test="${group.id == ug.group.id}"><c:set var="sele" value="selected" /></c:if>
												</c:forEach>
												<option value="${group.id}" ${sele}>${group.name}</option>
											</c:forEach>
										</select>
									</td>
						      	</tr>
						      	<tr>
							        <th>入职日期</th>
							        <td><input type="text" name="hiredate" id="hiredate" value="${user.hiredate}" class="form-control form-date"></td>
						        	<th>性别</th>
						        	<td>
						        		<label class="radio-inline"><input type="radio" name="gender" value="m" <c:if test="${user.gender == 'm'}">checked="checked"</c:if> id="genderm"> 男</label>
						        		<label class="radio-inline"><input type="radio" name="gender" value="f" <c:if test="${user.gender == 'f'}">checked="checked"</c:if> id="genderf"> 女</label>
						        	</td>
					   			</tr>
							</tbody>
					   	</table>
					    <table align="center" class="table table-form">
					   		<caption class="text-left text-muted">帐号信息</caption>
					   		<tbody>
					   			<tr>
							        <th class="w-90px">用户名</th>
							        <td class="w-p40"><div class="required required-wrapper"></div>
							        	<input type="text" name="account" id="account" value="${user.account}" class="form-control" autocomplete="off">
									</td>
					        		<th class="w-90px" style="padding-left: 15px;">邮箱</th>
					        		<td>
					        			<input style="display:none"><!-- for disable autocomplete on chrome -->
							        	<input type="text" name="email" id="email" value="${user.email}" class="form-control">
							        </td>
					   			</tr>
					   			<tr>
							        <th>密码</th>
							        <td>
							          <span class="input-group">
							          	<input type="text" style="display:none">
							        	<input type="password" style="display:none"> 
							          	<input type="password" name="password" id="password1" value="" class="form-control disabled-ie-placeholder">
							            <span class="input-group-addon" id="passwordStrength"></span>
							          </span>
							        </td>
							        <th>请重复密码</th>
							        <td><input type="password" name="password2" id="password2" value="" class="form-control" autocomplete="off"></td>
					   			</tr>
					   			<tr>
							    	<th>源代码帐号</th>
							        <td><input type="text" name="commiter" id="commiter" value="${user.commiter}" class="form-control">
									</td>
								</tr>
					    	</tbody>
					    </table>
					    <table align="center" class="table table-form">
					    	<caption class="text-left text-muted">联系信息</caption>
					      	<tbody>
					      		<tr>
							        <th class="w-90px">Skype</th>
							        <td class="w-p40"><input type="text" name="skype" id="skype" value="${user.skype}" class="form-control"></td>
							        <th class="w-90px">QQ</th>
							        <td><input type="text" name="qq" id="qq" value="${user.qq}" class="form-control"></td>
					      		</tr>  
					      		<tr>
							        <th>雅虎通</th>
							        <td><input type="text" name="yahoo" id="yahoo" value="${user.yahoo}" class="form-control"></td>
							        <th>GTalk</th>
							        <td><input type="text" name="gtalk" id="gtalk" value="${user.gtalk}" class="form-control"></td>
					      		</tr>  
					      		<tr>
						        	<th>旺旺</th>
						        	<td><input type="text" name="wangwang" id="wangwang" value="${user.wangwang}" class="form-control"></td>
						        	<th>手机</th>
						      	  	<td><input type="text" name="mobile" id="mobile" value="${user.mobile}" class="form-control"></td>
						     	</tr>
						     	<tr>
							        <th>电话</th>
							        <td><input type="text" name="phone" id="phone" value="${user.phone}" class="form-control"></td>
							        <th>通讯地址</th>
							        <td><input type="text" name="address" id="address" value="${user.address}" class="form-control"></td>
					      		</tr>  
					      		<tr>
						      		<th>邮编</th>
						      		<td><input type="text" name="zipcode" id="zipcode" value="${user.zipcode}" class="form-control"></td>
					      		</tr>
					    	</tbody>
					    </table>
					    <table align="center" class="table table-form">
					    	<caption class="text-left text-muted">安全验证</caption>
					    	<tbody>
					    		<tr>
								    <th class="w-120px">请输入你的密码</th>
								    <td>
								    	<div class="required required-wrapper"></div>
								        <input type="password" name="verifyPassword" id="verifyPassword" value="" class="form-control disabled-ie-placeholder" autocomplete="off" placeholder="需要输入你的密码加以验证">
								    </td>
								</tr>
					      		<tr>
					      			<td colspan="2" class="text-center"> 
						      			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
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
		s = ${user.dept_id} == data[i].id ? "selected" : "";
		$("#dept").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
		iterateTree(data[i].children,a);
	}
}

function check() {
	if(checkPassword() == false) {
		return false;
	} else if(checkName() == false) {
		return false;
	} else if(checkEmail() == false) {
		return false;
	}
	
	document.getElementById("userForm").submit();
}

function checkPassword() {
	var pass1 = $("#password1").val();
	var pass2 = $("#password2").val();
	if(!pass1 && !pass2) {
		return true;
	}
	if(pass1 !== pass2) {
		
		if(pass1.length<6 && pass2.length<6) {
			alert("两次密码应相等。\n密码应该符合规则，长度至少为六位。");
		} else {
			alert("两次密码应当相等。");
		}
		return false;
	}
}

function checkName() {
	var name = $("#account").val();
	if(!name) {
		alert("用户名不能为空！");
		return false;
	}
	$.get("../getAllUser", function(data){
		for(var i = 0; i < data.length; i++) {
			if(data[i].account == name && data[i].id != ${user.id}) {
				alert("【用户名】已经有『"+ name +"』这条记录了。如果您确认该记录已删除，请到后台管理-回收站还原。");
				return false;
			}
		}
	})
	
}

function checkEmail() {
	var email = $("#email").val();
// 	var i=email.length; 
// 	var temp = email.indexOf(mailto:%20@); 
// 	var tempd = email.indexOf('.'); 
// 	if (temp > 1) { 
// 		if ((i-temp) > 3){ 
// 			if ((i-tempd)>0){ 
// 				return true; 
// 			} 
// 		} 
// 	}
// 	alert("『邮箱』应当为合法的EMAIL");
// 	return false; 
}
</script>
</body>
</html>