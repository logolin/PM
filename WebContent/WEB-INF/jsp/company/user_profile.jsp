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
    
<script type="text/javascript">
$(document).ready(function() {
	$('select.chosen').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	});
	
}); 	

</script>
<title>用户::待办</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 406px;">
			<%@ include file="/WEB-INF/jsp/include/userhead.jsp" %>
			<div class="container mw-600px">
				<div id="titlebar">
			    	<div class="heading" style="padding-right: 106px;">
						<span class="prefix" title="USER"><i class="icon-user"></i> <strong>${user.id}</strong></span>
						<strong>${user.realname} (<small>${user.account}</small>)</strong>
						<small class="text-muted"> 档案 <i class="icon-eye-open"></i></small>
					</div>
					<div class="actions">
						<a href="./user_edit_${user.id}_company" class="btn btn-primary"><i class="icon-pencil"></i> 修改档案</a>
					</div>
				</div>
				<table class="table table-borderless table-data">
					<tbody>
						<tr>
							<th class="w-100px">所属部门</th>
							<td><c:choose><c:when test="${user.getDept_id() != 0}">${dept.name}</c:when>
								<c:otherwise>/</c:otherwise></c:choose>
							</td>
						</tr>
						<tr>
							<th class="w-100px">用户名</th>
							<td>${user.account}</td>
						</tr>
						<tr>
							<th class="w-100px">真实姓名</th>
							<td>${user.realname} </td>
						</tr>
						<tr>
							<th class="w-100px">权限</th>
							<td></td>
						</tr>
						<tr>
							<th class="w-100px">职位</th>
							<td>${user.role}</td>
						</tr>
						<tr>
							<th class="w-100px">源代码账号</th>
							<td>${user.commiter} </td>
						</tr>
						<tr>
							<th class="w-100px">邮箱</th>
							<td>${user.email} </td>
						</tr>
						<tr>
							<th class="w-100px">入职日期</th>
							<td>${user.hiredate}</td>
						</tr>
						<tr>
							<th class="w-100px">访问次数</th>
							<td>${user.visits}</td>
						</tr>
						<tr>
							<th class="w-100px">最后IP</th>
							<td>${user.ip}</td>
						</tr>
						<tr>
							<th class="w-100px">Skype</th>
							<td>${user.skype}</td>
						</tr>
						<tr>
							<th class="w-100px">QQ</th>
							<td>${user.qq}</td>
						</tr>
						<tr>
							<th class="w-100px">雅虎通</th>
							<td>${user.yahoo}</td>
						</tr>
						<tr>
							<th class="w-100px">GTalk</th>
							<td>${user.gtalk}</td>
						</tr>
						<tr>
							<th class="w-100px">旺旺</th>
							<td>${user.wangwang}</td>
						</tr>
						<tr>
							<th class="w-100px">手机</th>
							<td>${user.mobile} </td>
						</tr>
						<tr>
							<th class="w-100px">电话</th>
							<td>${user.phone}</td>
						</tr>
						<tr>
							<th class="w-100px">通讯地址</th>
							<td>${user.address}</td>
						</tr>
						<tr>
							<th class="w-100px">邮编</th>
							<td>${user.zipcode}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>