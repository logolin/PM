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
	<div class="titlebar">
		<div class="title">
			<div class="title1">
				<div class="title2">
					<span>${bug.id}&nbsp;&nbsp;${bug.title}</span>
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
                    <p><label>所属平台：</label>${branch.name}</p>
                    <p><label>所属模块：</label>${module.name}</p>
                    <p><label>所属计划：</label>${plan.title}</p>
                    <p><label>Bug类型：</label>${typeMap[bug.type]}</p>
                    <p><label>严重程度：</label>${bug.severity}</p>
                    <p><label>优先级：</label><c:if test="${bug.pri == 0}"></c:if><c:if test="${bug.pri == 0}">${bug.pri}</c:if></p>
                    <p><label>Bug状态：</label>${statusMap[bug.status]}</p>
                    <p><label>激活次数：</label>${bug.activatedCount}</p>
                    <p><label>是否确认：</label><c:if test="${bug.confirmed == 0}">是</c:if><c:if test="${bug.confirmed != 0}">否</c:if></p>
                    <p><label>当前指派：</label>
                    	<c:if test="${bug.assignedTo != null && bug.assignedTo != ''}">
							<c:if test="${bug.assignedTo == 'closed'}">Closed 于  <fmt:formatDate type="both" value="${bug.assignedDate}"/> </c:if>
							<c:if test="${bug.assignedTo != 'closed'}">${userMap[bug.assignedTo]} 于 <fmt:formatDate type="both" value="${bug.assignedDate}"/></c:if>
						</c:if>
                    </p>
                    <p><label>操作系统：</label>${osMap[bug.os]}</p>
                    <p><label>浏览器：</label>${browserMap[bug.browser]}</p>
                    <p><label>关键词：</label>${bug.keywords}</p>
                    <p><label>抄送给：</label>${userMap[bug.mailto]}</p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	项目/需求/任务
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p><label>所属项目：</label>${task.project.name}</p>
                    <p><label>相关需求：</label>${story.title}</p>
                    <p><label>相关任务：</label>${task.name}</p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	BUG的一生
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p><label>由谁创建：</label>
                    	<c:if test="${bug.openedBy != null && bug.openedBy !='' }">
							${userMap[bug.openedBy]} 于 <fmt:formatDate type="both" value="${bug.openedDate}"/>
						</c:if>
                    </p>
                    <p><label>影响版本：</label>${bug.openedBuild}</p>
                    <p><label>由谁解决：</label>
                    	<c:if test="${bug.resolvedBy != null && bug.resolvedBy !='' }">
							${userMap[bug.resolvedBy]} 于 <fmt:formatDate type="both" value="${bug.resolvedDate}"/>
						</c:if>
                    </p>
                    <p><label>解决版本：</label>${bug.resolvedBuild}</p>
                    <p><label>解决方案：</label>${resolutionMap[bug.resolution]}</p>
                    <p><label>由谁关闭：</label>
                    	<c:if test="${bug.closedBy != null && bug.closedBy != ''}">
							${userMap[bug.closedBy]} 于  <fmt:formatDate type="both" value="${bug.closedDate}"/>
						</c:if>
                    </p>
                    <p><label>最后修改：</label>
                    	<c:if test="${bug.lastEditedBy != null && bug.lastEditedBy != ''}">
							${userMap[bug.lastEditedBy]} 于  <fmt:formatDate type="both" value="${bug.lastEditedDate}"/>
						</c:if>
                    </p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	其他相关
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p>${bug.linkBug}</p>
                </div>
       		</div>
       	</div>
   	</div>
   	<div class="wrap">
		<div class="head-back">
		    <div class="head-front">
		       	重要步骤
		    </div>
		</div>
        <div class="wrap-info">
            <div class="info1">
                <div class="info2">
                    <p>${bug.steps}</p>
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
                    </p>
                </div>
       		</div>
       	</div>
   	</div>
	<div class="btn-list">
		<div>
			<button type="button" onclick="window.location.href='bug-assign-${bug.id}'">
				<i class="icon icon-hand-right"></i><br>
				<span>指派</span>
			</button>
		</div>
		<c:if test="${bug.status == 'active'}">
			<div>
				<button type="button" onclick="window.location.href='bug-solve-${bug.id}'">
					<i class="icon icon-checked"></i><br>
					<span>解决</span>
				</button>
			</div>
		</c:if>
		<c:if test="${bug.status == 'resolved'}">
			<div>
				<button type="button" onclick="window.location.href='bug-close-${bug.id}'">
					<i class="icon icon-off"></i><br>
					<span>关闭</span>
				</button>
			</div>
		</c:if>
		<c:if test="${bug.status == 'resolved' || bug.status == 'closed'}">
 		    <div>
 		    	<button onclick="window.location.href='bug-active-${bug.id}'">
	 		    	<i class="icon icon-magic"></i><br>
	 		    	<span>激活</span>
 		    	</button>
 		    </div>
 		</c:if>
 		<c:if test="${bug.status == 'active'}">
 		    <div>
 		    	<button onclick="window.location.href='bug-damandFor-${bug.id}'">
 		    		<i class="icon icon-lightbulb"></i><br>
	 		    	<span>提需求</span>
 		    	</button>
 		    </div>
 		</c:if>
	    <c:if test="${bug.status == 'closed'}">
	    	<div>
	    		<button onclick="isDelete(${bug.id})">
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
		<div class="btn-group dropup">
			<button class="dropdown-toggle" data-toggle="dropdown" type="button">
				<i class="icon icon-plus"></i><br>
				<span>更多</span>
			</button>
			<ul class="dropdown-menu" role="menu" >
				<li>
					<button onclick="window.location.href='bug-edit-${bug.id}'"><i class="icon icon-pencil"></i><span>编辑</span></button>
				</li>
				<c:if test="${bug.status != 'closed'}">
					<li class="divider"></li>
					<li>
						<button onclick="isDelete(${bug.id})"><i class="icon icon-times"></i>&nbsp;<span>删除</span></button>
					</li>
				</c:if>
				<li class="divider"></li>
				<li>
					<button onclick="window.location.href='bug-buildCase-${bug.id}'"><i class="icon icon-usecase"></i><span>建用例</span></button>
				</li>
			</ul>
		</div>
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
	// 	删除功能
	function isDelete(bugId) {
		if(confirm('您确定要删除这个BUG吗？')) {
			location.href="bug-delete-"+bugId;
		}
	}
</script>
</html>