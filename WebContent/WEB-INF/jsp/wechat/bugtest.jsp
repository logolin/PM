<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<title>Bug详情</title>
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/wxcss/detail.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
</head>
<body>
	<div class = "title"><label>${bug.id}</label>&nbsp;&nbsp;<strong>${bug.title}</strong></div>
	<div class = "content">
		<div class="bug-info">
			<div class="info-heading">
				<strong>基本信息</strong>
				<i class="icon icon-angle-down"></i>
			</div>
			<div class="info-body" >
				<table class="baseInfor">
					<tr>
						<th>所属产品：</th>
						<td >${bug.product.name}</td>
					</tr>
					<tr>
						<th>所属平台：</th>
						<td>${branch.name}</td>
					</tr>
					<tr>
						<th>所属模块：</th>
						<td>${module.name}</td>
					</tr>
					<tr>
						<th>所属计划：</th>
						<td>${plan.title}</td>
					</tr>
					<tr>
						<th>Bug类型：</th>
						<td>${typeMap[bug.type]}</td>
					</tr>
					<tr>
						<th>严重程度：</th>
						<td >${bug.severity}</td>
					</tr>
					<tr>
						<th>优先级：</th>
						<c:if test="${bug.pri == 0}"><td></td></c:if>
						<c:if test="${bug.pri == 0}"><td>${bug.pri}</td></c:if>
					</tr>
					<tr>
						<th>Bug状态：</th>
						<td id="status">
							${statusMap[bug.status]}
						</td>
					</tr>
					<tr>
						<th>激活次数：</th>
						<td>${bug.activatedCount}</td>
					</tr>
					<tr>
						<th id="isConfirmed">是否确认：</th>
						<td>
							<c:if test="${bug.confirmed == 0}">是</c:if>
							<c:if test="${bug.confirmed != 0}">否</c:if>
						</td>
					</tr>
					<tr>
						<th>当前指派：</th>
						<td>
							<c:if test="${bug.assignedTo != null && bug.assignedTo != ''}">
								<c:if test="${bug.assignedTo == 'closed'}">Closed 于  <fmt:formatDate type="both" value="${bug.assignedDate}"/> </c:if>
								<c:if test="${bug.assignedTo != 'closed'}">${userMap[bug.assignedTo]} 于 <fmt:formatDate type="both" value="${bug.assignedDate}"/></c:if>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>操作系统：</th>
						<td>${osMap[bug.os]}</td>
					</tr>
					<tr>
						<th>浏览器：</th>
						<td>${browserMap[bug.browser]}</td>
					</tr>
					<tr>
						<th>关键词：</th>
						<td>${bug.keywords}</td>
					</tr>
					<tr>
						<th>抄送给：</th>
						<td>${userMap[bug.mailto]}</td>
					</tr>
				</table>
			</div>
		</div>	
		<div class="bug-info">
			<div class="info-heading" >
				<strong>项目/需求/任务</strong>
				&nbsp;&nbsp;<i class="icon icon-angle-down"></i>
			</div>
			<div class="info-body" >
				<table class="">
					<tr>
						<th >所属项目：</th>
						<td >${task.project.name}</td>
					</tr>
					<tr>
						<th>相关需求：</th>
						<td>${story.title}</td>
					</tr>
					<tr>
						<th>相关任务：</th>
						<td>${task.name}</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="bug-info">
			<div class="info-heading" >
				<strong>BUG的一生</strong>
				<i class="icon icon-angle-down"></i>
			</div>
			<div class="info-body" >
				<table class="">
					<tr>
						<th >由谁创建：</th>
						<td >
							<c:if test="${bug.openedBy != null && bug.openedBy !='' }">
								${userMap[bug.openedBy]} 于 <fmt:formatDate type="both" value="${bug.openedDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>影响版本：</th>
						<td>${bug.openedBuild}</td>
					</tr>
					<tr>
						<th>由谁解决：</th>
						<td>
							<c:if test="${bug.resolvedBy != null && bug.resolvedBy !='' }">
								${userMap[bug.resolvedBy]} 于 <fmt:formatDate type="both" value="${bug.resolvedDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>解决版本：</th>
						<td>${bug.resolvedBuild}</td>
					</tr>
					<tr>
						<th>解决方案：</th>
						<td>${resolutionMap[bug.resolution]}</td>
					</tr>
					<tr>
						<th>由谁关闭：</th>
						<td>
							<c:if test="${bug.closedBy != null && bug.closedBy != ''}">
								${userMap[bug.closedBy]} 于  <fmt:formatDate type="both" value="${bug.closedDate}"/>
							</c:if>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>最后修改：</th>
						<td>
							<c:if test="${bug.lastEditedBy != null && bug.lastEditedBy != ''}">
								${userMap[bug.lastEditedBy]} 于  <fmt:formatDate type="both" value="${bug.lastEditedDate}"/>
							</c:if>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="bug-info" >
			<div class = "info-heading">
				<strong>其他相关</strong>
				<i class="icon icon-angle-down"></i>
			</div> 
			<div class = "info-body" >
				<table>
					<tr>
						<td>${bug.linkBug}</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="bug-info">
			<div class = "info-heading">
				<strong>重要步骤</strong>
				<i class="icon icon-angle-down"></i>
			</div> 
			<div class = "info-body" >
				<table>
					<tr>
						<td>
							${bug.steps}
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="bug-info">
			<div class = "info-heading" >
				<strong>附件</strong>
				<i class="icon icon-angle-down"></i>
			</div> 
			<div class = "info-body" >
				
			</div>
		</div>
		<div class="bug-info">
			<div class="info-heading" >
				<strong>历史记录</strong>
				<i class="icon icon-angle-down"></i>
			</div>
			
			<div class = "info-body" >
			<%@ include file="/WEB-INF/jsp/include/history.jsp"%>
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
	          						<form method="post" action="./action-editBugComment-${action.id}">
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
			</div>
		</div>
	</div>
	<div>
		<div  class= "exbtn"><i class="icon icon-plus-sign"></i></div>
		<div class = " btn-group-vertical ">
