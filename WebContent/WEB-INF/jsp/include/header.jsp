<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<nav id="mainmenu" style="margin-top:0">
		<ul class="nav">
			<li data-id="my" <c:if test="${menu == 'my'}"> class="active"</c:if>><a href=""><i class="icon-home"></i><span> 我的地盘</span></a></li>
			<shiro:hasAnyRoles name="product,allview">
				<li <c:if test="${menu == 'product'}"> class="active"</c:if>><a href="${ctx}/product/story_browse_${sessionProductId}">产品</a></li>
			</shiro:hasAnyRoles>
			<shiro:hasAnyRoles name="project,allview">
				<li <c:if test="${fn:contains(ctxUri, '/project/')}"> class="active"</c:if>><a href="${ctxpj}/project_task_${sessionProjectId}">项目</a></li>
			</shiro:hasAnyRoles>
			<shiro:hasAnyRoles name="repo,allview">
				<li <c:if test="${fn:contains(ctxUri, '/repo/')}"> class="active"</c:if>><a href="${ctx}/repo/repo_browse">代码</a></li>
			</shiro:hasAnyRoles>
			<%-- <li <c:if test="${menu == 'qa'}"> class="active"</c:if>><a href="">测试</a></li>
			<li <c:if test="${menu == 'doc'}"> class="active"</c:if>><a href="">文档</a></li>
			<li <c:if test="${menu == 'doc'}"> class="active"</c:if>><a href="">统计</a></li> --%>
			<shiro:hasAnyRoles name="company,allview">
				<li <c:if test="${fn:contains(ctxUri, '/company')}"> class="active"</c:if>><a href="${ctx}/company/company_browse">组织</a></li>
			</shiro:hasAnyRoles>
<%-- 			<li <c:if test="${menu == 'admin'}"> class="active"</c:if>><a href="">后台</a></li> --%>
<!-- 			<li class="custom-item"><a href="#" data-type="iframe" title="自定义导航" data-icon="cog" data-width="80%"><i class="icon icon-cog"></i></a></li> -->
			<li class="right"><a href="${ctx}/logout">退出</a></li>
		</ul>
		<div class="input-group input-group-sm" id="searchbox">
			<div class="input-group-btn" id="typeSelector" >
				<button type="button" class="btn dropdown-toggle" data-toggle="dropdown">
				<span id="searchTypeName">项目</span> 
				<span class="caret"></span>
				</button>
				<input type="hidden" name="searchType" id="searchType" value="product">
			</div>
			<input type="text" name="searchQuery" id="searchQuery" value=""
			 onkeydown="if(event.keyCode==13) shortcut()" class="form-control" placeholder="">
			<div id="objectSwitcher" class="input-group-btn">
				<a href="javascript:shortcut();" class="btn">搜索</a>
			</div>
		</div>
	</nav>
