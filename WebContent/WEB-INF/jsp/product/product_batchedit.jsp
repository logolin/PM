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
<style type="text/css">
a>div>b {
	margin-top: 9px;
}
</style>
<title>批量编辑</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer" style="min-height: 494px;">
			<div id="titlebar">
			  	<div class="heading">
			    	<span class="prefix"><i class="icon-cube"></i></span>
			    	<strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 批量编辑</strong>
			  	</div>
			</div>
			<form class="form-condensed" method="post" action="./product_batchEdit_${productId}" style="overflow-x: auto;">
			<div style="min-height:400px;">
			  	<table class="table table-form table-fixed">
				    <thead>
				      	<tr>
					        <th class="w-id">   ID</th>
					        <th>产品名称 <span class="required"></span></th>
					        <th class="w-150px" style="padding-left: 15px;">产品代号 <span class="required"></span></th>
					        <th class="w-150px" style="padding-left: 15px;">产品负责人</th>
					        <th class="w-150px">测试负责人</th>
					        <th class="w-150px">发布负责人</th>
					        <th class="w-100px">产品类型</th>
					        <th class="w-100px">状态</th>
					        <th class="w-200px">产品描述</th>
					        <th class="w-80px">排序</th>
				      	</tr>
				    </thead>
			        <tbody>
			        	<c:forEach items="${productList}" var="product" varStatus="i">
				        <tr class="text-center">
					      	<td>
					      		${product.id}<input type="hidden" name="products[${i.index}].id" id="productIDList[6]" value="${product.id}">
							</td>
					      	<td title="1">
					      		<input type="text" name="products[${i.index}].name" id="names[6]" value="${product.name}" class="form-control">
							</td>
					      	<td>
					      		<input type="text" name="products[${i.index}].code" id="codes[6]" value="${product.code}" class="form-control">
							</td>
					      	<td class="text-left" style="overflow:visible">
					      		<select name="products[${i.index}].po" id="POs6" class="form-control chosen">
									<option value=""></option>
									<c:forEach items="${userMap}" var="user">
			          					<option value="${user.key}" <c:if test="${product.po == user.key}">selected</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>									
									<option value="closed" <c:if test="${product.po == 'closed'}">selected</c:if>>Closed</option>
								</select>
							</td>
					      	<td class="text-left" style="overflow:visible">
					      		<select name="products[${i.index}].qd" id="QDs6" class="form-control chosen">
									<option value=""></option>
									<c:forEach items="${userMap}" var="user">
			          					<option value="${user.key}" <c:if test="${product.qd == user.key}">selected</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>									
									<option value="closed" <c:if test="${product.qd == 'closed'}">selected</c:if>>Closed</option>
								</select>
							</td>
					      	<td class="text-left" style="overflow:visible">
						      	<select name="products[${i.index}].rd" id="RDs6" class="form-control chosen">
									<option value=""></option>
									<c:forEach items="${userMap}" var="user">
			          					<option value="${user.key}" <c:if test="${product.rd == user.key}">selected</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>									
									<option value="closed" <c:if test="${product.rd == 'closed'}">selected</c:if>>Closed</option>
								</select>
							</td>
					      	<td class="">
					      		<select name="products[${i.index}].type" id="types6" class="form-control">
									<option value=""></option>
									<option value="normal" <c:if test="${product.type == 'normal'}">selected</c:if>>正常</option>
									<option value="branch" <c:if test="${product.type == 'branch'}">selected</c:if>>多分支</option>
									<option value="platform" <c:if test="${product.type == 'platform'}">selected</c:if>>多平台</option>
								</select>
							</td>
					      	<td class="">
					      		<select name="products[${i.index}].status" id="statuses6" class="form-control">
									<option value=""></option>
									<option value="normal" <c:if test="${product.status == 'normal'}">selected</c:if>>正常</option>
									<option value="closed" <c:if test="${product.status == 'closed'}">selected</c:if>>结束</option>
								</select>
							</td>
			      			<td class="">
			      				<textarea name="products[${i.index}].descript" id="descs[6]" rows="1" class="form-control autosize">${product.descript}</textarea>
							</td>
			      			<td>
			      				<input type="text" name="products[${i.index}].sort" id="orders[6]" value="${product.sort}" class="form-control">
							</td>
			    		</tr>
			    		</c:forEach>
			        	<tr>
			        		<td colspan="10" class="text-center"> 
			        			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			        		</td>
			        	</tr>
			  		</tbody>
			  	</table>
			</div>
			</form>
	  	</div>
	</div>	
<script type="text/javascript">
$(function(){
	$("select.chosen").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true
	});
})
</script>
</body>
</html>