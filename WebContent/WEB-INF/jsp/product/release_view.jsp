<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
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
<title>RELEASE #${release.id} ${release.name}/${currentProduct.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div id="titlebar">
  			<div class="heading">
    			<span class="prefix"><i class="icon-tags"></i> <strong>${release.id}</strong></span>
    			<strong>${release.name}</strong>
      		</div>
  			<div class="actions">
   				<div class="btn-group">
   					<shiro:hasPermission name="release:changeStatus">
		   				<c:choose>
							<c:when test="${release.status == 'normal'}">
								<a href="./release_changeStatus_${productId}_${release.id}_terminate" class="btn" title="停止维护"><i class="icon-pause"></i> 停止维护</a>
							</c:when>
							<c:otherwise>
								<a href="./release_changeStatus_${productId}_${release.id}_normal" class="btn" title="激活"><i class="icon-play"></i> 激活</a>
							</c:otherwise>
						</c:choose>
					</shiro:hasPermission>
					<shiro:hasPermission name="release:linkStory">
						<a class="btn" data-size="lg" data-type="iframe" data-url="./release_linkStories_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-link"></i> 关联需求</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="release:linkBug">
						<a class="btn" data-size="lg" data-type="iframe" data-url="./release_linkBugs_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-bug"></i> 关联解决Bug</a>
					</shiro:hasPermission>
				</div>
				<div class="btn-group">
					<shiro:hasPermission name="release:edit">
						<a href="./release_edit_${productId}_${releaseId}" class="btn " title="编辑发布"><i class="icon-common-edit icon-pencil"></i></a>
					</shiro:hasPermission>
				</div>
				<div class="btn-group">
					<a href="javascript:history.go(-1);" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
				</div>  
			</div>
		</div>
		<div class="row-table">
  			<div class="col-main">
    			<div class="main">
      				<div class="tabs">
                		<ul class="nav nav-tabs">
          					<li class="active"><a href="#stories" data-toggle="tab"><i class="icon-lightbulb green"></i> 完成的需求</a></li>
          					<li class=""><a href="#bugs" data-toggle="tab"><i class="icon-bug green"></i> 解决的Bug</a></li>
          					<li class=""><a href="#leftBugs" data-toggle="tab"><i class="icon-bug red"></i> 遗留的Bug</a></li>
          					<shiro:hasPermission name="release:export">
                    			<li class="pull-right"><a href="" class="btn export"><i class="icon-common-export icon-download-alt"></i> 导出HTML</a></li>
                  			</shiro:hasPermission>
                  		</ul>
        				<div class="tab-content">
          					<div class="tab-pane active" id="stories">
                        		<div class="action">
                        			<shiro:hasPermission name="release:linkStory">
                        				<a class="btn btn-sm btn-primary" data-size="lg" data-type="iframe" data-url="./release_linkStories_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-link"></i> 关联需求</a>
									</shiro:hasPermission>
								</div>
            					<div class="linkBox"></div>
                        		<form method="post" target="hiddenwin" action="/release-batchUnlinkStory-13.html" id="linkedStoriesForm">
						            <table class="table datatable table-condensed table-striped table-fixed" id="storyList">
						              	<thead>
						               	 	<tr>
							                 	<th data-width="50" data-type="number" data-col-class="text-left">ID</th>
                  								<th data-width="40">P</th>
                  								<th class="">需求名称</th>
                  								<th class="w-user">创建</th>
                  								<th class="w-60px" data-width="60" data-col-class="text-right">预计</th>
                  								<th class="w-status">状态</th>
                  								<th class="w-80px">阶段</th>
                  								<th data-width="50" data-sort="false">  操作</th>
						                	</tr>
						              	</thead>
                                        <tbody>
                                        	<c:forEach items="${storyList}" var="story">
                                        	<tr class="text-center Stories" data-id="${story.id}">
                    							<td>
                                            		<a href="./story_view_${story.product.id}_${story.id}">${story.id}</a>
                    							</td>
                    							<td>
                    								<span class="pri${story.pri}"><c:if test="${story.pri != 0}">${story.pri}</c:if></span>
                   								</td>
                   								<td class="text-left nobr" title="${story.title}">
                   									<a href="./story_view_${story.product.id}_${story.id}" style='color: ${story.color}'>${story.title}</a>
												</td>
                    							<td>${userMap[story.openedBy]}</td>
                    							<td>${story.estimate}</td>
							                    <td class="story-${story.status}">${storyStatusMap[story.status]}</td>
							                    <td>${stageMap[story.stage]}</td>
							                    <td>
							                    	<shiro:hasPermission name="release:unlinkStory">
                      									<a href='javascript:ajaxUnlinkFromRelease(0,${story.id},"Stories")' class="btn-icon" title="移除需求"><i class="icon-unlink"></i></a>
                    								</shiro:hasPermission>
                    							</td>
                  							</tr>     
                  							</c:forEach>       
                            			</tbody>
                            			<tfoot>
							                <tr>
							                  	<td colspan="8">
							                    	<div class="table-actions clearfix">
							                      		<div class="table-actions clearfix pdl-8px">
								                      		<shiro:hasPermission name="release:batchUnlinkStory">
								                      			<button type="button" id="submit" onclick="ajaxUnlinkFromRelease(0,'','Stories','batch')" class="btn btn-primary" data-loading="稍候...">批量移除</button>
							                      			</shiro:hasPermission>
							                      		</div>                      
							                      		<div class="text">本次共完成${storyList.size()} 个需求</div>
							                    	</div>
							                  	</td>
						                	</tr>
						              	</tfoot>
            						</table>
            					</form>
          					</div>
          					<div class="tab-pane" id="bugs">
                        		<div class="action">
	                        		<shiro:hasPermission name="release:linkBug">
	                        			<a class="btn btn-sm btn-primary" data-size="lg" data-type="iframe" data-url="./release_linkBugs_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-bug"></i> 关联Bug</a>
									</shiro:hasPermission>
								</div>
            					<div class="linkBox"></div>
                        		<form method="post" action="" id="linkedBugsForm">
            						<table class="table datatable table-condensed table-striped table-fixed" id="bugList">
						              	<thead>
						                	<tr>
							                  	<th data-width="50" data-type="number" data-col-class="text-left">ID</th>
							                  	<th>Bug标题</th>
							                  	<th class="w-100px">Bug状态</th>
							                  	<th class="w-user">创建</th>
							                  	<th class="w-date">创建日期</th>
							                  	<th class="w-user">解决</th>
							                  	<th class="w-100px">解决日期</th>
							                  	<th data-width="50" data-sort="false">操作</th>
						                	</tr>
						              	</thead>
                                        <tbody>
                                        	<c:forEach items="${bugList}" var="bug">
                                        	<tr class="text-center Bugs" data-id="${bug.id}">
                								<td>
                                    				<a href="">${bug.id}</a>            
                                    			</td>
                								<td class="text-left nobr" title="${bug.title}">
                									<a href="" class="preview" style="color: ${bug.color}">${bug.title}</a>
												</td>
								                <td class="bug-${bug.status}">${bugStatusMap[bug.status]}</td>
								                <td>${userMap[bug.openedBy]}</td>
								                <td>${bug.openedDate}</td>
								                <td>${userMap[bug.resolvedBy]}</td>
								                <td>${bug.resolvedDate}</td>
								                <td>
								                	<shiro:hasPermission name="release:unlinkBug">
                  										<a href='javascript:ajaxUnlinkFromRelease(1,${bug.id},"Bugs")' class="btn-icon" title="移除Bug"><i class="icon-unlink"></i></a>
								                	</shiro:hasPermission>
								                </td>
							              	</tr>
							              	</c:forEach>
                            			</tbody>
                            			<tfoot>
							                <tr>
							                  	<td colspan="8">
							                    	<div class="table-actions clearfix">
							                      		<div class="table-actions clearfix pdl-8px">
							                      			<shiro:hasPermission name="release:batchUnlinkBug">
							         	             			<button type="button" id="submit" onclick="ajaxUnlinkFromRelease(1,'','Bugs','batch')" class="btn btn-primary" data-loading="稍候...">批量移除</button>
							                      			</shiro:hasPermission>
							                      		</div>                      
							                      		<div class="text">本次共解决 ${bugList.size()}个Bug</div>
							                    	</div>
							                  	</td>
						                	</tr>
						              	</tfoot>
					            	</table>
					            </form>
				          	</div>
          					<div class="tab-pane" id="leftBugs">
                        		<div class="action">
	                        		<shiro:hasPermission name="release:linkBug">
	                        			<a class="btn btn-sm btn-primary" data-size="lg" data-type="iframe" data-url="./release_linkLeftBugs_${release.product.id}_${release.id}" data-toggle="modal"><i class="icon-bug"></i> 关联Bug</a>
									</shiro:hasPermission>
								</div>
            					<div class="linkBox"></div>
                       			<form method="post" target="hiddenwin" action="" id="linkedBugsForm">
						            <table class="table datatable table-condensed table-striped table-fixed" id="leftBugList">
						              	<thead>
						                	<tr>
							                  	<th data-width="50" data-type="number" data-col-class="text-left">ID</th>
							                  	<th data-width="40">级别</th>
							                  	<th>Bug标题</th>
							                  	<th class="w-100px">Bug状态</th>
							                  	<th class="w-user">创建</th>
							                  	<th class="w-150px">创建日期</th>
							                  	<th data-width="50" data-sort="false">操作</th>
							                </tr>
					              		</thead>
                                      	<tbody>
                                      		<c:forEach items="${leftBugList}" var="leftBug">
                                      		<tr class="text-center LeftBugs" data-id="${leftBug.id}">
								                <td>
	                                    			<a href="">${leftBug.id}</a>             
	                                    		</td>
								                <td><span class="severity${leftBug.severity}">${leftBug.severity}</span></td>
								                <td class="text-left nobr" title="${leftBug.title}">
								                	<a href="" class="preview" style='color: ${leftBug.color}'>${leftBug.title}</a>
												</td>
								                <td class="bug-${leftBug.status}">${bugStatusMap[leftBug.status]}</td>
								                <td>${userMap[leftBug.openedBy]}</td>
								                <td>${leftBug.openedDate}</td>
								                <td>
								                	<shiro:hasPermission name="release:unlinkBug">
								                  		<a href='javascript:ajaxUnlinkFromRelease(2,${leftBug.id},"LeftBugs")' class="btn-icon" title="移除Bug"><i class="icon-unlink"></i></a>
								                	</shiro:hasPermission>
								                </td>
							              	</tr>
							              	</c:forEach>
                            			</tbody>
                            			<tfoot>
							                <tr>
							                  	<td colspan="7">
							                    	<div class="table-actions clearfix">
							                      		<div class="text">
							                        		<div class="table-actions clearfix pdl-8px">
							                        			<shiro:hasPermission name="release:batchUnlinkBug">
							                        				<button type="button" id="submit" onclick="ajaxUnlinkFromRelease(2,'','LeftBugs','batch')" class="btn btn-primary" data-loading="稍候...">批量移除</button>
							                        			</shiro:hasPermission>
							                        		</div>                        
							                        		本次共遗留 ${leftBugList.size()}个Bug                      
							                        	</div>
							                    	</div>
						                  		</td>
						                	</tr>
						              	</tfoot>
						            </table>
					            </form>
				          	</div>
			        	</div>
			      	</div>
		    	</div>
		  	</div>
		  	<div class="col-side">
		    	<div class="main-side main">
			      	<fieldset>
			        	<legend>描述</legend>
			        	<div class="article-content">${release.descript}</div>
			      	</fieldset>
			      	<fieldset>
			        	<legend>基本信息</legend>
			        	<table class="table table-data table-condensed table-borderless table-fixed">
			          		<tbody>
			          			<tr>
			            			<th class="w-80px">产品</th>
			            			<td>${release.product.name}</td>
			          			</tr>  
			          			<c:if test="${release.product.type != 'normal'}">
			                    <tr>
						            <th>
						            	<c:choose>
						            		<c:when test="${release.product.type == 'branch'}">
							        			所属分支
							        		</c:when>
							        		<c:when test="${release.product.type == 'platform'}">
							        			所属平台
							        		</c:when>
							        		<c:otherwise></c:otherwise>
							        	</c:choose>
							        </th>
						            <td>${release.branchName}</td>
					          	</tr>
					          	</c:if>
			                    <tr>
						            <th>发布名称</th>
						            <td>${release.name}</td>
					          	</tr>  
					          	<tr>
					            	<th>版本</th>
					            	<td>${release.build.name}</td>
					          	</tr>  
					          	<tr>
			            			<th>状态</th>
			            			<td>${release.status}</td>
			          			</tr>
		          				<tr>
			            			<th>发布日期</th>
			            			<td>${release.date}</td>
			          			</tr>
		        			</tbody>
		        		</table>
	      			</fieldset>
      				<fieldset>
        				<legend>附件 </legend>
        				<div class="article-content">
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
<script type="text/javascript">
var ids = new Array();
$(document).ready(function()
{
	$("form").each(function(){fixedTfootAction(this)});
	$('table.datatable').each(function(index){
		$(this).datatable({
			sortable: true, 
			colHover: false,
			checkable: true,
			checksChanged: function(event) {
				ids[index] = event.checks.checks;
			}
		});
	});
    $('.side-handle-btn').click(function()
    {   
        if($(this).parents('.row-table').hasClass('hide-side'))
        {   
            $('.row-table').removeClass('hide-side');
            $('.side-handle-btn i').removeClass('icon-collapse-full');
            $('.side-handle-btn i').addClass('icon-expand-full');
        }   
        else
        {   
            $('.side-handle-btn i').removeClass('icon-expand-full');
            $('.side-handle-btn i').addClass('icon-collapse-full');
            $('.row-table').addClass('hide-side');
        }   
    });
});
function ajaxUnlinkFromRelease(i,id,unlinkCol,type) {
	bootbox.confirm("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  所选记录将会被移除，您确定要移除吗？</h4>",function(result){
		if (result === false)
			return true;
		else {
			var data = new Array();
			if(type === "batch")
				data = ids[i];
			else
				data[0] = id;
			$.post("../ajaxUnlink" + unlinkCol + "FromRelease/${releaseId}", {ids: data}, function(){
				$.each(data,function(index,value){
					$("tr[data-id='" + value + "']." + unlinkCol).remove();
				});
			});
		}
	});
}
function fixedTfootAction(a) {
    if ($(a).size() == 0) {
        return false
    }
    if ($(a).find("table:last").find("tfoot").size() == 0) {
        return false
    }
    c();
    $(window).scroll(h);
    $(".side-handle").click(function() {
        setTimeout(c, 300)
    });
    var f, e, g, d, j, b;
    function h() {
        f = $(a).find("table:last");
        e = f.find("tfoot");
        d = f.width();
        b = e.hasClass("fixedTfootAction");
        offsetHeight = $(window).height() + $(window).scrollTop();
        j = f.offset().top + f.height() - e.height() / 5;
        g = e.find(".table-actions").children(".input-group");
        if (!b && offsetHeight <= j) {
            e.addClass("fixedTfootAction");
            e.width(d);
            e.find("td").width(d);
            if (g.size() > 0) {
                g.width(g.width())
            }
        }
        if (b && (offsetHeight > j || $(document).height() == offsetHeight)) {
            e.removeClass("fixedTfootAction");
            e.removeAttr("style");
            e.find("td").removeAttr("style")
        }
    }
    function c() {
        e = $(a).find("table:last").find("tfoot");
        if (e.hasClass("fixedTfootAction")) {
            e.removeClass("fixedTfootAction")
        }
        h()
    }
}
</script>
</body>
</html>