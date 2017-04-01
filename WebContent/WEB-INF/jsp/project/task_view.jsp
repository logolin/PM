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
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/zui/assets/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript">
var kEditorId = ["comment","lastComment"];
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
function setComment() {
	$('#commentBox').toggleClass('hide');
}
</script> 
<title>TASK#${task.id} ${task.name} / ${project.name}</title>
</head>
<body>
<header id="header">
	<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="titlebar">
				<div class="heading" style="padding-right: 417px;">
			    	<span class="prefix"><i class="icon-lightbulb"></i> <strong>${task.id}</strong></span>
			    	<strong style="color: ${task.color}">${task.name}</strong>
	      		</div>
				<div class="actions">
		    		<div class="btn-group">
		    			<c:if test="${task.status != 'closed' && task.status != 'cancel'}">
			    			<shiro:hasPermission name="task:assignTo">
						  		<a class="btn iframe" type="button" title="指派" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_assigned_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-assignTo icon-hand-right"></i> 指派</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始'}">
							<shiro:hasPermission name="task:start">
								<a class="btn iframe" type="button" title="开始" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_begin_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-restart icon-play"></i> 开始</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'pause'}">
							<shiro:hasPermission name="task:restart">
								<a class="btn iframe" type="button" title="继续" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_begin_${task.id}_${project.id}_restart" data-show-header="false" data-toggle="modal"><i class="icon-task-restart icon-play"></i> 继续</a>
							</shiro:hasPermission>
						</c:if>
						<shiro:hasPermission name="task:recordEstimate">
							<a class="btn iframe" type="button" title="工时" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_recordEstimate_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-recordEstimate icon-time"></i> 工时</a>
						</shiro:hasPermission>
						<c:if test="${task.ch_status == '进行中'}">
							<shiro:hasPermission name="task:pause">
								<a class="btn iframe" type="button" title="暂停" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_close_${task.id}_${project.id}_pause" data-show-header="false" data-toggle="modal"><i class="icon-task-pause icon-pause"></i> 暂停</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始' || task.ch_status == '进行中' || task.status == 'pause'}">
							<shiro:hasPermission name="task:finish">
								<a class="btn iframe showinonlybody text-success" title="完成" data-position="0" type="button" data-width="800px" data-iframe="${ctxpj}/task_finish_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-finish icon-ok-sign"></i> 完成</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始' || task.ch_status == '进行中' || task.status == 'pause'}">
							<shiro:hasPermission name="task:cancel">
								<a class="btn iframe" type="button" title="取消" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_cancel_${project.id}_${task.id}" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 取消</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'cancel' || task.status == 'cancel'|| task.status == 'done'}">
							<shiro:hasPermission name="task:close">
								<a class="btn iframe" type="button" title="关闭" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_close_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 关闭</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'cancel' || task.status == 'closed' || task.status == 'done'}">
							<shiro:hasPermission name="task:activate">
								<a class="btn iframe" type="button" title="激活" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_assigned_${task.id}_${project.id}_activate" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 激活</a>
							</shiro:hasPermission>
						</c:if>
					</div>
					<div class="btn-group">
						<shiro:hasPermission name="task:edit">
							<a href="${ctxpj}/task_edit_${task.project.id}_${task.id}" class="btn " title="编辑"><i class="icon-common-edit icon-pencil"></i></a>
						</shiro:hasPermission>
						<a href="#commentBox" title="备注" onclick="setComment()" class="btn"><i class="icon-comment-alt"></i></a>
						<shiro:hasPermission name="task:create">
							<a href="${ctxpj}/task_create_${project.id}" class="btn " title="create"><i class="icon-common-copy icon-copy"></i></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="task:delete">
							<a class="btn " title="删除" onclick="deleteTask(${task.id})"><i class="icon-common-delete icon-remove"></i></a>
						</shiro:hasPermission>
					</div>
					<div class="btn-group">
						<a href="javascript:void(0)" onclick="history.go(-1)" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
					</div>
				</div>
	 		</div>
			<div class="row-table">
			  <div class="col-main">
			    <div class="main">
			      <fieldset>
			        <legend>任务描述</legend>
			        <div class="article-content">${task.descript}</div>
			      </fieldset>
			      <fieldset>
			        <legend>需求描述</legend>
			        <div class="article-content">${storySpec.spec}</div>
			      </fieldset>
			      <fieldset>
			        <legend>验收标准</legend>
			        <div class="article-content"></div>
			      </fieldset>
			      <style> .files-list {margin: 0;} .files-list > .list-group-item {padding: 0px; border:0px;} .files-list > .list-group-item a {color: #666} .files-list > .list-group-item:hover a {color: #333} .files-list > .list-group-item > .right-icon {opacity: 0.01; transition: all 0.3s;} .files-list > .list-group-item:hover > .right-icon {opacity: 1} .files-list .btn-icon > i {font-size:15px}</style>
			      <fieldset>
			        <legend>附件</legend>
			        <div class="list-group files-list">
			        </div>
			      </fieldset>      
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
				  <div class="actions">
		    		<div class="btn-group">
		    			<c:if test="${task.status != 'closed' && task.status != 'cancel'}">
			    			<shiro:hasPermission name="task:assignTo">
						  		<a class="btn iframe" type="button" title="指派" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_assigned_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-assignTo icon-hand-right"></i> 指派</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始'}">
							<shiro:hasPermission name="task:start">
								<a class="btn iframe" type="button" title="开始" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_begin_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-restart icon-play"></i> 开始</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'pause'}">
							<shiro:hasPermission name="task:restart">
								<a class="btn iframe" type="button" title="继续" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_begin_${task.id}_${project.id}_restart" data-show-header="false" data-toggle="modal"><i class="icon-task-restart icon-play"></i> 继续</a>
							</shiro:hasPermission>
						</c:if>
						<shiro:hasPermission name="task:recordEstimate">
							<a class="btn iframe" type="button" title="工时" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_recordEstimate_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-recordEstimate icon-time"></i> 工时</a>
						</shiro:hasPermission>
						<c:if test="${task.ch_status == '进行中'}">
							<shiro:hasPermission name="task:pause">
								<a class="btn iframe" type="button" title="暂停" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_close_${task.id}_${project.id}_pause" data-show-header="false" data-toggle="modal"><i class="icon-task-pause icon-pause"></i> 暂停</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始' || task.ch_status == '进行中' || task.status == 'pause'}">
							<shiro:hasPermission name="task:finish">
								<a class="btn iframe showinonlybody text-success" title="完成" data-position="0" type="button" data-width="800px" data-iframe="${ctxpj}/task_finish_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-finish icon-ok-sign"></i> 完成</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.ch_status == '未开始' || task.ch_status == '进行中' || task.status == 'pause'}">
							<shiro:hasPermission name="task:cancel">
								<a class="btn iframe" type="button" title="取消" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_cancel_${project.id}_${task.id}" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 取消</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'cancel' || task.status == 'cancel'|| task.status == 'done'}">
							<shiro:hasPermission name="task:close">
								<a class="btn iframe" type="button" title="关闭" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_close_${task.id}_${project.id}_view" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 关闭</a>
							</shiro:hasPermission>
						</c:if>
						<c:if test="${task.status == 'cancel' || task.status == 'closed' || task.status == 'done'}">
							<shiro:hasPermission name="task:activate">
								<a class="btn iframe" type="button" title="激活" data-position="0" data-width="800px" data-iframe="${ctxpj}/task_assigned_${task.id}_${project.id}_activate" data-show-header="false" data-toggle="modal"><i class="icon-task-cancel icon-ban-circle"></i> 激活</a>
							</shiro:hasPermission>
						</c:if>
					</div>
					<div class="btn-group">
						<shiro:hasPermission name="task:edit">
							<a href="${ctxpj}/task_edit_${task.project.id}_${task.id}" class="btn " title="编辑"><i class="icon-common-edit icon-pencil"></i></a>
						</shiro:hasPermission>
						<a href="#commentBox" title="备注" onclick="setComment()" class="btn"><i class="icon-comment-alt"></i></a>
						<shiro:hasPermission name="task:create">
							<a href="${ctxpj}/task_create_${project.id}" class="btn " title="create"><i class="icon-common-copy icon-copy"></i></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="task:delete">
							<a class="btn " title="删除" onclick="deleteTask(${task.id})"><i class="icon-common-delete icon-remove"></i></a>
						</shiro:hasPermission>
					</div>
					<div class="btn-group">
						<a href="javascript:void(0)" onclick="history.go(-1)" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
					</div>
				</div>
				<fieldset id="commentBox" class="hide">
		        	<legend>备注</legend>
	        		<form method="post" action="./action_createComment_${taskId}_${task.project.id}">
		          		<div class="form-group">
				    		<textarea id="comment" name="comment" class="form-control kindeditor" style="height:150px;"></textarea>
				  		</div>
		           		<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
		           		<a href="javascript:setComment();" class="btn btn-back ">返回</a>        
		        	</form>
		      	</fieldset>
			    </div>
			  </div>
			  <div class="row-table">
			  	<div class="col-main">
			  		<div class="main">
			      <fieldset>
			        <legend>基本信息</legend>
			        <table class="table table-data table-condensed table-borderless"> 
			          <tbody>
						<tr>
				            <th class="w-80px">所属项目</th>
				            <td><a href="${ctxpj}/project_view_${project.id}">${project.name}</a>
				            </td>
				        </tr>  
			          	<tr>
			            	<th>所属模块</th>
			                <td id="module" title="/"></td>
						</tr>  
			          	<tr class="nofixed">
			            <th>相关需求</th>
			            <td>${story.title}</td>
			          	</tr>
			            <tr>
				            <th>指派给</th>
				            <c:if test="${task.assignedTo != null && task.assignedTo != ''}">
				            <td><c:if test="${task.assignedTo == 'closed'}">closed</c:if> <c:if test="${task.assignedTo != 'closed'}">${userMap[task.assignedTo]}</c:if> 于<fmt:formatDate value="${task.assignedDate}" type="both"/> </td> 
				            </c:if>
			          	</tr>
			         	<tr>
				            <th>任务类型</th>
				            <td>${typeMap[task.type]}</td>
			          	</tr>
			          	<tr>
				          	<th>任务状态</th>
				          	<td class="${task.status}">${task.ch_status}</td>
			          	</tr>
			          	<tr>
				            <th>优先级</th>
				            <td>
				            	<span class="pri${task.pri}">
				            		<c:choose>
				            			<c:when test="${task.pri == 0}"></c:when>
					      				<c:otherwise>${task.pri}</c:otherwise>
					      			</c:choose>
								</span>
							</td>
			          	</tr>
			          	<tr>
				            <th>抄送给</th>
				            <td>${task.mailto}</td>
			          	</tr>
			        </tbody>
			      </table>
			    </fieldset>
			    <fieldset>
			    	<legend>工时信息</legend>
			        <table class="table table-data table-condensed table-borderless"> 
			        	<tbody>
			        		<tr>
					            <th class="w-80px">预计开始</th>
					            <td>${task.estStarted}</td>
			        		</tr>
			        		<tr>
					            <th>实际开始</th>
					            <td>${task.realStarted}</td>
			        		</tr>  
			        		<tr>
					            <th>截止日期</th>
					            <td>${task.deadline}</td>
			        		</tr>  
			        		<tr>
					            <th>最初预计</th>
					            <td><fmt:formatNumber type="number" value="${task.estimate}" />工时</td>
			        		</tr>  
			        		<tr>
					            <th>总消耗</th>
					            <td><fmt:formatNumber type="number" value="${task.consumed}" />工时</td>
			        		</tr>  
			        		<tr>
					            <th>预计剩余</th>
					            <td><fmt:formatNumber type="number" value="${task.remain}" />工时</td>
			        		</tr>
				        </tbody>
			        </table>
			    </fieldset>
			    <fieldset>
			        <legend>任务的一生</legend>
			        <table class="table table-data table-condensed table-borderless"> 
			          <tbody>
			          	<tr>
				            <th class="w-80px">由谁创建</th>
				            <c:if test="${task.openedBy != null && task.openedBy != ''}">
				            <td> ${task.openedBy} 于  <fmt:formatDate value="${task.openedDate}" type="both"/></td>
				            </c:if>
			          	</tr>
			          	<tr>
				            <th>由谁完成</th>
				            <c:if test="${task.finishedBy != null && task.finishedBy != ''}">
				            <td> ${task.finishedBy} 于  <fmt:formatDate value="${task.finishedDate}" type="both"/> </td>
				            </c:if>
			          	</tr>
			          	<tr>
				            <th>由谁取消</th>
				            <c:if test="${task.canceledBy != null && task.canceledBy != ''}">
				            <td> ${task.canceledBy} 于  <fmt:formatDate value="${task.canceledDate}" type="both"/></td>
				            </c:if>
			          	</tr>
			          	<tr>
				            <th>由谁关闭</th>
				            <c:if test="${task.closedBy != null && task.closedBy != ''}">
				            <td>${task.closedBy} 于 <fmt:formatDate value="${task.closedDate}" type="both"/> </td>
				            </c:if>
			          	</tr>
			          	 <tr>
				            <th>关闭原因</th>
				            <td>
					            <c:if test="${task.closedReason == 'done'}">已完成</c:if>
					            <c:if test="${task.closedReason == 'cancel'}">已取消</c:if>
				            </td>
			          	</tr>
			          	<tr>
				            <th>最后编辑</th>
				            <c:if test="${task.lastEditedBy != null && task.lastEditedBy != ''}">
				            <td>${task.lastEditedBy} 于  <fmt:formatDate value="${task.lastEditedDate}" type="both"/></td>
				            </c:if>
			          	</tr>
			          </tbody>
			    	</table>
			    </fieldset>
			    </div>
			  </div>
			</div>	    
		  </div>
		</div>	
	</div>
<script>
$(function(){
	loadModule("${task.module_id}")
})
function loadModule(moduleId) {
	$.get("../getSingleModule/" + moduleId, function(data){
		if(!$.isEmptyObject(data)) {
			iterateTree(data, "", moduleId);
		}
	})
}

function iterateTree(data, name, moduleId) {
	var a = name;
// 	while(data.id != moduleId) {
// 		a = a + "/" + data.name;
// 		var data = data.children;
// 	}
	for (var i = 0; i < data.length; i++) {
		if(a == "") {
			a = data[i].productName + "> <a href='../project/project_task_${project.id}_byModule_"+ data[i].id +"'>" + data[i].name + "</a>";
		} else {
			a = a + "> <a href='../project/project_task_${project.id}_byModule_"+ data[i].id +"'>" + data[i].name + "</a>";
		}
		if(data[i].id == moduleId) {
			$("#module").append(a + "");
		}
		iterateTree(data[i].children, a ,moduleId);
	}
	
}
function deleteTask(taskId) {
	if(confirm("您确定删除这个任务吗？")) {
		location.href="${ctxpj}/task_deleted_"+taskId+"_"+${project.id};
	}
}
</script> 
</body>
</html>