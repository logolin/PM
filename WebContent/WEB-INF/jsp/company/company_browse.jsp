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
<title>组织视图首页::部门结构</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer with-side with-transition" style="min-height: 494px;">
			<div class="side" id="treebox" >
		  		<a class="side-handle" onclick="showTree()" data-id="productTree" style="">
		  		<i id="myIcon" class="icon-caret-left"></i></a>
		  		<div class="side-body">
		    		<div class="panel panel-sm">
		    			<div class="panel-heading nobr"><i class="icon-building"></i> <strong>部门结构</strong></div>
		      			<div class="panel-body">
		      				<ul class="tree-lines tree" id="deptTree" data-animate="true" data-ride="tree">
	          				</ul>
		        			<div class="text-right">
		        				<a href="javascript:;" data-toggle="showModuleModal">维护部门结构</a>
		        			</div>
		      			</div>
		    		</div>
		  		</div>
			</div>
		<div class="main">
			<form method="post" id="userForm" action="./user_batchEdit_0">
				<table class="table table-condensed table-striped" data-custom-menu='true' data-checkable='true' data-checkbox-name="task" id="myTable">
					<thead>
						<tr class="colhead text-center">
							<th <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
					      	<th <c:if test="${orderBy == 'realname'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>真实姓名</th>
					      	<th <c:if test="${orderBy == 'account'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>用户名</th>
					      	<th <c:if test="${orderBy == 'role'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>职位</th>
					      	<th <c:if test="${orderBy == 'email'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>邮箱</th>
					      	<th <c:if test="${orderBy == 'gender'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>性别</th>
					      	<th <c:if test="${orderBy == 'phone'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>电话</th>
					      	<th <c:if test="${orderBy == 'qq'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>QQ</th>
					      	<th <c:if test="${orderBy == 'hiredate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>入职日期</th>
					      	<th <c:if test="${orderBy == 'last'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>最后登录</th>
					      	<th <c:if test="${orderBy == 'visits'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>访问次数</th>
					      	<th class="w-id" data-sort="false">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${users.content}" var="user">
							<tr class="text-center slectable-item active" data-id="${user.id}">
								<td><fmt:formatNumber value="${user.id}" minIntegerDigits="3"></fmt:formatNumber></td>
								<td>
									<shiro:hasPermission name="user:todo">
										<a href="./user_profile_${user.account}">${user.realname}</a>
									</shiro:hasPermission>
									<shiro:lacksPermission name="user:todo">${user.realname}</shiro:lacksPermission>
									</td>
								<td>${user.account}</td>
								<td>
									<c:if test="${user.role == 'dev'}">研发</c:if>
									<c:if test="${user.role == 'qa'}">测试</c:if>
									<c:if test="${user.role == 'pm'}">项目经理</c:if>
									<c:if test="${user.role == 'po'}">产品经理</c:if>
									<c:if test="${user.role == 'td'}">研发主管</c:if>
									<c:if test="${user.role == 'pd'}">产品主管</c:if>
									<c:if test="${user.role == 'qd'}">测试主管</c:if>
									<c:if test="${user.role == 'top'}">高层管理</c:if>
									<c:if test="${user.role == 'others'}">其他</c:if>
								</td>
								<td>${user.email}</td>
								<td><c:if test="${user.gender == 'm'}">男</c:if><c:if test="${user.gender == 'f'}">女</c:if></td>
								<td>${user.phone}</td>
								<td>${user.qq}</td>
								<td>${user.hiredate}</td>
								<td><fmt:formatDate value="${user.last}" pattern="yyyy-MM-dd" /></td>
								<td>${user.visits}</td>
								<td class="text-left">
									<shiro:hasPermission name="user:edit">
						        		<a href="./user_edit_${user.id}_company" class="btn-icon " title="编辑用户"><i class="icon-common-edit icon-pencil"></i></a>
						        	</shiro:hasPermission>
						        	<shiro:hasPermission name="user:delete">
						        		<button type="button" id="deleteUser" class="btn-icon iframe" title="删除用户" data-show-header="false" data-width="800px" data-iframe="./user_delete_${user.id}" data-toggle="modal"><i class="icon-remove"></i></button>
						      		</shiro:hasPermission>
						      	</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="12">
								<shiro:hasPermission name="user:batchEdit">
									<div class="table-actions clearfix">
										<div class="checkbox btn">
	                        				<label><input type="checkbox" class="check-all check-btn"> 选择</label>
	                        			</div>
	                        			<input id="userIds" name="userIds" type="hidden"/>
	                        			<button type="submit" id="submit" class="btn btn-default" data-loading="稍候...">编辑</button>
									</div>
								</shiro:hasPermission>
								<div style="float:right; clear:none;" class="pager form-inline">
				        				共 <strong>${users.totalElements}</strong> 条记录，
				        				<div class="dropdown dropup">
				        					<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
				        					<ul class="dropdown-menu">
					        					<c:forEach begin="5" end="50" step="5" var="i">
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
					        					</c:forEach>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
					        				</ul>
					        			</div> 
					        			<strong>${users.number + 1}/${users.totalPages}</strong>
					        			<c:choose>
					        				<c:when test="${users.isFirst()}">
					        					<i class="icon-step-backward" title="首页"></i>
					        					<i class="icon-play icon-rotate-180" title="上一页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
					        					<a href="./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
											</c:otherwise>
						        			</c:choose>
						        			<c:choose>
					        				<c:when test="${users.isLast()}">
					        					<i class="icon-play" title="下一页"></i>
					        					<i class="icon-step-forward" title="末页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
					        					<a href="./company_browse_${deptId}_${type}_${orderBy}_${ascOrDesc}_${recPerPage}_${users.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
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
<script type="text/javascript">
$(function(){
	loadDept();
	var userIds;
	//判断是否选中用户
	$("#userForm").submit(function(){
		 if($('#userIds').val() === '') {
			 bootbox.alert("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  请选择您要编辑的用户！</h4>");
			 return false;
		 }
	});
	//表格排序
	$('#myTable').datatable({
		storage: false,
		sortable: true, 
		colHover: false,
		checksChanged: function(event) {
			userIds = event.checks.checks;
			$("#userIds").val(userIds);
		},
		sort: function(event) {
			var s = ['id','realname','account','role','email','gender','phone','qq','hiredate','last','visits'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./company_browse_${deptId}_${type}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${recPerPage}_${page}";
			}
		}
	});
});
	
//获得dept树
function loadDept() {
	$.get("../getDept", function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree4Nav(data);
		}		
	})
}
function iterateTree4Nav(data) {
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
		no_list = "<li><a href='./company_browse_" + data[i].id + "'>" + data[i].name + "</a></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./company_browse_" + data[i].id + "'>" + data[i].name + "</a><ul id='dept" + data[i].id +"'></ul></li>";
		childrenLeng = data[i].children.length;
		if (data[i].parent == 0) {
			appendList(childrenLeng,"#deptTree", no_list,has_list,append);
		} else {
			appendList(childrenLeng,"#dept" + data[i].parent,no_list,has_list,append);
		}
		iterateTree4Nav(data[i].children);
	}
}
function appendList(childrenLeng,idStr,no_list,has_list,func) {
	childrenLeng == 0 ? func(idStr,no_list) : func(idStr,has_list);
}

//删除用户
function deleteUser(userId) {
	location.href="./delete_user_" + userId;
}
//侧边滑动栏
function showTree() {
	$('#myIcon').toggleClass('icon-caret-left');
	$('.outer').toggleClass('hide-side');
	$('#myIcon').toggleClass('icon-caret-right');
}
</script>
</body>
</html>