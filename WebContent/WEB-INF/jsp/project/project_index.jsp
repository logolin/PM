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
    <link href="${ctxResources}/zui/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/zui/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <script src="${ctxResources}/jquery-1.12.4.min.js"></script>
    <script src="${ctxResources}/zui/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/zui/src/js/dashboard.js"></script>
	
<script>
$(document).ready(function() {
    $('#dashboard').dashboard({
        shadowType: 'normal', 
        sensitive: true
    });
    $('table.datatable').datatable({
    	fixedHeader: true
    	});
});
</script>
<script>
function doLink(strURL)
{
  window.location = strURL;
}
</script>
<title>项目</title>
</head>
<body style="background-color: #f7f7f7">

	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer with-side with-transition" style="min-height: 494px;">
			<div style="padding-left: 19px;padding-right: 19px;">
				<div id="dashboard" class="dashboard dashboard-draggable">
				<div class="row">
		          <div class="col-md-4 col-sm-6" data-id='1'>
		            <div class="panel"  style="overflow-y:scroll" data-url='http://baidu.com'>
		              <div class="panel-heading">
		                <div class="panel-actions">
		                  <button class="btn btn-mini refresh-panel">更多<i class="icon icon-double-angle-right"></i></button>
		                    <div class="dropdown">
		                      <button role="button" class="btn btn-mini" data-toggle="dropdown"><span class="icon icon-ellipsis-v"></span></button>
		                      <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dropdownMenu1">
		                        <li><a href="#"><i class="icon-pencil"></i> 编辑</a></li>
		                        <li><a href="#" class="remove-panel"><i class="icon-remove"></i> 移除</a></li>
		                      </ul>
		                    </div>
		                  </div>指派给我的任务
		                </div>
		              <div class="panel-body">
		              	<table class="table table-striped datatable table-hover">
							<thead>
							  <tr>
							    <th>ID</th>
							    <th>P</th>
							    <th>任务名称</th>
							    <th>预</th>
							    <th>截止日期</th>
							    <th>状态</th>						    			    				    
							  </tr>
							</thead>
							<tbody>
								<c:forEach items="${taskList}" var="task" varStatus="vs">
								<tr>
									<td>${task.id}</td>
									<td><span class="pri${task.pri}">
								      	<c:choose><c:when test="${task.pri == 0}"></c:when>
								      	<c:otherwise>${task.pri}</c:otherwise>
								      	</c:choose></span>
								      </td>
									<td><shiro:hasPermission name="task:view"><a href="./task_view_${task.id}_${projectId}"></shiro:hasPermission> ${task.name}<shiro:hasPermission name="task:view"></a></shiro:hasPermission></td>
									<td><fmt:formatNumber type="number" value="${task.estimate}" /></td>
									<td>${task.deadline}
									<td>${task.status}</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
		              </div>
		            </div>
		          </div>
		          <div class="col-md-4 col-sm-6" data-id='1'>
		            <div class="panel">
		              <div class="panel-heading">
		                <div class="panel-actions">
		                  <button class="btn btn-mini refresh-panel">更多<i class="icon icon-double-angle-right"></i></button>
		                    <div class="dropdown">
		                      <button role="button" class="btn btn-mini" data-toggle="dropdown"><span class="icon icon-ellipsis-v"></span></button>
		                      <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dropdownMenu1">
		                        <li><a href="#"><i class="icon-pencil"></i> 编辑</a></li>
		                        <li><a href="#" class="remove-panel"><i class="icon-remove"></i> 移除</a></li>
		                      </ul>
		                    </div>
		                  </div>项目列表
		                </div>
		              <div class="panel-body">
		              	<table class="table table-striped table-hover">
							<thead>
							  <tr>
							    <th>结束日期</th>
							    <th>状态</th>
							    <th>总预计</th>
							    <th>总消耗</th>
							    <th>总剩余</th>
							    <th>进度</th>						    			    				    
							  </tr>
							</thead>
							<tbody>
								<c:forEach items="${projectList}" var="projectl" varStatus="vs">
								<tr onClick="doLink('${ctxpj}/project_task_${projectl.id}_unclosed');">
									<td>${projectl.end}</td>
									<td>${projectl.status}</td>
									<td><fmt:formatNumber value="${projectl.estimate}" type="number" /> </td>
						  			<td><fmt:formatNumber value="${projectl.consumed}" type="number" /></td>
						  			<td><fmt:formatNumber value="${projectl.remain}" type="number" /></td>
									<td></td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
		              </div>
		            </div>
		          </div>
				</div>
			</div>
			</div>
		</div>
	</div>
</body>
</html>