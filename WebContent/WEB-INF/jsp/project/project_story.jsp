<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>

<title>需求</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer with-side with-transition" style="min-height: 494px;">
			<div id="featurebar">
				<ul class="nav">
					<li id="closedstoryTab">需求列表</li>
				</ul>
				<div class="actions">
					<div class="btn-group">
				    	<div class="btn-group">
				        	<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				          		<i class="icon-download-alt"></i> 导出数据 <span class="caret"></span>
				        	</button>
				        	<ul class="dropdown-menu" id="exportActionMenu">
				        		<shiro:hasPermission name="story:export">
						        	<li><a href="" class="export">导出数据</a></li>  
						        </shiro:hasPermission>   
						        <li><a href="#" class="disabled">导出模板</a></li>
					        </ul>
				    	</div>
				    	<shiro:hasPermission name="story:create">
					      	<c:if test="${idProduct != 0}">
					        	<a href="${ctxpj}/story_create_${idProduct}_${projectId}" class="btn create-story-btn"><i class="icon-story-create icon-plus"></i> 新增需求</a>
					        </c:if>
				        </shiro:hasPermission>
				        <shiro:hasPermission name="story:linkStory">
				        	<a href="./project_linkStory_${projectId}" class="btn "><i class="icon-project-linkStory icon-link"></i> 关联需求</a>
						</shiro:hasPermission>
					</div>
				</div>
			  <div id="querybox" class=""></div>
			</div>
			<div class="side" id="treebox" >
		  		<a class="side-handle" onclick="showTree()" data-id="productTree" style="">
		  		<i id="myIcon" class="icon-caret-left"></i></a>
		  		<div class="side-body">
		    		<div class="panel panel-sm">
		      			<div class="panel-heading nobr"><i class="icon-cube-alt"></i> <strong>${project.name}</strong></div>
		      			<div class="panel-body">
		      				<ul class="tree-lines tree" id="modulesTree" data-animate="true" data-ride="tree">
	         					<li id="branchModules" style="display:none"></li>
	         					<c:forEach items="${productList}" var="product" varStatus="i">
	         						<li class="has-list open in">
	         							<a href='./project_story_${project.id}_byProduct_${product.id}'>${product.name}</a>
	         							<ul id="product${product.id}"></ul>
	         						</li>
	         					</c:forEach>
	          				</ul>
		      			</div>
		    		</div>
		  		</div>
			</div>
			<div class="main">
		  	<form method="post" id="projectStoryForm" action="./story_batchEdit_${project.id}">
		    	<table class="table table-condensed table-striped table-hover tablesorter table-fixed " id="myTable">
		      		<thead>
						<tr>
							<th class="w-id" <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
							<th class="w-pri" <c:if test="${orderBy == 'pri'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>P</th>
					        <th class="w-p30" <c:if test="${orderBy == 'title'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>> 需求名称</th>
					        <th <c:if test="${orderBy == 'openedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建</th>
					        <th <c:if test="${orderBy == 'assignedTo'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派</th>
					        <th class="w-hour" <c:if test="${orderBy == 'estimate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>预计</th>
					        <th <c:if test="${orderBy == 'status'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>状态</th>
					        <th <c:if test="${orderBy == 'stage'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>阶段</th>
					        <th data-sort="false" class='w-70px'>任务数</th>
					        <th data-sort="false">操作</th>
						</tr>
		      		</thead>
			      	<tbody>
				      	<c:set var="estimatesum" value="0"/>
				      	<!-- 设置权限，不用每行都重新查权限 -->
					    <shiro:hasPermission name="story:delete">
							<c:set var="delete" value="true" />
					 	</shiro:hasPermission>
					 	<shiro:hasPermission name="story:delete">
							<c:set var="delete" value="true" />
					 	</shiro:hasPermission>
					  	<c:forEach items="${storyPage.content}" var="story">
							<tr class="text-center" data-id="${story.id}">
								<td class="text-left">
									<a href="${ctx}/product/story_view_${project.id}_${story.id}_1">
									<fmt:formatNumber type="number" minIntegerDigits="3" value="${story.id}" /></a></td>
							    <td>
							      	<span class="pri${story.pri}">
							      	<c:choose><c:when test="${story.pri == 0}"></c:when>
							      	<c:otherwise>${story.pri}</c:otherwise>
							      	</c:choose></span>
								</>
								<td class="text-left" title="${story.title}">        
				                	<a href="${ctx}/product/story_view_${story.product.id}_${story.id}">${story.title}</a></td>
								<td>${story.openedBy}</td>
								<td>${story.assignedTo}</td>
							  	<td><fmt:formatNumber value="${story.estimate}" type="number" /></td>
							   	<td>
							   		<c:if test="${story.status == 'active'}">激活</c:if>
							   		<c:if test="${story.status == 'draft'}">激活</c:if>
							   		<c:if test="${story.status == 'closed'}">已关闭</c:if>
							   		<c:if test="${story.status == 'changed'}">已变更</c:if>
							   	</td>
							  	<td>
							  		<c:if test="${story.stage == 'wait'}">未开始</c:if>
							  		<c:if test="${story.stage == 'planned'}">已计划</c:if>
							   		<c:if test="${story.stage == 'projected'}">已立项</c:if>
							   		<c:if test="${story.stage == 'developing'}">研发中</c:if>
							   		<c:if test="${story.stage == 'developed'}">研发完毕</c:if>
							   		<c:if test="${story.stage == 'testing'}">测试中</c:if>
							   		<c:if test="${story.stage == 'tested'}">测试完毕</c:if>
							   		<c:if test="${story.stage == 'verified'}">已验收</c:if>
							   		<c:if test="${story.stage == 'released'}">已发布</c:if>
							  	</td>
							  	<td>
							  		<c:choose>
							  			<c:when test="${story.taskSum == 0}">0</c:when>
							  			<c:otherwise><a type="button" data-icon="icon icon-file-text" data-iframe="${ctxpj}/story_taskSum_${projectId}_${story.id}"  data-toggle="modal">${story.taskSum}</a></c:otherwise>
							  		</c:choose>
							  	</td>
							  	<td class="text-center">
							  		<shiro:hasPermission name="task:create">
										<a href="${ctxpj}/task_create_${project.id}_${story.id}" class="btn-icon" title="分解任务"  data-title="分解任务">
											<i class="icon-task-create icon-list-ul"></i> 
										</a>
									</shiro:hasPermission>
									<shiro:hasPermission name="task:batchCreate">
										<a href="${ctxpj}/task_batchCreate_${project.id}_${story.id}" class="btn-icon" title="批量分解"><i class="icon-task-batchCreate icon-stack"></i></a>
									</shiro:hasPermission>
									<shiro:hasPermission name="testcase:create">
										<a href="#" class="btn-icon" title="建用例"><i class="icon-testcase-batchCreate icon-sitemap"></i> </a>
									</shiro:hasPermission>
									<shiro:hasPermission name="story:delete">
										<a href="#" class="btn-icon" title="移除需求" onclick="disassociation(${story.id})"><i class="icon-unlink"></i> </a>
							  		</shiro:hasPermission>
							  	</td>
							</tr>
							<script>
									$('#module0').addClass('active');
									$('#unclosedTab').addClass('active');
									function disassociation(storyId){
										if(confirm("您确定从该项目中移除该需求吗？")){
											location.href="${ctxpj}/projectstory_deleted_${project.id}_"+storyId;
										}
									}
							</script>
						<c:set var="estimatesum" value="${estimatesum = estimatesum + story.estimate}" />
				  	</c:forEach>
			      	</tbody>
			      	<tfoot>
				      	<tr>
							<td colspan="10" data-column="0">
								<div class="table-actions clearfix">
		                        	<div class="checkbox btn">
		                        		<input type="hidden" name="storyIds" id="storyIds"/>
		                        		<label><input type="checkbox" class="check-all check-btn"> 选择</label>
		                       		</div>
		                       		<div class="btn-group dropup">
		           						<button type="submit" class="btn btn-default">编辑</button>              
		           						<button type="button" class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
		           						<ul class="dropdown-menu">
		               						<li><a href="#" onclick="batchChange('close');">关闭</a></li>
											<li><a href="#" onclick="batchChange('delete');">移除需求</a></li>
										</ul>
		            				</div>
		                      		<div class="text">本页共 <strong>${storyPage.numberOfElements}</strong> 个需求，预计 <strong><fmt:formatNumber value="${estimatesum}" type="number" />
		                      		</strong> 个工时，用例覆盖率<strong>
		                      		<c:choose>
		                      			<c:when test="${storyPage.numberOfElements == 0}">0%</c:when>
		                      			<c:otherwise><fmt:formatNumber type="percent" value="${caseSum/storyPage.numberOfElements}" /></c:otherwise>
		                      		</c:choose></strong>。</div>
		       					</div>
								<div style="float:right; clear:none;" class="pager form-inline">
						        	共 <strong>${storyPage.totalElements}</strong> 条记录，
						        	<div class="dropdown dropup">
						        		<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
						        		<ul class="dropdown-menu">
							        		<c:forEach begin="5" end="50" step="5" var="i">
							        			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_${i}_1'>${i}</a></li>
							        		</c:forEach>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_100_1'>100</a></li>
							       			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_200_1'>200</a></li>
							       			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_500_1'>500</a></li>
							       			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_1000_1'>1000</a></li>
							       			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_2000_1'>2000</a></li>
							        	</ul>
							       	</div> 
							 		<strong>${storyPage.number + 1}/${storyPage.totalPages}</strong> &nbsp; 
							        	<c:choose>
							        		<c:when test="${storyPage.isFirst()}">
							        			<i class="icon-step-backward" title="首页"></i>
							        			<i class="icon-play icon-rotate-180" title="上一页"></i>
							        		</c:when>
							        		<c:otherwise>
												<a href="./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
							        			<a href="./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
											</c:otherwise>
								        </c:choose>
								        <c:choose>
							        		<c:when test="${storyPage.isLast()}">
							        			<i class="icon-play" title="下一页"></i>
							        			<i class="icon-step-forward" title="末页"></i>
							        		</c:when>
							        		<c:otherwise>
												<a href="./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
							        			<a href="./project_story_${projectId}_${orderBy}_${ascOrDesc}_${byProductOrModule}_${byPrOrMdId}_${recPerPage}_${storyPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
											</c:otherwise>
							        	</c:choose>
								</div>
							</td>
				      	</tr>
		      		</tfoot>
		    	</table>
		    </form>
		</div>
	</div>
