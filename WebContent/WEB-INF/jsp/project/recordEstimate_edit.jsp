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
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script src="${ctxResources}/dist/js/color.js"></script>

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
	<div id="titlebar">
	    <div class="heading">
	    	<strong>编辑工时</strong>
	    	<small class="text-muted"><i class="icon-pencil"></i></small>
	    </div>
	</div>
	<form class="form-condensed" method="post" target="_parent" name="estimate" onsubmit="return confirmLeft();">
		<table class="table table-form">
			<tbody>
				<tr>
			    	<th class="w-80px">日期</th>
			        <td class="w-p45">
			        	<input type="text" name="date" id="date" value="${estimate.date}" class="form-control form-date">
						<input type="hidden" name="id" value="${estimate.id}" />
					</td>
					<td></td>
				</tr>  
				<tr>
			    	<th>工时</th>
			        <td><input type="text" name="consumed" id="consumed" value="${estimate.consumed}" class="form-control">
			        </td>
			      </tr>
				<tr>
			        <th>预计剩余</th>
			        <td><input type="text" name="remain" id="remain" value="${estimate.remain}" class="form-control">
					</td>
				</tr>
				<tr>
			    	<th>备注</th>
			        <td colspan="2"><textarea name="work" id="work" class="form-control">${estimate.work}</textarea>
					</td>
				</tr>  
				<tr>
			        <td></td>
			        <td colspan="2" class="text-center">
			   			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			   		</td>
				</tr>
			</tbody>
		</table>
	</form>
<script>
function confirmLeft() {
	var consumed = $("#consumed").val();
	var remain = $("#remain").val();
	if(!parseInt(consumed)) {
		alert("[工时]不能为空");
		return false;
	} else if(!parseInt(remain)) {
		alert("[预计剩余]不能为空");
		return false;
	}
}
</script>
</body>
</html>