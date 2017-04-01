<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/js/flex.js"></script>
<style>.contentDiv { height:190px; overflow-y:auto; margin-bottom: 10px!important}
.contentDiv .panel-heading {line-height: 14px;}
.red {color:red}
.green {color:green}
input[type=checkbox].ml-10px{margin-left:10px;}
.pdl-8px{padding-left:8px;}
.tabs{position:relative;}
.tabs .nav-tabs{border-bottom:none;}
.tabs .nav-tabs>li{margin-bottom:0px;}
.tabs .tab-content{padding:0px; border:0px;}
.tabs .tab-content .tab-pane #querybox{margin:0px; border-left:1px solid #ddd; border-right:1px solid #ddd;}
.tabs .tab-content .tab-pane #querybox form{padding-left:0px;}
.tabs .tab-content .tab-pane .action{position: absolute; right: 110px; top: 0px;}
</style>

<title>BUILD #${build.id} ${build.name} - ${project.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="titlebar">
		  		<div class="heading" style="padding-right: 279px;">
				    <span class="prefix"><i class="icon-tag"></i> <strong>${build.id}</strong></span>
				    <strong>${build.name}</strong>
		  		</div>
		  		<div class="actions">
					<div class="btn-group">
						<shiro:hasPermission name="build:linkStory">
							<a href="" class="btn"><i class="icon-link"></i> 关联需求</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="build:linkBug">
							<a href="" class="btn"><i class="icon-bug"></i> 关联Bug</a>
						</shiro:hasPermission>
					</div>
					<div class="btn-group">
						<shiro:hasPermission name="build:edit">
							<a href="${ctxpj}/build_edit_${build.id}_${build.project_id}" class="btn" title="编辑版本"><i class="icon-common-edit icon-pencil"></i></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="build:delete">
							<a href="javascript:deleteBuild(${build.id},${build.project_id});" class="btn " title="删除版本" target="hiddenwin"><i class="icon-common-delete icon-remove"></i></a>
						</shiro:hasPermission>
					</div>
					<a href="javascript:void(0)" onclick="history.go(-1)" class="btn" title="返回">
						<i class="icon-goback icon-level-up icon-large icon-rotate-270"></i>
					</a>
		  		</div>
			</div>
			<div class="row-table">
		  		<div class="col-main">
		    		<div class="main">
		      			<div class="tabs">
					       	<ul class="nav nav-tabs">
					        	<li class="active">
					          		<a href="#stories" data-toggle="tab"><i class="icon-lightbulb green"></i> 完成的需求</a>
					          	</li>
					          	<li><a href="#bugs" data-toggle="tab"><i class="icon-bug green"></i> 解决的Bug</a></li>
					          	<li><a href="#newBugs" data-toggle="tab"><i class="icon-bug red"></i> 产生的Bug</a></li>
					       	</ul>
		        			<div class="tab-content">
					        	<div class="tab-pane active" id="stories">
					        		<div class="tab-pane active">
							          	<div class="action">
							          		<a href='./build_view_${build.id}_${build.project_id}_linkStory' class="btn btn-sm btn-primary">
							          		<i class="icon-link"></i> 关联需求</a>
							            </div>
							            <div class="linkBox"></div>
						            	<form method="post" action="./build_view_${build.id}_${build.project_id}_${type}" id="linkedStoriesForm">
								            <table class="table datatable table-condensed table-striped table-fixed" id="storyList">
								              	<c:if test="${type == 'linkStory'}">
							            			<caption class="text-left text-special"><i class="icon-unlink"></i> <strong>未关联需求</strong></caption>
							            		</c:if>
								              	<thead>
								               	 	<tr>
												          <th class="w-id">ID</th>
												          <th class="w-pri">P</th>
												          <th>需求名称</th>
												          <th class="w-user">创建</th>
												          <th class="w-user">指派</th>
												          <th class="w-30px">预计</th>
												          <th class="w-status">状态</th>
												          <th class="w-60px">阶段</th>
											        </tr>
								              	</thead>
								              	<tbody>
		                                        	<c:forEach items="${storyList}" var="story">
			                                        	<tr class="text-center Stories" data-id="${story.id}">
			                    							<td>
			                    								<input type="checkbox" <c:if test="${type == 'linkStory' && story.stage == 'developed'}">checked</c:if> name="storyIds" value="${story.id}" />
			                                            		<a href="../product/story_view_${story.product.id}_${story.id}">${story.id}</a>
			                    							</td>
			                    							<td>
			                    								<span class="pri${story.pri}"><c:if test="${story.pri != 0}">${story.pri}</c:if></span>
			                   								</td>
			                   								<td class="text-left nobr" title="${story.title}">
			                   									<a href="../product/story_view_${story.product.id}_${story.id}" style='color: ${story.color}'>${story.title}</a>
															</td>
			                    							<td>${userMap[story.openedBy]}</td>
			                    							<td>${userMap[story.assignedTo]}</td>
			                    							<td>${story.estimate}</td>
										                    <td class="story-${story.status}">${statusMap[story.status]}</td>
										                    <td>
										                    	<c:choose>
										                    		<c:when test="${type == 'story'}">
												                    	<shiro:hasPermission name="release:unlinkStory">
					                      									<a href="javascript:deleteStory(${story.id},${build.project_id});" class="btn-icon" title="移除需求"><i class="icon-unlink"></i></a>
					                    								</shiro:hasPermission>
				                    								</c:when>
				                    								<c:when test="${type == 'linkStory'}">
				                    									${stageMap[story.stage]}
				                    								</c:when>
				                    							</c:choose>
			                    							</td>
			                  							</tr>     
		                  							</c:forEach>       
	                            				</tbody>
								              	<tfoot>
									                <tr>
									                	<td colspan="8">
										                	<div class="table-actions clearfix">
										                		<c:choose>
										                			<c:when test="${storyList.size() > 0 && type == 'story'}">
																		<div class="checkbox btn">
																			<label><input type="checkbox" onclick="selectAll(this)" class="rows-selector"> 选择</label>
																		</div> 
																		<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">批量移除</button>                      
																		<div class="text"> 本次共完成 ${storyList.size()}个需求</div>
																	</c:when>
																	<c:when test="${storyList.size() > 0 && type == 'linkStory'}">
																		<div class="checkbox btn">
																			<label><input type="checkbox" onclick="selectAll(this)" class="rows-selector"> 选择</label>
																		</div> 
																		<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">关联需求</button>                      
																		<a href="javascript:history.go(-1);" class="btn">返回</a>
																	</c:when>
																	<c:otherwise>
																		<div class="text"> 本次共完成 0个需求</div>
																	</c:otherwise>
																</c:choose>
															</div>
									                	</td>
									                </tr>
								              </tfoot>
								            </table>
						            	</form>
						            </div>
					        	</div>
					          	<div class="tab-pane " id="bugs">
					             	<div class="action"><a href='' class="btn btn-sm btn-primary"><i class="icon-bug"></i> 关联Bug</a>
					             	</div>
					            	<div class="linkBox"></div>
					            	<form method="post" target="hiddenwin" action="" id="linkedBugsForm">
							            <table class="table table-hover table-condensed table-striped tablesorter table-fixed" id="bugList">
							              <thead>
							                <tr>
							                  <th class="w-id">ID</th>
							                  <th>Bug标题</th>
							                  <th class="w-100px">Bug状态</th>
							                  <th class="w-user">创建</th>
							                  <th class="w-date">创建日期</th>
							                  <th class="w-user">解决</th>
							                  <th class="w-100px">解决日期</th>
							                  <th class="w-50px">操作</th>
							                </tr>
							              </thead>
							              <tfoot>
							                <tr>
							                  <td colspan="8">
							                    <div class="table-actions clearfix">
							                      <div class="text"> 本次共解决 0 个Bug</div>
							                    </div>
							                  </td>
							                </tr>
							              </tfoot>
							            </table>
					            	</form>
					          	</div>
		            			<div class="tab-pane " id="newBugs">
									<table class="table table-hover table-condensed table-striped tablesorter table-fixed">
						            	<thead>
						                	<tr>
							              		<th class="w-id">ID</th>
							                	<th class="w-severity">级别</th>
							                	<th>Bug标题</th>
							                	<th class="w-100px">Bug状态</th>
							                	<th class="w-user">创建</th>
							                	<th class="w-date">创建日期</th>
							                	<th class="w-user">解决</th>
							                	<th class="w-100px">解决日期</th>
						                	</tr>
						                </thead>
										<tfoot>
							                <tr>
							                  <td colspan="8">
							                    <div class="table-actions clearfix">
							                      <div class="text"> 本次共产生 0 个Bug</div>
							                    </div>
							                  </td>
							                </tr>
						                </tfoot>
									</table>
								</div>
		        			</div>
		      			</div>
		    		</div>
		  		</div>
			  	<div class="col-side">
				    <div class="main-side main">
				    	<fieldset>
				        	<legend>描述</legend>
				        	<div class="article-content">${build.descript}</div>
				      	</fieldset>
				      	<fieldset>
				        	<legend>基本信息</legend>
				        	<table class="table table-data table-condensed table-borderless table-fixed">
				          		<tbody>
					          		<tr>
							            <th class="w-80px">产品</th>
							            <td>${build.product.name}</td>
					          		</tr> 
					          		<c:if test="${build.product.type != 'normal'}"> 
					                <tr>
							            <th><c:if test="${build.product.type == 'platform'}">所属平台</c:if><c:if test="${build.product.type == 'branch'}">所属分支</c:if></th>
							            <td id="branch">
							            	<c:choose>
							            		<c:when test="${branch != null}">${branch.name}</c:when>
							            		<c:otherwise>
								            		<c:if test="${build.product.type == 'platform'}">所有平台</c:if>
								            		<c:if test="${build.product.type == 'branch'}">所有分支</c:if>
							            		</c:otherwise>
							            	</c:choose>
							            </td>
					                </tr>
					                </c:if>
					                <tr>
							            <th>名称编号</th>
							            <td>${build.name}</td>
							        </tr>
						          	<tr>
							            <th>构建者</th>
							            <td>${realname}</td>
						          	</tr>  
						          	<tr>
							            <th>打包日期</th>
							            <td>${build.date}</td>
						          	</tr>  
						          	<tr>
							            <th>源代码地址</th>
							            <td style="word-break:break-all;"><a href="" target="_blank">${build.scmPath}</a>
						            	</td>
						          	</tr>  
						          	<tr>
							            <th>下载地址</th>
							            <td style="word-break:break-all;"><a href="" target="_blank">${build.filePath}</a>
						            	</td>
						          	</tr>
				          		</tbody>
				        	</table>
				      	</fieldset>
				      	<fieldset>
							<legend>附件</legend>
							<div class="list-group files-list"></div>
				      	</fieldset>
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
				          			<div class="changes hide alert" id="changeBox${i.index + 2}" style="display: none;">
				          				<c:if test="${action.histories.size() != 0}">
					          				<c:forEach items="${action.histories}" var="history">
			        	  						修改了 <strong><i>${fieldNameMap[history.field]}</i></strong>，旧值为 "${history.oldValue}"，新值为 "${history.newValue}"。<br>
			        						</c:forEach>
		        						</c:if>
		        					</div>
			          			</li>
	  						</c:forEach>
	        			</ol>		
		  			</fieldset>
				    </div>
			  	</div>
			</div>
		</div>
	</div>
<script>
function deleteBuild(buildId, projectId) {
	if(confirm("您确定删除该版本吗？")) {
		location.href="${ctxpj}/build_deleted_" + buildId + "_" + projectId;
	}
}
//移除单个需求
function deleteStory(storyId, projectId) {
	if(confirm("您确定移除该需求吗？")) {
		location.href = "./build_delete_${build.id}_" + storyId + "_" + projectId;
	}
}

//全选复选框
function selectAll(obj) {
	$('input[name="storyIds"]').prop("checked",obj.checked);
};
</script>
</body>
</html>