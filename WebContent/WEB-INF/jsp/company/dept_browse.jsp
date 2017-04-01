<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
<style>.table.table-form {width: auto;}
.table-form > tbody > tr > td .form-control + .form-control {margin-top: 5px;}

.tree li.has-list > .tree-actions > .tree-action[data-type="delete"] {display: none}
.tree-toggle {cursor: pointer;}
.tree-actions, .tree li.hover > .tree-actions {opacity: 1}

#addChildModal form > .form-control {margin-bottom: 8px;}
#addChildModal .modal-dialog {max-width: 360px;}
</style>
<title>维护部门结构::力德科技</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
<div id="wrap">
	<div class="outer" style="min-height:406px;">
		<div id="titlebar">
			<div class="heading" style="padding-right: 231px;"><i class="icon-group"></i> 部门结构</div>
		</div>
		<div class="row">
			<div class="col-sm-4">
		    	<div class="panel">
					<div class="panel-heading"><i class="icon-sitemap"></i> <strong>维护部门结构::力德科技</strong></div>
		      		<div class="panel-body">
			        	<div class="container">
			          		<ul class="tree-lines tree" id="deptTree" data-ride="tree">
			          		</ul>
		        		</div>
		      		</div>
				</div>
			</div>
			<div class="col-sm-8">
		    	<div class="panel panel-sm">
		      		<div class="panel-heading">
		        		<i class="icon-sitemap"></i> <strong>下级部门</strong>
		      		</div>
		      		<div class="panel-body">
				        <form method="post" class="form-condensed">
				        	<table class="table table-form">
				            	<tbody>
				            		<tr>
						            	<td>
						            		<c:choose>
						            			<c:when test="${deptId != 0}">
						            				<nobr id="dept0"><a href="./dept_browse_${deptId}">${dept.name}</a><i class="icon-angle-right"></i></nobr>
						            			</c:when>
						            			<c:otherwise><nobr><a href="./dept_browse_0">力德科技</a><i class="icon-angle-right"></i></nobr></c:otherwise>
						            		</c:choose>
						            	</td>
						        		<td class="w-300px"> 
							            	<c:forEach items="${deptList}" var="dept" varStatus="i">
								            	<input type="hidden" name="deptIds" value="${dept.id}">
								            	<input type="text" name="deptNames" value="${dept.name}" class="form-control">
							            	</c:forEach>
							            	<c:forEach begin="0" end="9" var="i">
							            		<input type="hidden" name="depts[${i}].position">
							            		<input type="hidden" name="depts[${i}].function">
							            		<input type="hidden" name="depts[${i}].manager">
							            		<input type="text" name="depts[${i}].name" id="depts${i}" value="" class="form-control">
							            	</c:forEach>
						              </td>
						              <td></td>
				            		</tr>
				            		<tr>
				              			<td></td>
				              			<td>
							            	<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
							            	<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
							            	<input type="hidden" name="maxOrder" id="maxOrder" value="20">
							                <input type="hidden" value="0" name="parentDeptID">
							       		</td>
				            		</tr>
				            	</tbody>
				            </table>
				        </form>
		      		</div>
		    	</div>
			</div>
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
		
// 		<span class='dept-manager text-muted'><i class='icon icon-user'></i> ${userMap["+ data[i].manager +"]}</span>
		no_list = "<li><span class='dept-name'><a href='./dept_browse_" + data[i].id + "'>"+ data[i].name +" </a><span class='dept-manager text-muted'><i class='icon icon-user'></i>${userMap["+data[i].manager+"]}</span></span><div class='tree-actions'><a class='sort-handler tree-action' data-toggle='tooltip' href='javascript:;' data-type='sort' title='' data-original-title='拖动排序'><i class='icon icon-move'></i></a><a type='button' data-iframe='./dept_edit_"+ data[i].id +"' data-toggle='modal' data-show-header='false' data-width='800px' class='tree-action iframe' title='编辑部门'>编辑</a><a data-toggle='tooltip' href='javascript:deleteDept("+ data[i].id +");' class='tree-action' data-type='delete' title='删除部门'>删除</a></div></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><span class='dept-name'><a href='./dept_browse_" + data[i].id + "'>"+ data[i].name +" </a><span class='dept-manager text-muted'><i class='icon icon-user'></i> ${userMap["+data[i].manager+"]}</span></span><div class='tree-actions'><a class='sort-handler tree-action' data-toggle='tooltip' href='javascript:;' data-type='sort' title='' data-original-title='拖动排序'><i class='icon icon-move'></i></a><a type='button' data-iframe='./dept_edit_"+ data[i].id +"' data-toggle='modal' data-show-header='false' data-width='800px' class='tree-action iframe' title='编辑部门'>编辑</a><a data-toggle='tooltip' href='javascript:deleteDept("+ data[i].id +");'  class='tree-action' data-type='delete' title='删除部门'>删除</a></div><ul id='dept" + data[i].id +"'></ul></li>";
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

//删除部门
function deleteDept(deptId) {
	$.get("../getDeptUser_" + deptId, function(data) {
		if(data > 0) {
			alert("该部门有职员，不能删除！");
		} else {
			if(confirm("您确定删除该部门吗？")) {
				location.href="./dept_delete_" + deptId;
			}
		}
		
	})
	
}
</script>
</body>
</html>