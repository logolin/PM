<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

<title>任务的详细信息</title>

<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/wxcss/detail.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
</head>
<body>
	<div class="title"><label>${task.id}</label>&nbsp;&nbsp;<strong>${task.name}</strong></div>
	<div class="content">
		<div class="task-info">
			<div class="info-heading">
				<strong>基本信息</strong>
				<i class="icon icon-angle-down"></i>
			</div>
			<div class="info-body" >
				<table class="baseInfor">
					<tr >
						<th>所属项目：</th>
						<td>${task.project.name}</td>
					</tr>
					<tr>
						<th>所属模块：</th>
						<td>${module.name}</td>
					</tr>
					<tr>
						<th>相关需求：</th>
						<td>${story.title}</td>
					</tr>
					<tr>
						<th>指派给：</th>
						<td>${userMap[task.assignedTo]}</td>
					</tr>
					<tr>
						<th>任务类型：</th>
						<td>${typeMap[task.type]}</td>
					</tr>
					<tr>
						<th>任务状态：</th>
						<td id="status">${task.ch_status}</td>
					</tr>
					<tr>
						<th>优先级：</th>
						<c:if test="${task.pri == 0}"><td></td></c:if>
						<c:if test="${task.pri != 0}"><td>${task.pri}</td></c:if>
					</tr>
					<tr>
						<th>抄送给：</th>
						<td>${userMap[task.mailto]}</td>
					</tr>
				</table>
			</div>
		</div>	
		<div class="task-info">
			<div class="info-heading" >
				<strong>工时信息</strong>
				&nbsp;&nbsp;<i class="icon icon-angle-down "></i>
			</div>
			<div class="info-body" >
				<table class="baseImfor">
					<tr>
						<th >预计开始：</th>
						<td >${task.estStarted}</td>
					</tr>
					<tr>
						<th>实际开始：</th>
						<td>${task.realStarted}</td>
					</tr>
					<tr>
						<th>截止日期：</th>
						<td>${task.deadline}</td>
					</tr>
					<tr>
						<th>最初预计：</th>
						<td><fmt:formatNumber type="number" >${task.estimate}</fmt:formatNumber></td>
					</tr>
					<tr>
						<th>总消耗：</th>
						<td><fmt:formatNumber type="number" >${task.consumed}</fmt:formatNumber></td>
					</tr>
					<tr>
						<th>预计剩余：</th>
						<td><fmt:formatNumber type="number" >${task.remain}</fmt:formatNumber></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="task-info">
			<div class="info-heading" >
				<strong>任务的一生</strong>
				<i class="icon icon-angle-down"></i>
			</div>
			<div class="info-body" >
				<table class="baseImfor">
					<tr>
						<th >由谁创建：</th>
						<td >
							<c:if test="${task.openedBy != null && task.openedBy != ''}">
								${userMap[task.openedBy]} 于  <fmt:formatDate type="both" value="${task.openedDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>由谁完成：</th>
						<td >
							<c:if test="${task.finishedBy != null && task.finishedBy != ''}">
								${userMap[task.finishedBy]} 于  <fmt:formatDate type="both" value="${task.finishedDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>由谁取消：</th>
						<td >
							<c:if test="${task.canceledBy != null && task.canceledBy != ''}">
								${userMap[task.canceledBy]} 于  <fmt:formatDate type="both" value="${task.canceledDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>由谁关闭：</th>
						<td >
							<c:if test="${task.closedBy != null && task.closedBy != ''}">
								${userMap[task.closedBy]} 于  <fmt:formatDate type="both" value="${task.closedDate}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>关闭原因：</th>
						<td>${task.closedReason}</td>
					</tr>
					<tr>
						<th>最后编辑：</th>
						<td >
							<c:if test="${task.lastEditedBy != null && task.lastEditedBy != ''}">
								${userMap[task.lastEditedBy]} 于  <fmt:formatDate type="both" value="${task.lastEditedDate}"/>
							</c:if>
						</td>
					</tr>
					
				</table>
			</div>
		</div>
		<div class="task-info" >
			<div class="info-heading">
				<strong>任务描述</strong>
				<i class="icon icon-angle-down "></i>
			</div> 
			<div class="info-body" >
				<table>
					<tr>
						<td>
							${task.descript}
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="task-info">
			<div class="info-heading">
				<strong>需求描述</strong>
				<i class="icon icon-angle-down "></i>
			</div> 
			<div class="info-body" >
				<table>
					<tr>
						<td>
							${storyspec.spec}
						</td>
					</tr>
				</table>
			</div>
		</div>
