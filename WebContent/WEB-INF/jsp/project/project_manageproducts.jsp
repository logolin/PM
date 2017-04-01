<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<!DOCTYPE html>
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
$(document).ready(function(){
	$("select.chosen-select").chosen({
		no_results_text: '没有找到',    
	    search_contains: true,  
	});
})
</script>
<style>.mgr-5px{margin-right:5px;}
#productsBox {padding: 20px;}
#productsBox > .col-sm-4 {padding: 8px 15px; border:1px solid #ddd;margin-bottom:5px; width:32%; margin-right:8px;}
#productsBox > .col-sm-4 label {display:block; cursor: pointer;}
#productsBox > .col-sm-4:hover {background: #f1f1f1; cursor: pointer;}
#productsBox > .col-sm-4.checked, #productsBox > .col-sm-4.checked:hover {background: #E5FFE6; border: 1px solid #229F24;}
.col-sm-4+.col-sm-4 {margin-left: 0;}
</style>
<title>关联产品:: ${project.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div>
			<div id='titlebar'>
			    <div class='heading'><i class='icon-cube'></i> 关联产品    </div>
		  	</div>
			<form class="form-condensed" method="post">
			    <div id="productsBox" class="row">
			    	<c:forEach items="${map}" var="map" varStatus="i">
			    		<c:if test="${map.key.type == 'normal'}">
				    	<div class="col-sm-4 ">
			                <label for="product${i.index}">
			                	<c:set var="isProduct" value="0" />
			                	<c:forEach items="${pjpd}" var="pjpd">
			                		<c:if test="${pjpd.id.product.id == map.key.id}"><c:set var="isProduct" value="1" /></c:if>
			                	</c:forEach>
			          			<input type="checkbox" name="pjPdId" value="${map.key.id}" <c:if test="${isProduct == 1}">checked="checked"</c:if> id="product${i.index}"> ${map.key.name} 
			          			<input type="hidden" name="pjPdRelations[${i.index}].id.product.id" value="${map.key.id}">
			          			<input type="hidden" name="pjPdRelations[${i.index}].id.project.id" value="${project.id}">
			          			<input type="hidden" name="pjPdRelations[${i.index}].branch_id" value="0">      
			          		</label>
						</div>
						</c:if>
						<c:if test="${map.key.type != 'normal'}">
						<div class='col-sm-4 '>
							<div class='col-sm-6' style='padding-left:0px'>        
								<label for="product${i.index}">
									<c:set var="isProduct" value="0" />
									<c:forEach items="${pjpd}" var="pjpd">
			                			<c:if test="${pjpd.id.product.id == map.key.id}"><c:set var="isProduct" value="1" /></c:if>
			                		</c:forEach>
									<input type="checkbox" name="pjPdId" value="${map.key.id}" <c:if test="${isProduct == 1}">checked="checked"</c:if> id="product${i.index}"> ${map.key.name} 
									<input type='hidden' name='pjPdRelations[${i.index}].id.product.id' value="${map.key.id}"> 
									<input type="hidden" name="pjPdRelations[${i.index}].id.project.id" value="${project.id}">      
						        </label>
					        </div>
					        <div class='col-sm-6'>
						    	<select name='pjPdRelations[${i.index}].branch_id' id='branch${i.index}' class='from-control chosen-select' style="width:100%">
									<option value="0"><c:if test="${map.key.type =='branch'}">所有平台</c:if> <c:if test="${map.key.type =='platform'}">所有分支</c:if></option>
									<c:forEach items="${map.value}" var="branch">
										<c:set var="isBranch" value="0" />
										<c:forEach items="${pjpd}" var="pjpd">
				                			<c:if test="${pjpd.branch_id == branch.id}"><c:set var="isBranch" value="1" /></c:if>
				                		</c:forEach>
										<option value='${branch.id}' <c:if test="${isProduct == 1 && isBranch == 1}">selected</c:if>>${branch.name}</option>
									</c:forEach>
								</select>
							</div> 
						</div>
						</c:if>
					</c:forEach>
				</div>
			    <div class="text-center">
			       <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>    
				</div>
			</form>
			</div>
		</div>
	</div>
</body>
</html>