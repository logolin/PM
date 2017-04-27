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
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript">
var kEditorId = ["comment","lastComment"];
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
function setComment() {
	$('#commentBox').toggleClass('hide');
}
</script>
<title>STORY #${story.id} ${story.title} - ${currentProduct.name}::产品</title>
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
	    			<span class="prefix"><i class="icon-lightbulb"></i> <strong>${story.id}</strong></span>
	    			<strong style="color: ${story.color}">${storySpec.title}</strong>
	    			<c:if test="${story.version > 1}">
		    			<small class="dropdown">
	      					<a href="#" data-toggle="dropdown" class="text-muted">#${version} <span class="caret"></span></a>
	      					<ul class="dropdown-menu">
	      						<c:forEach begin="0" end="${story.version - 1}" step="1" var="i">
	      							<c:set var="num" value="${story.version - i}"/>
	      							<li <c:if test="${version == num}">class="active"</c:if>><a href="./story_view_${currentProduct.id}_${story.id}_${num}">#${num}</a></li>
	      						</c:forEach>
							</ul>
	    				</small>
    				</c:if>
	      		</div>
  		  		<div class="actions">
	    			<div class="btn-group">
        				<c:choose>
        					<c:when test="${story.status != 'closed'}">
        						<shiro:hasPermission name="story:change">
		  							<a href="./story_change_${story.product.id}_${story.id}" class="btn "><i class="icon-story-change icon-random"></i> 变更</a>
			  					</shiro:hasPermission>
			  					<shiro:hasPermission name="story:review">
			  						<c:if test="${story.status == 'draft' || story.status == 'changed'}">
			  							<a href="./story_review_${story.product.id}_${story.id}" class="btn "><i class="icon-story-review icon-search"></i> 评审</a>
			  						</c:if>	
			  					</shiro:hasPermission>	  		
			  					<shiro:hasPermission name="story:close">
		  							<a href="" class="btn text-danger" data-show-header="false" data-type="iframe" data-width="784px" data-url="./story_close_${currentProduct.id}_${story.id}" data-toggle="modal"><i class="icon-story-close icon-off"></i> 关闭</a>
		  						</shiro:hasPermission>
		  					</c:when>
		  					<c:otherwise>
		  						<shiro:hasPermission name="story:activate">
 	      							<a href="" data-show-header="false" data-type="iframe" data-url="./story_activate_${story.product.id}_${story.id}" data-width="784px" data-toggle="modal" class='btn text-success' ><i class='icon-story-activate icon-off'></i> 激活</a>
 	      						</shiro:hasPermission>
 	      					</c:otherwise>
						</c:choose>
						<shiro:hasPermission name="testcase:create">
		    	  			<a href="" class="btn "><i class="icon-testcase-create icon-sitemap"></i> 建用例</a>
						</shiro:hasPermission>
					</div>
					<div class="btn-group">
						<shiro:hasPermission name="story:edit">
				  			<a href="./story_edit_${story.product.id}_${story.id}" class="btn " title="编辑"><i class="icon-common-edit icon-pencil"></i></a>
				  		</shiro:hasPermission>
				  		<a href="#commentBox" title="备注" onclick="setComment()" class="btn"><i class="icon-comment-alt"></i></a>
				  		<shiro:hasPermission name="story:create">
				  			<a href="./story_create_${story.product.id}" class="btn " title="create"><i class="icon-common-copy icon-copy"></i></a>
						</shiro:hasPermission>
					</div>
					<div class="btn-group">
			  			<a href="javascript:history.go(-1)" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
			  			<a href="" id="next" class="btn" title="#65 12345 [快捷键:→]"><i class="icon-pre icon-chevron-right"></i></a>
					</div>
		  		</div>
	    	</div>
			<div class="row-table">
		  		<div class="col-main">
		    		<div class="main">
		      			<fieldset>
		        			<legend>需求描述</legend>
		        			<div class="article-content">${storySpec.spec}</div>
		      			</fieldset>
		      			<fieldset>
		        			<legend>验收标准</legend>
		        			<div class="article-content">${storySpec.verify}</div>
		      			</fieldset>
		      			<style> .files-list {margin: 0;} .files-list > .list-group-item {padding: 0px; border:0px;} .files-list > .list-group-item a {color: #666} .files-list > .list-group-item:hover a {color: #333} .files-list > .list-group-item > .right-icon {opacity: 0.01; transition: all 0.3s;} .files-list > .list-group-item:hover > .right-icon {opacity: 1} .files-list .btn-icon > i {font-size:15px}</style>
		      			<fieldset>
		        			<legend>附件</legend>
		        			<div class="list-group files-list">
		        				<c:forEach items="${fileList}" var="file">
		        					<a href="../download/${file.id}" title="上传者：${userMap[file.addedBy]}&#10上传日期：${file.addedDate}&#10大小：${file.size}B&#10下载次数：${file.downloads}"><i class="icon-download-alt"></i>&nbsp;${file.title}.${file.extension}</a><br/>
		        				</c:forEach>
		        			</div>
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
					              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}
					              			<c:if test="${action.action == 'linkplan'}">
					              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
					              				<c:if test="${fn:startsWith(a,',')}">
					              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
					              				</c:if>
					              				<a href="./plan_view_${productId}_${a}">#${a}</a>。
					              			</c:if>
					              			<c:if test="${action.action == 'linkstories'}">
					              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
					              				<c:if test="${fn:startsWith(a,',')}">
					              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
					              				</c:if>
					              				#${a}。
					              			</c:if>
					              			<c:if test="${action.action == 'childstories'}">
					              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
					              				<c:if test="${fn:startsWith(a,',')}">
					              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
					              				</c:if>
					              				#${a}。
					              			</c:if>
					              			<c:if test="${action.action == 'close'}">，原因为 <strong>${closedReasonMap[action.histories[1].newValue]}</strong></c:if>
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
				        					<shiro:hasPermission name="action:editComment"><c:if test="${i.last && action.comment != ''}"><span class="pull-right comment${action.id}"><a href="javascript:toggleComment(${action.id})" class="btn btn-mini" style="border:none"><i class="icon-pencil"></i></a></span></c:if></shiro:hasPermission>
			        						<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
					          				<c:if test="${i.last && action.comment != ''}">
						          				<div class="hide" id="lastCommentBox">
		          									<form method="post" action="./action_editStoryComment_${productId}_${action.id}">
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
			    			<div class="btn-group">
		        				<c:choose>
		        					<c:when test="${story.status != 'closed'}">
		        						<shiro:hasPermission name="story:change">
				  							<a href="./story_change_${story.product.id}_${story.id}" class="btn "><i class="icon-story-change icon-random"></i> 变更</a>
					  					</shiro:hasPermission>
					  					<shiro:hasPermission name="story:review">
					  						<c:if test="${story.status == 'draft' || story.status == 'changed'}">
					  							<a href="./story_review_${story.product.id}_${story.id}" class="btn "><i class="icon-story-review icon-search"></i> 评审</a>
					  						</c:if>	
					  					</shiro:hasPermission>	  		
					  					<shiro:hasPermission name="story:close">
				  							<a href="" class="btn text-danger" data-show-header="false" data-type="iframe" data-width="784px" data-url="./story_close_${currentProduct.id}_${story.id}" data-toggle="modal"><i class="icon-story-close icon-off"></i> 关闭</a>
				  						</shiro:hasPermission>
				  					</c:when>
				  					<c:otherwise>
				  						<shiro:hasPermission name="story:activate">
		 	      							<a href="" data-show-header="false" data-type="iframe" data-url="./story_activate_${story.product.id}_${story.id}" data-width="784px" data-toggle="modal" class='btn text-success' ><i class='icon-story-activate icon-off'></i> 激活</a>
		 	      						</shiro:hasPermission>
		 	      					</c:otherwise>
								</c:choose>
								<shiro:hasPermission name="testcase:create">
				    	  			<a href="" class="btn "><i class="icon-testcase-create icon-sitemap"></i> 建用例</a>
								</shiro:hasPermission>
							</div>
							<div class="btn-group">
								<shiro:hasPermission name="story:edit">
						  			<a href="./story_edit_${story.product.id}_${story.id}" class="btn " title="编辑"><i class="icon-common-edit icon-pencil"></i></a>
						  		</shiro:hasPermission>
						  		<a href="#commentBox" title="备注" onclick="setComment()" class="btn"><i class="icon-comment-alt"></i></a>
						  		<shiro:hasPermission name="story:create">
						  			<a href="./story_create_${story.product.id}" class="btn " title="create"><i class="icon-common-copy icon-copy"></i></a>
								</shiro:hasPermission>
							</div>
							<div class="btn-group">
					  			<a href="javascript:history.go(-1)" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
					  			<a href="" id="next" class="btn" title="#65 12345 [快捷键:→]"><i class="icon-pre icon-chevron-right"></i></a>
							</div>
				  		</div>
		      			<fieldset id="commentBox" class="hide">
		        			<legend>备注</legend>
	        				<form method="post">
		          				<div class="form-group">
				    				<textarea id="comment" name="comment" class="form-control kindeditor" style="height:150px;"></textarea>
				  				</div>
		           				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
		           				<a href="javascript:setComment();" class="btn btn-back ">返回</a>        
		        			</form>
		      			</fieldset>
	    			</div>
		  		</div>
		  		<div class="col-side">
		    		<div class="main main-side">
		      			<div class="tabs">
		        			<ul class="nav nav-tabs">
		         	 			<li class="active"><a href="#legendBasicInfo" data-toggle="tab">基本信息</a></li>
		          				<li class=""><a href="#legendLifeTime" data-toggle="tab">需求的一生</a></li>
		        			</ul>
		        			<div class="tab-content">
		          				<div class="tab-pane active" id="legendBasicInfo">
		            				<table class="table table-data table-condensed table-borderless">
		              					<tbody>
		              						<tr>
		                						<th class="w-70px">所属产品</th>
		                						<td><a href="./product_view_${story.product.id}">${story.product.name}</a></td>
		              						</tr>
		              						<tr>
		                						<th>所属模块</th>
		                						<td>
		                							<c:if test="${story.module_id == 0}">/</c:if>
		                							<c:if test="${story.module_id != 0}">
			                							<nobr>
		                									<c:forEach items="${path}" var="obj" varStatus="s">
		                										<a href="./story_browse_${story.product.id}_0_${obj[0]}">${obj[1]}</a>
																<c:if test="${s.last == false}">
																	&nbsp;<i class="icon-angle-right"></i>&nbsp;  
																</c:if>
		                									</c:forEach>
														</nobr>
													</c:if>
		                						</td>
		              						</tr>
		              						<tr>
		                						<th>所属计划</th>
								                <td> 
								                	<c:forEach items="${planList}" var="plan">
								                		<a href="./plan_view_${plan.product.id}_${plan.id}">${plan.title}</a><br>
								                	</c:forEach>
								                </td>
								            </tr>
							              	<tr>
		                						<th>需求来源</th>
		                						<td id="source">${sourceMap[story.source]}</td>
		             	 					</tr>
		              						<tr>
		                						<th>当前状态</th>
									         	<td class="story-${story.status}">${statusMap[story.status]}</td>
							              	</tr>
							              	<tr>
		                						<th>所处阶段</th>
		                						<td>${stageMap[story.stage]}</td>
		              						</tr>
		              						<tr>
		                						<th>优先级</th>
	                							<td><span class="pri${story.pri}"><c:if test="${story.pri != 0}">${story.pri}</c:if></span></td>
		              						</tr>
	              							<tr>
		                						<th>预计工时</th>
		                						<td>${story.estimate}</td>
		              						</tr>
		              						<tr>
		                						<th>关键词</th>
		                						<td>${story.keywords}</td>
		              						</tr>
		              						<tr>
		                						<th>抄送给</th>
		                						<td>
		                							<c:forTokens items="${story.mailto}" delims="," var="mailto">
		                								${userMap[mailto]}
		                							</c:forTokens>
		                						</td>
		              						</tr>
		            					</tbody>
		          					</table>
		        				</div>
		        				<div class="tab-pane" id="legendLifeTime">
		          					<table class="table table-data table-condensed table-borderless">
		            					<tbody>
		              						<tr>
		                						<th class="w-70px">由谁创建</th>
		                						<td>${userMap[story.openedBy]}  ${story.openedDate}</td>
		              						</tr>
		              						<tr>
		                						<th>指派给</th>
		                						<td>${userMap[story.assignedTo]}  ${story.assignedDate}</td>
		              						</tr>
		              						<tr>
		                						<th>由谁评审</th>
		                						<td>
		                							<c:forTokens items="${story.reviewedBy}" delims="," var="reviewedBy">
		                								${userMap[reviewedBy]}
		                							</c:forTokens>		                						
		                						</td>
		              						</tr>
		              						<tr>
		                						<th>评审时间</th>
		                						<td>${story.reviewedDate}</td>
		              						</tr>
	              							<tr>
		                						<th>由谁关闭</th>
		                						<td>
		                							<c:if test="${story.status == 'closed'}">
		                								${userMap[story.closedBy]}  ${story.closedDate}
		                							</c:if>
		                						</td>
	              							</tr>
		              						<tr>
		                						<th>关闭原因</th>
		                						<td>${closedReasonMap[story.closedReason]}</td>
		              						</tr>
		              						<tr>
	                							<th>最后修改</th>
		                						<td>${userMap[story.lastEditedBy]}  ${story.lastEditedDate}</td>
		              						</tr>
		            					</tbody>
		          					</table>
	        					</div>
		      				</div>
		      			</div>
		      			<div class="tabs">
		        			<ul class="nav nav-tabs">
		          				<li class="active"><a href="#legendProjectAndTask" data-toggle="tab">项目任务</a></li>
		          				<li><a href="#legendRelated" data-toggle="tab">相关信息</a></li>
		        			</ul>
		        			<div class="tab-content">
		          				<div class="tab-pane active" id="legendProjectAndTask">
		            				<ul class="list-unstyled">
		            					<c:forEach items="${projectList}" var="project">
		            						<c:forEach items="${project[4]}" var="task">
		            							<li title="${task[1]}">
													<a href="../project/task_view_${task[0]}">#${task[0]} ${task[1]}</a>
													<a href="../project/project_view_${project[0]}" class="text-muted">${project[1]}</a>
												</li>
		            						</c:forEach>
		            					</c:forEach>
									</ul>
		          				</div>
		          				<div class="tab-pane" id="legendRelated">
		            				<table class="table table-data table-condensed table-borderless">
		              					<tbody>
		                					<tr class="text-top">
		                  						<th class="w-70px">相关Bug</th>
		                  						<td class="pd-0">
		                    						<ul class="list-unstyled">
		                    							<c:forEach items="${bugList}" var="bug">
		                    								<li title="#${bug[0]} ${bug[1]}"><a href="">#${bug[0]} ${bug[1]}</a></li>
		                    							</c:forEach>
		                    						</ul>
		                  						</td>
		                					</tr>
		                					<tr class="text-top">
		                  						<th>相关用例</th>
		                  						<td class="pd-0">
		                    						<ul class="list-unstyled">
		                    							<c:forEach items="${caseList}" var="cas">
		                    								<li title="#${cas[0]} ${cas[1]}"><a href="">#${cas[0]} ${cas[1]}</a></li>
		                    							</c:forEach>
													</ul>
		                  						</td>
		                					</tr>
		                					<tr class="text-top">
		                  						<th>相关需求</th>
		                  						<td class="pd-0">
		                    						<ul class="list-unstyled">
		                    							<c:forEach items="${linkStoryList}" var="linkStory">
		                    								<li><a href="./story_view_${linkStory[2]}_${linkStory[0]}_0">#${linkStory[0]} ${linkStory[1]}</a></li>
		                    							</c:forEach>
		                    						</ul>
							                  	</td>
							                </tr>
							                <tr class="text-top">
							                  	<th>细分需求</th>
							                  	<td class="pd-0">
							                    	<ul class="list-unstyled">
							                    		<c:forEach items="${childStoryList}" var="childStory">
		                    								<li><a href="./story_view_${childStory[2]}_${childStory[0]}_0">#${childStory[0]} ${childStory[1]}</a></li>
		                    							</c:forEach>
							                    	</ul>
							                  	</td>
							                </tr>
						              	</tbody>
						            </table>
					          	</div>
					        </div>
				      	</div>
				    </div>
			  	</div>
			</div>	    
	  	</div>
	</div>	
</body>
</html>