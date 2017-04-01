<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/jquery-1.12.4.min.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript">
var kEditorId = ["lastComment"];
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
</script>
<title>${product.name}::产品概况</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
  		<div class="outer" style="min-height: 494px;">
	  		<div id="titlebar">
				<div class="heading">
		    		<span class="prefix"><i class="icon-cube"></i> <strong>${product.id}</strong></span>
		    		<strong>${product.name}</strong>
				</div>
				<div class="actions">
					<shiro:hasPermission name="product:close">
						<c:if test="${product.status != 'closed'}">
			    			<a data-iframe="./product_close_${productId}" data-width="784px" data-show-header="false" data-toggle="modal" class="btn text-danger"><i class="icon-product-close icon-off"></i> 关闭</a>
						</c:if>
					</shiro:hasPermission>
					<shiro:hasPermission name="product:edit">
						<div class="btn-group"><a href="./product_edit_${productId}" class="btn " title="编辑产品"><i class="icon-common-edit icon-pencil"></i></a></div>
					</shiro:hasPermission>
					<a href="./story_browse_${productId}" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
		 		</div>
      		</div>
			<div class="row-table">
		  		<div class="col-main">
		    		<div class="main">
		      			<fieldset>
		        			<legend>产品描述</legend>
		        			<div class="article-content">${product.descript}</div>
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
		          									<form method="post" action="./action_editProductComment_${productId}_${action.id}">
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
				          				<c:if test="${action.comment != ''}"></div></c:if>
				          			</li>
		  						</c:forEach>
		        			</ol>		
			  			</fieldset>
		      			<div class="actions">
		      				<shiro:hasPermission name="product:close">
			      				<c:if test="${product.status != 'closed'}">
			      					<a data-iframe="./product_close_${productId}" data-width="784px" data-show-header="false" data-toggle="modal" class="btn text-danger"><i class="icon-product-close icon-off"></i> 关闭</a>
			      				</c:if>
		      				</shiro:hasPermission>
		      				<shiro:hasPermission name="product:edit">
								<div class="btn-group"><a href="./product_edit_${productId}" class="btn " title="编辑产品"><i class="icon-common-edit icon-pencil"></i></a></div>
							</shiro:hasPermission>
							<a href="./story_browse_${productId}" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
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
							            <th class="strong w-80px">产品名称</th>
							            <td><strong>${product.name}</strong></td>
						          	</tr>  
						          	<tr>
						           	 	<th>产品代号</th>
						            	<td>${product.code}</td>
						          	</tr>  
						          	<tr>
						            	<th>产品负责人</th>
						            	<td>${userMap[product.po]}</td>
					         	 	</tr>  
	          						<tr>
							            <th>测试负责人</th>
							            <td>${userMap[product.qd]} </td>
						          	</tr>  
						          	<tr>
							            <th>发布负责人</th>
							            <td>${userMap[product.rd]}</td>
						          	</tr>  
						          	<tr>
							            <th>产品类型</th>
							            <td>
							            	<c:if test="${product.type == 'normal'}">正常</c:if>
							            	<c:if test="${product.type == 'branch'}">分支</c:if>
							            	<c:if test="${product.type == 'platform'}">多平台</c:if>
							            </td>
						          	</tr>  
						          	<tr>
							            <th>状态</th>
							            <td class="product-${product.status}">
							            	<c:if test="${product.status == 'normal'}">正常</c:if>
							            	<c:if test="${product.status == 'closed'}">结束</c:if>
							            </td>
						          	</tr>  
						          	<tr>
							            <th>访问控制</th>
							            <td>
							            	<c:if test="${product.acl == 'open'}">默认设置(有产品视图权限，即可访问)</c:if>
							            	<c:if test="${product.acl == 'private'}">私有产品(只有项目团队成员才能访问)</c:if>
							            	<c:if test="${product.acl == 'custom'}">自定义白名单(团队成员和白名单的成员可以访问)</c:if>
							            </td>
						          	</tr>  
						          	<tr>
							            <th>分组白名单</th>
							            <td>
							            	<c:forTokens items="${product.whitelist}" delims="," var="white">
							            		<c:set var="c" value="${(white+0).intValue()}"/>
							            		${groupMap[c]}
							            	</c:forTokens>
							            </td>
						          	</tr>  
						          	<tr>
							            <th>由谁创建</th>
							            <td>${userMap[product.createdBy]}</td>
						          	</tr>  
						          	<tr>
							            <th>创建日期</th>
							            <td>${product.createdDate}</td>
						          	</tr>  
		        				</tbody>
		        			</table>
		      			</fieldset>
				      	<fieldset>
					        <legend>其他信息</legend>
					        <table class="table table-data table-condensed table-borderless">
				          		<tbody>
						          	<tr>
							            <th class="strong w-80px">激活需求</th>
							            <td class="strong">${activeStoryCount}</td>
						          	</tr>
						          	<tr>
							            <th>已变更需求</th>
							            <td>${changedStoryCount}</td>
						          	</tr>
						          	<tr>
							            <th>草稿需求</th>
							            <td>${draftStoryCount}</td>
						          	</tr>
						          	<tr>
							            <th>已关闭需求</th>
							            <td>${closedStoryCount}</td>
						          	</tr>
						          	<tr>
							            <th>计划数</th>
							            <td>${planCount}</td>
						          	</tr>
						          	<tr>
							            <th>关联项目数</th>
							            <td>${projectCount}</td>
						          	</tr>
						          	<tr>
							            <th>相关BUG</th>
							            <td>${bugCount}</td>
						          	</tr>
						          	<tr>
							            <th>文档数</th>
							            <td>${docCount}</td>
						          	</tr>
						          	<tr>
							            <th>用例数</th>
							            <td>${caseCount}</td>
						          	</tr>
						          	<tr>
							            <th>BUILD数</th>
							            <td>${buildCount}</td>
						          	</tr>
						          	<tr>
							            <th>发布数</th>
							            <td>${releaseCount}</td>
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