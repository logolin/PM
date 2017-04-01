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
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>

<script type="text/javascript">
$(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
})

</script>
<title>维护部门结构::力德科技</title>
</head>
<body>
	<div class="modal-body">
		<div id="titlebar">
			<div class="heading">
		        <span class="prefix"><i class="icon-sitemap"></i></span>
		        <strong><small class="text-muted"><i class="icon-pencil"></i></small> 编辑部门</strong>
			</div>
		</div>
		<form target="_parent" class="form-condensed" method="post">
			<table class="table table-form" style="width:100%"> 
				<tbody>
					<tr>
						<th class="w-80px">上级部门</th>
          				<td>
          					<select name="parent" id="updept" class="form-control" style="width:100%">
          						<option value="0">/</option>
          					</select>
          				</td>
        			</tr>
        			<tr>
          				<th class="w-80px">部门名称</th>
          				<td><input type="text" name="name" value="${dept.name}" class="form-control"></td>
          			</tr>
          			<tr>
          				<th class="w-80px">负责人</th>
          				<td>
          					<select name="manager" class="form-control">
          						<option value=""></option>
          						<c:forEach items="${userList}" var="user">
          							<option value="${user.account}" <c:if test="${user.account == dept.manager}">selected</c:if>>${user.realname}</option>
          						</c:forEach>
          					</select>
          				</td>
          			</tr>
          			<tr>
          				<td colspan="2" class="text-center">
          				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>          </td>
          			</tr>
          		</tbody>
          	</table>
		</form>
	</div>
<script type="text/javascript">

$(function(){
	loadDept();
	$('select.chosen').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
})

//获得dept树
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
		if(data[i].id == ${dept.parent}) {
			s = "selected";
		}
		$("#updept").append("<option value='"+ data[i].id +" ' "+ s +">"+ a +"</option>");
		iterateTree(data[i].children,a);
	}
}
</script>
</body>
</html>