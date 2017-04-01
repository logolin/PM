<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<% String date = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
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
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>

	<script>
	$(document).ready(function(){
		//选择时间
		$(".form-date").datetimepicker(
			{
			    language:  "zh-CN",
			    weekStart: 1,
			    todayBtn:  1,
			    autoclose: 1,
			    todayHighlight: 1,
			    startView: 2,
			    minView: 2,
			    forceParse: 0,
			    format: "yyyy-mm-dd"
			});
	});
	</script>
	<style>.body-modal > .main {padding: 20px}
.body-modal > .main .table-form {border: 1px solid #ddd}
</style>
<title>工时</title>
</head>
<body>
	<div id='titlebar'>
	  <div class='heading'>
	    <span class='prefix'><i class='icon-check-sign'></i> <strong>${task.id}</strong></span>
	    <strong style="color: ${task.color}">${task.name}</strong>
	    <small class='text-muted'> 记录工时 <i class='icon-time'></i></small>
	  </div>
	</div>
	<div class='main'>
	  <form method="post" onsubmit="return check();" target="_parent">
	    <table class='table table-form'>
	    	<c:if test="${taskEstimateList.size() > 0}">
		    	<thead>
			    	<tr class='text-center'>
			         	<th class="w-id">ID</th>
			          	<th class="w-100px">日期</th>
			          	<th class="w-60px">工时</th>
			          	<th class="w-60px">剩余</th>
			          	<th>备注</th>
			          	<th class="w-60px">操作</th>
			        </tr>
		      </thead>
	      </c:if>
	      <c:forEach items="${taskEstimateList}" var="taskEstimates" varStatus="vs">
	            <tr class="a-center text-center">
			        <td>${taskEstimates.id}</td>
			        <td>${taskEstimates.date}</td>
			        <td>${taskEstimates.consumed}</td>
			        <td>${taskEstimates.remain}</td>
			        <td class="text-left">${taskEstimates.work}</td>
			        <td align='center'>
			          <a href='./recordEstimate_edit_${taskEstimates.id}_${task.id}_${status}_${task.project.id}' class='btn-icon showinonlybody' title='编辑工时' >
			          	<i class='icon-task-editEstimate icon-pencil'></i>
			          </a>
			          <a href="" onclick="deleteEstimate(${taskEstimates.id})" class='btn-icon showinonlybody' title='删除工时'  target='hiddenwin'>
			          	<i class='icon-task-deleteEstimate icon-remove'></i>
			          </a>       
			        </td>
	            </tr>
	      	</c:forEach>
	      <thead>
	        <tr class='text-center'>
	          	<th class="w-id">ID</th>
	          	<th class="w-120px">日期</th>
	          	<th class="w-60px">工时</th>
	          	<th class="w-60px">剩余</th>
	          	<th>备注</th>
	          	<th></th>
	        </tr>
	      </thead>
	      <tbody>
	      	<c:forEach begin="0" end="4" step="1" var="i">
		    	<tr class="text-center a-center">
		        	<td>${i+1}</td>
		        	<td><input type="text" name="dates" id="date${i}" class='form-control text-center form-date' /></td>
			    	<td><input type='text' name="consumed" id="consumed${i}"  class='form-control text-center' /></td>
			   		<td><input type='text' name="remain" id="remain${i}" class='form-control text-center left'  /></td>
			   		<td class="text-left"><textarea name="work" id="work${i}" class='form-control' rows='1'></textarea></td>
			    	<td></td>
		    	</tr>
		    </c:forEach>
	      	<tr>
	        	<td colspan='6' class='text-center'> 
	        		<button type='submit' id='submit' class='btn btn-primary'  data-loading='稍候...'>保存</button>
	        	</td>
	      	</tr>
	      </tbody>
	    </table>
	  </form>
	  <input type="hidden" value="<%=date %>" id="copydate" />
	</div>
<script type="text/javascript">

function deleteEstimate(estimateId) {
	if(confirm("您确定删除这条记录吗？")) {
		windows.href = "./recordEstimate_delete_" + estimateId + "_${task.id}_${status}}";
	}
}

function check() {
	for(var i = 0; i < 5; i++) {
		if(!$("#date" + i).val() || $("#date" + i).val() == "") {
			$("#date" + i).val($("#copydate").val() );
		}
		if(!$("#consumed" + i).val() ) {
			$("#consumed" + i).val(0);
		}
		if(!$("#remain" + i).val() ) {
			$("#remain" + i).val(0);
		}
		if(!$("#work" + i).val() ) {
			$("#work" + i).val("");
		}
	}
}
</script>
</body>
</html>