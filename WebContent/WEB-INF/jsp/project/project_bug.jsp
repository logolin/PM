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
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<title>${project.name}::Bug列表</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div>
				<div id="featurebar">
					<ul class="nav">
				    	<li id="calendarTab" class="active"><a href="">Bug列表</a>
						</li>
					</ul>
					<div class="actions">
					    <a href="" class="btn export iframe"><i class="icon-common-export icon-download-alt"></i> 导出数据</a>
					    <a href="" class="btn "><i class="icon-bug-create icon-plus"></i> 提Bug</a>
					</div>
				</div>
			</div>
			<form name="bugList" id="bugList" method="post">
			<table class="table table-condensed table-striped table-hover tablesorter table-fixed " id="myTable">
				<thead>
			    	<tr>
			        	<th class="w-id" <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
			        	<th class="w-severity" <c:if test="${orderBy == 'severity'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>级别</th>
			        	<th class="w-pri" <c:if test="${orderBy == 'pri'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>P</th>
			        	<th <c:if test="${orderBy == 'title'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>Bug标题</th>
			        	<th class="w-user" <c:if test="${orderBy == 'openedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建</th>
			        	<th class="w-user" <c:if test="${orderBy == 'assignedTo'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派</th>
			        	<th class="w-user" <c:if test="${orderBy == 'resolvedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>解决者</th>
			        	<th class="w-resolution" <c:if test="${orderBy == 'resolution'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>方案</th>
			        	<th class="w-140px {sorter:false}" data-sort="false">操作</th>
			        </tr>
			    </thead>
				<tbody>
				<c:forEach items="${bugPage.content}" var="bug">
					<tr class="slectable-item text-center">
				      	<td><input type="checkbox" name="bugs" value="${bug.id}">${bug.id}</td>
				      	<td><span class="severity${bug.severity}">${bug.severity}</span></td>
				      	<td><span class="pri${bug.pri}">${bug.pri}</span></td>
				      	<td><a href="#">${bug.title}</a></td>
				      	<td>${bug.openedBy}</td>
				      	<td>${bug.assignedTo}</td>
				      	<td>${bug.resolvedBy}</td>
				      	<td>${bug.resolution}</td>
					  	<td class="text-right">
					  		<a href="" class="btn-icon iframe" title="确认"><i class="icon-bug-confirmBug icon-search"></i></a>
          					<a href="" class="btn-icon iframe" title="指派"><i class="icon-bug-assignTo icon-hand-right"></i></a>
          					<a href="" class="btn-icon iframe" title="解决"><i class="icon-bug-resolve icon-ok-sign"></i></a>
          					<button type="button" class="disabled btn-icon iframe"><i class="icon-bug-close disabled icon-off" title="关闭"></i></button>
          					<a href="" class="btn-icon " title="编辑"><i class="icon-common-edit icon-pencil"></i></a>
          					<a href="" class="btn-icon " title="create"><i class="icon-common-copy icon-copy"></i></a>
          				</td>
					</tr>
				</c:forEach>
				</tbody>
				<c:if test="${bugPage.content.size() > 0}">
				<tfoot>
					<tr>
						<td colspan="9">
							<div class="table-actions clearfix">
				          		<div class="checkbox btn">
				          			<label><input type="checkbox" data-scope="" class="rows-selector" onclick="selectAll(this)"> 选择</label>
				          		</div>
				          		<div class="dropup btn-group">
				          			<button class="btn dropdown-toggle" type="button" data-toggle="dropdown">指派给<span class="caret"></span></button>
				          			<ul class="dropdown-menu assign-menu" role="menu">
				          				<c:forEach items="${teamList}" var="team">
				          					<li class="option" data-key="demo"><a href="#">
				          					${team.id.user.realname}</a></li>
				          				</c:forEach>
									</ul>
								</div>
					         </div>
					          	<div style="float:right; clear:none;" class="pager form-inline">
					          		共 <strong>${bugPage.totalElements}</strong> 条记录，
					          		<div class="dropdown dropup">
					          			<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="10">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
					          			<ul class="dropdown-menu">
				        					<c:forEach begin="5" end="50" step="5" var="i">
				        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
				        					</c:forEach>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_bug_${projectId}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
				        				</ul>
					          		</div>
					          		<strong>${bugPage.number + 1}/${bugPage.totalPages}</strong> 
					          		<c:choose>
				        				<c:when test="${bugPage.isFirst()}">
				        					<i class="icon-step-backward" title="首页"></i>
				        					<i class="icon-play icon-rotate-180" title="上一页"></i>
				        				</c:when>
				        				<c:otherwise>
											<a href="./project_bug_${projectId}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
				        					<a href="./project_bug_${projectId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
										</c:otherwise>
				        			</c:choose>
				        			<c:choose>
				        				<c:when test="${bugPage.isLast()}">
				        					<i class="icon-play" title="下一页"></i>
				        					<i class="icon-step-forward" title="末页"></i>
				        				</c:when>
				        				<c:otherwise>
											<a href="./project_bug_${projectId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
				        					<a href="./project_bug_${projectId}_${orderBy}_${ascOrDesc}_${recPerPage}_${bugPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
										</c:otherwise>
				        			</c:choose>
					          	</div>
						</td>
					</tr>
				</tfoot>
				</c:if>
			</table>
			</form>
		</div>
	</div>
<script>
$(document).ready(function() {
	$('table.datatable').datatable({
		sortable: true,
		storage: true,
		colHover: false,
		sortable: true,
	});
	$('#myTable').datatable({
		storage: false,
		sortable: true, 
		colHover: false,
		sort: function(event) {
			var s = ['id','severity', 'pri', 'title', 'openedBy', 'assignedTo', 'resolvedBy', 'resolution'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./project_bug_${projectId}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${recPerPage}_${page}";
			}
		}
	});
	fixedTfootAction('#productplanForm');
});

function selectAll(obj) {
	$('input[name="bugs"]').prop("checked",obj.checked);
};

// function submitLi(assignedTo) {
// 	bugList.action="./bug_batchAssign_admin_${project.id}";
// 	document.getElementById("bugList").action="${ctxpj}/bug_batchAssign_"+assignedTo+"_${project.id}";
// 	document.getElementById('bugList').submit();
// 	windows.location="${ctxpj}/bug_batchAssign_"+assignedTo+"_${project.id}";
// }
</script>
</body>
</html>