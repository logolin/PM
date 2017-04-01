<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/src/js/tree.js"></script>
<title>树状图</title>
<style>.mgr-5px{margin-right:5px;}
.no-padding {padding: 0!important;}


#projectTree {margin-bottom: 0}
#projectTree > .tree-action-item {display: none!important}
#projectTree li > .tree-item-wrapper > .tree-toggle {display: block}
#projectTree li > .tree-item-wrapper:hover {background-color: #edf3fe; cursor: pointer; margin-left: -20px; padding-left: 20px;}
#projectTree li {line-height: 30px; padding-top: 0; padding-bottom: 0}
#projectTree > li.open > .tree-item-wrapper {border-bottom: none}
#projectTree.tree li.has-list.open > ul:after {top: -10px; bottom: 17px; display: none}
#projectTree.tree ul > li.has-list:after {top: 14px}
#projectTree.tree ul > li:after {top: 13px}
#projectTree.tree ul > li:before {display: block; content: ' '; border: none; border-left: 1px dotted #999; top: -11px; bottom: 12px; left: -11px; position: absolute; width: auto; height: auto}
#projectTree.tree ul > li:last-child:before {bottom: auto; height: 25px}
#projectTree.tree ul > li > .tree-item-wrapper:before {display: block; content: ' '; position: absolute; width: 7px; height: 7px; top: 10px; left: 8px; background-color: #ddd}
#projectTree.tree ul > li.has-list > .tree-item-wrapper:before {display: none;}
#projectTree.tree ul > li.item-type-task > .tree-item-wrapper {padding-left: 15px; margin-left: -15px;}
#projectTree.tree ul > li.item-type-task > .tree-item-wrapper:hover {background-color: #edf3fe}
#projectTree.tree ul > li.item-type-task > .tree-item-wrapper:before {left: 0; z-index: 2}
#projectTree.tree li>.list-toggle {top: 2px}
#projectTree.tree li:before {display: none}
#projectTree .item-type-story > ul > li {padding-left: 10px;}
#projectTree .item-type-tasks > .tree-item-wrapper:hover {background-color: #f5f5f5}
#projectTree .task-pri {position: relative; top: -1px}
#projectTree .task-assignto {display: inline-block; margin-left: 10px; color: #808080}
#projectTree .task-info {display: none;}
#projectTree .task-info > div {display: inline-block; margin: 0 5px;}
#projectTree .task-info > div.buttons {position: relative; top: 2px}
#projectTree .item-type-task:hover .task-info {display: inline-block; margin-left:10px;}

.tree-view-btn {min-width: 36px;}
.main > .panel > .panel-heading > .panel-actions {margin-top: -8px; margin-right: -12px;}

