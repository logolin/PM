<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<nav id="modulemenu">
    <ul class="nav">
		<li data-id="name">力德科技<i class="icon-angle-right"></i> </li>
		<shiro:hasPermission name="company:browse">
			<li <c:if test="${fn:contains(ctxUri, '/company_browse')}"> class="active"</c:if>><a href="${ctx}/company/company_browse">用户</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="dept:browse">
			<li <c:if test="${fn:contains(ctxUri, '/dept_browse')}"> class="active"</c:if>><a href="${ctx}/company/dept_browse">部门</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="group:managePriv">
			<li <c:if test="${fn:contains(ctxUri, '/group')}"> class="active"</c:if>><a href="${ctx}/company/group_browse">权限</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="company:view">
			<li <c:if test="${fn:contains(ctxUri, '/company_view')}"> class="active"</c:if>><a href="${ctx}/company/company_view">公司</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="company:dynamic">
			<li <c:if test="${fn:contains(ctxUri, '/company_dynamic')}"> class="active"</c:if>><a href="${ctx}/company/company_dynamic">动态</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="group:create">
			<li class="right "><a href="${ctx}/company/group_create"><i class="icon-group"></i> 添加分组</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="user:batchCreate">
			<li class="right "><a href="${ctx}/company/user_batchCreate"><i class="icon-plus-sign"></i> 批量添加</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="user:create">
			<li class="right "><a href="${ctx}/company/user_create_0"><i class="icon-plus"></i> 添加用户</a></li>
		</shiro:hasPermission>
	</ul>
</nav>