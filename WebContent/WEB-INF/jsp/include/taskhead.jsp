<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<shiro:hasPermission name="project:task">
<div id="featurebar">
		  <ul class="nav">
		  	<c:if test="${statusId == 0 || statusId == null}">
		    	<li><div class="label-angle">所有模块      </div></li>
		    </c:if>
		    <c:if test="${statusId != 0 && statusId != null}">
		    	<li><div class="label-angle with-close"><a href="./project_task_${project.id}" class="text-muted"><i class="icon icon-remove"></i></a></div></li>
            </c:if>
            <li <c:if test="${fn:contains(ctxUri, '/unclosed')}">class="active"</c:if>><a href="${ctxpj}/project_task_${project.id}_unclosed">未关闭</a>
			</li>
            <li <c:if test="${fn:contains(ctxUri, '/all')}">class="active"</c:if>><a href="${ctxpj}/project_task_${project.id}_all">所有</a>
			</li>
            <li><a href="${ctxpj}/project_task_${project.id}_delayed">已延期</a>
			</li>
            <li><a href="${ctxpj}/project_task_${project.id}_needconfirm">需求变动</a>
			</li>
			<li id="statusTab" class="dropdown">
				<a data-toggle="dropdown">更多 <span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="${ctxpj}/project_task_${project.id}_wait">未开始</a></li>
					<li><a href="${ctxpj}/project_task_${project.id}_doing">进行中</a></li>
					<li><a href="${ctxpj}/project_task_${project.id}_finishedbyme">我完成</a></li>
					<li><a href="${ctxpj}/project_task_${project.id}_done">已完成</a></li>
					<li><a href="${ctxpj}/project_task_${project.id}_closed">已关闭</a></li>
					<li><a href="${ctxpj}/project_task_${project.id}_cancel">已取消</a></li>
				</ul>
			</li>
			<shiro:hasPermission name="project:kanban">
		    <li><a href="${ctxpj}/project_kanban_${project.id}-pri_asc">看板</a></li>
			</shiro:hasPermission>
			<shiro:hasPermission name="project:burn">
		    <li><a href="${ctxpj}/project_burn_${project.id}">燃尽图</a></li>
		    </shiro:hasPermission>
		    <shiro:hasPermission name="project:tree">
		    <li><a href="${ctxpj}/project_tree_${project.id}">树状图</a>
			</li>
			</shiro:hasPermission>
		    <li class="dropdown">
				<a href="#" data-toggle="dropdown">分组查看 <span class="caret"></span></a>
			    <ul class="dropdown-menu">
			    	<li <c:if test="${grouptype == 'story'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_story_all">需求分组</a></li>
			    	<li <c:if test="${grouptype == 'status'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_status_all">状态分组</a></li>
					<li <c:if test="${grouptype == 'pri'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_pri_all">优先级分组</a></li>
					<li <c:if test="${grouptype == 'assignedTo'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_assignedTo_undone">指派给分组</a></li>
					<li <c:if test="${grouptype == 'finishedBy'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_finishedBy_done">完成者分组</a></li>
					<li <c:if test="${grouptype == 'closedBy'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_closedBy_closed">关闭者分组</a></li>
					<li <c:if test="${grouptype == 'type'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_type_all">类型分组</a></li>
					<li <c:if test="${grouptype == 'deadlines'}">class="active"</c:if>><a href="${ctxpj}/project_group_${project.id}_deadline_all">截止分组</a></li>
				</ul>
			</li>
			<li><a href="#"><i class="icon-search icon"></i>搜索</a>
			</li>
		  </ul>
		  <div class="actions">
		    <div class="btn-group">
		      <div class="btn-group">
		      </div>
		      	<shiro:hasPermission name="task:report">
		      		<a href="#" class="btn create-story-btn"><i class="icon-common-report icon-bar-chart"></i>报表</a>
		        </shiro:hasPermission>
		        <shiro:hasPermission name="task:export">
		        	<a href="#" class="btn create-story-btn"><i class="icon-download-alt">导出</i> </a>
		        </shiro:hasPermission>
		        <a href="#" class="btn "><i class="icon-upload-alt"></i>导入</a>
		        <shiro:hasPermission name="task:batchCreate">
		        	<a href="${ctxpj}/task_batchCreate_${project.id}" class="btn "><i class="icon-task-batchCreate icon-plus-sign"></i>批量添加</a>
		        </shiro:hasPermission>
		        <shiro:hasPermission name="task:create">
		        	<a href="${ctxpj}/task_create_${project.id}" class="btn "><i class="icon-task-create icon-sitemap"></i>建任务</a>
		    	</shiro:hasPermission>
		    </div>
		  </div>
		  <div id="querybox" class=""></div>
		</div>
</shiro:hasPermission>