<script>
var prod = 1;
var storyIds;
$(document).ready(function(){
	
	$('#myTable').datatable({
		storage: false,
		sortable: true,
		checkable: true,
		colHover: false,
		checksChanged: function(event) {
			storyIds = event.checks.checks;
			$("#storyIds").val(storyIds);
		},
		sort: function(event) {
			var s = ['id', 'pri', 'title', 'openedBy', 'assignedTo', 'estimate', 'status', 'stage'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./project_story_${projectId}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${byProductOrModule}_${byPrOrMdId}_${recPerPage}_${page}";
			}
		}
	});
	
	$("#projectStoryForm").submit(function(){
		 if($('#storyIds').val() == '') {
			 alert("请选择您要编辑的任务！");
			 return false;
		 }
	});
	
	loadProductModules("${project.id}");
});
function showTree() {
	$('#myIcon').toggleClass('icon-caret-left');
	$('.outer').toggleClass('hide-side');
	$('#myIcon').toggleClass('icon-caret-right');
}

function loadProductModules(projectId) {
	$.get("../ajaxGetModules/" + projectId +"/task",function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree4Nav(data);
		}		
	});
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
		no_list = "<li><a href='./project_story_" + ${project.id} + "_byModule_" + data[i].id + "'>" + data[i].name + "</a></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./project_story_" + ${project.id} + "_byModule_" + data[i].id + "'>" + data[i].name + "</a><ul id='module" + data[i].id +"'></ul></li>";
		childrenLeng = data[i].children.length;
		if (data[i].id == ${byPrOrMdId} && "${byProductOrModule}" === "byModule") {
			$(".with-close").append(data[i].name);
		} else if(data[i].root == ${byPrOrMdId} && "${byProductOrModule}" === "byProduct"){
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

//批量操作
function batchChange(fieldName) {
	console.log(storyIds);
	$.ajax({
		type:"post",
		url:"../project/story_batchChange_${project.id}",
		traditional:true,
		data:{"storyIds":storyIds,"fieldName":fieldName},
		beforeSend:function(){
			if (storyIds == undefined) {
				bootbox.alert("<h4>请选择您需要修改的需求！</h4>");
				return false;
			}
		},
		complete:function(){
			history.go(0);
		},
	})
}
</script>
</body>
</html>