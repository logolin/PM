<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<!DOCTYPE html>
<html lang='zh-cn'>
<head>
<meta charset='utf-8'>
<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<meta name="renderer" content="webkit"> 
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<title>关联需求</title>
</head>
<body>
	<div class='outer'>
  			<div id="unlinkStoryList">
				<table class="table datatable table-condensed table-striped table-fixed" id="storyList" data-sortable="true" data-checkable='true' >
	           		<thead>
						<tr>
							<th data-type="number" data-width="50" data-col-class="text-left">ID</th>
							<th data-width="40">P</th>
							<c:if test="${storyId != null}">
							<th>所属产品</th>
							</c:if>
							<th>需求名称</th>
							<c:if test="${releaseId == null}">
							<th>所属计划</th>
							</c:if>							
							<th data-width="80">创建</th>
							<c:if test="${storyId == null}">
							<th data-width="80">指派</th>
							<th data-width="60">状态</th>
							<th data-width="80">阶段</th>
							</c:if>
							<th data-width="60" >预计</th>							
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${storyList}" var="story">
			        	<tr class="text-center" data-id="${story.id}">
							<td class="text-left">
		                 		<a href="./story_view_${story.product.id}_${story.id}" target="_blank">${story.id}</a>
							</td>
							<td>
								<span class="pri${story.pri}"><c:if test="${story.pri != 0}">${story.pri}</c:if></span>
							</td>
							<c:if test="${storyId != null}">
							<td><a href="./product_view_${story.product.id}" target="_blank">${story.product.name}</a></td>
							</c:if>
							<td class="text-left nobr" title="${story.title}">
								<a href="./story_view_${story.product.id}_${story.id}" target="_blank" style='color: ${story.color}'>${story.title}</a>
							</td>
							<c:if test="${releaseId == null}">
							<td class="text-left nobr" title="${story.plan}">${story.plan}</td>
							</c:if>							
    						<td>${userMap[story.openedBy]}</td>
    						<c:if test="${storyId == null}">
							<td>${userMap[story.assignedTo]}</td>
							<td class="story-${story.status}">${statusMap[story.status]}</td>
							<td>${stageMap[story.stage]}</td>
							</c:if>
							<td class="text-right">${story.estimate}</td>
						</tr>     
						</c:forEach>                                     
	           		</tbody>
					<tfoot>
						<tr>
							<td colspan="9">
								<div class="table-actions clearfix">
									<div class="btn-group dropup"> 
										<button type="button" id="submit" class="btn btn-primary" data-loading="稍候...">关联需求</button>
									</div>                      
     								</div>
  								</td>
						</tr>
 						</tfoot>
				</table>
			</div>
		</div>
<script type="text/javascript">
var storyIds;
$(function(){
	$('table.datatable').datatable({
		sortable: true, 
		colHover: false,
		checkable: true,
		checksChanged: function(event) {
			storyIds = event.checks.checks;
		}
	});
	$("#submit").on("click", function(){
		$.post("../ajaxLink${where}/${objectId}", {ids: storyIds}, function(){
			window.parent.$.zui.closeModal();
			parent.history.go(0);
		});
	});
})
</script>
</body>
</html>
