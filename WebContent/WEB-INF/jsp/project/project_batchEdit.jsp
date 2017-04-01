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
<script src="${ctxResources}/jquery-1.12.4.min.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script type="text/javascript">
$(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
	
	// 仅选择日期
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
});
</script>
<title>批量编辑</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="titlebar">
				<div class="heading">
				    <span class="prefix"><i class="icon-check-sign"></i></span>
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 项目视图::批量编辑</strong>
				    <div class="actions">
				      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post" action="${ctxpj}/project_batchEdit_${project.id}_update">
				<table class="table table-form">
					<thead>
						<tr class="text-center">
							<th class="w-50px">ID</th>
							<th class="">项目名称 <span class="required"></span></th>
							<th class="w-150px" style="padding-left: 15px;">项目代号 <span class="required"></span></th>
							<th class="w-150px" style="padding-left: 15px;">项目负责人</th>
							<th class="w-100px">项目状态</th>
							<th class="w-110px">开始日期 <span class="required"></span></th>
							<th class="w-110px" style="padding-left: 15px;">结束日期 <span class="required"></span></th>
							<th class="w-150px">可用工作日</th>
							<th class="w-80px">项目排序</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${projectList}" var="project" varStatus="i">
							<tr class="text-center">
								<td>${project.id}<input type="hidden" name="projects[${i.index}].id" value="${project.id}"></td>
								<td title="${project.name}"><input type="text" name="projects[${i.index}].name" value="${project.name}" class="form-control"></td>
								<td><input type="text" name="projects[${i.index}].code" value="${project.code}" class="form-control"></td>
								<td class="text-left" style="overflow:visible">
									<select name="projects[${i.index}].PM" class="form-control chosen-select">
										<c:forEach items="${userList}" var="user">
											<option value="${user.account}" <c:if test="${user.account == project.PM}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
										</c:forEach>
									</select>
								</td>
								<td class="">
									<select name="projects[${i.index}].status" class="form-control">
										<option value="wait" <c:if test="${project.status == 'wait'}">selected="selected"</c:if>>未开始</option>
										<option value="doing" <c:if test="${project.status == 'doing'}">selected="selected"</c:if>>进行中</option>
										<option value="suspended" <c:if test="${project.status == 'suspended'}">selected="selected"</c:if>>已挂起</option>
										<option value="done" <c:if test="${project.status == 'done'}">selected="selected"</c:if>>已完成</option>
									</select>
								</td>
								<td><input type="text" name="projects[${i.index}].begin" id="begins[${i.index}]" value="${project.begin}" class="form-control form-date"></td>
								<td><input type="text" name="projects[${i.index}].end" id="ends[${i.index}]" value="${project.end}" class="form-control form-date"></td>
								<td class="">
							    	<div class="input-group">
								        <input type="text" name="projects[${i.index}].days" id="dayses[${i.index}]" value="${project.days}" class="form-control" autocomplete="off">
								        <span class="input-group-addon">天</span>
							    	</div>
							    </td>
							    <td><input type="text" name="projects[${i.index}].sort" value="${project.sort}" class="form-control" autocomplete="off"></td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
				    	<tr>
				    		<td colspan="13"> 
				    			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
				    		</td>
				    	</tr>
				    </tfoot>
				</table>
			</form>
		</div>
	</div>
</body>
</html>