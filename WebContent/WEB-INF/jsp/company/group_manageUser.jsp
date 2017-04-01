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
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
<style>.group-item {display:block; width:100px; float:left}
.outer .table th {vertical-align: top;}
.col-side {width: 192px;}
</style>
<title>组织视图::编辑用户</title>
</head>
<body class="m-group-managemember body-modal">
	<div class="outer">
	<div id="titlebar">
		<div class="heading">
		    <span class="prefix" title="GROUP"><i class="icon-group"></i> <strong>${group.id}</strong></span>
		    <strong>${group.name}</strong>
		    <small class="text-muted"> 成员维护 <i class="icon-cog"></i></small>
		</div>
	</div>
	<div class="row-table row-table-swap">
		<div class="col-side">
	    	<div class="side-body">
		      	<div class="panel panel-sm">
			        <div class="panel-heading nobr"><i class="icon-building"></i> <strong>部门结构</strong></div>
			        <div class="panel-body">
			        	<ul class="tree tree-lines" id="deptTree" data-ride="tree">
						</ul>
					</div>
		      	</div>
			</div>
		</div>
		<div class="col-main">
	    	<form class="form-condensed pdb-20" method="post" target="_parent">
	   			<table align="center" class="table table-form"> 
	            	<tbody>
	            		<c:if test="${userInList.size() > 0}">
	            		<tr>
	          				<th class="w-100px">组内用户
								<input type="checkbox" name="allchecker" checked="checked" onclick="selectAll(this, 'in')"> 
							</th>
	          				<td id="group" class="f-14px pv-10px">
	          					<c:forEach items="${userInList}" var="user">
	          						<div class="group-item">
			          					<label class="checkbox-inline">
			          						<input type="checkbox" name="accountIns"  value="${user.account}" checked="checked" class="userIds"> ${user.realname}
			          					</label>
	          						</div>
	          					</c:forEach>
	                      	</td>
	        			</tr>
	        			</c:if>
						<tr>
				        	<th class="w-100px">组外用户
				        		<input type="checkbox" name="allchecker" onclick="selectAll(this, 'out')"> 
				        	</th>
				        	<td id="other" class="f-14px pv-10px">
				        		<c:if test="${userOutList.size() > 0}">
				        		<c:forEach items="${userOutList}" var="user">
					        		<div class="group-item">
					        			<label class="checkbox-inline">
					        				<input type="checkbox" name="accountOuts" value="${user.account}" class="userOuts"> ${user.realname}
					        			</label>
					        		</div>
				        		</c:forEach>
				        		</c:if>
				            </td>
						</tr>
						<tr>
				            <th></th>
				            <td class="text-center">
				            	<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
				            	<input type="hidden" name="foo" id="foo" value="">
				            </td>
				        </tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</div>  
<script type="text/javascript">
$(function(){
	loadDept();
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
		no_list = "<li><a href='./group_managemember_${groupId}_" + data[i].id + "'>" + data[i].name + "</a></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./group_managemember_${groupId}_" + data[i].id + "'>" + data[i].name + "</a><ul id='dept" + data[i].id +"'></ul></li>";
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

function selectAll(obj, mark) {
	if(mark == "in") {
		$(".userIds").prop("checked",obj.checked);
	}
	if(mark == "out") {
		$(".userOuts").prop("checked",obj.checked);
	}
}

</script>
</body>
</html>