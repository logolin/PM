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
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<script>
$(document).ready(function() {
	$('table.datatable').datatable({
			sortable: true,
			storage: true,
			colHover: false,
			});
});
</script>
<title>${project.name}::动态</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="featurebar">
				<nav class="nav">
				  	<li <c:if test="${condition == 'today'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_today_${orderBy}_${ascOrDesc}_${recPerPage}_1">今天</a></li>
					<li <c:if test="${condition == 'yesterday'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_yesterday_${orderBy}_${ascOrDesc}_${recPerPage}_1">昨天</a></li>
					<li <c:if test="${condition == 'twodaysago'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_twodaysago_${orderBy}_${ascOrDesc}_${recPerPage}_1">前天</a></li>
					<li <c:if test="${condition == 'thisweek'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_thisweek_${orderBy}_${ascOrDesc}_${recPerPage}_1">本周</a></li>
					<li <c:if test="${condition == 'lastweek'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_lastweek_${orderBy}_${ascOrDesc}_${recPerPage}_1">上周</a></li>
					<li <c:if test="${condition == 'thismonth'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_thismonth_${orderBy}_${ascOrDesc}_${recPerPage}_1">本月</a></li>
					<li <c:if test="${condition == 'lastmonth'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_lastmonth_${orderBy}_${ascOrDesc}_${recPerPage}_1">上月</a></li>
					<li <c:if test="${condition == 'all'}">class="active"</c:if>><a href="./project_dynamic_${projectId}_all_${orderBy}_${ascOrDesc}_${recPerPage}_1">所有</a></li>
					<li class="w-150px">
						<select name='account' id='account' onchange="changeUser(this.value)" class="chosen-select form-control">
							<option value=""></option>
							<c:forEach items="${userMap}" var="user">
								<option value="${user.key}" <c:if test="${condition == user.key}">selected</c:if>>${user.value}</option>
							</c:forEach>
						</select>
					</li>  
				</nav>
			</div>
			<form id="productplanForm">
			<table id="myTable" class="table table-condensed table-striped">
			  	<thead>
				    <tr>
				      	<th data-width="150" <c:if test="${orderBy == 'date'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>日期</th>
				      	<th data-width="80" <c:if test="${orderBy == 'actor'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>操作者</th>
				      	<th data-width="100" <c:if test="${orderBy == 'action'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>动作</th> 
				      	<th data-width="90" <c:if test="${orderBy == 'objectType'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>对象类型</th>
				      	<th data-width="70" <c:if test="${orderBy == 'objectId'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
				      	<th data-sort="false">对象名称</th>
				    </tr>
			   </thead>
			   <tbody>
			   		<c:forEach items="${actionPage.content}" var="action">
					<tr class="text-center">
					    <td><fmt:formatDate value="${action.date}" pattern="MM月dd日 HH:mm"/></td>
					    <td>${userMap[action.actor]}</td>
					    <td>${actionMap[action.action]}</td>
					    <td>${objectTypeMap[action.objectType]}</td>
					    <td>${action.objectId}</td>
					    <td class="text-left" data-sort="false">
					    	<c:choose>
					    		<c:when test="${action.objectType == 'bug'}"><shiro:hasPermission name="bug:view">${action.objectName}</shiro:hasPermission></c:when>
					    		<c:when test="${action.objectType == 'story'}"><shiro:hasPermission name="story:view"><a href="#" onclick="storyView(${action.objectId})">${action.objectName}</a></shiro:hasPermission></c:when>
					    		<c:when test="${action.objectType == 'task'}"><shiro:hasPermission name="task:view"><a href="./task_view_${action.objectId}_${action.project}"></shiro:hasPermission>${action.objectName}<shiro:hasPermission name="task:view"></a></shiro:hasPermission></c:when>
					    		<c:when test="${action.objectType == 'build'}"><shiro:hasPermission name="build:view"><a href="./build_view_${action.objectId}_${action.project}"></shiro:hasPermission>${action.objectName}<shiro:hasPermission name="build:view"></a></shiro:hasPermission></c:when>
					    		<c:otherwise><shiro:hasPermission name="bug:view"><a href="./${action.objectType}_view_${action.objectId}">${action.objectName}</a></shiro:hasPermission></c:otherwise>
					    	</c:choose>
					    </td>
					</tr>
					</c:forEach>		   
			   </tbody>
			   <tfoot>
	    			<tr>
			      		<td colspan="6">
			          		<c:if test="${actionPage.totalElements != 0}">
			        		<div style="float:right; clear:none;" class="pager form-inline">
			        			共 <strong>${actionPage.totalElements}</strong> 条记录，
			        			<div class="dropdown dropup">
			        				<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
			        				<ul class="dropdown-menu">
			        					<c:forEach begin="5" end="50" step="5" var="i">
			        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
			        					</c:forEach>
			        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
			        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
			        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
			        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
			        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
			        				</ul>
			        			</div> 
			        			<strong>${actionPage.number + 1}/${actionPage.totalPages}</strong> &nbsp; 
			        			<c:choose>
			        				<c:when test="${actionPage.isFirst()}">
			        					<i class="icon-step-backward" title="首页"></i>
			        					<i class="icon-play icon-rotate-180" title="上一页"></i>
			        				</c:when>
			        				<c:otherwise>
										<a href="./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
			        					<a href="./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
									</c:otherwise>
			        			</c:choose>
			        			<c:choose>
			        				<c:when test="${actionPage.isLast()}">
			        					<i class="icon-play" title="下一页"></i>
			        					<i class="icon-step-forward" title="末页"></i>
			        				</c:when>
			        				<c:otherwise>
										<a href="./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
			        					<a href="./project_dynamic_${projectId}_${condition}_${orderBy}_${ascOrDesc}_${recPerPage}_${actionPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
									</c:otherwise>
			        			</c:choose>
							</div>   
							</c:if>
							<c:if test="${actionPage.totalElements == 0}"> 
								<div style="float:right; clear:none;" class="page">暂时没有记录</div>
							</c:if>  
						</td>
			    	</tr>			   	
			   </tfoot>
			</table>
			</form>
  		</div>
	</div>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',   
	    search_contains: true,      
	    allow_single_deselect: true
	});
	$('#myTable').datatable({
		storage: false,
		sortable: true, 
		colHover: false,
		sort: function(event) {
			var s = ['date','actor','action','objectType','objectId'];
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./project_dynamic_${projectId}_${condition}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${recPerPage}_${page}";
			}
		}
	});
	fixedTfootAction('#productplanForm');
});
function changeUser(account)
{
    location.href = account == '' ? "./project_dynamic_${projectId}_all_${orderBy}_${ascOrDesc}_${recPerPage}_${page}" : "./project_dynamic_${projectId}_" + account + "_${orderBy}_${ascOrDesc}_${recPerPage}_${page}";
}
function fixedTfootAction(a) {
    if ($(a).size() == 0) {
        return false
    }
    if ($(a).find("table:last").find("tfoot").size() == 0) {
        return false
    }
    c();
    $(window).scroll(h);
    $(".side-handle").click(function() {
        setTimeout(c, 300)
    });
    var f, e, g, d, j, b;
    function h() {
        f = $(a).find("table:last");
        e = f.find("tfoot");
        d = f.width();
        b = e.hasClass("fixedTfootAction");
        offsetHeight = $(window).height() + $(window).scrollTop();
        j = f.offset().top + f.height() - e.height() / 5;
        g = e.find(".table-actions").children(".input-group");
        if (!b && offsetHeight <= j) {
            e.addClass("fixedTfootAction");
            e.width(d);
            e.find("td").width(d);
            if (g.size() > 0) {
                g.width(g.width())
            }
        }
        if (b && (offsetHeight > j || $(document).height() == offsetHeight)) {
            e.removeClass("fixedTfootAction");
            e.removeAttr("style");
            e.find("td").removeAttr("style")
        }
    }
    function c() {
        e = $(a).find("table:last").find("tfoot");
        if (e.hasClass("fixedTfootAction")) {
            e.removeClass("fixedTfootAction")
        }
        h()
    }
}

function storyView(storyId) {
	$.get("../getStoryProduct_" + storyId, function(data){
		
		location.href="${ctx}/product/story_view_" + data +"_" + storyId;
	})
	
}
</script>
</body>
</html>