<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<div id="featurebar">
<ul class="nav">
	<li class="w-150px">
		<a id="currentItem" href="javascript:" onclick="showDropMenu(this,'user')">
			${project.name} <span class="icon-caret-down"></span></a>
			<div id="dropMenu">
				<input type="text" class="form-control" id="search" value="" placeholder="搜索" onkeyup="search(this,'project')">
				<div id="searchResult">
  					<div id="defaultMenu" class="search-list">
    					<ul>
						</ul>
  					</div>
				</div>
			</div>
	</li>
	<li id="todoTab"><a href="">待办</a></li>
	<li id="storyTab"><a href="">需求</a></li>
	<li id="taskTab"><a href="">任务</a></li>
	<li id="bugTab"><a href="">缺陷</a></li>
	<li id="testTab"><a href="">测试</a></li>
	<li id="dynamicTab"><a href="">动态</a></li>
	<li id="projectTab"><a href="">项目</a></li>
	<li id="profileTab" class="active"><a href="">档案</a>
	</li>
</ul>
</div>
<script>
$(function(){
	loadUser();
})

function loadUser() {
	$.get("../getUser", function(data){
		if(!$.isEmptyObject(data)) {
			console.log(data);
			for(var i = 0; i < data.length; i++) {
				$("#account").append("<option value='"+ data[i].account +"'>"+ data[i].account +":"+data[i].realname+"</option>");
			}
			
		}
	})
}
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
	var no_result = "<li class='no-result-tip active'>找不到包含\"" + content +"\"的用户</li> ";
	var $ul = $next.find("div ul");
	
	if ("${currentProduct.type}" === "normal") {
		$(obj).closest("li").remove();
		return;
	}
	 	$.get("../getUser",function(data){ //暂时用admind代替
	 		var $next = $(obj).next();
	 		var $defaultMenuUl = $next.find("div#defaultMenu ul");
	 		var $defaultMenuDiv = $next.find("div#defaultMenu div");
	 		$next.find("div ul").empty();
	 		if (content === "") {
	 			if($("#moreMenu").length == 0)
	 				$(obj).next().find("div#defaultMenu").after("<div id='moreMenu'><ul></ul></div>");
	 			$defaultMenuDiv.show();
	 			for ( var i in data) {
					if (data[i] === "admin" && data[i][2] !== "done") {
						$defaultMenuUl.append("<li id='myCharges' class='heading'>我负责：</li>");
						$("#myCharges").after("<li><a href='" + subMenu + "_" + action + "_" + data[i][0] + "' class='mine text-important'><i class='icon-folder-close-alt'></i>" + data[i][1] + "</a></li>");
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
</script>