<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% SimpleDateFormat finish=new SimpleDateFormat("MM-dd HH:mm"); %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
  
<style>
.table-datatable tbody > tr td,
.table-datatable thead > tr th {max-height: 34px; line-height: 21px;}
.table-datatable tbody > tr td .btn-icon > i {line-height: 19px;}
.hide-side .table-datatable thead > tr > th.check-btn i {visibility: hidden;}
.hide-side .side-handle {line-height: 33px}
.table-datatable .checkbox-row {display: none}
.outer .datatable {border: 1px solid #ddd;}
.outer .datatable .table, .outer .datatable .table tfoot td {border: none; box-shadow: none}
.datatable .table>tbody>tr.active>td.col-hover, .datatable .table>tbody>tr.active.hover>td {background-color: #f3eed8 !important;}
.datatable-span.flexarea .scroll-slide {bottom: -30px}

.panel > .datatable, .panel-body > .datatable {margin-bottom: 0;}

.dropdown-menu.with-search {padding-bottom: 34px; min-width: 150px; overflow: hidden; max-height: 305px}
.dropdown-menu > .menu-search {padding: 0; position: absolute; z-index: 0; bottom: 0; left: 0; right: 0}
.dropdown-menu > .menu-search .input-group {width:100%;}
.dropdown-menu > .menu-search .input-group-addon {position: absolute; right: 10px; top: 0; z-index: 10; background: none; border: none; color: #666}
.pl-5px{padding-left:5px;}
a.removeModule{color:#ddd}
a.removeModule:hover{color:red}
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
		<div class="modal fade" id="showModuleModal" tabindex="-1" role="dialog" aria-hidden="true">
		  <div class="modal-dialog w-600px">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		        <h4 class="modal-title"><i class="icon-cog"></i> 列表页是否显示模块名</h4>
		      </div>
		      <div class="modal-body">
		        <form class="form-condensed" method="post" target="hiddenwin" action="">
		          <p>
		            <span><label class="radio-inline">
		            <input type="radio" name="showModule" value="0" checked="checked" id="showModule0"> 不显示</label>
		            <label class="radio-inline">
		            <input type="radio" name="showModule" value="base" id="showModulebase"> 只显示一级模块</label>
		            <label class="radio-inline">
		            <input type="radio" name="showModule" value="end" id="showModuleend"> 只显示最后一级模块</label></span>
		            <button type="button" id="setShowModule" class="btn btn-primary">保存</button>
		         </p>
		        </form>
		      </div>
		    </div>
		  </div>
		</div>
		<%@include file="/WEB-INF/jsp/include/taskhead.jsp" %>
		<div class="side" id="treebox" >
		  		<a class="side-handle" onclick="showTree()" data-id="productTree" style="">
		  		<i id="myIcon" class="icon-caret-left"></i></a>
		  		<div class="side-body">
		    		<div class="panel panel-sm">
		      			<div class="panel-heading nobr"><i class="icon-folder-close-alt"></i> <strong>${project.name}</strong></div>
		      			<div class="panel-body">
		      				<ul class="tree-lines tree" id="modulesTree" data-animate="true" data-ride="tree">
	         					<li id="branchModules" style="display:none"></li>
	         					<c:forEach items="${productList}" var="product" varStatus="i">
	         						<li class="has-list open in">
	         							<a href='./project_task_${project.id}_byProduct_${product.id}'>${product.name}</a>
	         							<ul id="product${product.id}"></ul>
	         						</li>
	         					</c:forEach>
	          				</ul>
		        			<div class="text-right">
		        				<a href="${ctxpj}/project_edit_${projectId}">编辑</a>
		          				<a href="">维护模块</a>
		        			</div>
		        			<div class="text-right">
		        				<a href="javascript:;" data-toggle="showModuleModal">列表页是否显示模块名</a>
		        			</div>
		      			</div>
		    		</div>
		  		</div>
			</div>
		<div class="main">
			<form method="post" id="projectTaskForm" action="${ctxpj}/task_batchEdit_${project.id}">
				<table class="table table-condensed table-striped" data-custom-menu='true' data-checkable='true' data-checkbox-name="task" id="myTable">
					<thead>
						<tr>
							<th class="text-center" data-width="50" <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
					        <th class="text-center" data-width="50" <c:if test="${orderBy == 'pri'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>P</th>
						    <th class="w-p30" <c:if test="${orderBy == 'name'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>任务名称</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'type'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>任务类型</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'status'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>状态</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'estimate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>预</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'consumed'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>消耗</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'remain'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>剩</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'deadline'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>截止</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'openedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建者</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'openedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'estStarted'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>预计开始</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'realStarted'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>实际开始</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'assignedTo'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派给</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'assignedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派日期</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'finishedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>完成者</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'finishedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>完成</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'canceledBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>由谁取消</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'canceledDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>取消时间</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'closedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>由谁关闭</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'closedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>关闭时间</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'closedReason'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>关闭原因</th>
							<th class="flex-col" data-width="100" <c:if test="${orderBy == 'story_id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>相关需求</th>
							<th class="text-center" data-sort="false">操作</th>
				      	</tr>
			      </thead>
			       <tbody>
			       <c:set var="waitsum" value="0"/>
			       <c:set var="doingsum" value="0"/>
			       <c:set var="estimatesum" value="0"/>
			       <c:set var="consumedsum" value="0"/>
			       <c:set var="remainsum" value="0"/>
			       <!-- 设置权限，不用每行都重新查权限 -->
			       <shiro:hasPermission name="task:assignTo">
				       <c:set var="assignTo" value="true" />
			       </shiro:hasPermission>
			       <shiro:hasPermission name="task:start">
				       <c:set var="start" value="true" />
			       </shiro:hasPermission>
			       <shiro:hasPermission name="task:editEstimate">
				       <c:set var="editEstimate" value="true" />
				   </shiro:hasPermission>
				   <shiro:hasPermission name="task:finish">
				       <c:set var="finish" value="true" />
				   </shiro:hasPermission>
				   <shiro:hasPermission name="task:close">
				       <c:set var="close" value="true" />
				   </shiro:hasPermission>
				   <shiro:hasPermission name="task:edit">
				       <c:set var="edit" value="true" />
				   </shiro:hasPermission>
			       <c:forEach items="${taskPage.content}" var="task">  
						<tr class="slectable-item text-center" data-id="${task.id}">
					      <td class="text-left" id="taskId"><fmt:formatNumber type="number" minIntegerDigits="3" value="${task.id}" /></td>
					      <td>
					      	<span class="pri${task.pri}">
					      	<c:choose><c:when test="${task.pri == 0}"></c:when>
					      	<c:otherwise>${task.pri}</c:otherwise>
					      	</c:choose></span>
					      </td>	
					      <td class="text-left"><a href="${ctxpj}/task_view_${task.id}_${task.project.id}">${task.name}</a></td>
					      <td class="text-center">${typeMap[task.type]}</td>
					      <td class="${task.status}">${task.ch_status}</td>
					      <td><fmt:formatNumber value="${task.estimate}" pattern="" type="number" /></td>
					      <td><fmt:formatNumber value="${task.consumed}" pattern="" type="number" /></td>
					      <td><fmt:formatNumber value="${task.remain}" pattern="" type="number" /></td>
					      <td class="<c:if test="${task.status == 'delay'}"> delayed</c:if>"><fmt:formatDate value="${task.deadline}" pattern="MM-dd HH:mm" /></td>
					      <td>${userMap[task.openedBy]}</td>
					      <td><fmt:formatDate value="${task.openedDate}" pattern="MM-dd HH:mm" /></td>
					      <td >${task.estStarted}</td>
					      <td>${task.realStarted}</td>
					      <td>${userMap[task.assignedTo]}</td>
					      <td><fmt:formatDate value="${task.assignedDate}" pattern="MM-dd HH:mm" /></td>
					      <td>${userMap[task.finishedBy]}</td>
					      <td><fmt:formatDate value="${task.finishedDate}" pattern="MM-dd HH:mm" /></td>
					      <td>${userMap[task.canceledBy]}</td>
					      <td><fmt:formatDate value="${task.canceledDate}" pattern="MM-dd HH:mm" /></td>
					      <td>${userMap[task.closedBy]}</td>
					      <td><fmt:formatDate value="${task.closedDate}" pattern="MM-dd HH:mm" /></td>
					      <td>${task.closedReason}</td>
					      <td><a href="../product/story_view_${storyMap[task.story_id.toString()][2]}_${task.story_id}">${storyMap[task.story_id.toString()][1]}</a></td>
					      <td class="text-center">
					      	<c:if test="${assignTo == 'true'}">
								<button type="button" class="btn-icon" title="指派" data-width="900px" data-iframe="./task_assigned_${task.id}_${project.id}_${status}" data-show-header="false" data-toggle="modal"><i class="icon icon-hand-right"></i> </button>
							</c:if>
							<c:if test="${start == 'true'}">
								<button type="button" class="btn-icon" title="开始" <c:if test="${task.ch_status == '未开始'}">data-width="900px" data-iframe="./task_begin_${task.id}_${project.id}_${status}" data-show-header="false" data-toggle="modal"</c:if>><i class="icon <c:if test="${task.ch_status != '未开始'}">disabled</c:if> icon-play"></i> </button>
							</c:if>
							<c:if test="${editEstimate == 'true'}">
								<button type="button" class="btn-icon" title="工时" data-width="900px" data-iframe="./task_recordEstimate_${task.id}_${project.id}_${status}" data-show-header="false" data-toggle="modal"><i class="icon-task-recordEstimate icon-time"></i> </button>
							</c:if>
							<c:if test="${finish == 'true'}">
								<button type="button" class="btn-icon" title="完成" <c:if test="${task.ch_status != '已完成'}"> data-width="900px" data-iframe="./task_finish_${task.id}_${project.id}_${status}" data-show-header="false" data-toggle="modal"</c:if>><i class="icon-ok-sign <c:if test="${task.ch_status == '已完成'}">disabled</c:if>"></i></button>
							</c:if>
							<c:if test="${close == 'true'}">
								<button type="button" class="btn-icon" title="关闭" <c:if test="${task.ch_status == '已完成'}"> data-width="900px" data-iframe="./task_close_${task.id}_${project.id}_${status}" data-show-header="false" data-toggle="modal"</c:if>><i class="icon <c:if test="${task.ch_status != '已完成'}">disabled</c:if> icon-off"></i></button>   
							</c:if>
							<c:if test="${edit == 'true'}">
								<a type="button" class="btn-icon" href="${ctxpj}/task_edit_${projectId}_${task.id}" title="编辑"><i class="icon-common-edit icon-pencil"></i></a>   
						  	</c:if>
						  </td>
					    </tr>
					    <c:if test="${task.status == 'wait'}">
					    	<c:set var="waitsum" value="${waitsum = waitsum + 1}" />
					    </c:if>
					    <c:if test="${task.status == doing}">
					    	<c:set var="doingsum" value="${doingsum = doingsum + 1}" />
					    </c:if>
					    <c:set var="estimatesum" value="${estimatesum = estimatesum + task.estimate}" />
					    <c:set var="consumedsum" value="${consumedsum = consumedsum + task.consumed}" />
					    <c:set var="remainsum" value="${remainsum = remainsum + task.remain}" />
				    </c:forEach> 
			      	<tfoot>
				      	<tr>
				      		<c:choose>
                  				<c:when test="${taskPage.content.size() > 0}">
					        	<td colspan="11">
					        	  	<div class="table-actions clearfix">
	                       				<div class="checkbox btn">
	                       					<label><input type="checkbox" class="check-all check-btn"> 选择</label>
	                       				</div>                        
	                  					<div class="btn-group dropup">
	                   						<input id="taskIds" name="taskIds" type="hidden"/>
	       									<button type="submit" id="submit" class="btn btn-default">编辑</button>              
	       									<button type="button" class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
	       									<ul class="dropdown-menu">
	           									<li><a onclick="batchChange('close',0)">关闭</a></li>
												<li class="dropdown-submenu">
													<a href="javascript:;" id="moduleItem">模块</a>
													<ul class="dropdown-menu with-search">
														<li class="option" data-key="0"><a onclick="batchChange('Module_id',0)">/</a></li>
														<li class="menu-search">
															<div class="input-group input-group-sm">
																<input type="text" class="form-control" placeholder="">
																<span class="input-group-addon"><i class="icon-search"></i></span>
															</div>
														</li>
													</ul>
												</li>
												<li class="dropdown-submenu">
													<a href="javascript::" target="id=&quot;assignItem&quot;">指派给</a>
													<ul class="dropdown-menu with-search">
														<c:forEach items="${userList}" var="user">
															<li class="option" data-key="${user.account}"><a onclick="batchChange('AssignedTo','${user.account}')">${user.realname}</a></li>
														</c:forEach>
														<li class="option" data-key="closed"><a onclick="batchChange('AssignedTo','closed')">Closed</a></li>
														<li class="menu-search">
															<div class="input-group input-group-sm">
																<input type="text" class="form-control" placeholder="">
																<span class="input-group-addon"><i class="icon-search"></i></span>
															</div>
														</li>
													</ul>
												</li>              
											</ul>
			        					</div>
	                   					<div class="text">本页共 <strong>${taskPage.numberOfElements}</strong> 个任务，未开始 <strong>${waitsum}</strong>，
	                     					进行中 <strong>${doingsum}</strong>，总预计<strong><fmt:formatNumber value="${estimatesum}" type="number" />
	                     					</strong>工时，已消耗<strong><fmt:formatNumber value="${consumedsum}" type="number" />
	                     					</strong>工时，剩余<strong><fmt:formatNumber value="${remainsum}" type="number" /></strong>工时。
	                   					</div>
					        	  	</div>
					          		<div style="float:right; clear:none;" class="pager form-inline">
				        				共 <strong>${taskPage.totalElements}</strong> 条记录，
				        				<div class="dropdown dropup">
				        					<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
				        					<ul class="dropdown-menu">
					        					<c:forEach begin="5" end="50" step="5" var="i">
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
					        					</c:forEach>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
					        				</ul>
					        			</div> 
					        			<strong>${taskPage.number + 1}/${taskPage.totalPages}</strong> &nbsp; 
					        			<c:choose>
					        				<c:when test="${taskPage.isFirst()}">
					        					<i class="icon-step-backward" title="首页"></i>
					        					<i class="icon-play icon-rotate-180" title="上一页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
					        					<a href="./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
											</c:otherwise>
						        			</c:choose>
						        			<c:choose>
					        				<c:when test="${taskPage.isLast()}">
					        					<i class="icon-play" title="下一页"></i>
					        					<i class="icon-step-forward" title="末页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
					        					<a href="./project_task_${projectId}_${status}_${statusId}_${orderBy}_${ascOrDesc}_${recPerPage}_${taskPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
											</c:otherwise>
					        			</c:choose>
					        		</div>      
				          		</td>
				          		</c:when>
               					<c:otherwise>
               					<td colspan="12">
						            <div class="table-actions clearfix">
						            <div class="text">本页共 <strong>0</strong> 个任务，未开始 <strong>0</strong>，进行中 <strong>0</strong>，总预计<strong>0</strong>工时，已消耗<strong>0</strong>工时，剩余<strong>0</strong>工时。</div>            </div>
						            <div style="float:right; clear:none;" class="page">暂时没有记录</div>          </td>
               					</c:otherwise>
       						</c:choose>
				      	</tr>
			      	</tfoot>
			    </table>
			</form>
		</div>
<script>
$('#module0').addClass('active');
$('#unclosedTab').addClass('active');
</script>
<script type="text/javascript">
var taskIds;
var prod = 1;
$(document).ready(function() {
	$("#projectTaskForm").submit(function(){
		 if($('#taskIds').val() == '') {
			 bootbox.alert("请选择您要编辑的任务！");
			 return false;
		 }
	});
	loadProductModulesToIterateTree("${project.id}");
	loadProductModules("${project.id}");
	
	$('#myTable').datatable({
		storage: false,
		fixedLeftWidth: '45%',
		fixedRightWidth: '15%',
		sortable: true,
		colHover: false,
		checksChanged: function(event) {
			taskIds = event.checks.checks;
			$("#taskIds").val(taskIds);
		},
		sort: function(event) {
			var s = ['id','pri','name','type','status','estimate','consumed','remain','deadline','openedBy','openedDate','estStarted','realStarted','assignedTo','assignedDate','finishedBy','finishedDate','canceledBy','closedDate','closedBy','closedReason','story_id'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./project_task_${projectId}_${status}_${statusId}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${recPerPage}_${page}";
			}
		}
	})
})


function showTree() {
		$('#myIcon').toggleClass('icon-caret-left');
		$('.outer').toggleClass('hide-side');
		$('#myIcon').toggleClass('icon-caret-right');
}


function loadProductModules(projectId) {
 	$.get("../ajaxGetModules/" + projectId + "/task",function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree4Nav(data);
		}
	});
}
function loadProductModulesToIterateTree(projectId) {
	
	$.get("../ajaxGetModules/" + projectId,function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
		}
	})
}

