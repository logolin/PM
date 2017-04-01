<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<% String newDate = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/wxcss/record.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.js"></script>
<title>记录工时</title>
</head>
<body>
	<form action="" method="post" onsubmit="return check()">
		<div class="title">
			<h2 style="margin-top:10px;">记录工时</h2>
			<p style="margin-bottom:0;font-size:14px;">(${task.id}  ${task.name})</p>
		</div>
		<div class="wrap">
			<c:if test="${taskEstimateList.size() > 0}">
				<table class="oldTable">
			    	<thead>
				    	<tr>
				         	<th class="col-xs-1">ID</th>
				          	<th class="col-xs-3">日期</th>
				          	<th class="col-xs-2">工时</th>
				          	<th class="col-xs-2">剩余</th>
				          	<th class="col-xs-3">备注</th>
				          	<th class="col-xs-1"></th>
				        </tr>
			    	</thead>
			    	<tbody>
			    		<c:forEach items="${taskEstimateList}" var="taskEstimateList">
			    			<tr>
				    			<td>${taskEstimateList.id}</td>
				    			<td>${taskEstimateList.date}</td>
				    			<td>${taskEstimateList.consumed}</td>
				    			<td>${taskEstimateList.remain}</td>
				    			<td>${taskEstimateList.work}</td>
				    			<td onclick="isDelete(${taskEstimateList.id})" style="font-size:20px;">
				    				<i class="icon icon-remove"></i>
				    			</td>
				    		</tr>
			    		</c:forEach>
			    	</tbody>
			    </table>
			</c:if>
			<c:forEach begin="0" end="4" step="1" var="i">
				<table class="mytable">
					<thead>
						<tr style="border-bottom:1px solid #ddd;">
							<th>ID:${i+1}</th>
							<th style="width:60%;">
								<div class="input-group date form-date" >
									<span class="input-group-addon form-date"><i class="icon icon-calendar"></i></span>
									<input type="text" name="dates" id="date${i}" class="form-control"/>
								</div>
							</th>
							<th style="border-bottom:hidden;"></th>
							<th style="border-bottom:hidden;"></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>工时：</th>
							<td colspan="3"><input type="text" name="consumed" id="consumed${i}" class="form-control"></td>
						</tr>
						<tr>
							<th>剩余：</th>
							<td colspan="3"><input type="text" name="remain" id="remain${i}" class="form-control"></td>
						</tr>
						<tr>
							<th>备注:</th>
							<td colspan="3"><textarea name="work" id="work${i}" class="form-control" rows="1"></textarea></td>
						</tr>
					</tbody>
				</table>
			</c:forEach>
		</div>
		<input type="hidden" value="<%=newDate%>" id="newDate" />
		<div>
			<div class="btn1"> 
				<button type="submit"  data-loading="稍候..."class="btn btn-lg btn-save">保存</button>
				<button type="button"  data-loading="稍候..."class="btn btn-lg btn-save" onclick="history.go(-1)">返回</button>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	$(document).ready(function(){
		//选择时间
		$(".form-date").datetimepicker(
			{
			    language:  "zh-CN",
			    weekStart:1,
			    todayBtn:  1,
			    autoclose: 1,
			    todayHighlight: 1,
			    startView: 2,
			    minView: 2,
			    forceParse: 0,
			    format: "yyyy-mm-dd"
			});
	});
	//删除记录
	function isDelete(recordId) {
		if(confirm("您确定删除这条记录吗？")) {
			location.href="deleteRecord-${task.id}"+recordId;
		}
	}
	//检查
	function check() {
		for(var i = 0; i < 5; i++) {
			var date = $('#date'+i).val();
			var consumed = $('#consumed'+i).val();
			var remain = $('#remain'+i).val();
			var work = $('#work'+i).val();
			if(!date || date == "") {
				$('#date'+i).val($('#newDate').val);
			}
			if(!consumed) {
				$('#consumed'+i).val(0);
			}
			if(!remain) {
				$('#consumed'+i).val(0);
			}
			if(!work) {
				$('#consumed'+i).val("");
			}
		}
	}
</script>
</html>
