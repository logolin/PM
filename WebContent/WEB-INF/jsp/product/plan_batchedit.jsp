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
<link href="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.js"></script>
<title>批量编辑</title>
<script type="text/javascript">
$(function(){
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
})
</script>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer" style="min-height: 494px;">
	  		<div id="titlebar">
  				<div class="heading">批量编辑</div>
			</div>
			<form method="post" action="./plan_batchEdit_${productId}_${branchId}">
				<table class="table table-form">
  					<thead>
				    	<tr>
					      	<th class="w-60px">编号</th>
					      	<th>名称</th>
					      	<th>描述</th>
					      	<th class="w-150px">开始日期</th>
					      	<th class="w-150px">结束日期</th>
				    	</tr>
				  	</thead>
				  	<tbody>
				  		<c:forEach items="${planList}" var="plan" varStatus="i">
					      	<tr>
					      		<td>
					      			${plan.id}<input type="hidden" name="plans[${i.index}].id" id="id[${i.index}]" value="${plan.id}">
					      		</td>
					      		<td title="${plan.title}">
					      			<input type="text" name="plans[${i.index}].title" id="title[${i.index}]" value="${plan.title}" class="form-control">
								</td>
					      		<td>
					      			<textarea name="plans[${i.index}].descript" id="descript[${i.index}]" class="form-control" rows="1">${plan.descript}</textarea>
								</td>
					      		<td>
					      			<input type="text" name="plans[${i.index}].begin" id="begin[${i.index}]" value="${plan.begin}" class="form-control form-date">
								</td>
					      		<td>
					      			<input type="text" name="plans[${i.index}].end" id="end[${i.index}]" value="${plan.end}" class="form-control form-date">
								</td>
					    	</tr>
				    	</c:forEach>
			    	</tbody>
			  		<tfoot>
				    	<tr>
				    		<td colspan="5" class="text-center"> 
				    			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
				    			<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
				    		</td>
				    	</tr>
				  	</tfoot>
				</table>
			</form>
	  	</div>
	</div>	
</body>
</html>