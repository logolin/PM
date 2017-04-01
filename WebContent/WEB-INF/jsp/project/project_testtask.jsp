<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
<script>
$(document).ready(function() {
	$('table.datatable').datatable(
			{sortable: true,
			storage: true,
			colHover: false,
			});
});
</script>
<title>${project.name}::测试视图版本</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 494px;">
		<div>
			<div id="featurebar">
			    <ul class="nav">
			    	<shiro:hasPermission name="project:build">
			    		<li id="calendarTab" class="active"><a href="${ctxpj}/project_build_${projectId}">版本列表</a></li>
			    	</shiro:hasPermission>
				</ul>
				<shiro:hasPermission name="test:create">
					<div class="actions">
						<a href="#" class="btn"><i class="icon-plus"></i> 提交测试</a>
					</div>
				</shiro:hasPermission>
			</div>
		</div>
		<table class="table datatable table-striped table-condensed collapse">
			<thead>
				<tr>
			    	<th class="w-id header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ID</div></th>
			      	<th><div class="tablesorter-header-inner">名称</div></th>
			      	<th><div class="tablesorter-header-inner">版本</div></th> 
			      	<th><div class="tablesorter-header-inner">负责人</div></th>
			      	<th><div class="tablesorter-header-inner">开始日期</div></th>
			      	<th><div class="tablesorter-header-inner">结束日期</div></th>
			      	<th><div class="tablesorter-header-inner">状态</div></th>
			      	<th><div class="tablesorter-header-inner">操作</div></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${testTaskList}" var="ttlist" varStatus="vs">
				<tr class="slectable-item text-center">
			      	<td class="text-center">${ttlist.id}</td>
			      	<td>
			      		<shiro:hasPermission name="testtask:view"><a href="">${ttlist.name}</a></shiro:hasPermission>
			      		<shiro:lacksPermission name="testtask:view">${ttlist.build}</shiro:lacksPermission>
			      	</td>
			      	<td>
			      		<shiro:hasPermission name="build:view"><a href="">${ttlist.build}</a></shiro:hasPermission>
			      		<shiro:lacksPermission name="bulid:view">${ttlist.build}</shiro:lacksPermission>
			      	</td>
			      	<td>${ttlist.owner}</td>
			      	<td>${ttlist.begin}</td>
			      	<td>${ttlist.end}</td>
			      	<td>${ttlist.status}</td>
				  	<td>
				  		<shiro:hasPermission name="testtask:cases">
     						<a href="" class="btn-icon " title="用例"><i class="icon-testtask-cases icon-smile"></i></a>
     					</shiro:hasPermission>
     					<shiro:hasPermission name="testtask:linkcase">
     						<a href="" class="btn-icon " title="关联用例"><i class="icon-testtask-linkCase icon-link"></i></a>
     					</shiro:hasPermission>
     					<shiro:hasPermission name="testtask:edit">
     						<a href="" class="btn-icon " title="编辑版本"><i class="icon-common-edit icon-pencil"></i></a>
     					</shiro:hasPermission>
    				</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	  </div>
	</div>
</body>
</html>