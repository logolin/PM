<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<title>任务列表页面</title>
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/list.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
</head>
<body>
	<div class="titlebar" >
		<h2>
			<c:if test="${type == 'finish'}">已完成任务</c:if>
			<c:if test="${type == 'unfinish'}">未完成任务</c:if>
		</h2>
		<img src="../resources/wximg/title.png" />
	</div>
	<div class="wrap">
		<c:forEach items="${taskList}" var="task"> 
			<div class="info" >
				<div class="header ">
					<table>
						<tr>
							<td style="text-align: left;"><input type="checkbox" name="taskIds" id="taskIds" value="${task.id}"></td>
							<td style="text-align: right;" onclick="window.location.href='task-detail-${task.id}'">
								<i class="icon icon-chevron-right" style="font-size: 18px;"></i>
							</td>
						</tr>
					</table>
				</div>
					<div class="info1">
						<table class="row" id="myTable">
							<tr>
								<th class="col-xs-2">ID</th>
								<th class="col-xs-4">任务名称</th>
								<th class="col-xs-2">状态</th>
								<th class="col-xs-4">截止时间</th>
							</tr>
							<tr style="color:#222;" onclick="window.location.href='task-detail-${task.id}'">
								<td class="col-xs-2">${task.id}</td>
								<td class="col-xs-4" >${task.name}</td>
								<td class="col-xs-2" value="${task.status}">${task.ch_status}</td>
								<td class="col-xs-4 <c:if test="${task.status == 'delay'}"> active</c:if>" >${task.deadline}</td>
							</tr>
						</table>
					</div>
			</div>
		</c:forEach>
	</div>
	<input type="hidden" name="user" id="user" value="${userAccount}"/>
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
				<c:forEach items="${userList}" var="user">
					<li data-key="${user.account}"><a onclick="massHandle('AssignedTo', '${user.account}')">${user.realname}</a></li>
				</c:forEach>
				<li data-key="closed"><a onclick="massHandle('AssignedTo','${user.account}')">Closed</a></li>
			</ul>
		</div>
		<c:if test="${type == 'finish'}">
			<div class="btn-close">
				<button onclick="massHandle('close',0)">
					<i class="icon icon-off"></i><br>
					<span>关闭</span>
				</button>
			</div>
		</c:if>
		<c:if test="${type == 'unfinish'}">
			<div class="btn-finish">
				<button onclick="massHandle('finish',0)">
					<i class="icon icon-check-circle-o"></i><br>
					<span>完成</span>
				</button>
			</div>
		</c:if>
		<div class="btn-delete">
			<button onclick="massHandle('delete',0)">
				<i class="icon icon-remove-circle"></i><br>
				<span>删除</span>
			</button>
		</div>
	</div>
</body>
<script type="text/javascript">
	//全选功能
	function selectAll(obj) {
		$('input[name="taskIds"]').prop("checked",obj.checked);
	};
	//批量指派、关闭、删除 
	function massHandle(fieldName ,fieldVal) {
		var arr=new Array();
		var taskIds=$("input[name='taskIds']");
		for(var i=0;i<taskIds.length;i++){  
			if(taskIds[i].checked==true){  
				arr.push(taskIds[i].value);  
			}
		}
		$.ajax({
			type:"post",//请求方式
			url:"task-massHandle",//发送请求的地址
			traditional:true,
			data:{"taskIds":arr,"fieldName":fieldName,"fieldVal":fieldVal},//发送到服务器的数据
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
</html>
