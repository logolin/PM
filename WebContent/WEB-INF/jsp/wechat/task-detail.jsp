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
	<div class="titlebar">
		<div class="title">
			<div class="title1">
				<div class="title2">
					<span>${task.id}&nbsp;&nbsp;${task.name}</span>
				</div>
			</div>
		</div>
	</div>
    <div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	 基本信息
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p><label>所属项目：</label>${task.project.name}</p>
                    <p><label>所属模块：</label>${module.name}</p>
                    <p><label>相关需求：</label>${story.title}</p>
                    <p><label>指派给：</label>${userMap[task.assignedTo]}</p>
                    <p><label>任务类型：</label>${typeMap[task.type]}</p>
                    <p><label>任务状态：</label>${task.ch_status}</p>
                    <p><label>优先级：</label><c:if test="${task.pri == 0}"></c:if><c:if test="${task.pri != 0}">${task.pri}</c:if></p>
                    <p><label>抄送给：</label>${userMap[task.mailto]}</p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
        <div class="head-back">
		    <div class="head-front">
		       	 工时信息
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p><label>预计开始：</label>${task.estStarted}</p>
                    <p><label>实际开始：</label>${task.realStarted}</p>
                    <p><label>截止日期：</label>${task.deadline}</p>
                    <p><label>最初预计：</label><fmt:formatNumber type="number" >${task.estimate}</fmt:formatNumber></p>
                    <p><label>总消耗：</label><fmt:formatNumber type="number" >${task.consumed}</fmt:formatNumber></p>
                    <p><label>预计剩余：</label><fmt:formatNumber type="number" >${task.remain}</fmt:formatNumber></p>
                </div>
       		</div>
       	</div>
   	</div>
	<div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	 任务的一生
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p><label>由谁创建：</label>
						<c:if test="${task.openedBy != null && task.openedBy != ''}">${userMap[task.openedBy]} 于  <fmt:formatDate type="both" value="${task.openedDate}"/></c:if>
                    </p>
                    <p><label>由谁完成：</label>
                    	<c:if test="${task.finishedBy != null && task.finishedBy != ''}">
							${userMap[task.finishedBy]} 于  <fmt:formatDate type="both" value="${task.finishedDate}"/>
						</c:if>
                    </p>
                    <p><label>由谁取消：</label>
                    	<c:if test="${task.canceledBy != null && task.canceledBy != ''}">
							${userMap[task.canceledBy]} 于  <fmt:formatDate type="both" value="${task.canceledDate}"/>
						</c:if>
                    </p>
                    <p><label>由谁关闭：</label>
                    	<c:if test="${task.closedBy != null && task.closedBy != ''}">
							${userMap[task.closedBy]} 于  <fmt:formatDate type="both" value="${task.closedDate}"/>
						</c:if>
                    </p>
                    <p><label>关闭原因：</label>
                    	${task.closedReason}
                    </p>
                    <p><label>最后编辑：</label>
                    	<c:if test="${task.lastEditedBy != null && task.lastEditedBy != ''}">
							${userMap[task.lastEditedBy]} 于  <fmt:formatDate type="both" value="${task.lastEditedDate}"/>
						</c:if>
                    </p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
        <div class="head-back">
		    <div class="head-front">
		       	 任务描述
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p>${task.descript}</p>
                </div>
       		</div>
       	</div>
   	</div>
    <div class="wrap">
        <div class="head-back">
		    <div class="head-front">
		       	 需求描述
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p>${storyspec.spec}</p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
        <div class="head-back">
		    <div class="head-front">
		       	 历史记录
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p>
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
                    </p>
                </div>
       		</div>
       	</div>
   	</div>
	<div class="btn-list">
		<c:if test="${task.ch_status == '未开始' || task.status == 'done' || task.status == 'pause' || task.ch_status == '进行中'}">
			<div>
				<button type="button" onclick="window.location.href='task-assign-${task.id}'">
					<i class="icon icon-hand-right"></i><br>
					<span>指派</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.ch_status == '未开始'}">
			<div>
				<button type="button" onclick="window.location.href='task-begin-${task.id}'">
					<i class="icon icon-play"></i><br>
					<span>开始</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'pause'}">
			<div>
				<button type="button" onclick="window.location.href='task-continue-${task.id}'">
					<i class="icon icon-play"></i><br>
					<span>继续</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.ch_status == '进行中'}">
			<div>
				<button type="button" onclick="window.location.href='task-pause-${task.id}'">
					<i class="icon icon-pause"></i><br>
					<span>暂停</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.ch_status == '未开始' || task.status == 'pause' || task.ch_status == '进行中'}">
			<div>
				<button type="button" onclick="window.location.href='task-finish-${task.id}'">
					<i class="icon icon-checked"></i><br>
					<span>完成</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'done' || task.status == 'cancel' }">
			<div>
				<button type="button" onclick="window.location.href='task-close-${task.id}'">
					<i class="icon icon-off"></i><br>
					<span>关闭</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'closed' || task.status == 'done' || task.status == 'cancel'}">
			<div>
				<button type="button" onclick="window.location.href='task-actived-${task.id}'">
					<i class="icon icon-magic"></i><br>
					<span>激活</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'closed'}">
			<div>
				<button type="button" onclick="window.location.href='task-edit-${task.id}'">
					<i class="icon icon-pencil"></i><br>
					<span>编辑</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'closed'}">
			<div>
				<button type="button" onclick="window.location.href='task-create-${task.project.id}-${task.id}'">
					<i class="icon icon-copy"></i><br>
					<span>创建</span>
				</button>
			</div>
		</c:if>
		<c:if test="${task.status == 'cancel' || task.status == 'closed'}">
			<div>
				<button type="button" onclick="isDelete(${task.id})">
					<i class="icon icon-times"></i><br>
					<span>删除</span>
				</button>
			</div>
		</c:if>
		<div>
			<button onclick="history.go(-1)">
				<i class="icon icon-undo"></i><br>
				<span>返回</span>
			</button>
		</div>
		<c:if test="${task.status != 'closed'}">
				<div class="btn-group dropup">
					<button class="dropdown-toggle" data-toggle="dropdown" type="button">
						<i class="icon icon-plus"></i><br>
						<span>更多</span>
					</button>
					<ul class="dropdown-menu" role="menu" >
						<c:if test="${task.ch_status == '未开始' || task.status == 'pause' || task.ch_status == '进行中'}">
							<li>
								<button type="button" onclick="window.location.href='task-cancel-${task.id}'"><i class="icon icon-ban-circle"></i><span>取消</span></button>
							</li>
							<li class="divider"></li>
						</c:if>
						<li >
							<button type="button" onclick="window.location.href='task-edit-${task.id}'"><i class="icon icon-pencil"></i><span>编辑</span></button>
						</li>
						<li class="divider"></li>
						<li>
							<button type="button" onclick="window.location.href='task-create-${task.project.id}-${task.id}'"><i class="icon icon-copy"></i><span>创建</span></button>
						</li>
						<c:if test="${task.status != 'cancel'}">
							<li class="divider"></li>
							<li>
								<button type="button" onclick="isDelete(${task.id})"><i class="icon icon-times"></i>&nbsp;<span>删除</span></button>
							</li>
						</c:if>
					</ul>
				</div>
			</c:if>
		</div>
</body>
<script>
	$(document).ready(function(){
		// 显示/隐藏信息
		$('.wrap').each(function(){
			var onoff= true;
			$(this).find('.head-back').click(function(){
				if(onoff){//隐藏
					$(this).next().hide();
				}
				else{//显示
					$(this).next().show();
				}
				onoff=!onoff;
			});
		});
	});
	function isDelete(taskId) {
		if(confirm('您确定要删除这个任务吗？')) {
			location.href="task-delete-"+taskId;	
		}	
	}
</script>
</html>