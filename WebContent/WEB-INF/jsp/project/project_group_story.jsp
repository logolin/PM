<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<link rel='stylesheet' href='http://cdn.zentao.net/8.2.4/theme/default/zh-cn.default.css?v=pro5.3.1' type='text/css' media='screen' />
<script src='http://cdn.zentao.net/8.2.4/js/all.js?v=pro5.3.1' type='text/javascript'></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<script src="../resources/zui/src/js/collapse.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$('table.datatable').datatable(
		{checkable: true,
		storage: true,
		});
});
</script>

<style>.mgr-5px{margin-right:5px;}
.highlight-warning {background: #FBF5C6!important}
.group-title td {background: #f1f1f1!important; border-bottom: 1px solid #ccc!important}
tr.groupdivider td {background: #fff!important;}
.groupdivider  .text {color: #808080}
.groupdivider  .text strong {color: #333}
.groupby{border-right:1px solid #ddd;cursor: pointer;}
#groupTable tr > th:first-child, #groupTable tr > td:first-child{padding:6px 5px;} 

.sub-featurebar {margin: -20px -20px -1px; padding: 5px 20px 0; border-bottom: none}
.sub-featurebar .nav-tabs > li {margin-bottom: 0}
</style>
<title>${project.name}::任务列表</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer with-side with-transition" style="min-height: 494px;">
			<%@include file="/WEB-INF/jsp/include/taskhead.jsp" %>
			<c:if test="${grouptype != 'status' && grouptype != 'type'}">
			<div class="sub-featurebar">
				<ul class="nav nav nav-tabs">
					<c:choose>
		    			<c:when test="${grouptype == 'story'}">
			    			<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
				    		<li <c:if test="${typeName == 'linked'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_linked">已关联需求的任务</a>
				    		</li>
			    		</c:when>
			    		<c:when test="${grouptype == 'pri'}">
			    			<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
				    		<li <c:if test="${typeName == 'setted'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_setted">已设置</a>
				    		</li>
			    		</c:when>
			    		<c:when test="${grouptype == 'assignedTo'}">
			    			<li <c:if test="${typeName == 'undone'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_undone">未完成</a>
				    		</li>
				    		<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
			    		</c:when>
			    		<c:when test="${grouptype == 'finishedBy'}">
			    			<li <c:if test="${typeName == 'done'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_done">已完成</a>
				    		</li>
				    		<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
			    		</c:when>
			    		<c:when test="${grouptype == 'closedBy'}">
			    			<li <c:if test="${typeName == 'closed'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_closed">已关闭</a>
				    		</li>
				    		<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
			    		</c:when>
			    		<c:when test="${grouptype == 'deadline'}">
			    			<li <c:if test="${typeName == 'all'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_all">所有</a>
				    		</li>
				    		<li <c:if test="${typeName == 'setted'}">class="active"</c:if>>
				    			<a href="${ctxpj}/project_group_${project.id}_${grouptype}_setted">已设置</a>
				    		</li>
			    		</c:when>
		    		</c:choose>
			    </ul>
			</div>
			</c:if>
			<table class="table datatable table-striped active-disabled table-condensed table-hover tablesorter" id="groupTable">
				<thead>
					<tr>
				      <th class="w-200px text-left">
				        <a href="###" class="expandAll" data-action="expand"><i class="icon-caret-down"></i> 相关需求</a>
				        <a href="###" class="collapseAll hidden" data-action="collapse">
				        	<i class="icon-caret-right"></i> 相关需求
				        </a>
				      </th>
				      <th>任务名称</th>
				      <th class="w-pri"> P</th>
				      <th class="w-user">指派给</th>
				      <th class="w-user">由谁完成</th>
				      <th class="w-50px">预</th>
				      <th class="w-50px">消耗</th>
				      <th class="w-50px">剩</th>
				      <th class="w-50px">类型</th>
				      <th class="w-80px">截止</th>
				      <th class="w-80px">任务状态</th>
				      <th class="w-60px">操作</th>
			    	</tr>
				</thead>
				<c:forEach items="${tempMap}" var="tempMap" varStatus="vs">
				<c:set var="waitnum" value="0" />
				<c:set var="doingnum" value="0" />
				<tbody>
			       <tr class="text-center">
			          <td rowspan="${tempMap.value.size()+2}" class="groupby text-left">
				      <a href="###" class="expandGroup" data-action="expand" title="${tempMap.key}">
				      <i class="icon-caret-down"></i> ${tempMap.key}</a>
				      </td>
				  </tr>
				  <c:forEach items="${tempMap.value}" var="task" varStatus="vs">
				  <tr>
			          <td class="text-left"> ${task.id}::<a href="${ctxpj}/task_view_${task.id}_${task.project.id}">${task.name}</a>
					  </td>
				      <td>
				      	<span class="pri${task.pri}"><c:choose><c:when test="${task.pri == 0}"></c:when>
					      	<c:otherwise>${task.pri}</c:otherwise>
					      	</c:choose></span>
					   </td>
				      <td style="color:red">${task.assignedTo}</td>
				      <td>${task.finishedBy}</td>
				      <td><fmt:formatNumber value="${task.estimate}" pattern="" type="number" /></td>
				      <td><fmt:formatNumber value="${task.consumed}" pattern="" type="number" /></td>
				      <td><fmt:formatNumber value="${task.remain}" pattern="" type="number" /></td>
				      <td>${typeMap[task.type]}</td>
				      <td class="<c:if test="${task.status == 'delay'}"> delayed</c:if>"><fmt:formatDate value="${task.deadline}" pattern="MM-dd HH:mm" /></td>
				      <td class="${task.status}">${task.ch_status}</td>
				      <td>
			        	<a href="${ctxpj}/task_edit_${projectId}_${task.id}" class="btn-icon " title="编辑">
			        	<i class="icon-common-edit icon-pencil"></i>
			        	</a>
						<a class="btn-icon" onclick="deleteTask(${task.id})" title="删除">
						<i class="icon-common-delete icon-remove"></i></a>
				      </td>
				      <script>
								function deleteTask(taskId){
									if(confirm("您确定删除这个任务吗？")){
										location.href="${ctxpj}/deleted_task_${project.id}_"+taskId+"_${grouptype}";
									}
								}
							</script>
				  </tr>
				  <c:if test="${task.ch_status == '未开始'}"><c:set var="waitnum" value="${waitnum + 1}" /></c:if>
				  <c:if test="${task.ch_status == '进行中'}"><c:set var="doingnum" value="${doingnum + 1}" /></c:if>
				  </c:forEach>
				 <tr>
			      <td colspan='4' class='text-left'>
			        <span class='groupdivider' style='margin-left:10px;'>
			          <span class='text'>
			                        本组共 <strong><fmt:formatNumber value="${tempMap.value.size()}" pattern="" type="number" /></strong> 个任务，未开始 <strong>${waitnum}</strong>，进行中 <strong>${doingnum}</strong></span>
			        </span>
			      </td>
			      <td>
			      	<c:set var="estimatesum" value="0" />
				      <c:forEach items="${tempMap.value}" var="estimate">
				      <c:set var="estimatesum" value="${estimatesum + estimate.estimate}" />
				      </c:forEach> 
				      <fmt:formatNumber value="${estimatesum}" pattern="" type="number" />
			      </td>
			      <td>
				      <c:set var="consumsum" value="0" />
				      <c:forEach items="${tempMap.value}" var="consum">
				      <c:set var="consumsum" value="${consumsum + consum.consumed}" />
				      </c:forEach> 
				      <fmt:formatNumber value="${consumsum}" pattern="" type="number" />
				  </td>
			      <td>
			      	<c:set var="remainsum" value="0" />
				      <c:forEach items="${tempMap.value}" var="remain">
				      <c:set var="remainsum" value="${remainsum + remain.remain}" />
				      </c:forEach> 
				      <fmt:formatNumber value="${remainsum}" pattern="" type="number" />
			      </td>
			      <td colspan='4'></td>
			    </tr>
				</tbody>
				</c:forEach>
			</table>
		</div>
	</div>
<script>
$(function()
{
    setTimeout(function(){fixedTheadOfList('#groupTable')}, 100);
    $(document).on('click', '.expandAll', function()
    {
        $('.expandAll').addClass('hidden');
        $('.collapseAll').removeClass('hidden');
        $('table#groupTable').find('tbody').each(function()
        {
            $(this).find('tr').addClass('hidden');
            $(this).find('tr.group-collapse').removeClass('hidden');
        })
    });
    $(document).on('click', '.collapseAll', function()
    {
        $('.collapseAll').addClass('hidden');
        $('.expandAll').removeClass('hidden');
        $('table#groupTable').find('tbody').each(function()
        {
            $(this).find('tr').removeClass('hidden');
            $(this).find('tr.group-collapse').addClass('hidden');
        })
    });
    $('.expandGroup').closest('.groupby').click(function()
    {
        $tbody = $(this).closest('tbody');
        $tbody.find('tr').addClass('hidden');
        $tbody.find('tr.group-collapse').removeClass('hidden');
    });
    $('.collapseGroup').click(function()
    {
        $tbody = $(this).closest('tbody');
        $tbody.find('tr').removeClass('hidden');
        $tbody.find('tr.group-collapse').addClass('hidden');
    });
})

</script>
</body>
</html>