.label-task-count {background: #ddd; color: #333}
</style>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 492px;">
		<%@ include file="/WEB-INF/jsp/include/taskhead.jsp" %>
			<div class="main">
			  	<div class="panel">
				  	<div class="panel-heading">
				    	<i class="icon icon-folder-close-alt"></i> <strong>${project.name}</strong>
				      	<div class="panel-actions pull-right">
					        <div class="btn-group">
					        	<button type="button" class="btn btn-sm tree-view-btn" data-type="story">显示需求</button>
					        	<button type="button" class="btn btn-sm tree-view-btn" data-type="task">显示任务</button>
					    	</div>
				      </div>
				    </div>
				    <div class="panel-body">
      					<ul id="projectTree" class="tree-lines tree" data-ride="tree">
      						<c:if test="${!taskList.isEmpty()}">
      						<li class="item-type-module has-list open in" id="firstNull">
      							<i class="list-toggle icon"></i>
      							<div class="tree-item-wrapper tree-toggle">
      							<span class="tree-toggle"><i class="icon icon-bookmark-empty text-muted"></i> /</span>
      							</div>
      							<c:forEach items="${taskList}" var="task">
      							<ul>
      								<li class="item-type-task">
	      								<div class="tree-item-wrapper"><span class="task-pri pri${task.pri}">
	      								<c:choose><c:when test="${task.pri == 0}"></c:when><c:otherwise>${task.pri}</c:otherwise></c:choose></span> 
	      								<span class="text-muted">#${task.id} </span>
	      								<a href="${ctxpj}/task_view_${task.id}_${task.project.id}">${task.name}</a>
	      								<span class="task-assignto"><i class="icon icon-user text-muted"></i> ${userMap[task.assignedTo]}</span>
	      									<div class="task-info clearfix">
		      									<div class="status-${task.status}">${task.ch_status}</div>
			      								<div>预计 ${task.estimate} 消耗 ${task.consumed} 剩余 ${task.remain}</div>
						      					<div class="buttons" id="hrehtml">
						      						<shiro:hasPermission name="task:assignTo">
														<button type="button" class="btn-icon" title="指派" <c:if test="${task.ch_status != '已关闭'}"> data-width="900px" data-iframe="./task_assigned_${task.id}_${project.id}_tree" data-show-header="false" data-toggle="modal"</c:if>><i class="icon icon-hand-right <c:if test="${task.ch_status == '已关闭'}">disabled</c:if>"></i> </button>
													</shiro:hasPermission>
													<shiro:hasPermission name="task:start">
														<button type="button" class="btn-icon" title="开始" <c:if test="${task.ch_status == '未开始'}">data-width="900px" data-iframe="./task_begin_${task.id}_${project.id}_tree" data-show-header="false" data-toggle="modal"</c:if>><i class="icon <c:if test="${task.ch_status != '未开始'}">disabled</c:if> icon-play"></i> </button>
													</shiro:hasPermission>
													<shiro:hasPermission name="task:editEstimate">
														<button type="button" class="btn-icon" title="工时" data-width="900px" data-iframe="./task_recordEstimate_${task.id}_${project.id}_tree" data-show-header="false" data-toggle="modal"><i class="icon-task-recordEstimate icon-time"></i> </button>
													</shiro:hasPermission>
													<shiro:hasPermission name="task:finish">
														<button type="button" class="btn-icon" title="完成" <c:if test="${task.ch_status != '已完成' && task.ch_status != '已关闭'}"> data-width="900px" data-iframe="./task_finish_${task.id}_${project.id}_tree" data-show-header="false" data-toggle="modal"</c:if>><i class="icon-ok-sign <c:if test="${task.ch_status == '已完成' || task.ch_status == '已关闭'}">disabled</c:if>"></i></button>
													</shiro:hasPermission>
													<shiro:hasPermission name="task:close">
														<button type="button" class="btn-icon" title="关闭" <c:if test="${task.ch_status == '已完成' || task.ch_status == '已取消'}"> data-width="900px" data-iframe="./task_close_${task.id}_${project.id}_tree" data-show-header="false" data-toggle="modal"</c:if>><i class="icon <c:if test="${task.ch_status != '已完成' && task.ch_status != '已取消'}">disabled</c:if> icon-off"></i></button>   
													</shiro:hasPermission>
													<shiro:hasPermission name="task:edit">
														<a type="button" class="btn-icon" href="${ctxpj}/task_edit_${projectId}_${task.id}" title="编辑"><i class="icon-common-edit icon-pencil"></i></a>   
												  	</shiro:hasPermission>
							      				</div>
	      									</div>
	      								</div>
	      							</li>
      							</ul>
      							</c:forEach>
      						</li>
      						</c:if>
      						<c:forEach items="${productList}" var="product">
      							<li class="item-type-product has-list open in">
      								<i class="list-toggle icon"></i>
      								<div class="tree-item-wrapper tree-toggle"><span>
      									<i class="icon icon-cube text-muted"></i> ${product.name}</span>
      								</div>
      								<ul id="product${product.id}"></ul>
      							</li>
      						</c:forEach>
      					</ul>
      				</div>
			  	</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	loadProductModules("${project.id}");
	loadStory("${project.id}");
	loadTask("${project.id}");
});


//显示模块
function loadProductModules(projectId) {
	$.ajax({
		type: "get",
		url: "../ajaxGetModules/" + projectId +"/task",
		async: false,
		success: function(data){
			if (!$.isEmptyObject(data)) {
				iterateTree4Nav(data);
			}
		}
	})
}
//具体显示模块
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
		no_list = "<li class='item-type-module has-list open in' id='moduleli"+ data[i].id +"'><i class='list-toggle icon'></i><div class='tree-item-wrapper tree-toggle'><span class='tree-toggle'><i class='icon icon-bookmark-empty text-muted'></i> " + data[i].name + "</span></div><ul id='module" + data[i].id +"'></ul></li>";
		has_list = "<li class='item-type-module has-list open in' id='moduleli"+ data[i].id +"'><i class='list-toggle icon'></i><div class='tree-item-wrapper tree-toggle'><span class='tree-toggle'><i class='icon icon-bookmark-empty text-muted'></i> " + data[i].name + "</span></div><ul id='module" + data[i].id +"'></ul></li>";
		childrenLeng = data[i].children.length;
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

