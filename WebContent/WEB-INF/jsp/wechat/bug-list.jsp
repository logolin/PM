<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<title>Bug列表</title>
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/list.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<style type="text/css">
	.btn-list div {
		width:25%;
	}
</style>
</head>
<body>
	<div class="titlebar" >
		<h2>
			<c:if test="${type == 'finish'}">已完成Bug</c:if>
			<c:if test="${type == 'unfinish'}">未完成Bug</c:if>
		</h2>
		<img src="../resources/wximg/title.png" />
	</div>
	<div class="wrap">
		<c:forEach items="${bugList}" var="bug"> 
			<div class="info">
				<div class="header">
					<table>
						<tr>
							<td style="text-align: left;"><input type="checkbox" name="bugIds" id="bugIds" value="${bug.id}"></td>
							<td style="text-align: right;" onclick="window.location.href='bug-detail-${bug.id}'">
								<i class="icon icon-chevron-right" style="font-size:18px;"></i>
							</td>
						</tr>
					</table>
				</div>
					<div class="info1">
						<table class="row" id="myTable">
							<tr>
								<th class="col-xs-2">ID</th>
								<th class="col-xs-5">标题</th>
								<th class="col-xs-2">级别</th>
								<c:if test="${type == 'unfinish'}">
									<th class="col-xs-3">状态</th>
								</c:if>
								<c:if test="${type == 'finish'}">
									<th class="col-xs-3">优先级</th>
								</c:if>
							</tr>
							<tr style="color:#222;" onclick="window.location.href='bug-detail-${bug.id}'">
								<td class="col-xs-2">${bug.id}</td>
								<td class="col-xs-5">${bug.title}</td>
								<td class="col-xs-2">${bug.severity}</td>
								<c:if test="${type == 'unfinish'}">
									<td class="col-xs-3">${statusMap[bug.status]}</td>
								</c:if>
								<c:if test="${type == 'finish'}">
									<td class="col-xs-3">${bug.pri}</td>
								</c:if>
							</tr>
						</table>
					</div>
			</div>
		</c:forEach>
	</div>
	<!-- 		按钮 -->
	<div class="btn-list">
		<div class="btn-home">
			<button onclick="history.go(-1)">
				<i class="icon icon-home"></i><br>
				<span>首页</span>
			</button>
		</div>
		<div class="btn-select" style="padding:2px;">
			<label>
				<input type="checkbox" onclick="selectAll(this)" hidden>
				<i class="icon icon-list" style="font-size:22px;"></i><br>
				<span style="font-weight:normal;">全选</span>
			</label>
		</div>
		<div class="dropup btn-group btn-assignTo">
			<button class="dropdown-toggle" type="button" data-toggle="dropdown">
				<i class="icon icon-hand-right"></i><br>
				<span>指派</span>
			</button>
			<ul class="dropdown-menu assignmenu" role="menu">
				<c:forEach items="${userList}" var = "user">
					<li data-key="${user.account}"><a onclick="massHandle('assignedTo','${user.account}')">${user.realname}</a></li>
				</c:forEach>
				<li data-key="closed"><a onclick="massAssign('${user.account}')">Closed</a></li>
			</ul>
		</div>
		<div class="btn-delete">
			<button onclick="massHandle('delete',0)">
				<i class="icon icon-remove-circle"></i><br>
				<span>删除</span>
			</button>
		</div>
	</div>
	<script type="text/javascript">
		//全选功能
		function selectAll(obj) {
			$('input[name="bugIds"]').prop("checked",obj.checked);
		};
		//批量指派
		function massHandle(fieldName ,fieldVal) {
			var arr=new Array();
			var bugIds=$("input[name='bugIds']");
			for(var i=0;i<bugIds.length;i++){  
				if(bugIds[i].checked==true){  
					arr.push(bugIds[i].value);  
				}
			}
			$.ajax({
				type:"post",//请求方式
				url:"bug-massAssign",//发送请求的地址
				traditional:true,
				data:{"bugIds":arr,"fieldName":fieldName,"fieldVal":fieldVal},//发送到服务器的数据
				beforeSend:function(){
					if (arr == "" || arr == "undefined" || arr == null) {
						bootbox.alert("<h4>请选择您需要修改的bug！</h4>");
						return false;//取消本次ajax请求
					}
				},
				complete:function(){//请求完成后刷新页面（请求成功或失败时均调用）
						history.go(0);
				},
			})
		}
	</script>
</body>

</html>
