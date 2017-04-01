<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<title>${project.name}::团队成员</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="featurebar">
			    <ul class="nav">
			    	<li id="calendarTab" class="active">团队成员</li>
				</ul>
				<div class="actions">
					<shiro:hasPermission name="project:manageMembers">
				    	<a href="./project_managemembers_${projectId}" class="btn btn-primary manage-team-btn">团队管理</a>
				    </shiro:hasPermission>
				</div>
			</div>
			<table class="table datatable" id="memberList" role="grid">
			    <thead>
			    	<tr class="tablesorter-headerRow" role="row">
				        <th><div class="tablesorter-header-inner">用户</div></th>
				        <th><div class="tablesorter-header-inner">角色</div></th>
				        <th><div class="tablesorter-header-inner">加盟日</div></th>
				        <th><div class="tablesorter-header-inner">可用工日</div></th>
				        <th><div class="tablesorter-header-inner">可用工时/天</div></th>
				        <th><div class="tablesorter-header-inner">总计</div></th>
				        <th><div class="tablesorter-header-inner">操作</div></th>
			    	</tr>
			    </thead>
			    <tbody aria-live="polite" aria-relevant="all">
			    	<c:set var="sum" value="0"></c:set>
			    	<c:forEach items="${teamList}" var="team" varStatus="vs">
				    	<tr class="text-center odd">
					    	<td>
					    		<shiro:hasPermission name="user:todo">
					    			<a href="../company/user_profile_${team.id.user.account}">${userMap[team.id.user.account]}</a></td>
					    		</shiro:hasPermission>
					    		<shiro:lacksPermission name="user:todo">${userMap[team.id.user.account]}</shiro:lacksPermission>
					      	<td>${team.role}</td>
					      	<td>${team.hiredate}</td>
					      	<td><fmt:formatNumber value="${team.days}" type="number" /></td>
					      	<td><fmt:formatNumber value="${team.hours}" type="number" /></td>
					      	<td><fmt:formatNumber value="${team.days*team.hours}" type="number" /></td>
					      	<td>
					      		<shiro:hasPermission name="project:unlinkMember">
						        	<a href="#" class="btn-icon" title="移除成员" onclick="deleteAccount('${team.id.user.account}')">
						        		<i class="icon-green-project-unlinkMember icon-remove"></i>
						        	</a>
					        	</shiro:hasPermission>
					        </td>
				    	</tr>
					    <script>
							function deleteAccount(account){
								if(confirm("您确定从该项目中移除该用户吗？")){
									location.href="${ctxpj}/team_deleted_${project.id}_"+account;
								}
							}
						</script>
						<c:set var="sum" value="${sum + (team.days*team.hours)}" />
			    	</c:forEach>
			    </tbody>
			    <tfoot>
			    	<tr>
			      		<td colspan="7" data-column="0">
			      			<div class="table-actions clearfix"><div class="text">总计：<strong>
			      			<fmt:formatNumber value="${sum}" type="number" />
			      			</strong></div></div>
			      		</td>
			    	</tr>
			    </tfoot>
			</table>
		</div>
	</div>
</body>
</html>