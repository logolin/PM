<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<nav id="modulemenu">
    <ul class="nav">
		<li data-id="list"><i class="icon-angle-right"></i></li>
		<li class=" " data-id="browse"><a href="/pro/repo-browse-.html">浏览</a>
		</li>
		<li class=" " data-id="review"><a href="/pro/repo-review-.html">评审</a>
		</li>
		<li class=" " data-id="settings"><a href="/pro/repo-settings-.html">设置</a>
		</li>
		<li class=" " data-id="delete"><a href="/pro/repo-delete-.html" target="hiddenwin">删除</a>
		</li>
		<li class="right " data-id="create"><a href="/pro/repo-create.html"><i class="icon-plus icon-large"></i> 新增版本库</a>
		</li>
	</ul>
</nav>