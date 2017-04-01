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
<style>
.tabs{position:relative;}
.tabs .tab-content .tab-pane .action{position: absolute; right: 0px; top: 0px;}
.tabs .tab-content .tab-pane #querybox{margin:0px}
.tabs .tab-content .tab-pane #querybox form{padding-left:0px;}
.outer .datatable .table, .outer .datatable .table tfoot td {border: none; box-shadow: none}

.hide-side .col-main {width: 100%;}
.hide-side .col-side .main-side {width: 0; display: none;}

#unlinkBugList, #unlinkStoryList{margin-bottom:5px;}
input[type=checkbox].ml-10px{margin-left:10px;}

.dropdown-menu {min-width:95px;}
.dropdown-menu.with-search {padding-bottom: 34px; min-width: 150px; overflow: hidden; max-height: 305px}
.dropdown-menu > .menu-search {padding: 0; position: absolute; z-index: 0; bottom: 0; left: 0; right: 0}
.dropdown-menu > .menu-search .input-group {width:100%;}
.dropdown-menu > .menu-search .input-group-addon {position: absolute; right: 10px; top: 0; z-index: 10; background: none; border: none; color: #666}
</style>
<title>PLAN #${plan.id} ${plan.title}/${currentProduct.name}</title>
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
  				<span class="prefix"><i class="icon-flag"></i><strong>${plan.id}</strong></span>
   				<strong>${plan.title}</strong>
   				<c:if test="${plan.deleted == 1}">
   					<span class='label label-danger'>已经删除</span>
   				</c:if>
      		</div>
  			<div class="actions">
  				<div class="btn-group">
					<a href="./story_create_${productId}" class="btn "><i class="icon-story-create icon-plus"></i> 提需求</a>
					<a class="btn" data-size="lg" data-type="iframe" data-url="./plan_linkStories_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-link"></i> 关联需求</a>
					<a class="btn" data-size="lg" data-type="iframe" data-url="./plan_linkBugs_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-bug"></i> 关联Bug</a>
				</div>
				<div class="btn-group">
					<a href="./plan_edit_${productId}_${planId}" class="btn " title="编辑计划"><i class="icon-common-edit icon-pencil"></i></a>
				</div>
				<a href="./plan_browse_${productId}" class="btn" title="返回"><i class="icon-goback icon-level-up icon-large icon-rotate-270"></i></a>
  			</div>
		</div>	
		<div class="row-table ">
  			<div class="col-main">
    			<div class="main">
      				<div class="tabs">
        				<ul class="nav nav-tabs">
          					<li class="active">
          						<a href="#stories" data-toggle="tab"><i class="icon-lightbulb"></i> 需求</a>
       						</li>
          					<li class="">
          						<a href="#bugs" data-toggle="tab"><i class="icon-bug"></i> Bug</a>
          					</li>
        				</ul>
        				<div class="tab-content" style="padding-bottom: 0px">
          					<div id="stories" class="tab-pane active">
                        		<div class="action">
            						<a class="btn btn-sm btn-primary" data-size="lg" data-type="iframe" data-url="./plan_linkStories_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-link"></i> 关联需求</a>
              						<span class="side-handle-btn">
                            			<a href="###" class="btn btn-sm" style="height: 30px; padding-top: 7px"><i class="icon-expand-full"></i></a>
              						</span>
            					</div>
            					<div class="linkBox"></div>
                        		<form class="form-condensed" method="post" action="">
              						<table class="table datatable table-condensed table-striped table-fixed" id="storyList">
                                		<thead>
                							<tr>
                  								<th data-type="number" data-width="50">ID</th>
                  								<th class="w-pri">P</th>
                  								<th class="">需求名称</th>
                  								<th class="w-user">创建</th>
                  								<th class="w-user">指派</th>
                  								<th class="w-60px">预计</th>
                  								<th class="w-status">状态</th>
                  								<th class="w-80px">阶段</th>
                  								<th data-width="50" data-sort="false">  操作</th>
               								</tr>
                						</thead>
                						<tbody>
                							<c:set var="sum" value="0"/>
                							<c:forEach items="${storyList}" var="story">
                                        	<tr class="text-center storyTr" data-id="${story.id}">
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
                    							<td>${userMap[story.assignedTo]}</td>
                    							<td>${story.estimate}</td>
							                    <td class="story-${story.status}">${storyStatusMap[story.status]}</td>
							                    <td>${stageMap[story.stage]}</td>
							                    <td>
                      								<a href='javascript:ajaxChangePlan(${story.id},"")' class="btn-icon" title="移除需求"><i class="icon-unlink"></i></a>
                    							</td>
                  							</tr>     
                  							<c:set var="sum" value="${sum = sum + story.estimate}" /> 
                  							</c:forEach>                                     
                                  		</tbody>
               		 					<tfoot>
                							<tr>
                  								<td colspan="9">
                    								<div class="table-actions clearfix">
               											<div class="btn-group dropup"> 
               												<button type="button" class="btn btn-default" onclick="ajaxChangePlan('','','batch')">移除需求</button>
               												<button style="height: 26px" type="button" class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
               												<ul class="dropdown-menu">
               													<li class="dropdown-submenu">
               														<a href="javascript:;" id="changePlan">计划</a>
																	<ul class="dropdown-menu">
																		<li class="option">
																			<a href="#" onclick="ajaxChangePlan('','','batch')">空</a>
																		</li>
																		<c:forEach items="${planList}" var="plan">
																			<li class="option"><a href="#" onclick="ajaxChangePlan('','${plan.id}','batch')">${plan.title} [${plan.begin} ~ ${plan.end}]</a></li>
																		</c:forEach>
																	</ul>
																</li>
															</ul>
														</div>                      
														<div class="text">本页共 <strong>${storyList.size()}</strong> 个需求，预计 <strong>${sum}</strong> 个工时，用例覆盖率<strong><c:choose><c:when test="${storyList.size() == 0}">0%</c:when><c:otherwise><fmt:formatNumber type="percent" value="${caseSum/storyList.size()}" /></c:otherwise></c:choose></strong>。</div>
                    								</div>
                  								</td>
               								</tr>
                						</tfoot>
              						</table>
            					</form>
       						</div>
          					<div id="bugs" class="tab-pane ">
                        		<div class="action">
            						<a class="btn btn-sm btn-primary" data-size="lg" data-type="iframe" data-url="./plan_linkBugs_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-bug"></i> 关联Bug</a>
           							<span class="side-handle-btn">
                         				<a href="###" class="btn btn-sm" style="height: 30px; padding-top: 7px"><i class="icon-expand-full"></i></a>
           							</span>
            					</div>
            					<div class="linkBox">
            					</div>
                       			<form method="post" action="">
              						<table class="table datatable table-condensed table-striped table-fixed" id="bugList">
                                		<thead>
                							<tr>
                  								<th data-type="number" data-width="50">ID</th>   
                  								<th class="w-pri">P</th>   
                  								<th class="">Bug标题 </th>      
								                <th class="w-user">创建</th>
                  								<th class="w-user">指派 </th> 
                  								<th class="w-status">状态</th>
                  								<th data-width="50" data-sort="false">操作</th>
                							</tr>
                						</thead>
                						<tbody>
                							<c:forEach items="${bugList}" var="bug">
                                           	<tr class="text-center bugTr" data-id="${bug.id}">
                    							<td>
                                            		<a href="">${bug.id}</a>
                    							</td>
                    							<td><span class="pri${bug.pri}"><c:if test="${bug.pri != 0}">${bug.pri}</c:if></span></td>
                    							<td class="text-left nobr" title="${bug.title}">
                    								<a href="">${bug.title}</a>
												</td>
                    							<td>${userMap[bug.openedBy]}</td>
                    							<td>${userMap[bug.assignedTo]}</td>
                    							<td class="bug-${bug.status}">${bugStatusMap[bug.status]}</td>
                    							<td>
                      								<a href='javascript:ajaxUnlinkPlanFromBugs(${bug.id})' class="btn-icon" title="移除Bug"><i class="icon-unlink"></i></a>
                    							</td>
                  							</tr>
                  							</c:forEach>
                                  		</tbody>
                						<tfoot>
							               	<tr>
							                 	<td colspan="7">
							                   		<div class="table-actions clearfix">
						                      			<button type="button" id="submit" onclick="ajaxUnlinkPlanFromBugs('','batch')" class="btn btn-primary" data-loading="稍候...">批量移除</button>
							                    		<div class="text">本页共 <strong>${bugList.size()}</strong> 个Bug </div>
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
   		 		<div class="main main-side">
      				<fieldset>
        				<legend>描述</legend>
        				<div class="article-content">${plan.descript}</div>
      				</fieldset>
      				<fieldset>
       			 		<legend>基本信息</legend>
        				<table class="table table-data table-condensed table-borderless">
          					<tbody>
          						<tr>
            						<th class="w-80px strong">名称</th> 
            						<td>${plan.title}</td>
          						</tr>
			          			<c:if test="${plan.product.type != 'normal'}">
			                    <tr>
						            <th>
						            	<c:choose>
						            		<c:when test="${plan.product.type == 'branch'}">
							        			所属分支
							        		</c:when>
							        		<c:when test="${plan.product.type == 'platform'}">
							        			所属平台
							        		</c:when>
							        		<c:otherwise></c:otherwise>
							        	</c:choose>
							        </th>
						            <td>${plan.branchName}</td>
					          	</tr>
					          	</c:if>
                    			<tr>
            						<th>开始日期</th>
            						<td>${plan.begin}</td>
          						</tr>
						        <tr>
						           	<th>结束日期</th>
						           	<td>${plan.end}</td>
          						</tr>
        					</tbody>
        				</table>
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
var storyIds,bugIds;
$(document).ready(function()
{
	$("form").each(function(){fixedTfootAction(this)});
	$('table.datatable').each(function(index){
		$(this).datatable({
			sortable: true, 
			colHover: false,
			checkable: true,
			checksChanged: function(event) {
				if (index == 0)
					storyIds = event.checks.checks; 
				else
					bugIds = event.checks.checks;
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
function ajaxChangePlan(storyId,replacePlanId,type) {
	bootbox.confirm("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  所选需求将会被移除，您确定要移除吗？</h4>",function(result){
		if (result === false)
			return true;
		else {
			var story = new Array();
			if(type === "batch")
				story = storyIds;
			else
				story[0] = storyId;
			$.post("../ajaxChangePlan/${planId}", {storyIds: story, replacePlanId: replacePlanId}, function(){
				$.each(story,function(index,value){
					$("tr[data-id='" + value + "'].storyTr").remove();
				});
			});
		}
	});
}
function ajaxUnlinkPlanFromBugs(bugId,type) {
	bootbox.confirm("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  所选Bug将会被移除，您确定要移除吗？</h4>",function(result){
		if (result === false)
			return true;
		else {
			var bug = new Array();
			if(type === "batch")
				bug = bugIds;
			else
				bug[0] = bugId;
			$.post("../ajaxUnlinkPlanFromBugs/${planId}", {bugIds: bug}, function(){
				$.each(bug,function(index,value){
					$("tr[data-id='" + value + "'].bugTr").remove();
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