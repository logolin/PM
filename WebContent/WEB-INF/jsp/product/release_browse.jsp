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
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#myTable').datatable({sortable: true, colHover: false});
});
</script>
<title>${currentProduct.name}::浏览发布</title>
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
	      			<i class="icon-tags"></i>
	      			浏览发布      
	      			<c:if test="${currentProduct.type != 'normal' && branchId != null}"><span class="label label-info"><c:if test="${branchId == 0}">所有</c:if>${branchMap[branchId]}</span></c:if>    
	      		</div>
	      		<div class="actions">
	      			<shiro:hasPermission name="release:create">
	      				<a href="./release_create_${productId}_${branchId}" class="btn "><i class="icon-release-create icon-plus"></i> 创建发布</a>
	      			</shiro:hasPermission>
	      		</div>
      		</div>
			<table id="myTable" class="table datatable table-bordered table-condensed table-striped">
			  	<thead>
			    	<tr>
			      		<th data-type="number" data-width="70" style="text-align: center">ID</th>
			      		<th style="text-align: center">发布名称</th>
			      		<th style="text-align: center">版本</th> 
			      		<c:if test="${currentProduct.type != 'normal'}">
			      			<th data-width="100" style="text-align: center">
			      				<c:set var="c" value="${(c+0).intValue()}"/>
			      				所属${branchMap[c]}
			      			</th>
			      		</c:if>
			      		<th data-width="100" style="width:100px;text-align: center">发布日期</th>
			      		<th data-width="100" style="width:100px;text-align: center">状态</th>
			      		<th data-width="150" style="width:150px;text-align: center">操作</th>
			    	</tr>
			  	</thead>
			  	<tbody>
			  	<c:forEach items="${releaseList}" var="release">
			  	 	<tr class="slectable-item">
			      		<td class="text-center">${release.id}</td>
			      		<td>
			      			<shiro:hasPermission name="release:view">
			      				<a href="./release_view_${release.product.id}_${release.id}">${release.name}</a>
			      			</shiro:hasPermission>
			      			<shiro:lacksPermission name="release:view">${release.name}</shiro:lacksPermission>
			      			</td>
			      		<td>${release.build.name}</td>
			      		<c:if test="${currentProduct.type != 'normal'}">
			        		<td class="text-center"><c:if test="${release.branch_id == 0}">所有</c:if>${branchMap[release.branch_id]}</td>
			        	</c:if>
			      		<td class="text-center">${release.date}</td>
			      		<td class="text-center">
			      		<c:choose>
			      			<c:when test="${release.status == 'terminate'}">停止维护</c:when>
			      			<c:when test="${release.status == 'normal'}">正常</c:when>
			      			<c:otherwise></c:otherwise>
			      		</c:choose>
			      		</td>
			      		<td class="text-center">
			      			<shiro:hasPermission name="release:linkStory">
								<a style="cursor: pointer;" class="btn-icon" title="关联需求" data-size="lg" data-type="iframe" data-url="./release_linkStories_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-link"></i> </a>
							</shiro:hasPermission>
							<shiro:hasPermission name="release:linkBug">
								<a style="cursor: pointer;" class="btn-icon" title="关联解决Bug" data-size="lg" data-type="iframe" data-url="./release_linkBugs_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-bug"></i> </a>
							</shiro:hasPermission>
							<shiro:hasPermission name="release:changeStatus">
								<c:choose>
									<c:when test="${release.status == 'normal'}">
										<a href="./release_changeStatus_${productId}_${release.id}_terminate" class="btn-icon" title="停止维护"><i class="icon-pause"></i> </a>
									</c:when>
									<c:otherwise>
										<a href="./release_changeStatus_${productId}_${release.id}_normal" class="btn-icon" title="激活"><i class="icon-play"></i> </a>
									</c:otherwise>
								</c:choose>
							</shiro:hasPermission>
							<shiro:hasPermission name="release:edit">
								<a href="./release_edit_${productId}_${release.id}" class="btn-icon" title="编辑发布"><i class="icon-common-edit icon-pencil"></i></a>      
							</shiro:hasPermission>
				  		</td>
			    	</tr>
			  	</c:forEach>		    
			 	</tbody>
			</table>
	 	</div>  
	</div>
</body>
</html>