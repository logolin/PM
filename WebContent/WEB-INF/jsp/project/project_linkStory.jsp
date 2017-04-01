<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
<script>
var storyIds;
$(document).ready(function() {
	$('#myTable').datatable(
			{sortable: true,
			storage: true,
			checkable: true,
			colHover: false,
			checksChanged: function(event) {
				storyIds = event.checks.checks;
				$("#storyIds").val(storyIds);
			},
			});
});
</script>
<title>${project.name}::关联需求</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 494px;">
			<div>
				<div id="featurebar">
					<ul class="nav">
				    	<li id="calendarTab" class="active">关联需求</li>
					</ul>
					<div class="actions">
						<a href="javascript:history.go(-1);" class="btn"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i> 返回</a>
					</div>
				</div>
			</div>
			<form method="post">
				<table class="table table-striped table-condensed collapse" id="myTable">
					<thead>
						<tr class="tablesorter-headerRow" role="row">
							<th data-width="70px">ID</th>
							<th data-width="50px">P</th>
							<th>所属产品</th>
							<th>所属模块</th>
							<th>需求名称</th>
							<th>所属计划</th>
							<th class="text-center" data-width="80px">创建</th>
							<th class="text-center" data-width="80px">预计</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${storyList}" var="story" varStatus="i">
							<tr data-id="${story.id}">
								<td class="text-left">
									<a href="../product/story_view_${story.product.id}_${story.id}"><fmt:formatNumber type="number" minIntegerDigits="3" value="${story.id}" /></a>
								</td>
								<td>
									<span class="pri${story.pri}">
							      	<c:choose><c:when test="${story.pri == 0}"></c:when>
							      	<c:otherwise>${story.pri}</c:otherwise>
							      	</c:choose></span>
						      	</td>
								<td class="text-left"><a href="../product/product_view_${story.product.id}">${story.product.name}</a></td>
								<td class="text-left" id="modules${i.index}"></td>
								<td class="text-left">${story.title}</td>
								<td id="plans${i.index}"></td>
								<td>${userMap[story.openedBy]}</td>
								<td>${story.estimate}</td>
								<input type="hidden" id="plan${i.index}" value="${story.plan}" />
								<input type="hidden" id="module${i.index}" value="${story.module_id}" />
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<c:choose>
								<c:when test="${storyList.size() > 0}">
								<td colspan="7" class="text-left" data-column="0">
									<div class="table-actions clearfix">
										<div class="checkbox btn">
											<input type="hidden" id="storyIds" name="storyIds" />
											<label><input type="checkbox" class="check-all check-btn"> 选择</label>
										</div> 
										<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
									</div>
								</td>
								</c:when>
								<c:otherwise>
									<td colspan="7" class="text-left" data-column="0">
										<div class="table-actions clearfix">
										<div class="text">看起来没有需求可以关联。请检查下项目关联的产品中有没有需求，而且要确保它们已经审核通过。</div>          </div>
									</td>
								</c:otherwise>
							</c:choose>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	/* var leng = ${storyList.size()};
	for(var i = 0; i < leng; i++) {
		var modid = $("#module" + i).val();
		loadModule(modid, i);
	} */
	var leng = ${storyList.size()};
	for(var i = 0; i < leng; i++) {
		var plid = $("#plan" + i).val();
		if(plid != null && plid != "") {
			loadPlans(parseInt(plid),i);
		}
	}
	
})
/* 
function loadModule(moduleId,i) {
	$.ajax({
		url: "../getSingleModule/" + moduleId,
		type: 'get',
		async: false,
		success: function(data) {
			if (!$.isEmptyObject(data)) {
					iterateTree(data, "", i);
			}
		}
	})
}


function iterateTree(data, name, index) {
	var a = name;
	var modid = $("#module" + index).val();
	for (var i = 0; i < data.length; i++) {
		a = a + "/" + data[i].name;
		if(data[i].id == modid) {
			$("#modules" + index).append("jj");
			console.log(index + ":" + data[i].id +":"+ modid);
			console.log(a);
		}
		iterateTree(data[i].children, a ,index);
	}
	
}
 */
function loadPlans(planId,i) {
	 
	$.get("../getSinglePlan/" + planId, function(data){
		if (!$.isEmptyObject(data)) {
			$("#plans" + i).append("" + data.title);
		}
	})
}
</script>
<body>
</html>