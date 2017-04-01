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
<title>版本</title>
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
			      <li id="calendarTab" class="active"><a href="/project-effortcalendar-830.html">版本列表</a>
					</li>
				</ul>
				<div class="actions">
					<a href="${ctxpj}/build_create_${projectId}" class="btn"><i class="icon-plus"></i> 创建版本</a>
				</div>
			</div>
		</div>
		<table class="table datatable table-striped table-condensed collapse table-bordered">
			<thead>
				<tr>
			    	<th>ID</th>
			      	<th>产品</th>
			      	<th>名称编号</th> 
			      	<th>源代码地址</th>
			      	<th>下载地址</th>
			      	<th>打包日期</th>
			      	<th>构建者</th>
			      	<th>操作</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${buildList}" var="build" varStatus="vs">
				<tr class="slectable-item">
			      	<td class="text-center">${build.id}</td>
			      	<td>${build.product.name}</td>
			      	<td>
			      		<shiro:hasPermission name="build:view"><a href="${ctxpj}/build_view_${build.id}_${build.project_id}_story">${build.name}</a></shiro:hasPermission>
			      		<shiro:lacksPermission name="build:view">${build.name}</shiro:lacksPermission>
			      	</td>
			      	<td>${build.scmPath}</td>
			      	<td>${build.filePath}</td>
			      	<td>${build.date}</td>
			      	<td>${userMap[build.builder]}</td>
				  	<td class="text-right">
				  		<shiro:hasPermission name="build:linkStory">
						  	<a href="" class="btn-icon" title="关联需求">
						  		<i class="icon icon-link"></i>
						  	</a>
					  	</shiro:hasPermission>
					  	<shiro:hasPermission name="testtask:create">
							<a href="" class="btn-icon " title="提交测试">
								<i class="icon-testtask-create icon-bullhorn"></i>
							</a>
						</shiro:hasPermission>
						<a href="./project_bug_${project.id}" class="btn-icon " title="查看bug">
							<i class="icon-project-bug icon-bug"></i>
						</a>
						<shiro:hasPermission name="build:edit">
							<a href="${ctxpj}/build_edit_${build.id}_${build.project_id}" class="btn-icon " title="编辑版本">
								<i class="icon-common-edit icon-pencil"></i>
							</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="build:delete">
							<a href='' class="btn-icon" title="删除版本" onclick="deleteBuild(${build.id})">
								<i class="icon-remove"></i>
							</a>
						</shiro:hasPermission>
						<script>
							function deleteBuild(buildId){
								if(confirm("您确定删除该版本吗？")){
									location.href="${ctxpj}/build_deleted_"+buildId+"_"+${project.id};
								}
							}
						</script>
			    	</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	  </div>
	</div>
<body>
</html>