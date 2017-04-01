<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<title>新增产品</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div class="container mw-1400px">
		<div id="titlebar">
		    <div class="heading">
		    	<script>
		    	if (action == "edit") {
					document.write('<span class="prefix"><i class="icon-cube"></i> <strong>${productId}</strong></span><strong><a href="./product_view_${productId}">${product.name}</a></strong><small class="text-muted"> 编辑产品 <i class="icon icon-pencil"></i></small>');
				} else {
					document.write('<span class="prefix"><i class="icon-cube"></i></span><strong><small class="text-muted"><i class="icon icon-plus"></i></small> 新增产品</strong>');
				}
		    	</script>
		    </div>
	  	</div>
			<form class="form-condensed" method="post" id="product">
			    <table class="table table-form"> 
		      		<tbody>
			      		<tr>
					        <th class="w-90px">产品名称</th>
					        <td class="w-p25-f">
					        	<div class="required required-wrapper"></div>
					        	<input type="text" name="name" id="name" value="${product.name}" class="form-control" autofocus="autofocus" required>
							</td>
							<td style="padding-left: 15px;"></td>
			      		</tr>  
			      		<tr>
		        			<th>产品代号</th>
					        <td>
					        	<div class="required required-wrapper"></div>
					        	<input type="text" name="code" id="code" value="${product.code}" class="form-control" required>
							</td>
							<td style="padding-left: 15px;"></td>
			      		</tr>  
			      		<tr>
					        <th>产品负责人</th>
					        <td>
				          		<select id="PO" name="po" class="chosen form-control">
				          			<option value=""></option>
				          			<c:forEach items="${userMap}" var="user">
				          				<option value="${user.key}" <c:if test="${product.po == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
				          			</c:forEach>
					          	</select>
							</td>
							<td></td>
			      		</tr>  
			      		<tr>
					        <th>测试负责人</th>
					        <td>
			          			<select id="QD" name="qd" class="chosen form-control">
			          				<option value=""></option>
			          				<c:forEach items="${userMap}" var="user">
				          				<option value="${user.key}" <c:if test="${product.qd == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
				          			</c:forEach>
								</select>
							</td>
							<td></td>
			      		</tr> 
			      		<tr>
					        <th>发布负责人</th>
					        <td>
		          				<select id="RD" name="rd" class="chosen form-control">
			          	 	 		<option value=""></option>
	          						<c:forEach items="${userMap}" var="user">
			          					<option value="${user.key}" <c:if test="${product.rd == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>
								</select>
							</td>
							<td></td>
			      		</tr> 
			      		<tr>
					        <th>产品类型</th>
					        <td>
			          			<select id="type" name="type" data-placeholder=""  class="form-control">
									<option value="normal" <c:if test="${product.type == 'normal'}">selected</c:if>>正常</option>
									<option value="branch" <c:if test="${product.type == 'branch'}">selected</c:if>>多分支</option>
									<option value="platform" <c:if test="${product.type == 'platform'}">selected</c:if>>多平台</option>
			          			</select>
							</td>
							<td></td>
			      		</tr> 	
			      		<script>
			      		if (action == 'edit')
			      			document.write('<tr><th>状态</th><td><select name="status" id="status" class="form-control"><option value=""></option><option value="normal" selected="selected">正常</option><option value="closed">结束</option></select></td><td></td></tr>');
				      	</script>
			      		<tr>
					        <th>产品描述</th>
					        <td colspan="2">
					        	<textarea id="descript" name="descript" class="form-control kindeditor" style="height:150px;">${product.descript}</textarea>
				        	</td>
			      		</tr>  
			      		<tr>
			        		<th>访问控制</th>
			        		<td colspan="2">
					        	<div class="radio">
					        		<label>
					        			<input type="radio" name="acl" value="open" onclick="setWhite(this.value);" id="aclopen" <c:if test="${'open' == product.acl}">checked="checked"</c:if>> 
					        			默认设置(有产品视图权限，即可访问)
				        			</label>
			        			</div>
			        			<div class="radio">
			        				<label>
			        					<input type="radio" name="acl" value="private" onclick="setWhite(this.value);" id="aclprivate" <c:if test="${'private' == product.acl}">checked="checked"</c:if>> 
			        					私有产品(只有项目团队成员才能访问)
		        					</label>
		       					</div>
		       					<div class="radio">
		       						<label>
		       							<input type="radio" name="acl" value="custom" onclick="setWhite(this.value);" id="aclcustom" <c:if test="${'custom' == product.acl}">checked="checked"</c:if>> 
		       							自定义白名单(团队成员和白名单的成员可以访问)
		       						</label>
		       					</div>
      						</td>
	      				</tr>  
		      			<tr id="whitelistBox" class="hidden">
	        				<th>分组白名单</th>
					        <td colspan="2">
					        	<c:set var="whitelist" value=",${product.whitelist},"/>
					        	<c:forEach items="${groupMap}" var="group">
					        		<c:set var="w" value=",${group.key},"/>
      						        <label class="checkbox-inline">
					        			<input type="checkbox" name="whitelist" value="${group.key}" id="whitelist${group.key}" <c:if test="${fn:contains(whitelist,w)}">checked</c:if>> 
					        			${group.value}
				        			</label>
					        	</c:forEach>
			        		</td>
				      	</tr>  
				      	<tr>
				      		<td></td>
				      		<td colspan="2"> 
				      			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			      			</td>
		      			</tr>
		    		</tbody>
	    		</table>
			</form>
		</div>
		</div>
	</div>
<script>
var kEditorId = ['descript'];
$(function(){
	$('select.chosen').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
});
$(function(){
	var a = '${product.acl}';
	if(a === '')
		$("#aclopen").attr("checked",true);
	else
		setWhite(a);
})
function setWhite(acl)
{
    acl == 'custom' ? $('#whitelistBox').removeClass('hidden') : $('#whitelistBox').addClass('hidden');
}
</script>
</body>
</html>