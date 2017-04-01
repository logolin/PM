<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>

<title>组织视图::公司信息</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 406px;">
			<div class="container mw-600px">
				<div id="titlebar">
					<div class="heading" style="padding-right: 62px;"><i class="icon-building"></i> 公司信息</div>
				    <div class="actions">
				    	<a type="button" class="btn btn-primary iframe" data-iframe="./company_edit_${company.id}" data-show-header="false" data-toggle="modal">编辑</a>
				    </div>
				</div>
				<table class="table table-borderless table-data"> 
			    	<tbody>
			    		<tr>
			    			<th class="w-100px">公司名称</th>
			    			<td>${company.name}</td>
			    		</tr>  
			    		<tr>
				    		<th>联系电话</th>
				    		<td>${company.phone}</td>
			    		</tr>  
			    		<tr>
				    		<th>传真</th>
				    		<td>${company.fax}</td>
			    		</tr>  
			    		<tr>
				    		<th>通讯地址</th>
				    		<td>${company.address}</td>
			    		</tr>  
			    		<tr>
				    		<th>邮政编码</th>
				    		<td>${company.zipcode}</td>
			    		</tr>  
			    		<tr>
				    		<th>官网</th>
				    		<td>${company.website}</td>
			    		</tr>  
			    		<tr>
				    		<th>内网</th>
				    		<td>${company.backyard}</td>
			    		</tr>  
			    		<tr>
				    		<th>匿名登录</th>
				    		<td>
				    			<c:if test="${company.guest == '0'}">不允许</c:if>
				    			<c:if test="${company.guest == '1'}">允许</c:if>
				    		</td>
			    		</tr>  
			    		<tr>
			    			<td colspan="2" class="text-center"></td>
			    		</tr>
			    	</tbody>
				</table>
			</div>
		</div>  
		<div id="divider"></div>
	</div>
</body>
</html>