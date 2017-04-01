<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String begin=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script src="${ctxResources}/dist/js/color.js"></script>
<script>
function close(){
	var modalTrigger = $('#ahha').data('modal');
	myModalTrigger.close();
}
</script>
</head>
<body>
	<div id="titlebar">
		<div class="heading">
			<span class="prefix"><i class="icon-check-sign"></i> <strong>${task.id}</strong></span>
		    <strong><strong class="heading-title" style="color: ${task.color}">${task.name}</strong>
			</strong>
		    <small class="text-muted"><c:if test="${task.status == 'pause'}">继续</c:if> <c:if test="${task.status != 'pause'}">开始</c:if></small>
		    <button type="button" id="ahha" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
		</div>
	</div>
	<form class="form-condensed" name="task" method="post" target="_parent" onsubmit="return checkLeft();" >
		<table class="table table-form">
			<tbody>
				<tr>
					<th class="w-80px">实际开始</th>
					<td class="w-p25-f">
						<div class="datepicker-wrapper datepicker-date">
							<input type="text" name="realStarted" id="realStarted"  value="<c:if test="${status == 'restart'}">${task.realstart}</c:if><c:if test="${status != 'restart'}"><%=begin %></c:if>" class="form-control form-date">
						</div>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>总消耗</th>
					<td>
						<div class="input-group">
							<input type="text" name="consumed" id="consumed" value="<fmt:formatNumber type="number" value="${task.consumed}" />" class="form-control">
			 				<span class="input-group-addon">小时</span>
			 			</div>
			 		</td>
			 		<td></td>
				</tr>
			    <tr>
					<th>预计剩余</th>
					<td>
						<div class="input-group">
							<input type="text" name="remain" value="<fmt:formatNumber type="number" value="${task.remain}" />" class="form-control">
		 					<span class="input-group-addon">小时</span>
		 				</div>
					</td>
					<td></td>
				</tr> 
			    <tr>
					<th>备注</th>
					<td colspan="2">
						<div class="form-group">
							<textarea name="comment" class="form-control kindeditor " style="height:150px;"></textarea>
						</div>
					</td>
				</tr> 
			    <tr>
					<th></th>
					<td colspan="2"> 
						<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">开始</button>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<div class="main" style="position: relative;height: 380px; overflow:auto;">
		<%@ include file="/WEB-INF/jsp/include/history.jsp"%> 
		<fieldset id="actionbox" class="actionbox">
			<legend>
				<i class="icon-time"></i>历史记录    
			   	<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
			  	<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
			</legend>
		  	<ol id="historyItem">
		  		<c:forEach items="${actionList}" var="action" varStatus="i">
		  			<li>
				   		<span class="item">
				        	${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}。
					       	<c:if test="${action.histories.size() != 0}"><a id="switchButton${i.index + 2}" class="switch-btn btn-icon" onclick="switchChange(${i.index + 2})" href="javascript:;"><i class="icon- change-show"></i></a></c:if>
				   		</span>
				     	<c:if test="${action.comment != ''}"><div class="history"></c:if>
					    	<div class="changes hide alert" id="changeBox${i.index + 2}" style="display: none;">
					        	<c:if test="${action.histories.size() != 0}">
						        	<c:forEach items="${action.histories}" var="history">
					       	  			修改了 <strong><i>${fieldNameMap[history.field]}</i></strong>，旧值为 "${history.oldValue}"，新值为 "${history.newValue}"。<br>
					       			</c:forEach>
				       			</c:if>
				       		</div>
				       		<c:if test="${i.last && action.comment != ''}"><span class="pull-right comment${action.id}"><a href="javascript:toggleComment(${action.id})" class="btn btn-mini" style="border:none"><i class="icon-pencil"></i></a></span></c:if>
			        		<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
					      	<c:if test="${i.last && action.comment != ''}">
						   	<div class="hide" id="lastCommentBox">
		          				<form method="post" action="./action_editTaskComment_${task.project.id}_${action.id}">
		            				<table align="center" class="table table-form bd-0">
		              					<tbody>
		              						<tr>
		              							<td style="padding-right: 0">
		              								<textarea name="lastComment" id="lastComment" rows="5" class="form-control">${action.comment}</textarea>
												</td>
											</tr>
		              						<tr>
		              							<td> 
		              								<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button><a href="javascript:toggleComment(${action.id})" class="btn">返回</a>
												</td>
											</tr>
										</tbody>
									</table>
								</form>
							</div>
						</c:if>
			       	</li>
	  			</c:forEach>
	        </ol>		
		</fieldset>
	</div>
</body>
</html>