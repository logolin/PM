<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
var uri = window.location.pathname.split(/\/|_/,5);
var subMenu = uri[3];
var action = uri[4];
$(function(){
	$("#currentItem").mouseup(function(event){
		event.stopPropagation();
	});
	$("#" + subMenu).addClass("active");
})

function showDropMenu(obj,type) {
	var $dropMenu = $(obj).next();
	if ($dropMenu.css("display") == "none") {
		search($dropMenu.find("#search"),type);
		$dropMenu.slideToggle(300).find("input").focus();
		$(document).mouseup(function (e){
		    if (!$dropMenu.is(e.target) && $dropMenu.has(e.target).length === 0) 
		    {
		    	$dropMenu.slideToggle(300);
		    	$(document).off("mouseup");
		    }
		});
	} else {
		$dropMenu.slideToggle(300);
		$(document).off("mouseup");
	}
}

function search(obj,type) {
	var content = $(obj).val();
	var $next = $(obj).next();
	var no_result = "<li class='no-result-tip active'>找不到包含\"" + content +"\"的项目</li> ";
	var $ul = $next.find("div ul");
	
	if ("${currentProduct.type}" === "normal") {
		$(obj).closest("li").remove();
		return;
	}
	 	$.get("../ajaxGetProjects/${userAccount}",{content:content},function(data){
	 		var $next = $(obj).next();
	 		var $defaultMenuUl = $next.find("div#defaultMenu ul");
	 		var $defaultMenuDiv = $next.find("div#defaultMenu div");
	 		$next.find("div ul").empty();
	 		if (content === "") {
	 			if($("#moreMenu").length == 0)
	 				$(obj).next().find("div#defaultMenu").after("<div id='moreMenu'><ul></ul></div>");
	 			$defaultMenuDiv.show();
	 			for ( var i in data) {
					if (data[i][3] === "${userAccount}" && data[i][2] !== "done") {
						if($defaultMenuUl.has("#myCharges").length === 0)
							$defaultMenuUl.append("<li id='myCharges' class='heading'>我负责：</li>");
						$("#myCharges").after("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='mine text-important'><i class='icon-folder-close-alt'></i>" + data[i][1] + "</a></li>");
					} else if(data[i][3] !== "${userAccount}" && data[i][2] !== "done") {
						if($defaultMenuUl.has("#other").length === 0)
							$defaultMenuUl.append("<li id='other' class='heading'>其他：</li>");
						$("#other").after("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='other text-special'><i class='icon-folder-close-alt'></i>" + data[i][1] + "</a></li>");
					} else {
						/* if(subMenu == "build") {
							$("#moreMenu ul").append("<li><a href='" + subMenu + "_" + action + "_${currentProjectId}"' class='closed'><i class='icon-folder-close-alt'></i>" + data[i][1] + "</a></li>");
						} else { */
							$("#moreMenu ul").append("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='closed'><i class='icon-folder-close-alt'></i>" + data[i][1] + "</a></li>");
// 						}
					}
				}
	 		} else {
	 			$defaultMenuDiv.hide();
	 			$("#moreMenu").remove();
	 			if (data.length == 0) 
					$defaultMenuUl.append(no_result);
	 			for ( var i in data) {
	 				$defaultMenuDiv.toggle();
	 				$defaultMenuUl.append("<li><a href='' class='" + data[i][2] + "'><i class='icon-cube-alt'></i>" + data[i][1] + "</a></li>");
				}
	 		}
		}); 
}
function switchMore() {
    $("#currentItem + div #search").width($("#currentItem + div #search").width()).focus();
    $("#moreMenu").width($("#defaultMenu").outerWidth());
    $("#searchResult").toggleClass("show-more")
}
</script>
<nav id="modulemenu">
    <ul class="nav">
    	<c:if test="${projectId != 0}">
			<li data-id="list">
				<a id="currentItem" href="javascript:" onclick="showDropMenu(this,'project')">
				${project.name} <span class="icon-caret-down"></span></a>
				<div id="dropMenu">
					<input type="text" class="form-control" id="search" value="" placeholder="搜索" onkeyup="search(this,'project')">
					<div id="searchResult">
	  					<div id="defaultMenu" class="search-list">
	    					<ul>
							</ul>
							<div>
	      						<a href="${ctxpj}/project_all_undone_${project.id}_id_asc_0_0_10_1"><i class="icon-cubes mgr-5px"></i> 全部项目</a>
	            				<div class="pull-right actions">
	            					<a id="more" href="javascript:switchMore()">已结束 <i class="icon-angle-right"></i></a>
	            				</div>
	          				</div>
	  					</div>
					</div>
				</div>
			</li>
		</c:if>
		<shiro:hasPermission name="project:task">
			<li data-id="task" <c:if test="${fn:contains(ctxUri, '/project_task')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_task_${project.id}_unclosed</c:if>" >任务</a> </li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:story">
			<li data-id="story" <c:if test="${fn:contains(ctxUri, 'story')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_story_${projectId}</c:if>">需求</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:bug">
			<li data-id="bug" <c:if test="${fn:contains(ctxUri, '/project_bug')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_bug_${projectId}</c:if>" >Bug</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:build">
			<li data-id="build" <c:if test="${fn:contains(ctxUri, '/project_build')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_build_${projectId}</c:if>" >版本</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:testtask">
			<li data-id="testtask" <c:if test="${fn:contains(ctxUri, '/project_testtask')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_testtask_${projectId}</c:if>">测试</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:team">
			<li data-id="team" <c:if test="${fn:contains(ctxUri, '/project_team')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_team_${projectId}</c:if>">团队</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:dynamic">
			<li data-id="dynamic" <c:if test="${fn:contains(ctxUri, '/project_dynamic')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_dynamic_${projectId}</c:if>">动态</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="doc:browse">
			<li data-id="doc" <c:if test="${fn:contains(ctxUri, '/project_doc')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_doc_${projectId}</c:if>">文档</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:manageProducts">
			<li data-id="product" <c:if test="${fn:contains(ctxUri, '/project_product')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_manageproducts_${projectId}</c:if>">产品</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:view">
			<li data-id="view" <c:if test="${fn:contains(ctxUri, '/project_view')}">class="active"</c:if>><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_view_${projectId}</c:if>">概况</a></li>
		</shiro:hasPermission>
		<%-- <shiro:hasPermission name="project:index">
			<li class="right " data-id="index"><a href="${ctxpj}/project_index_${project.id}"><i class='icon-home'></i> 项目主页</a></li>
		</shiro:hasPermission> --%>
		<shiro:hasPermission name="project:create">
		  	<li class="right " data-id="create"><a href="${ctxpj}/project_create_${projectId}"><i class='icon-plus'></i> 添加项目</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="project:all">
			<li class="right " data-id="all"><a href="${ctxpj}/<c:if test='${projectId == 0}'>project_create_0</c:if><c:if test='${projectId != 0}'>project_all_${projectId}_undone</c:if>"><i class='icon-th-large'></i> 所有项目</a></li>
		</shiro:hasPermission>
	</ul>
</nav>