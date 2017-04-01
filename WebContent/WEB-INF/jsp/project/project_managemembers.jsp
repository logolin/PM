<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>

<script type="text/javascript">
$(function(){
	$("select.chosen-select").chosen({
	    no_results_text: '没有找到',
	    search_contains: true,
	    allow_single_deselect: true,
	});
})
</script>

<title>团队管理::${project.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="featurebar">
			    <ul class="nav">
			    	<li id="calendarTab" class="active"><strong>团队管理</strong><i class="icon icon-angle-right text-muted"></i></li>
			    	<li>
			    		<select id="depttree" onchange="setDeptUsers(this.value)" class="form-control chosen" style="width:200px" data-placeholder="请选择部门">
			    			<option value="-1" <c:if test="${deptId == -1}">selected</c:if>></option>
			    			<option value="0" <c:if test="${deptId == 0}">selected</c:if>>/</option>
			    		</select>
			    	</li>
				</ul>
				<div class="actions">
					<button class="btn" id="itBtn"><i class="icon-copy"></i> 复制团队</button>
				</div>
			</div>
			<div class="main">
				<form class="form-condensed" method="post">
					<table class="table table-form">
						<thead>
							<tr class="text-center">
								<th style="width:39%">用户${userAccount}</th>
								<th style="width:39%">角色</th>
								<th style="width:8%">可用工日</th>
								<th style="width:8%">可用工时/天</th>
								<th style="width:3%"> 操作</th>
								<th style="width:3%"> 删除</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${teamList}" var="team" varStatus="i">
								<tr class="num">
									<td>
										<input type="text" readonly value="${userMap[team.id.user.account]}" id="account${i.index}" class="form-control chosen-select">
									</td>
									<td><input type="text" name="teams[${i.index}].role" id="role${i.index}" value="${team.role}" class="form-control"></td>
									<td><input type="text" name="teams[${i.index}].days " id="days${i.index}" value="${team.days}" class="form-control"></td>
									<td>
										<input type="text" name="teams[${i.index}].hours" id="hours${i.index}" value="${team.hours}" class="form-control">
										<input type="hidden" name="teams[${i.index}].id.project.id" value="${team.id.project.id}" />
										<input type="hidden" name="teams[${i.index}].id.user.account" value="${team.id.user.account}" />
										<input type="hidden" name="teams[${i.index}].hiredate" value="${team.hiredate}" />
									</td>
									<td><a href="javascript:;" onclick="addItem()" class="btn btn-block"><i class="icon-plus"></i></a></td>
									<td><a href="javascript:;" onclick="deleteItem()" class="disabled btn btn-block"><i class="icon icon-remove"></i></a></td>
								</tr>
							</c:forEach>
							<!-- 部门用户 -->
							<c:forEach items="${deptUser}" var="deptuser" varStatus="i">
								<tr class="addedItem num">
									<td>
										<select name="accounts" id="account${i.index}" class="form-control chosen-select" onchange="setRole(this.value, ${i.index + teamList.size()});">
											<option></option>
											<c:forEach items="${noteam}" var="user">
												<option value="${user.account}" <c:if test="${deptuser.account == user.account}">selected</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
											</c:forEach>
										</select>
									</td>
									<td><input type="text" name="roles" id="role${i.index + teamList.size()}" value="${deptuser.role}" class="form-control"></td>
									<td><input type="text" name="days" id="days${i.index + teamList.size()}" class="form-control" value="6"></td>
									<td>
										<input type="text" name="hours" id="hours${i.index + teamList.size()}" class="form-control" value="7.0">
									</td>
									<td><a href="javascript:;" onclick="addItem()" class="btn btn-block"><i class="icon-plus"></i></a></td>
									<td><a href="javascript:;" onclick="deleteItem(this)" class="btn btn-block"><i class="icon icon-remove"></i></a></td>
								</tr>
							</c:forEach>
							<!-- 生成5行 -->
							<c:forEach begin="${teamList.size() + deptUser.size()}" end="${teamList.size() + deptUser.size() + 4}" step="1" var="i">
								<tr class="addedItem copy">
									<td>
										<select name="accounts" id="accounts${i}" class="form-control chosen-select" onchange="setRole(this.value, ${i})">
											<option></option>
											<c:forEach items="${noteam}" var="user">
												<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
											</c:forEach>
										</select>
									</td>
									<td><input type="text" name="roles" id="role${i}" class="form-control"></td>
									<td><input type="text" name="days" id="days${i}" class="form-control" value="6"></td>
									<td>
										<input type="text" name="hours" id="hours${i}" class="form-control" value="7.0">
									</td>
									<td><a href="javascript:;" onclick="addItem()" class="btn btn-block"><i class="icon-plus"></i></a></td>
									<td><a href="javascript:;" onclick="deleteItem(this)" class="btn btn-block"><i class="icon icon-remove"></i></a></td>
								</tr>
							</c:forEach>
							<!-- 让js来添加下一行的 -->
								<tr id="addedItem" style="display:none">
									<td>
										<select name="accounts" class="form-control chosen-select">
											<option></option>
											<c:forEach items="${noteam}" var="user">
												<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
											</c:forEach>
										</select>
									</td>
									<td><input type="text" name="roles" class="form-control"></td>
									<td><input type="text" name="days" class="form-control" value="6"></td>
									<td>
										<input type="text" name="hours" class="form-control" value="7.0">
									</td>
									<td><a href="javascript:;" onclick="addItem()" class="btn btn-block"><i class="icon-plus"></i></a></td>
									<td><a href="javascript:;" onclick="deleteItem(this)" class="btn btn-block"><i class="icon icon-remove"></i></a></td>
								</tr>
							<tr id="submit">
								<td colspan="6" class="text-center">
									<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>        
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
	
	$("select.chosen").chosen({
	    no_results_text: '没有找到',
	    search_contains: true,
	    allow_single_deselect: true,
	});
});

function loadDept() {
	$.ajax({
		url: "../getDept",
		type: 'get',
		async: false,
		success: function(data) {
			
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"");
				
			}
		}
	});
}

function iterateTree(data,name) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		var s = "";
		if(${deptId} == data[i].id) {
			s = "selected";
		}
		$("#depttree").append("<option value='"+ data[i].id +"' "+ s +">"+ a +"</option>");
		iterateTree(data[i].children,a);
	}
}

function setRole(account, roleID){
	var role;
	roleOBJ = $('#role' + roleID);
	if(account == "") {
		roleOBJ.val("");
	} else {
		$.get("../getSingleUser/" + account, function(data) {
			role = data.role;
		    roleOBJ.val(role);
		});
	}
}

function setDeptUsers(deptId) {
	
	location.href = "./project_managemembers_${projectId}_" + deptId;
}

function addItem()
{
    var item = $('.copy').html();/* .replace("$i", document.getElementsByName("accounts").length - 1) */
    $('#submit').before("<tr class='addedItem'>" + item  + "</tr>");
    console.log(item);
    var accounts = $('#submit').closest('table').find('tr.addedItem:last').find('select:first')
    accounts.trigger('liszt:updated');
    
}

function deleteItem(obj) {
    $(obj).closest('.addedItem').remove();
}

</script>
</body>
</html>