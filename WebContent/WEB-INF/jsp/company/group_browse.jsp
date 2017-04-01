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
<title>组织视图::浏览分组</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
<div id="wrap">
	<div class="outer" style="min-height:406px;">
		<div id="titlebar">
			<div class="heading" style="padding-right: 231px;"><i class="icon-group"></i> 浏览分组</div>
			<div class="actions">
				<button type="button" class="btn iframe" data-width="550" data-iframe="./group_create_0" data-show-header="false" data-toggle="modal"><i class="icon-group-create icon-plus"></i> 新增分组</button>
				<a href="" class="btn btn-primary iframe">按模块分配权限</a>
			</div>
		</div>
		<table align="center" class="table table-striped table-condensed" id="groupList">
			<thead>
				<tr class="tablesorter-headerRow">
					<th>编号</th>
					<th>分组名称</th>
					<th>分组描述</th>
					<th class="w-p60">用户列表</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${map}" var="map">
					<tr>
						<td class="text-left">${map.key.id}</td>
						<td class="text-left">${map.key.name}</td>
						<td class="text-left">${map.key.descript}</td>
						<td class="text-left">
							<c:forEach items="${map.value}" var="user">
								${user.realname}
							</c:forEach>
						</td>
						<td class="text-center">
            				<a href="./group_manageView_${map.key.id}" class="btn-icon " title="视图维护"><i class="icon-group-manageView icon-eye-open"></i></a>      
            				<a href="./group_managepriv_byGroup_${map.key.id}_all" class="btn-icon " title="权限维护"><i class="icon-group-managepriv icon-lock"></i></a>           
            				<button type="button" class="btn-icon iframe" title="成员维护" data-width="800" data-iframe="./group_managemember_${map.key.id}_0" data-show-header="false" data-toggle="modal"><i class="icon-group-managemember icon-group"></i></button> 
            				<button type="button" class="btn-icon iframe" title="编辑分组" data-iframe="./group_edit_${map.key.id}" data-show-header="false" data-toggle="modal"><i class="icon-common-edit icon-pencil"></i></button> 
            				<button type="button" class="btn-icon iframe" title="复制分组" data-width="550" data-iframe="./group_copy_${map.key.id}" data-show-header="false" data-toggle="modal"><i class="icon-common-copy icon-copy"></i></button>
            				<a title="删除分组" onclick="deleteGroup(${map.key.id})" class="btn-icon"><i class="icon-remove"></i></a>
    					</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
<script>
function deleteGroup(groupId) {
	if(confirm("您确定删除该用户分组吗？")){
		window.location.href="./delete_group_" + groupId;
	}
}
</script>
</body>
</html>