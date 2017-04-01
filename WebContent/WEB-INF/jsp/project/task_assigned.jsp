<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String assignTo=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/dist/js/color.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
	    search_contains: true,      // 从任意位置开始检索
	    allow_single_deselect: true,
	});
});
</script>
</head>
<body>
	<div id="titlebar">
		<div class="heading">
		    <span class="prefix"><i class="icon-check-sign"></i> <strong>${task.id}</strong></span>
		    <strong class="heading-title" style="color:${task.color}">${task.name}</strong>
		    <small class="text-muted"> 
		    	<c:choose>
		    		<c:when test="${statu == 'activate'}">激活</c:when>
		    		<c:otherwise>指派</c:otherwise>
		    	</c:choose>
		    </small>
		    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
		</div>
	</div>
	<div id="wrap">
		<div class="outer" style="min-height: 292px;">
			<form name="task" method="post" target="_parent">
				<table class="table table-form"> 
					<tbody>
						<tr>
							<th class="w-80px">指派给</th>
					        <td class="w-p25-f">
								<select id="assignedTo" name="assignedTo" class="form-control chosen-select">
						        	<option value=""></option>
									<c:forEach items="${userList}" var="user" varStatus="vs">
										<option value="${user.account}" <c:if test="${task.assignedTo==user.account}">selected="selected"</c:if>>${fn:toUpperCase(user.account.toCharArray()[0])}:${user.realname}</option>
									</c:forEach>
								</select>
								<c:if test="${statu != 'activate'}"><input type="hidden" name="assignedDate" value="<%=assignTo %>" /></c:if>
								<c:if test="${statu == 'activate'}"><input type="hidden" name="status" value="doing" /></c:if>
							</td>
							<td></td>
						</tr>
						<tr>
							<th>预计剩余</th>
					        <td>
					        	<div class="input-group">
					        	<input type="text" name="remain" <c:if test="${statu != 'activate'}">value='<fmt:formatNumber value="${task.remain}" pattern="" type="number" />'</c:if> class="form-control" />
	 							<span class="input-group-addon">小时</span></div>
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
	      					<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td>
						</tr>
					</tbody>
				</table>
			</form>
			<div class="main" style="position: relative; height: 380px; overflow:auto;">
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
					          	<c:if test="${action.comment != ''}"></c:if>
					       	</li>
			  			</c:forEach>
			        </ol>		
				</fieldset>
			</div>
		</div>
	</div>
</body>
</html>