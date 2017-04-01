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
    <link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/dist/lib/kindeditor/themes/default/default.css" rel="stylesheet"/>
    <script src="${ctxResources}/jquery-1.12.4.min.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
    <script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
    <script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
    <script src="${ctxResources}/dist/js/color.js"></script>
	<script>
	$(document).ready(function(){
		//chosen的初始化
		$('select.chosen-select').chosen({
			no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});
	});
	</script>
<script>
$(function(){
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
})
</script>
<title>${project.name}::编辑版本</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer with-side with-transition" style="min-height: 494px;">
	  <div class="container mw-1400px">
		<div id="titlebar">
		    <div class="heading">
		      <span class="prefix" title="TESTTASK"><i class="icon-check"></i></span>
		      <strong><a href="" target="_blank">${testTask.name}</a></strong>
		      <small class="text-muted"> 编辑版本 <i class="icon-pencil"></i></small>
		    </div>
		</div>
		<form class="form-condensed" method="post" target="hiddenwin" name="testTask">
			<table class="table table-form"> 
				<tbody>
					<tr>
				        <th class="w-80px">所属项目</th>
				        <td class="w-p25-f">
				        <div class="required required-wrapper"></div>
				        <select name="project_id" class="form-control chosen-select">
				        <option value="${project.id}">${project.name}</option>
						</select>
						</td>
				        <td style="padding-left: 15px;">
						</td>
					</tr>
			      	<tr>
				        <th>版本</th>
				        <td>
				        <div class="required required-wrapper"></div>
				        <select name="build" class="form-control chosen chosen-select">
				        <option value="${testTask.build}">${testTask.build}</option>
						</select>
						</td>
				        <td style="padding-left: 15px;"><input type="hidden" name="product" id="product" value="204">
						</td>
					</tr>
			      	<tr>
				        <th>负责人</th>
				        <td>
				        <select name="owner" class="form-control chosen chosen-select">
				        	<c:forEach items="${userList}" var="user" varStatus="vs">
				        		<option value="${user.realname}" <c:choose><c:when test="${testTask.owner == user.realname}">selected</c:when></c:choose>>
				        		${user.account.toCharArray()[0]}:${user.realname}</option>
				        	</c:forEach>
						</select>
						</td>
				        <td style="padding-left: 15px;"><input type="hidden" name="product" id="product" value="204">
						</td>
					</tr>
			        <tr>
				        <th>优先级</th>
				        <td>
				        	<select name="pri" id="pri" class="form-control">
								<option value="0" ></option>
								<option value="3">3</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="4">4</option>
							</select>
						</td>
				        <td style="padding-left: 15px;"><input type="hidden" name="product" id="product" value="204">
						</td>
					</tr>
			      <tr>
			        <th>开始日期</th>
			        <td>
				        <div class="required required-wrapper"></div>
				        <input type="text" name="begin" id="begin" value="${testTask.begin}" class="form-control form-date" placeholder="开始日期">
					</td>
			      </tr>  
			      <tr>
			        <th>结束日期</th>
			        <td>
				        <div class="required required-wrapper"></div>
				        <input type="text" name="end" value="${testTask.end}" class="form-control form-date" placeholder="结束日期">
					</td>
			      </tr>
			      <tr>
			        <th>当前状态</th>
			        <td>
			          <select name=status class="form-control">
			          	<option value="wait">未开始</option>
			          	<option value="doing">进行中</option>
						<option value="done">已完成</option>
						<option value="blocked">被阻塞</option>
						</select>
			        </td>
			      </tr>
			      <tr>
			        <th>名称</th>
						<td colspan="2">
							<div class="required required-wrapper"></div>
					        <input type="text" name="name" value="${testTask.name}" class="form-control">
				        </td>
			      </tr>
			      <tr>
			        <th>描述</th>
			        <td colspan="2"><textarea name="descript" class="form-control kindeditor" style="height:150px;">${testTask.descript}</textarea></td>
			      </tr>
			      <tr>
			        <th>测试总结</th>
			        <td colspan="2"><textarea name="report" class="form-control kindeditor" style="height:150px;">${testTask.report}</textarea></td>
			      </tr>
			      <tr>
			      	<th>抄送给</th>
			      	<td colspan="2">
			      		<div class="input-group">
					    	<select class="form-control chosen-select" name="mailto" data-placeholder="选择要发信通知的用户..." multiple>
					      		<c:forEach items="${userList}" var="user" varStatus="">
					      			<option value="${user.account}">${user.account.toCharArray()[0]}:${user.account}</option>
					      		</c:forEach>
					      	</select>
					      	<select class="form-control chosen chosen-select">
								<option value="">联系人</option>				
							</select>
			      		</div>
			      	</td>
			      </tr>
			      <tr>
			        <td></td>
			        <td><button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			        <a href="${ctx}/test/testtask_edit_${testtask}_" class="btn btn-back ">返回</a></td>
			      </tr>
			    </tbody>
			 </table>
		</form>
	</div>
	</div>
</div>
</body>
</html>