<!-- 		<div class="task-info"> -->
<!-- 			<div class = "info-heading" > -->
<!-- 				<strong>附件</strong> -->
<!-- 				<i class="icon icon-angle-down"></i> -->
<!-- 			</div>  -->
<!-- 			<div class = "info-body"> -->
				
<!-- 			</div> -->
<!-- 		</div> -->
		<div class="task-info">
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
	          						<form method="post" action="./action-editTaskComment-${action.id}">
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
		<div  class="exbtn"><i class="icon icon-plus-sign"></i></div>
		<div class="btn-group-vertical">
			<c:if test="${task.ch_status == '未开始' || task.status == 'done' || task.status == 'pause' || task.ch_status == '进行中'}">
				<button type="button" class="btn btn-default " id="btn-assign" onclick="window.location.href='task-assign-${task.id}'">指派</button>
			</c:if>
			<c:if test="${task.ch_status == '未开始'}">
				<button type="button" class="btn btn-default " id="btn-begin" onclick="window.location.href='task-begin-${task.id}'">开始</button>
			</c:if>
			<c:if test="${task.status == 'pause'}">
				<button type="button" class="btn btn-default " id="btn-continue" onclick="window.location.href='task-continue-${task.id}'">继续</button>
			</c:if>
			<c:if test="${task.ch_status == '进行中'}">
				<button type="button" class="btn btn-default " id="btn-pause" onclick="window.location.href='task-pause-${task.id}'">暂停</button>
			</c:if>
<%-- 			<button type="button" class="btn btn-default " id="btn-workingHours" onclick="window.location.href='task-record-${task.id}'">工时</button> --%>
			<c:if test="${task.ch_status == '未开始' || task.status == 'pause' || task.ch_status == '进行中'}">
				<button type="button" class="btn btn-default " id="btn-finish" onclick="window.location.href='task-finish-${task.id}'">完成</button>
			</c:if>
			<c:if test="${task.status == 'done' || task.status == 'cancel' }">
				<button type="button" class="btn btn-default " id="btn-close" onclick="window.location.href='task-close-${task.id}'">关闭</button>
			</c:if>
			<c:if test="${task.status == 'done' || task.status == 'cancel' || task.status == 'colsed'}">
				<button type="button" class="btn btn-default " id="btn-actived" onclick="window.location.href='task-actived-${task.id}'">激活</button>
			</c:if>
			<c:if test="${task.ch_status == '未开始' || task.status == 'pause' || task.ch_status == '进行中'}">
				<button type="button" class="btn btn-default " id="btn-cancel" onclick="window.location.href='task-cancel-${task.id}'">取消</button>
			</c:if>
			<button type="button" class="btn btn-default" id="btn-edit" onclick="window.location.href='task-edit-${task.id}'">编辑</button>
		  	<button type="button" class="btn btn-default" id="btn-create" onclick="window.location.href='task-create-${task.project.id}-${task.id}'">创建</button>
		  	<button type="button" class="btn btn-default" id="btn-delete" onclick="isDelete(${task.id})">删除</button>
		 	<button type="button" class="btn btn-default" id="btn-back" onclick="history.go(-1)">返回</button>
		</div>
	</div>
</body>
<script>
	$(document).ready(function(){
		// 显示/隐藏信息
		$('.task-info').each(function(){
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
	function isDelete(taskId) {
		if(confirm('您确定要删除这个任务吗？')) {
			location.href="task-delete-"+taskId;	
		}	
	}
</script>
</html>