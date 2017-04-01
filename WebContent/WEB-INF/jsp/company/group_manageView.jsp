<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<style>
.group-item {display:block; width:80px; float:left; margin-top:5px;}
</style>

<title>组织视图::${group.name}::视图维护</title>
</head>
<body>
<header id="header">
	<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
</header>
<div id="wrap">
	<div class="outer" style="min-height: 486px;">
		<form class="form-condensed" method="post" target="_parent">
  			<table class="table table-form"> 
    			<tbody>
    				<tr>
				    	<th class="w-150px">允许访问视图 </th>
				      	<td class="w-p60">
				      		<c:forEach items="${viewList}" var="view">
				      			<c:if test="${view == 'product'}">
				      				<c:set var="product" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'project'}">
				      				<c:set var="project" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'qa'}">
				      				<c:set var="qa" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'doc'}">
				      				<c:set var="doc" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'report'}">
				      				<c:set var="report" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'company'}">
				      				<c:set var="company" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'admin'}">
				      				<c:set var="admin" value="true"></c:set>
				      			</c:if>
				      			<c:if test="${view == 'repo'}">
				      				<c:set var="repo" value="true"></c:set>
				      			</c:if>
				      		</c:forEach>
				        	<div class="group-item">
				        		<label class="priv" for="product">
				        			<input type="checkbox" id="product" name="views" <c:if test="${product == true}">checked</c:if> value="product">产品 
				        		</label>
				        	</div>
				            <div class="group-item">
					            <label class="priv" for="project">
					            	<input type="checkbox" id="project" name="views" <c:if test="${project == true}">checked</c:if> value="project">项目
					            </label>
					        </div>
				            <div class="group-item">
					        	<label class="priv" for="qa">
					            	<input type="checkbox" id="qa" name="views" <c:if test="${qa == true}">checked</c:if> value="qa">测试 
					            </label>
				        	</div>
				        	<div class="group-item">
					        	<label class="priv" for="doc">
					            	<input type="checkbox" id="doc" name="views" <c:if test="${doc == true}">checked</c:if> value="doc">文档 
					            </label>
				        	</div>
				           <div class="group-item">
					        	<label class="priv" for="doc">
					            	<input type="checkbox" id="report" name="views" <c:if test="${report == true}">checked</c:if> value="report">统计
					            </label>
				        	</div>
				        	<div class="group-item">
					        	<label class="priv" for="doc">
					            	<input type="checkbox" id="company" name="views" <c:if test="${company == true}">checked</c:if> value="company">组织
					            </label>
				        	</div>
				        	<div class="group-item">
					        	<label class="priv" for="doc">
					            	<input type="checkbox" id="admin" name="views" <c:if test="${admin == true}">checked</c:if> value="admin">后台 
					            </label>
				        	</div>
				        	<div class="group-item">
					        	<label class="priv" for="doc">
					            	<input type="checkbox" id="repo" name="views" <c:if test="${repo == true}">checked</c:if> value="repo">代码 
					            </label>
				        	</div>
				            <div class="group-item">
				            	<label class="priv" for="allchecker">
				            		<input type="checkbox" id="allchecker"  onclick="selectAll(this)">全选          		
				            	</label>
				        	</div>
				      	</td>
				      	<td>空代表访问没有访问限制</td>
					</tr>
			    	<tr>
			      		<th></th>
			      		<td colspan="2">
			         		<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button> 
			         		<button type="button" class="btn btn-default" onclick ="javascript:history.go(-1);">返回</button>
			         		<input type="hidden" name="foo" id="foo" value="">
			      		</td>
					</tr>
				</tbody>
			</table>
		</form>
  </div> 
</div>
<script type="text/javascript">
function selectAll(obj) {
	$("input[name='views']").prop("checked",obj.checked);
}
</script>
</body>
</html>