function iterateTree(data,name) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		var productNumber = 0;
		if (productNumber === 0) {
			c = "/" + data[i].productName + a;
			$("#moduleItem + ul").append("<li class='option' data-key='" + data[i].id + "'><a onclick='batchChange('Module_id'," + data[i].id + ")'>" + c + "</a></li>");
		} else {			
			$("#moduleItem + ul").append("<li class='option' data-key='" + data[i].id + "'><a onclick='batchChange('Module_id'," + data[i].id + ")'>" + a + "</a></li>");
		}
		iterateTree(data[i].children,a);
	}
}
function iterateTree4Nav(data) {
	var actions;
	var no_list;
	var has_list;
	var childrenLeng;
	var before = function(idStr,content) {
		$(idStr).before(content);
	};
	var append = function(idStr,content) {
		$(idStr).append(content);
	};
	for (var i = 0, l = data.length; i < l; i++) {
		no_list = "<li><a href='./project_task_" + ${project.id} + "_byModule_" + data[i].id + "'>" + data[i].name + "</a></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./project_task_" + ${project.id} + "_byModule_" + data[i].id + "'>" + data[i].name + "</a><ul id='module" + data[i].id +"'></ul></li>";
		childrenLeng = data[i].children.length;
		if (data[i].id == ${statusId} && "${status}" === "byModule") {
			$(".with-close").append(data[i].name);
		} else if(data[i].root == ${statusId} && "${status}" === "byProduct"){
			if(prod === 1) {
				$(".with-close").append('<i class="icon icon-cube"></i>' + data[i].productName);
				prod = 0;
			}
		}
		if (data[i].parent == 0) {
			appendList(childrenLeng,"#product" + data[i].root, no_list,has_list,append);
		} else {
			appendList(childrenLeng,"#module" + data[i].parent,no_list,has_list,append);
		}
		iterateTree4Nav(data[i].children);
	}
}
function appendList(childrenLeng,idStr,no_list,has_list,func) {
	childrenLeng == 0 ? func(idStr,no_list) : func(idStr,has_list);
}

function batchChange(fieldName,fieldVal) {
	$.ajax({
		type:"post",
		url:"./task_batchChange_${projectId}",
		traditional:true,
		data:{"taskIds":taskIds,"fieldName":fieldName,"fieldVal":fieldVal},
		beforeSend:function(){
			if (taskIds === undefined) {
				bootbox.alert("<h4>请选择您需要修改的任务！</h4>");
				return false;
			}
		},
		complete:function(){
			history.go(0);
		},
	})
}
</script>
</div>
</body>
</html>