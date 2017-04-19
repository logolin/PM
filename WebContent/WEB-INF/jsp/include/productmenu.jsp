<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<script type="text/javascript">
var uri = window.location.pathname.split(/\/|_/,5);
var subMenu = uri[3];
var action = uri[4];
$(function(){
	$("#currentBranch,#currentItem").mouseup(function(event){
		event.stopPropagation();
	});
	$("#_" + subMenu).addClass("active");
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
	var no_result = "<li class='no-result-tip active'>找不到包含\"" + content +"\"的相关项</li> ";
	var $ul = $next.find("div ul");
	if (type == "branch") {
		$.get("../ajaxGetBranches/${currentProduct.id}",{content:content},function(data){
			$ul.empty();
			if (data.length === 1 && content !== "") 
				$ul.append(no_result);
			for (var i = 0; i < data.length; i++) {
				if(content === "") {
					$ul.append("<li><a href='" + subMenu + "_" + action + "_${currentProduct.id}_" + data[i].id + "' class='text-important'><i class='icon icon-node'></i> " + data[i].name + "</a></li>")
				} else {
					if (data[i].id == 0)
						continue;
					$ul.append("<li><a href=''><i class='icon icon-node'></i> " + data[i].name + "</a></li>");
				}
			}
		});
	} else {
 		var $defaultMenuUl = $next.find("div#defaultMenu ul");
 		var $defaultMenuDiv = $next.find("div#defaultMenu div");
	 	$.get("../ajaxGetProducts/${userAccount}",{content:content},function(data){
	 		$ul.empty();
	 		if (content === "") {
	 			if($("#moreMenu").length == 0)
	 				$next.find("div#defaultMenu").after("<div id='moreMenu'><ul></ul></div>");
	 			$defaultMenuDiv.show();
	 			for ( var i in data) {
					if (data[i][3] === "${userAccount}" && data[i][2] === "normal") {
						if($defaultMenuUl.has("#myCharges").length === 0)
							$defaultMenuUl.append("<li id='myCharges' class='heading'>我负责：</li>");
						$("#myCharges").after("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='mine text-important'><i class='icon-cube-alt'></i>" + data[i][1] + "</a></li>");
					} else if(data[i][3] !== "${userAccount}" && data[i][2] === "normal") {
						if($defaultMenuUl.has("#other").length === 0)
							$defaultMenuUl.append("<li id='other' class='heading'>其他：</li>");
						$("#other").after("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='other text-special'><i class='icon-cube-alt'></i>" + data[i][1] + "</a></li>");
					} else {
						$("#moreMenu ul").append("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='closed'><i class='icon-cube-alt'></i>" + data[i][1] + "</a></li>");
					}
				}
	 		} else {
	 			$defaultMenuDiv.hide();
	 			$("#moreMenu").remove();
				if (data.length == 0) 
					$defaultMenuUl.append(no_result);
	 			for ( var i in data) {
	 				$defaultMenuDiv.toggle();
	 				$defaultMenuUl.append("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='" + data[i][2] + "'><i class='icon-cube-alt'></i>" + data[i][1] + "</a></li>");
				}
	 		}
		}); 
	}
}
function switchMore() {
    $("#currentItem + div #search").width($("#currentItem + div #search").width()).focus();
    $("#moreMenu").width($("#defaultMenu").outerWidth());
    $("#searchResult").toggleClass("show-more")
}
</script>
<nav id="modulemenu">
    <ul class="nav">
    	<c:if test="${productId != 0}">
			<li data-id="list">
				<a id="currentItem" href="javascript:" onclick="showDropMenu(this,'product')">
				${currentProduct.name} <span class="icon-caret-down"></span></a>
				<div id="dropMenu">
					<input type="text" class="form-control" id="search" value="" placeholder="搜索" onkeyup="search(this,'product')">
					<div id="searchResult">
	  					<div id="defaultMenu" class="search-list">
	    					<ul>
							</ul>
	 						<div>
	 							<shiro:hasPermission name="product:all">
	      							<a href="./product_browse_${currentProduct.id}"><i class="icon-cubes mgr-5px"></i> 全部产品</a>
	      						</shiro:hasPermission>
	            					<div class="pull-right actions">
	            						<a id="more" href="javascript:switchMore()">已关闭 <i class="icon-angle-right"></i></a>
	            					</div>
	          				</div>
	  					</div>
					</div>
				</div>
			</li>
			<c:if test="${currentProduct.type != 'normal' && branchId != null}">
			<li class="">
				<a id="currentBranch" href="javascript:" onclick="showDropMenu(this,'branch')"><c:if test="${branchId == 0}">所有</c:if>${branchMap[branchId]} <span class="icon-caret-down"></span></a>
				<div id="dropMenu">
					<input type="text" class="form-control" id="search" value="" placeholder="搜索" onkeyup="search(this,'branch')">
					<div id="searchResult">
			  			<div id="defaultMenu" class="search-list">
			    			<ul>   
							</ul>
			  			</div>
					</div>
				</div>
			</li>	
			</c:if>	
		</c:if>	
		<li id="_story"><a href="./story_browse_${productId}">需求</a></li>
		<shiro:hasPermission name="product:dynamic">
			<li id="_dynamic"><a href="./dynamic_browse_${productId}">动态</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="plan:browse">
			<li id="_plan"><a href="./plan_browse_${productId}">计划</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="release:browse">
			<li id="_release"><a href="./release_browse_${productId}">发布</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="product:roadmap">
			<li id="_roadmap"><a href="./roadmap_browse_${productId}">路线图</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="doc:browse">
			<li id="_doc"><a href="./doc_browse_${productId}">文档</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="product:project">
			<li id="_project"><a href="./project_browse_${productId}">项目</a></li>
		</shiro:hasPermission>
		<c:if test="${productId != 0 && currentProduct.type != 'normal'}">
			<shiro:hasPermission name="branch:manage">
				<li id="_branch"><a href="./branch_manage_${productId}" ><c:if test="${currentProduct.type == 'branch'}">分支</c:if><c:if test="${currentProduct.type == 'platform'}">平台</c:if></a></li>
			</shiro:hasPermission>
		</c:if>
		<shiro:hasPermission name="tree:browse">
			<li id="_module"><a href="./module_manage_${productId}">模块</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="product:view">
			<li id="_product"><a href="./product_view_${productId}">概况</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="product:create">
			<li class="right " data-id="create"><a href="./product_create_${productId}"><i class="icon-plus"></i>&nbsp;添加产品</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="product:all">
			<li class="right " data-id="all"><a href="./product_browse_${productId}"><i class="icon-cubes"></i>&nbsp;所有产品</a></li>
		</shiro:hasPermission>
		<%-- <shiro:hasPermission name="product:index">
			<li class="right " data-id="index"><a href="./product"><i class="icon-home"></i>产品主页</a></li>
		</shiro:hasPermission> --%>
	</ul>
</nav>