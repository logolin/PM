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
<title>关联BUG</title>
</head>
<body>
	<div class='outer'>
  			<div id="unlinkBugList">
				<table class="table datatable table-condensed table-striped table-fixed" id="bugList">
	           		<thead>
						<tr>
							<th data-width="70">ID</th>
							<th data-width="40">P</th>
							<th>Bug标题</th>
							<th data-width="80">创建</th>
							<th data-width="80">指派</th>
							<th data-width="60">状态</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${bugList}" var="bug">
			        	<tr class="text-center" data-id="${bug.id}">
							<td>
		                 		<a href="." target="_blank">${bug.id}</a>
							</td>
							<td>
								<span class="pri${bug.pri}"><c:if test="${bug.pri != 0}">${bug.pri}</c:if></span>
							</td>
							<td class="text-left nobr" title="${bug.title}">
								<a href="" target="_blank" style='color: ${bug.color}'>${bug.title}</a>
							</td>
   							<td>${userMap[bug.openedBy]}</td>
							<td>${userMap[bug.assignedTo]}</td>
							<td class="bug-${bug.status}">${statusMap[bug.status]}</td>
						</tr>     
						</c:forEach>                                     
	           		</tbody>
					<tfoot>
						<tr>
							<td colspan="9">
								<div class="table-actions clearfix">
									<div class="btn-group dropup"> 
										<button type="button" id="submit" class="btn btn-primary" data-loading="稍候...">关联Bug</button>
									</div>                      
   								</div>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>
	</div>
<script type="text/javascript">
var bugIds;
$(function(){
	$('table.datatable').datatable({
		sortable: true, 
		colHover: false,
		checkable: true,
		checksChanged: function(event) {
			bugIds = event.checks.checks;
		}
	});
	$("#submit").on("click", function(){
		$.post("../ajaxLink${where}/${objectId}", {ids: bugIds}, function(){
			window.parent.$.zui.closeModal();
			parent.history.go(0);
		});
	});
})
</script>
</body>
</html>
