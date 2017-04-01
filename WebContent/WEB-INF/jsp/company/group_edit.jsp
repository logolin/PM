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
</head>
<body class="m-group-edit body-modal">
<div id="titlebar">
	<div class="heading">
		<c:if test="${status == 'edit'}">
		<span class="prefix" title="GROUP"><i class="icon-group"></i> <strong>${group.id}</strong></span>
	    <strong class="heading-title">${group.name}</strong>
		<small class="text-muted"> 编辑分组</small>
	    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
		</c:if>
		<c:if test="${status == 'create'}">
		<strong><small><i class="icon-plus"></i></small> 新增分组</strong>
		</c:if>
		<c:if test="${status == 'copy'}">
		<strong>复制分组</strong><small class="text-muted"> <i class="icon-copy"></i></small>
		</c:if>
	</div>
</div>
<div class="wrap">
	<div class="outer">
		<div class="container mw-500px">
			<form name="group" method="post" onsubmit="return check()" id="groupForm" target="_parent">
				<table align="center" class="table table-form"> 
					<tbody>
						<tr>
							<th class="w-100px">分组名称</th>
							<td><div class="required required-wrapper"></div>
								<input type="text" name="name" id="name" value="${group.name}" class="form-control">
							</td>
						</tr>
						<tr>
							<th>分组描述</th>
							<td>
								<textarea name="descript" id="descript" rows="5" class="form-control">${group.descript}</textarea>
								<c:if test="${group == null}">
								<input type="text" name="role" class="hide">
								<input type="text" name="acl" class="hide">
								</c:if>
							</td>
						</tr>
						<c:if test="${status == 'copy'}">
						<tr>
					    	<th>选项</th>
					    	<td>
					    		<label class="checkbox-inline"><input type="checkbox" name="options" value="copyPriv" id="optionscopyPriv"> 复制权限</label>
					    		<label class="checkbox-inline"><input type="checkbox" name="options" value="copyUser" id="optionscopyUser"> 复制用户</label>
					    	</td>
					    </tr>
					    </c:if>
						<tr><th></th><td> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td></tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">
function check() {
	if(checkName() == false) {
		return false;
	}
	
	document.getElementById("groupForm").submit();
}


function checkName() {
	var name = $("#name").val();
	if(!name) {
		alert("『用户名』不能为空！");
		return false;
	}
	$.get("../getGroup", function(data){
		for(var i = 0; i < data.length; i++) {
			if(data[i].name == name) {
				alert("【分组名】已经有『"+ name +"』这条记录了。不能重复名字");
				return false;
			}
		}
	})
}

/*
function check() {
	if(checkName() == false) {
		return false;
	}
	document.getElementById("groupForm").submit();
}
function checkName() {
	var name = $("#name").val();
	var status = ${status};
	if(name != "kk") {
		alert("『分组名』不能为空！");
		return false;
	}
// 	if(status == "copy" || status == "create") {
		$.get("../getGroup", function(data){
			for(var i = 0; i < data.length; i++) {
				if(data[i].name == name) {
					alert("【分组名】已经有『"+ name +"』这条记录了。不能重复名字");
					return false;
				}
			}
		})
//   	}
	
}
*/
</script>
</body>
</html>