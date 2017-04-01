<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/includemenu.jsp"%>
<script>
$(document).ready(function() {
	$('table.datatable').datatable(
			{sortable: true,
			storage: true,
			colHover: false,
			});
});
</script>
<title>${project.name}::文档列表</title>
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
			      <li id="calendarTab" class="active">文档列表
					</li>
				</ul>
				<div class="actions">
				    <a href="${ctxpj}/doc_create_project_${project.id}" class="btn "><i class="icon-doc-create icon-plus"></i> 创建文档</a>
				</div>
			</div>
		</div>
		<table class="table datatable table-fixed tablesorter tablesorter-default hasSaveSort">
			<thead>
	      		<tr class="colhead tablesorter-headerRow" role="row">
			        <th data-column="0" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">ID</div>
			        </th>
			        <th data-column="1" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">所属分类</div>
			        </th>
			        <th data-column="2" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">文档标题</div>
			        </th>
			        <th data-column="3" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">由谁添加</div>
			        </th>
			        <th data-column="4" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">添加时间</div>
			        </th>
			        <th data-column="5" class="w-id header tablesorter-headerUnSorted" style="-webkit-user-select: none;">
			        	<div class="tablesorter-header-inner">所属分类</div>
			        </th>
			    </tr>
			</thead>
			<tbody aria-live="polite" aria-relevant="all">
				<c:forEach items="${docList}" var="doc" varStatus="vs">
					<tr class="text-center slectable-item" >
	        			<td><a href="">${doc.id}</a></td>
				        <td>${doc.type}</td>
				        <td class="text-left nobr"><nobr>
				        	<shiro:hasPermission name="doc:view"><a href="">${doc.title}</a></shiro:hasPermission>
				       		<shiro:lacksPermission name="doc:view">${doc.title}</shiro:lacksPermission>
				        </nobr></td>
				        <td>${userMap[doc.addedBy]}</td>
				        <td>${doc.addedDate}</td>
				        <td> 
				        	<shiro:hasPermission name="doc:edit">
				        		<a href="" class="btn-icon " title="编辑文档"><i class="icon-common-edit icon-pencil"></i></a>        
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