//显示需求
function loadStory(projectId) {
	$.ajax({
		type: "get",
		url: "../getStorysForProject/" + projectId,
		async: false,
		success: function(data) {
			if (!$.isEmptyObject(data)) {
				viewStory(data);
			}
		}
		
	});
}
//显示需求
function viewStory(data) {
	var mark = 0;
	for (var i = 0, l = data.length; i < l; i++) {
		var ulid = $("#product" + data[i].product.id +" .item-type-module ul");
		
		viewstorys = "<li class='item-type-story has-list'><i class='list-toggle icon'></i><div class='tree-item-wrapper'><span class='text-muted'></span><a href='../product/story_view_"+data[i].product.id +"_"+data[i].id+"_"+data[i].branch_id+"'> "+data[i].title+"</a><span class='label label-task-count label-badge'> "+data[i].id+"</span><div class='tree-actions'><a data-toggle='tooltip' href='javascript:;' class='tree-action' data-type='add' title='' data-original-title='批量分解'><i class='icon icon-sitemap'></i></a></div></div></li>";
		if(data[i].module_id != 0) {
		
			$("#product" + data[i].product.id +" .item-type-module #module" + data[i].module_id).append("<li class='item-type-story has-list'><i class='list-toggle icon'></i><div class='tree-item-wrapper'><span class='text-muted'> 需求#" + data[i].id + "</span><a href='../product/story_view_"+data[i].product.id +"_"+data[i].id+"_"+data[i].branch_id+"'> "+data[i].title+"</a><span class='label label-task-count label-badge'> "+data[i].id+"</span><div class='tree-actions'><a data-toggle='tooltip' href='../project/task_batchCreate_${projectId}_"+ data[i].id+"' class='tree-action' data-type='add' title='' data-original-title='批量分解'><i class='icon icon-sitemap'></i></a></div></div><ul id='story"+data[i].id+"'></ul></li>");
		
		} else if(mark == 1){
			
 			$("#product" + data[i].product.id +" .item-type-module #module" + data[i].module_id).append("<li class='item-type-story has-list'><i class='list-toggle icon'></i><div class='tree-item-wrapper'><span class='text-muted'> 需求#" + data[i].id + "</span><a href='../product/story_view_"+data[i].product.id +"_"+data[i].id+"_"+data[i].branch_id+"'> "+data[i].title+"</a><span class='label label-task-count label-badge'> "+data[i].id+"</span><div class='tree-actions'><a data-toggle='tooltip' href='../project/task_batchCreate_${projectId}_"+ data[i].id+"' class='tree-action' data-type='add' title='' data-original-title='批量分解'><i class='icon icon-sitemap'></i></a></div></div><ul id='story"+data[i].id+"'></ul></li>");
 			
		} else if(mark == 0){
			$("#product" + data[i].product.id).append("<li class='item-type-module has-list open in' id='moduleli"+data[i].module_id+"'><i class='list-toggle icon'></i><div class='tree-item-wrapper tree-toggle'><span class='tree-toggle'><i class='icon icon-bookmark-empty text-muted'></i> /</span></div><ul id='module0'></ul></li>");
 			$("#product" + data[i].product.id +" .item-type-module #module" + data[i].module_id).append("<li class='item-type-story has-list'><i class='list-toggle icon'></i><div class='tree-item-wrapper'><span class='text-muted'> 需求#" + data[i].id + "</span><a href='../product/story_view_"+data[i].product.id +"_"+data[i].id+"_"+data[i].branch_id+"'> "+data[i].title+"</a><span class='label label-task-count label-badge'> "+data[i].id+"</span><div class='tree-actions'><a data-toggle='tooltip' href='../project/task_batchCreate_${projectId}_"+ data[i].id+"' class='tree-action' data-type='add' title='' data-original-title='批量分解'><i class='icon icon-sitemap'></i></a></div></div><ul id='story"+data[i].id+"'></ul></li>");
			mark = 1;
		}
	}
}
//获得任务数据
function loadTask(projectId) {
	$.ajax({
		type: "get",
		url: "../getTaskForProject/" + projectId,
		async: false,
		success: function(data) {
			if(!$.isEmptyObject(data)) {
				viewTask(data);
			}
		}
	})
}
//显示任务
function viewTask(data) {
	var taskli;
	var spant; 
	var hid;
	var hre;
	for (var i = 0; i < data.length; i++) {
		
		//span
		spant = "<span class='task-pri pri${task.pri}'><c:if test='" + data[i].pri + " != 0'>" + data[i].pri + "</c:if></span><span class='text-muted'>" + data[i].id + " </span><a href='${ctxpj}/task_view_"+ data[i].id +"_"+ data[i].project.id +"'>"+ data[i].name +"</a><span class='task-assignto'><i class='icon icon-user text-muted'></i>"+ data[i].assignedTo +"</span>";
		
		//task消耗
		hid = "<div class='status-"+data[i].status+"'>"+ data[i].ch_status +"</div><div>预计 " + data[i].estimate + " 消耗 " + data[i].consumed + " 剩余 "+data[i].remain+"</div>";
		//task指派等链接

		hre = $("#hrehtml").html();
		console.log(hre);
		//taskli
		taskli = "<li class='item-type-task'><div class='tree-item-wrapper'>"+ spant +"<div class='task-info clearfix'>" + hid + "" + hre + "</div></div></li>";
		$("#story" + data[i].story_id).append(taskli)
	}
}
</script>
</body>
</html>