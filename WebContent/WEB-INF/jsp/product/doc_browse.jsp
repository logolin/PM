<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>        
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
	$('#docList').datatable({sortable: true, colHover: false});
});
</script>
<title>${currentProduct.name}::文档列表</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer" style="min-height: 494px;">
			<div>
				<div id="titlebar">
				  	<div class="heading" style="padding-right: 95px;"><i class="icon-file-text"></i> 文档列表  </div>
				  	<div class="actions">
				  		<shiro:hasPermission name="doc:create">
				    		<a href="./doc_create_${productId}" class="btn "><i class="icon-doc-create icon-plus"></i> 创建文档</a>
				  		</shiro:hasPermission>
				  	</div>
				</div>
				<table class="table table-condensed table-striped" id="docList">
				  	<thead>
					    <tr>
					      	<th data-width="70" data-type="number">ID</th>
					      	<th>所属分类</th>
					      	<th>文档标题</th>
					      	<th>由谁添加</th>
					      	<th>添加时间</th>
					      	<th data-width="100" data-sort="false">操作</th>
					    </tr>
				  	</thead>
			  		<tbody>         
			  			<c:forEach items="${docList}" var="doc">
					    <tr class="text-center">
					      	<td><a href=""><fmt:formatNumber value="${doc.id}" pattern="#000"/></a></td>
					      	<td>${doc.type}</td>
					      	<td class="text-left nobr"><nobr>
					      		<shiro:hasPermission name="doc:view"><a href=""></shiro:hasPermission>${doc.title}<shiro:hasPermission name="doc:view"></a></shiro:hasPermission>
					      	</nobr></td>
					      	<td>${userMap.get(doc.addedBy)}</td>
					      	<td>${doc.addedDate}</td>
					      	<td>
					      		<shiro:hasPermission name="doc:edit">
					      			<a href="" class="btn-icon " title="编辑文档"><i class="icon-common-edit icon-pencil"></i></a>      
					      		</shiro:hasPermission>
					      		<shiro:hasPermission name="doc:delete">
					      			<a href='javascript:ajaxDelete("/doc-delete-56-yes.html","docList",confirmDelete)' class="btn-icon" title="删除文档"><i class="icon-remove"></i></a>
					      		</shiro:hasPermission>
					      	</td>
					    </tr>
					    </c:forEach>  
				  	</tbody>
				</table>
			</div>
	  	</div>
	</div>
</body>
</html>