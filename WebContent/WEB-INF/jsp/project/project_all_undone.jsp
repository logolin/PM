<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="${ctxResources}/jquery-1.12.4.min.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
<script src="${ctxResources}/zui/src/js/sortable.js"></script>

<script>
$(document).ready(function() {
	$('table.datatable').datatable(
			{storage: true,
			colHover: false,
			});
	$("select.chosen-select").chosen({
		no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width:'100%',
	    disable_search_threshold: 1, 
	    placeholder_text_single: ' ', 
	    placeholder_text_multiple: ' '
	});
});
function selectAll(obj) {
	$('input[name="projectIds"]').prop("checked",obj.checked);
};


$(function(){
	var lis = $('#featurebar ul li');
	lis.each(function(){
		$(this).click(function(){
			$(this).siblings().removeClass('active');
			$(this).addClass('active');
		});
	});
	
	$('table').datatable({
		storage: false,
		sortable: true, 
		colHover: false,
		sort: function(event) {
			var s = ['id','name','code','PM','end', 'status'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./project_all_${projectId}_${status}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${productId}_${projectSum}_${recPerPage}_${page}";
			}
		}
	});
})

</script>
<title>所有项目</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 494px;">
		  <div id="featurebar">
	    	<ul class="nav">
		    	<li id="undone" <c:if test="${status == 'undone'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_undone">未完成</a></li>
		        <li id="all" <c:if test="${status == 'all'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_all">所有</a></li>
	            <li id="wait" <c:if test="${status == 'wait'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_wait">未开始</a></li>
	            <li id="doing" <c:if test="${status == 'doing'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_doing">进行中</a></li>
	            <li id="suspended" <c:if test="${status == 'suspended'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_suspended">已挂起</a></li>
				<li id="done" <c:if test="${status == 'done'}">class="active"</c:if>><a href="${ctxpj}/project_all_${project.id}_done">已完成</a></li>
				<li>
					<select class="form-control chosen chosen-select" onchange="self.location.href=options[selectedIndex].value">
							<option value="${ctxpj}/project_all_${project.id}_all_${orderBy}_${ascOrDesc}_0_0_10_1">请选择产品</option>
							<c:forEach items="${productList}" var="product" varStatus="vs">
								<option value="${ctxpj}/project_all_${project.id}_all_${orderBy}_${ascOrDesc}_${product.id}_0_10_1"
									<c:if test="${product.id == productId}">selected</c:if>>
									${product.name}
								</option>
							</c:forEach>
					</select>
					
				</li>
			</ul>
		  </div>
		  <form method="post" action="${ctxpj}/project_batchEdit_${project.id}">
			  <table id="project" name="project" class="table datatable table-striped table-condensed collapse">
				  <thead>
				    <tr>
				      <th class="w-id" <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
				      <th class="w-p30" <c:if test="${orderBy == 'name'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>项目名称</th>
				      <th <c:if test="${orderBy == 'code'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>项目代号</th>
				      <th <c:if test="${orderBy == 'PM'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>项目负责人</th>
				      <th <c:if test="${orderBy == 'end'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>结束日期</th>
				      <th <c:if test="${orderBy == 'status'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>项目状态</th>
				      <th data-sort="false">总预计</th>
				      <th data-sort="false">总消耗</th>
				      <th data-sort="false">总剩余</th>
				      <th class='w-150px' data-sort="false">进度</th>
				      <th class='w-150px' data-sort="false">燃尽图</th>
				      <th class='w-60px sort-default' data-sort="false"><div class='headerSortUp'>排序</div></th>
				    </tr>
				  </thead>
				  <c:if test="${projectPage.totalElements != 0}">
				  <tbody>
				  	<c:forEach items="${projectPage.content}" var="projectlist" varStatus="vs">
				  		<tr class="text-center">
				  			<td>
				  				<input type="checkbox" name="projectIds" value="${projectlist.id}">
				  				<a href="${ctxpj}/project_view_${projectlist.id}"><fmt:formatNumber value="${projectlist.id}" minIntegerDigits="3" type="number" /></a>
				  			</td>
				  			<td><a href="${ctxpj}/project_view_${projectlist.id}">${projectlist.name}</a></td>
				  			<td>${projectlist.code}</td>
				  			<td>${projectlist.PM}</td>
				  			<td>${projectlist.end}</td>
				  			<td><div class="status-${projectlist.status}">${projectlist.statusStr}</div></td>
				  			<td><fmt:formatNumber value="${projectlist.estimate}" type="number" /> </td>
				  			<td><fmt:formatNumber value="${projectlist.consumed}" type="number" /></td>
				  			<td><fmt:formatNumber value="${projectlist.remain}" type="number" /></td>
							<td class="text-left w-150px">
							<div>
						      <img class="progressbar" alt="" height="16" style="width:
						      <c:choose>
						      		<c:when test="${(projectlist.consumed+projectlist.remain) == 0}">0.8%</c:when>
								    <c:otherwise>
								    	${100*projectlist.consumed/(projectlist.consumed+projectlist.remain)}%
								    </c:otherwise>
								</c:choose>
								">
						      <small>
						      	<c:choose>
						      		<c:when test="${(projectlist.consumed+projectlist.remain) == 0}">0%</c:when>
								    <c:otherwise>
								    <fmt:formatNumber type="percent" maxFractionDigits="1" value="${projectlist.consumed/(projectlist.consumed+projectlist.remain)}" />
								    </c:otherwise>
								</c:choose>
						      </small>
						      </div>
						    </td>
					    	<td class="projectline text-left" values="${projectlist.burnStr}"></td>
				  			<td class='sort-handler' style="text-align:center"><i class="icon icon-move"></i></td>
				  		</tr>
				  	</c:forEach>
				  </tbody>
				  </c:if>
				  <tfoot>
				  	<tr>
				  		<c:if test="${projectPage.totalElements > 0}">
					  		<td colspan="10">
					  			<div class="table-actions clearfix">
		                        	<div class="checkbox btn">
		                        		<label><input type="checkbox" onclick="selectAll(this)" class="check-all check-btn"> 选择</label>
		                       		</div>
		                       		<div class="btn-group dropup">
		           						<button type="submit" class="btn btn-primary">批量编辑</button>              
		            				</div>
		       					</div>
		       					<div style="float:right; clear:none;" class="pager form-inline">
						        	共 <strong>${projectPage.totalElements}</strong> 条记录，
						        	<div class="dropdown dropup">
						        		<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
						        		<ul class="dropdown-menu">
							        		<c:forEach begin="5" end="50" step="5" var="i">
							        			<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_${i}_1'>${i}</a></li>
							        		</c:forEach>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_100_1'>100</a></li>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_200_1'>200</a></li>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_500_1'>500</a></li>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_1000_1'>1000</a></li>
							        		<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_2000_1'>2000</a></li>
							        	</ul>
							       	</div> 
							 		<strong>${projectPage.number + 1}/${projectPage.totalPages}</strong> &nbsp; 
							        	<c:choose>
							        		<c:when test="${projectPage.isFirst()}">
							        			<i class="icon-step-backward" title="首页"></i>
							        			<i class="icon-play icon-rotate-180" title="上一页"></i>
							        		</c:when>
							        		<c:otherwise>
												<a href="./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
							        			<a href="./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
											</c:otherwise>
								        </c:choose>
								        <c:choose>
							        		<c:when test="${projectPage.isLast()}">
							        			<i class="icon-play" title="下一页"></i>
							        			<i class="icon-step-forward" title="末页"></i>
							        		</c:when>
							        		<c:otherwise>
												<a href="./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
							        			<a href="./project_all_${projectId}_${status}_${orderBy}_${ascOrDesc}_${productId}_${projectPage.totalElements}_${recPerPage}_${projectPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
											</c:otherwise>
							        	</c:choose>
								</div>
					  		</td>
				  		</c:if>
				  		<c:if test="${projectPage.totalElements == 0}">
				  			<td colspan="10">
				  			<div style="float:right;">暂时没有记录</div>
				  			</td>
				  		</c:if>
				  	</tr>
				  </tfoot>
			  </table>
		  </form>
	  </div>
	</div>
</body>
</html>