<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<title>项目概况</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div>
				<div id="titlebar">
					<div class="heading" style="padding-right: 258px;">
					    <span class="prefix">
					    	<i class="icon-folder-close-alt"></i> <strong>${project.id}</strong>
					    </span>
					    	<strong>${project.id}</strong>
					</div>
					<div class="actions">
						<div class="btn-group">
							<shiro:hasPermission name="project:start">
								<c:if test="${project.status == 'wait'}">
									<a type="button" data-width="900px" class="btn iframe" title="开始"  data-iframe="./projects_start_${project.id}" data-show-header="false" data-toggle="modal">
										<i class="icon-project-start icon-play"></i> 开始
									</a>
								</c:if>
							</shiro:hasPermission>
							<shiro:hasPermission name="project:putoff">
								<c:if test="${project.status == 'wait' || project.status == 'doing'}">
									<a type="button" data-width="900px" class="btn iframe" title="延期" data-iframe="./projects_delay_${project.id}" data-show-header="false" data-toggle="modal">
										<i class="icon-project-putoff icon-calendar"></i> 延期
									</a>
								</c:if>
							</shiro:hasPermission>
							<shiro:hasPermission name="project:suspend">
								<c:if test="${project.status == 'wait' || project.status == 'doing'}">
									<a type="button" data-width="900px" class="btn iframe" title="挂起" data-iframe="./projects_suspend_${project.id}" data-show-header="false" data-toggle="modal">
										<i class="icon-project-suspend icon-pause"></i> 挂起
									</a>
								</c:if>
							</shiro:hasPermission>
							<shiro:hasPermission name="project:activate">
								<c:if test="${project.status == 'suspended' || project.status == 'done'}">
									<a type="button" data-width="900px" class="btn iframe" title="激活" data-iframe="./projects_activate_${project.id}" data-show-header="false" data-toggle="modal">
										<i class="icon-project-suspend icon-pause"></i> 激活
									</a>
								</c:if>
							</shiro:hasPermission>
							<shiro:hasPermission name="project:close">
								<c:if test="${project.status == 'wait' || project.status == 'suspended' || project.status == 'doing'}">
									<a type="button" data-width="900px" class="btn iframe" title="结束" data-iframe="./projects_close_${project.id}" data-show-header="false" data-toggle="modal">
										<i class="icon-project-close icon-off"></i> 结束
									</a>
								</c:if>
							</shiro:hasPermission>
						</div>
						<div class="btn-group">
							<shiro:hasPermission name="project:edit">
								<a href="${ctxpj}/project_edit_${project.id}" class="btn" title="编辑项目">
									<i class="icon-common-edit icon-pencil"></i>
								</a>
							</shiro:hasPermission>
						</div>
							<a href="javascript:void(0)" onclick="history.go(-1)" class="btn" title="返回">
							<i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
					</div>
				</div>
			</div>
			<div class="row-table">
				<div class="col-main">
					<div class="main">
						<fieldset>
					    	<legend>项目描述</legend>
					        <div class="content">${prkject.descript}</div>
					      </fieldset>
						<%@ include file="/WEB-INF/jsp/include/history.jsp"%> 
					  	<fieldset id="actionbox" class="actionbox">
			    			<legend>
			      				<i class="icon-time"></i>历史记录
			      				<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
			      				<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
			    			</legend>
		  					<ol id="historyItem">
		  						<c:forEach items="${actionList}" var="action" varStatus="i">
		  							<li>
					            		<span class="item">
					              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}。
					            			<c:if test="${action.histories.size() != 0}"><a id="switchButton${i.index + 2}" class="switch-btn btn-icon" onclick="switchChange(${i.index + 2})" href="javascript:;"><i class="icon- change-show"></i></a></c:if>
					            		</span>
					            		<c:if test="${action.comment != ''}"><div class="history"></c:if>
						          			<div class="changes hide alert" id="changeBox${i.index + 2}" style="display: none;">
						          				<c:if test="${action.histories.size() != 0}">
							          				<c:forEach items="${action.histories}" var="history">
					        	  						修改了 <strong><i>${fieldNameMap[history.field]}</i></strong>，旧值为 "${history.oldValue}"，新值为 "${history.newValue}"。<br>
					        						</c:forEach>
				        						</c:if>
				        					</div>
				        					<c:if test="${i.last && action.comment != ''}"><span class="pull-right comment${action.id}"><a href="javascript:toggleComment(${action.id})" class="btn btn-mini" style="border:none"><i class="icon-pencil"></i></a></span></c:if>
			        						<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
					          				<c:if test="${i.last && action.comment != ''}">
						          				<div class="hide" id="lastCommentBox">
		          									<form method="post" action="./action_editProjectComment_${projectId}_${action.id}">
		            									<table align="center" class="table table-form bd-0">
		              										<tbody>
		              											<tr>
		              												<td style="padding-right: 0">
		              													<textarea name="lastComment" id="lastComment" rows="5" class="form-control">${action.comment}</textarea>
																	</td>
																</tr>
		              											<tr>
		              												<td> 
		              													<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button><a href="javascript:toggleComment(${action.id})" class="btn">返回</a>
																	</td>
																</tr>
											            	</tbody>
										           		</table>
													</form>
										        </div>
									        </c:if>
				          				<c:if test="${action.comment != ''}"></c:if>
				          			</li>
		  						</c:forEach>
		        			</ol>		
			  			</fieldset>
						<div class="actions"> 
							<div class="btn-group">
								<shiro:hasPermission name="project:start">
									<c:if test="${project.status == 'wait'}">
										<a type="button" data-width="900px" class="btn iframe" title="开始"  data-iframe="./projects_start_${project.id}" data-show-header="false" data-toggle="modal">
											<i class="icon-project-start icon-play"></i> 开始
										</a>
									</c:if>
								</shiro:hasPermission>
								<shiro:hasPermission name="project:putoff">
									<c:if test="${project.status == 'wait' || project.status == 'doing'}">
										<a type="button" data-width="900px" class="btn iframe" title="延期" data-iframe="./projects_delay_${project.id}" data-show-header="false" data-toggle="modal">
											<i class="icon-project-putoff icon-calendar"></i> 延期
										</a>
									</c:if>
								</shiro:hasPermission>
								<shiro:hasPermission name="project:suspend">
									<c:if test="${project.status == 'wait' || project.status == 'doing'}">
										<a type="button" data-width="900px" class="btn iframe" title="挂起" data-iframe="./projects_suspend_${project.id}" data-show-header="false" data-toggle="modal">
											<i class="icon-project-suspend icon-pause"></i> 挂起
										</a>
									</c:if>
								</shiro:hasPermission>
								<shiro:hasPermission name="project:activate">
									<c:if test="${project.status == 'suspended' || project.status == 'done'}">
										<a type="button" data-width="900px" class="btn iframe" title="激活" data-iframe="./projects_activate_${project.id}" data-show-header="false" data-toggle="modal">
											<i class="icon-project-suspend icon-pause"></i> 激活
										</a>
									</c:if>
								</shiro:hasPermission>
								<shiro:hasPermission name="project:close">
									<c:if test="${project.status == 'wait' || project.status == 'suspended' || project.status == 'doing'}">
										<a type="button" data-width="900px" class="btn iframe" title="结束" data-iframe="./projects_close_${project.id}" data-show-header="false" data-toggle="modal">
											<i class="icon-project-close icon-off"></i> 结束
										</a>
									</c:if>
								</shiro:hasPermission>
							</div>
							<div class="btn-group">
								<shiro:hasPermission name="project:edit">
									<a href="${ctxpj}/project_edit_${project.id}" class="btn " title="编辑项目">
										<i class="icon-common-edit icon-pencil"></i>
									</a>
								</shiro:hasPermission>
							</div>
							<a href="javascript:void(0)" onclick="history.go(-1)" class="btn" title="返回">
							<i class="icon-goback icon-level-up icon-large icon-rotate-270"></i>
							</a>
						</div>
					</div>
				</div>
				<div class="col-side">
					<div class="main main-side">
						<fieldset>
					    	<legend>基本信息</legend>
						        <table class="table table-data table-condensed table-borderless">
						          <tbody>
						          <tr>
						            <th class="w-80px text-right strong">项目名称</th>
						            <td>${project.name}</td>
						          </tr>
						          <tr>
						            <th>项目代号</th>
						            <td>${project.code}</td>
						          </tr>
						          <tr>
						            <th>起止时间</th>
						            <td>${project.begin} ~ ${project.end}</td>
						          </tr>
						          <tr>
						            <th>可用工作日</th>
						            <td>${project.days}</td>
						          </tr>
						          <tr>
						            <th>项目类型</th>
						            <td>
						            	<c:if test="${project.type == 'sprint'}">短期项目</c:if>
						            	<c:if test="${project.type == 'waterfall'}">长期项目</c:if>
						            	<c:if test="${project.type == 'ops'}">运维项目</c:if>
						           	</td>
						          </tr>
						          <tr> 
						            <th>项目状态</th>
						            <td class="<c:if test="${project.statusStr == '已延期'}">delay</c:if><c:if test="${project.statusStr != '已延期'}">${project.status}</c:if>">${project.statusStr}</td>
						          </tr>
						          <tr>
						            <th>项目负责人</th>
						            <td>
						            	<c:forEach items="${userList}" var="user">
						            		<c:if test="${user.account == project.PM}">${user.realname}</c:if>
						            	</c:forEach>
						            </td>
						          </tr>
						          <tr>
						            <th>产品负责人</th>
						            <td>
						            	<c:forEach items="${userList}" var="user">
						            		<c:if test="${user.account == project.PO}">${user.realname}</c:if>
						            	</c:forEach>
						            </td>
						          </tr>
						          <tr>
						            <th>测试负责人</th>
						            <td>
						            	<c:forEach items="${userList}" var="user">
						            		<c:if test="${user.account == project.QD}">${user.realname}</c:if>
						            	</c:forEach>
						            </td>
						          </tr>
						          <tr>
						            <th>发布负责人</th>
						            <td>
						            	<c:forEach items="${userList}" var="user">
						            		<c:if test="${user.account == project.RD}">${user.realname}</c:if>
						            	</c:forEach>
						            </td>
						          </tr>
						          <tr>
						            <th>相关产品</th>
						            <td>
						            	<c:forEach items="${productList}" var="product">
						            		<a href="${ctx}/product/product_view_${product.id}">${product.name}</a>
						            	</c:forEach>
									</td>
						          </tr>
						          <tr>
						            <th>访问控制</th>
						            <td>
						            	<c:if test="${project.acl == 'open'}">默认设置(有项目视图权限，即可访问)</c:if>
						            	<c:if test="${project.acl == 'private'}">私有项目(只有项目团队成员才能访问)</c:if>
						            	<c:if test="${project.acl == 'custom'}">自定义白名单(团队成员和白名单的成员可以访问)</c:if>
						            </td>
						          </tr>  
						          <tr>
						            <th>分组白名单</th>
						            <td>
						            	<c:forTokens items="${project.whitelist}" delims="," var="white">
							            	<c:set var="c" value="${(white+0).intValue()}"/>
							            		${groupMap[c]}
							            </c:forTokens>
							       </td>
						          </tr>  
						        </tbody>
					      	</table>
						</fieldset>
						<fieldset>
							<legend>其他信息</legend>
					        <table class="table table-data table-condensed table-borderless">
						    	<tbody>
							    	<tr>
							        	<th class="w-80px">工时统计</th>
							            <td>可用工时<strong><fmt:formatNumber value="${project.estimate}" type="number"/></strong>工时<br>
							            	总共预计<strong><fmt:formatNumber value="${project.estimate}" type="number"/></strong>工时<br>
							            	已经消耗<strong><fmt:formatNumber value="${project.consumed}" type="number"/></strong>工时<br>
							            	预计剩余<strong><fmt:formatNumber value="${project.remain}" type="number"/></strong>工时</td>
							    	</tr>
						    	</tbody>
					        </table>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>