<%-- 			<button type="button" class="btn btn-default " id="btn-log" onclick="window.location.href='bug-record-${bug.id}'">工时</button> --%>
 		    <button type="button" class="btn btn-default " id="btn-assign" >指派</button>
 		    <c:if >
 		    	<button type="button" class="btn btn-default " id="btn-solve" >解决</button>
 		    </c:if>
 		    <c:if test="${bug.status == 'resolved'}">
 		    	<button type="button" class="btn btn-default " id="btn-close" >关闭</button>
 		    </c:if>
 		    <c:if test="${bug.status == 'resolved' || bug.status == 'closed'}">
 		    	<button type="button" class="btn btn-default " id="btn-active" onclick="window.location.href='bug-active-${bug.id}'">激活</button>
 		    </c:if>
 		    <c:if test="${bug.status == 'active'}">
 		    	<button type="button" class="btn btn-default " id="btn-demandFor" onclick="window.location.href='bug-damandFor-${bug.id}'">提需求</button>
 		    </c:if>
 		    <button type="button" class="btn btn-default " id="btn-buildCase"  onclick="window.location.href='bug-buildCase-${bug.id}'" >建用例</button>
 		    <button type="button" class="btn btn-default " id="btn-edit" onclick="window.location.href='bug-edit-${bug.id}'">编辑</button>
 		    <button type="button" class="btn btn-default " id="btn-delete" onclick="isDelete(${bug.id})">删除</button>
		  	<button type="button" class="btn btn-default" id="btn-back" onclick="history.go(-1)">返回</button>
		</div>
	</div>
</body>
<script> 
	$(document).ready(function(){
		// 显示/隐藏信息
		$('.bug-info').each(function(){
			var onoff= false;
			$(this).find('.info-heading').click(function(){
				if(onoff){//隐藏
					$(this).next().hide();
					$(this).find("i").attr("class","icon icon-angle-down");
				}
				else{//显示
					$(this).next().show();
					$(this).find("i").attr("class","icon icon-angle-up");
				}
				onoff=!onoff;
			});
		});
		
		//侧边栏按钮的显示/隐藏
		var onoff=false;
		$('.exbtn').click(function(){
			if(!onoff){
				$(this).find("i").attr("class","icon icon-remove-sign");
				$(this).next().show();
			}
			else{
				$(this).find("i").attr("class","icon icon-plus-sign");
				$(this).next().hide();
			}
			onoff=!onoff;
		});
		
	});
	
	// 	删除功能
	function isDelete(bugId) {
		if(confirm('您确定要删除这个BUG吗？')) {
			location.href="bug-delete-"+bugId;
		}
	}
</script>
</html>