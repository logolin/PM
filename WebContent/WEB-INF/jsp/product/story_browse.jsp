<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<style>
.table-datatable tbody > tr td,
.table-datatable thead > tr th {max-height: 34px; line-height: 21px;}
.table-datatable tbody > tr td .btn-icon > i {line-height: 19px;}
.hide-side .table-datatable thead > tr > th.check-btn i {visibility: hidden;}
.hide-side .side-handle {line-height: 33px}
.table-datatable .checkbox-row {display: none}
.outer .datatable {border: 1px solid #ddd;}
.outer .datatable .table, .outer .datatable .table tfoot td {border: none; box-shadow: none}
.datatable .table>tbody>tr.active>td.col-hover, .datatable .table>tbody>tr.active.hover>td {background-color: #f3eed8 !important;}
.datatable-span.flexarea .scroll-slide {bottom: -30px}

.panel > .datatable, .panel-body > .datatable {margin-bottom: 0;}

.dropdown-menu.with-search {padding-bottom: 34px; min-width: 150px; overflow: hidden; max-height: 305px}
.dropdown-menu > .menu-search {padding: 0; position: absolute; z-index: 0; bottom: 0; left: 0; right: 0}
.dropdown-menu > .menu-search .input-group {width:100%;}
.dropdown-menu > .menu-search .input-group-addon {position: absolute; right: 10px; top: 0; z-index: 10; background: none; border: none; color: #666}
.pl-5px{padding-left:5px;}
a.removeModule{color:#ddd}
a.removeModule:hover{color:red}
</style>    
<title>${currentProduct.name}::浏览需求</title>
</head>
<body>
	<div id="myModal" class="modal fade">
	  	<div class="modal-dialog" style="min-width: 650px">
	    	<div class="modal-content">
	    	  	<div class="modal-header">
     	   			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
    	  			<h4 class="modal-title">导出数据</h4>
	      		</div>
	      		<div class="modal-body">
	        		<form id="exportForm" class="form-condensed" method="post" style="padding: 40px 1% 50px" action="./story_export_${productId}_${branchId}_${moduleId}_${column}_${columnVal}">
  						<table class="w-p100 table-fixed">
    						<tbody>
    							<tr>
						      		<td>
						        		<div class="input-group">
						         	 		<span class="input-group-addon">文件名：</span>
						          			<input type="text" name="fileName" id="fileName" value="" class="form-control">
						        		</div>
						      		</td>
							      	<td class="w-60px">
							        	<select name="fileType" id="fileType" onchange="switchEncode(this.value)" class="form-control">
											<option value="csv">csv</option>
											<option value="xml">xml</option>
											<option value="html">html</option>
											<option value="pdf">pdf</option>
											<option value="xls">excel</option>
										</select>
							      	</td>
							      	<td class="w-80px">
							        	<select name="encode" id="encode" class="form-control">
											<option value="utf-8" selected="selected">UTF-8</option>
											<option value="gbk">GBK</option>
										</select>
							      	</td>
							      	<td class="w-90px">
							        	<select name="exportType" id="exportType" class="form-control">
											<option value="all" selected="selected">全部记录</option>
											<option value="selected">选中记录</option>
										</select>
										<input id="storyIds2" name="storyIds" type="hidden"/>
							      	</td>
					            	<td class="w-110px" style="overflow:visible">
					        			<span id="tplBox">
					        			<select name="template" id="template" class="form-control chosen" onchange="setTemplate(this.value)">
											<option value="default" selected="selected">默认模板</option>
										</select>
      								</td>
					            	<td style="width:94px">
					        			<div class="input-group">
					           				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">导出</button>                    
					           				<button type="button" onclick="setExportTPL()" class="btn">设置</button>
					                  	</div>
      								</td>
    							</tr>
  							</tbody>
  						</table>
				      	<div class="mb-150px" style="margin-bottom:245px"></div>
			  			<div class="panel" id="customFields" style="display:none">
			    			<div class="panel-heading"><strong>要导出字段</strong></div>
						    <div class="panel-body">
						      	<p>
						      		<select name="exportFields" id="exportFields" class="form-control chosen" multiple="">
										<option value="id" selected="selected">编号</option>
										<option value="product" selected="selected">所属产品</option>
										<option value="module" selected="selected">所属模块</option>
										<option value="plan" selected="selected">所属计划</option>
										<option value="source" selected="selected">需求来源</option>
										<option value="title" selected="selected">需求名称</option>
										<option value="spec" selected="selected">需求描述</option>
										<option value="verify" selected="selected">验收标准</option>
										<option value="keywords" selected="selected">关键词</option>
										<option value="pri" selected="selected">优先级</option>
										<option value="estimate" selected="selected">预计工时</option>
										<option value="status" selected="selected">当前状态</option>
										<option value="stage" selected="selected">所处阶段</option>
										<option value="openedBy" selected="selected">由谁创建</option>
										<option value="openedDate" selected="selected">创建日期</option>
										<option value="assignedTo" selected="selected">指派给</option>
										<option value="assignedDate" selected="selected">指派日期</option>
										<option value="mailto" selected="selected">抄送给</option>
										<option value="reviewedBy" selected="selected">由谁评审</option>
										<option value="reviewedDate" selected="selected">评审时间</option>
										<option value="closedBy" selected="selected">由谁关闭</option>
										<option value="closedDate" selected="selected">关闭日期</option>
										<option value="closedReason" selected="selected">关闭原因</option>
										<option value="lastEditedBy" selected="selected">最后修改</option>
										<option value="lastEditedDate" selected="selected">最后修改日期</option>
										<option value="childStories" selected="selected">细分需求</option>
										<option value="linkStories" selected="selected">相关需求</option>
										<option value="duplicateStory" selected="selected">重复需求</option>
										<option value="files" selected="selected">附件</option>
									</select>
								</p>
			      				<div>
						        	<div class="input-group">
						          		<span class="input-group-addon">模板名称</span>
					          			<input type="text" name="title" id="title" value="" class="form-control">
					                    <span class="input-group-btn"><button id="saveTpl" type="button" onclick="saveTemplate()" class="btn btn-primary">保存</button></span>
					          			<span class="input-group-btn"><button type="button" onclick="deleteTemplate()" class="btn">删除</button></span>
						        	</div>
				      			</div>
    						</div>
  						</div>
  					</form>
	      		</div>
	    	</div>
  		</div>
	</div>
	<header  id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer with-side with-transition hide-side" style="min-height: 494px;">
			<style>
			.datatable-menu-wrapper {position: relative;}
			.datatable-menu {position: absolute; right: 0; top: 0; border: 1px solid #ddd; background: #fff; z-index: 999;}
			.datatable-menu > .btn {padding: 5px 6px; outline: none; color: #4d90fe!important}
			.datatable-menu > .btn:hover {color: #002563!important}
			.datatable + .datatable-menu-wrapper .datatable-menu > .btn {padding: 5px 6px 6px;}
			</style>
			<div class="modal fade" id="showModuleModal" tabindex="-1" role="dialog" aria-hidden="true">
			  	<div class="modal-dialog w-600px">
			    	<div class="modal-content">
			      		<div class="modal-header">
			        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			        		<h4 class="modal-title"><i class="icon-cog"></i> 列表页是否显示模块名</h4>
			      		</div>
			      		<div class="modal-body">
			        		<form class="form-condensed" method="post" target="hiddenwin" action="">
			          			<p>
			            			<span>
			            				<label class="radio-inline"><input type="radio" name="showModule" value="0" checked="checked" id="showModule0"> 不显示</label>
			            				<label class="radio-inline"><input type="radio" name="showModule" value="base" id="showModulebase"> 只显示一级模块</label>
			            				<label class="radio-inline"><input type="radio" name="showModule" value="end" id="showModuleend"> 只显示最后一级模块</label>
			            			</span>
			            			<button type="button" id="setShowModule" class="btn btn-primary">保存</button>
			          			</p>
			        		</form>
			      		</div>
			    	</div>
			  	</div>
			</div>
			<div id="featurebar">
		  		<ul class="nav">
		  			<c:if test="${moduleId == 0}">
		    			<li><div class="label-angle">所有模块      </div></li>
		    		</c:if>
		    		<c:if test="${moduleId != 0}">
		    			<li><div class="label-angle with-close"><a href="./story_browse_${productId}_${branchId}" class="text-muted"><i class="icon icon-remove"></i></a></div></li>
            		</c:if>
            		<li id="unclosedTab" <c:if test="${columnVal == 'unclosed'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_status_unclosed_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">未关闭</a></li>
		           	<li id="allstoryTab" <c:if test="${columnVal == '0'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_deleted_0_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">全部需求</a></li>
		           	<li id="assignedtomeTab" <c:if test="${column == 'assignedTo'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_assignedTo_${userAccount}_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">指派给我</a></li>
		           	<li id="openedbymeTab" <c:if test="${column == 'openedBy'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_openedBy_${userAccount}_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">由我创建</a></li>
		           	<li id="reviewedbymeTab" <c:if test="${column == 'reviewedBy'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_reviewedBy_${userAccount}_${orderBy}_${ascOrDesc}_${recPerPage}_${page}_${isComplex}">由我评审</a></li>
			    	<li id="closedbymeTab" <c:if test="${column == 'closedBy'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_closedBy_${userAccount}_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">由我关闭</a></li>
				    <li id="draftstoryTab" <c:if test="${columnVal == 'draft'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_status_draft_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">草稿</a></li>
				    <li id="activestoryTab" <c:if test="${columnVal == 'active'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_status_active_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">激活</a></li>
				    <li id="changedstoryTab" <c:if test="${columnVal == 'changed'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_status_changed_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">已变更</a></li>
				    <li id="willcloseTab" <c:if test="${columnVal == 'willclose'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_stage_willclose_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">待关闭</a></li>
				    <li id="closedstoryTab" <c:if test="${columnVal == 'closed'}">class="active"</c:if>><a href="./story_browse_${productId}_${branchId}_${moduleId}_status_closed_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}">已关闭</a></li>
		    		<li id="bysearchTab"><a href="javascript:;"><i class="icon-search icon"></i> 搜索</a></li>
		  		</ul>
		  		<div class="actions">
		    		<div class="btn-group">
		      			<div class="btn-group">
		      				<shiro:hasPermission name="story:export">
		        			<a href="#" class="btn " class="export" data-toggle="modal" data-target="#myModal">
		          				<i class="icon-download-alt"></i> 导出数据          </a>
	          				</shiro:hasPermission>
		      			</div>
		      			<shiro:hasPermission name="story:report">
		        			<a href="./story_report_${productId}_${branchId}_${moduleId}_${column}_${columnVal}" class="btn "><i class="icon-common-report icon-bar-chart"></i> 报表</a>
		        		</shiro:hasPermission>
		    		</div>
				    <div class="btn-group">
				    	<shiro:hasPermission name="story:batchCreate">
					    <a href="./story_batchCreate_${productId}_${branchId}_${moduleId}" class="btn "><i class="icon-story-batchCreate icon-plus-sign"></i> 批量添加</a>
					    </shiro:hasPermission>
					    <shiro:hasPermission name="story:create">
						<a href="./story_create_${productId}" class="btn create-story-btn"><i class="icon-story-create icon-plus"></i> 提需求</a>
				    	</shiro:hasPermission>
				    </div>
		  		</div>
		  		<div id="querybox" class=""></div>
			</div>
			<div class="side" id="treebox" >
		  		<a class="side-handle" onclick="showTree()" data-id="productTree" style=""><i id="myIcon" class="icon-caret-right"></i></a>
		  		<div class="side-body">
		    		<div class="panel panel-sm">
		      			<div class="panel-heading nobr"><i class="icon-cube-alt"></i> <strong>${currentProduct.name}</strong></div>
		      			<div class="panel-body">
		        			<ul class="tree-lines tree" id="modulesTree" data-animate="true" data-ride="tree">
         						<li id="branchModules" style="display:none"></li>
       							<c:if test="${currentProduct.type != 'normal' && fn:length(branchList) > 0 && branchId == 0}">
        							<li class="tree-item-branch open in">
        								<span class="tree-toggle"><c:if test="${currentProduct.type == 'branch'}">分支</c:if><c:if test="${currentProduct.type == 'platform'}">平台</c:if></span>
        								<ul>
        									<c:forEach items="${branchList}" var="branch">
     											<li class="tree-item-branch open in">
      											<a href="./story_browse_${productId}_${branch[0].id}">${branch[0].name}</a>
      											<c:if test="${branch[1]}">
        											<ul id="branch${branch[0].id}">
        											</ul>
      											</c:if>
     											</li>
        									</c:forEach>
        								</ul>
        							</li>
       							</c:if>
          					</ul>
		        			<div class="text-right">
		        				<shiro:hasPermission name="tree:browse">
		          					<a href="./module_manage_${productId}">维护模块</a>
		          				</shiro:hasPermission>
		        			</div>
		      			</div>
		    		</div>
		  		</div>
			</div>
			<div class="main">
		  		<form method="post" id="productStoryForm" action="./story_batchEdit_${productId}_${branchId}_form">
        			<div class="datatable-menu-wrapper">
		        		<div class="dropdown datatable-menu">
		        			<c:choose>
		        				<c:when test="${isComplex == true}"><a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_${page}_${!isComplex}" class="btn btn-link"  data-toggle="tooltip" data-trigger="hover" data-title="切换至简单表格" data-placement="right">&nbsp;<i class="icon icon-th-list"></i>&nbsp;</a></c:when>
		        				<c:otherwise><a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_${page}_${!isComplex}" class="btn btn-link"  data-toggle="tooltip" data-trigger="hover" data-title="切换至高级表格" data-placement="right">&nbsp;<i class="icon icon-th"></i>&nbsp;</a></c:otherwise>
		        			</c:choose>
		        		</div>
	        		</div>
	        		<table class="table datatable table-condensed table-striped table-fixed" id="storyList" data-sortable="true" data-checkable='true' data-fixed-left-width='550' data-fixed-right-width='140' data-custom-menu='true' data-checkbox-name='storyIdList'>
				      	<thead>
					   	   <tr>
						        <th data-width="70" class="w-id" <c:if test="${orderBy == 'id'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>ID</th>
						        <th data-width="40" class="w-pri" <c:if test="${orderBy == 'pri'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>P</th>
						        <th data-width='auto' class='w-title' <c:if test="${orderBy == 'title'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>需求名称</th>
						        <c:if test="${isComplex == true && currentProduct.type != 'normal'}">
						        	<th data-width='100px' class='w-branch' data-sort="false">
						        		<c:set var="c" value="${(c+0).intValue()}"/>
						        		${branchMap[c]}
						        	</th>
						        </c:if>
						        <th data-width='90px' class='w-source' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'source'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>需求来源</th>
						        <th data-width='80px' class='w-status' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'status'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>状态</th>
						        <th data-width='90px' class='w-stage' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'stage'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>阶段</th>
						        <th data-width='80px' class='w-estimate' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'estimate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>预计</th>
						        <th data-width='90px' class='w-plan' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'plan'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>计划</th>
						        <th data-width='80px' class='w-openedBy' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'openedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建</th>
						        <th data-width='80px' class='w-assignedTo' <c:if test="${isComplex == true}">data-flex='true'</c:if> <c:if test="${orderBy == 'assignedTo'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派</th>
						        <c:if test="${isComplex == true}">
						        	 <th data-width='90px' class='w-openedDate' data-flex='true' <c:if test="${orderBy == 'openedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>创建日期</th>
							        <th data-width='90px' class='w-assignedDate' data-flex='true' <c:if test="${orderBy == 'assignedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>指派日期</th>
							        <th data-width='80px' class='w-reviewedBy' data-flex='true' <c:if test="${orderBy == 'reviewedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>评审</th>
							        <th data-width='90px' class='w-reviewedDate' data-flex='true' <c:if test="${orderBy == 'reviewedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>评审时间</th>
							        <th data-width='80px' class='w-closedBy' data-flex='true' <c:if test="${orderBy == 'closedBy'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>由谁关闭</th>
							        <th data-width='90px' class='w-closedDate' data-flex='true' <c:if test="${orderBy == 'closedDate'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>关闭日期</th>
							        <th data-width='90px' class='w-closedReason' data-flex='true' <c:if test="${orderBy == 'closedReason'}">data-sort="${ascOrDesc}" style="color: #03c"</c:if>>关闭原因</th>
						        </c:if>
						        <th data-width='auto' class='w-actions' data-sort="false" <c:if test="${isComplex == false}"></c:if>>操作</th>
					      	</tr>
				      	</thead>
		      			<tbody>
		      				<c:set var="sum" value="0"/>
		      				<c:forEach items="${storyPage.content}" var="story">
							<tr class='text-center' data-id='${story.id}'>
								<td class='' title=''>
									<shiro:hasPermission name="story:view"><a href='./story_view_${story.product.id}_${story.id}_${story.version}' ><fmt:formatNumber value="${story.id}" pattern="#000"/></a></shiro:hasPermission>
									<shiro:lacksPermission name="story:view"><fmt:formatNumber value="${story.id}" pattern="#000"/></shiro:lacksPermission>
								</td>
								<td class='' title=''><span class='pri${story.pri}'><c:if test="${story.pri != 0}">${story.pri}</c:if></span></td>
								<td class=' text-left' title='${story.title}'>
									<shiro:hasPermission name="story:view"><a href='./story_view_${story.product.id}_${story.id}_${story.version}' style='color: ${story.color}'>${story.title}</a></shiro:hasPermission>
									<shiro:lacksPermission name="story:view">${story.title}</shiro:lacksPermission>
									</td>
								<c:if test="${isComplex == true && currentProduct.type != 'normal'}">
									<td class='' title=''><c:if test="${story.branch_id == 0}">所有</c:if>${branchMap[story.branch_id]}</td>
								</c:if>
								<td title='${sourceMap[story.source]}'>${sourceMap[story.source]}</td>
								<td class=' story-${story.status}' title='${statusMap[story.status]}'>${statusMap[story.status]}</td>
								<td title='${stageMap[story.stage]}'>${stageMap[story.stage]}</td>
								<td title='${story.estimate}'>${story.estimate}</td>
								<td title='${planStrMap[story.id]}'>${planStrMap[story.id]}</td>
								<td title=''>${userMap[story.openedBy]}</td>
								<td title=''>${userMap[story.assignedTo]}</td>
								<c:if test="${isComplex == true}">
									<td title=''><fmt:formatDate value="${story.openedDate}" pattern="yyyy-MM-dd"/></td>
									<td title=''><fmt:formatDate value="${story.assignedDate}" pattern="yyyy-MM-dd"/></td>
									    <c:set var="d" value=""/>
									    <c:forTokens items="${story.reviewedBy}" delims="," var="reviewedBy">
               								<c:set var="d" value="${d.concat(userMap[reviewedBy]).concat(' ')}"/>
               							</c:forTokens>
									<td title='${d}'>${d}</td>
									<td title=''><fmt:formatDate value="${story.reviewedDate}" pattern="yyyy-MM-dd"/></td>
									<td title=''>${userMap[story.closedBy]}</td>
									<td title=''><fmt:formatDate value="${story.closedDate}" pattern="yyyy-MM-dd"/></td>
									<td title='${closedReasonMap[story.closedReason]}'>${closedReasonMap[story.closedReason]}</td>
								</c:if>
								<td>
									<shiro:hasPermission name="story:review">
										<c:if test="${story.status == 'draft' || story.status == 'changed'}">
											<a href="./story_review_${story.product.id}_${story.id}" class="btn-icon " title="评审"><i class="icon-eye-open icon-search"></i></a>
										</c:if>
										<c:if test="${story.status != 'draft' && story.status != 'changed'}">
											<button type="button" class="disabled btn-icon " disabled><i class="icon-eye-close disabled" title="评审"></i></button>
										</c:if>
									</shiro:hasPermission>
									<c:if test="${story.status != 'closed'}">
										<shiro:hasPermission name="story:change">
											<a href='./story_change_${story.product.id}_${story.id}' class='btn-icon ' title='变更' ><i class='icon-story-change icon-random'></i></a>
										</shiro:hasPermission>
										<shiro:hasPermission name="story:close">
											<a style="cursor: pointer;" data-iframe="./story_close_${story.product.id}_${story.id}" data-show-header="false" data-width="784px" data-toggle="modal" class='btn-icon' title='关闭' ><i class='icon-story-close icon-off'></i></a>
										</shiro:hasPermission>
									</c:if>
									<c:if test="${story.status == 'closed'}">
										<shiro:hasPermission name="story:change">
											<button type="button" class="disabled btn-icon " disabled><i class="icon-random disabled" title="变更"></i></button>
										</shiro:hasPermission>
										<shiro:hasPermission name="story:close">
											<button type="button" class="disabled btn-icon " disabled><i class="icon-off disabled" title="关闭"></i></button>
										</shiro:hasPermission>
									</c:if>
									<shiro:hasPermission name="story:edit">
										<a href='./story_edit_${story.product.id}_${story.id}' class='btn-icon ' title='编辑' ><i class='icon-common-edit icon-pencil'></i></a>
									</shiro:hasPermission>
									<shiro:hasPermission name="testcase:create">
										<a href='' class='btn-icon ' title='建用例' ><i class='icon-testcase-create icon-usecase'></i></a>
									</shiro:hasPermission>
								</td>        
							</tr>
							<c:set var="sum" value="${sum = sum + story.estimate}" />
							</c:forEach>
		      			</tbody>
           	  			<tfoot>
					      	<tr>
					        	<td colspan="<c:if test="${isComplex == true}">11</c:if><c:if test="${isComplex == false}">11</c:if>">
					        	  	<div class="table-actions clearfix">
					        	  		<c:if test="${storyPage.totalElements != 0}">
                        				<div class="checkbox btn">
                        					<label><input type="checkbox" data-scope="" class="check-all check-btn"> 选择</label>
                        				</div>                        
                       					<div class="btn-group dropup">
                       						<input id="storyIds" name="storyIds" type="hidden"/>
                       						<shiro:hasPermission name="story:batchEdit">
           										<button type="submit" class="btn btn-default">编辑</button>              
           									</shiro:hasPermission>
           									<button type="button" class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
           									<ul class="dropdown-menu">
           										<shiro:hasPermission name="story:batchClose">
               										<li><a href="#" onclick="batchChange('Status','closed')">关闭</a></li>
               									</shiro:hasPermission>
               									<shiro:hasPermission name="story:batchReview">
													<li class="dropdown-submenu">
														<a href="javascript:;" id="reviewItem">评审</a>
														<ul class="dropdown-menu">
															<li><a href="#" onclick="batchChange('Status','active')">确认通过</a></li>
															<li><a href="#" onclick="batchChange('Status','closed')">有待明确</a></li>
															<li class="dropdown-submenu">
																<a href="#" id="rejectItem">拒绝</a>
																<ul class="dropdown-menu">
																	<li><a href="#" onclick="batchChange('Status','closed')">已完成</a></li>
																	<li><a href="#" onclick="batchChange('Status','closed')">延期</a></li>
																	<li><a href="#" onclick="batchChange('Status','closed')">不做</a></li>
																	<li><a href="#" onclick="batchChange('Status','closed')">已取消</a></li>
																	<li><a href="#" onclick="batchChange('Status','closed')">设计如此</a></li>
																</ul>
															</li>
														</ul>
													</li>
												</shiro:hasPermission>
												<shiro:hasPermission name="story:batchChangeBranch">
													<li class="dropdown-submenu">
														<a href="javascript:;" id="branchItem">分支</a>
														<ul class="dropdown-menu">
														</ul>
													</li>
												</shiro:hasPermission>
												<shiro:hasPermission name="story:batchChangeModule">
													<li class="dropdown-submenu">
														<a href="javascript:;" id="moduleItem">模块</a>
														<ul class="dropdown-menu with-search">
															<li class="option" data-key="0"><a href="#" onclick="batchChange('Module_id',0)">/</a></li>
															<li class="menu-search">
																<div class="input-group input-group-sm">
																	<input type="text" class="form-control" placeholder="">
																	<span class="input-group-addon"><i class="icon-search"></i></span>
																</div>
															</li>
														</ul>
													</li>
												</shiro:hasPermission>
												<shiro:hasPermission name="story:batchChangePlan">
													<li class="dropdown-submenu">
														<a href="javascript:;" id="planItem">计划</a>
														<ul class="dropdown-menu with-search">
															<li class="option" data-key="0"><a href="#" onclick="batchChange('plan','0')">空</a></li>
															<c:forEach items="${planList}" var="plan">
																<li class="option" data-key="${plan.id}"><a href="#" onclick="batchChange('Plan','${plan.id}')">${plan.title}</a></li>
															</c:forEach>
															<li class="menu-search">
																<div class="input-group input-group-sm">
																	<input type="text" class="form-control" placeholder="">
																	<span class="input-group-addon"><i class="icon-search"></i></span>
																</div>
															</li>
														</ul>
													</li>
												</shiro:hasPermission>
												<shiro:hasPermission name="story:batchChangeStage">
													<li class="dropdown-submenu">
														<a href="javascript:;" id="stageItem">阶段</a>
														<ul class="dropdown-menu">
															<li><a href="#" onclick="batchChange('Stage','')">空</a></li>
															<c:forEach items="${stageMap}" var="stage">
																<li><a href="#" onclick="batchChange('Stage','stage.key')">${stage.value}</a></li>
															</c:forEach>
														</ul>
													</li>
												</shiro:hasPermission>
												<shiro:hasPermission name="story:batchAssignTo">
													<li class="dropdown-submenu">
														<a href="javascript::" target="id=&quot;assignItem&quot;">指派给</a>
														<ul class="dropdown-menu with-search">
															<c:forEach items="${userMap}" var="user">
																<li class="option" data-key="${user.key}"><a href='#' onclick="batchChange('AssignedTo','${user.key}')">${user.value}</a></li>
															</c:forEach>
															<li class="option" data-key="closed"><a href='#' onclick="batchChange('AssignedTo','closed')">Closed</a></li>
															<li class="menu-search">
																<div class="input-group input-group-sm">
																	<input type="text" class="form-control" placeholder="">
																	<span class="input-group-addon"><i class="icon-search"></i></span>
																</div>
															</li>
														</ul>
													</li> 
												</shiro:hasPermission>             
											</ul>
            							</div>
            							</c:if>
                       					<div class="text">本页共 <strong>${storyPage.numberOfElements}</strong> 个需求，预计 <strong>${sum}</strong> 个工时，用例覆盖率<strong><c:choose><c:when test="${storyPage.numberOfElements == 0}">0%</c:when><c:otherwise><fmt:formatNumber type="percent" value="${caseSum/storyPage.numberOfElements}" /></c:otherwise></c:choose></strong>。</div>
       								</div>
       								<c:if test="${storyPage.totalElements != 0}">
					          		<div style="float:right; clear:none;" class="pager form-inline">
				        				共 <strong>${storyPage.totalElements}</strong> 条记录，
				        				<div class="dropdown dropup">
				        					<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
				        					<ul class="dropdown-menu">
					        					<c:forEach begin="5" end="50" step="5" var="i">
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${i}_1_${isComplex}'>${i}</a></li>
					        					</c:forEach>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_100_1_${isComplex}'>100</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_200_1_${isComplex}'>200</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_500_1_${isComplex}'>500</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_1000_1_${isComplex}'>1000</a></li>
					        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_2000_1_${isComplex}'>2000</a></li>
					        				</ul>
					        			</div> 
					        			<strong>${storyPage.number + 1}/${storyPage.totalPages}</strong> &nbsp; 
					        			<c:choose>
					        				<c:when test="${storyPage.isFirst()}">
					        					<i class="icon-step-backward" title="首页"></i>
					        					<i class="icon-play icon-rotate-180" title="上一页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_1_${isComplex}"><i class="icon-step-backward" title="首页"></i></a>
					        					<a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}_${isComplex}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
											</c:otherwise>
						        			</c:choose>
						        			<c:choose>
					        				<c:when test="${storyPage.isLast()}">
					        					<i class="icon-play" title="下一页"></i>
					        					<i class="icon-step-forward" title="末页"></i>
					        				</c:when>
					        				<c:otherwise>
												<a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}_${isComplex}"><i class="icon-play" title="下一页"></i></a> 
					        					<a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_${orderBy}_${ascOrDesc}_${recPerPage}_${storyPage.totalPages}_${isComplex}"><i class="icon-step-forward" title="末页"></i></a>
											</c:otherwise>
					        			</c:choose>
					        		</div>  
					        		</c:if>
					        		<c:if test="${storyPage.totalElements == 0}">   
					        			<div style="float:right; clear:none;" class="page">暂时没有记录</div> 
					        		</c:if>
				          		</td>
					      	</tr>
				      	</tfoot>
		    		</table>
		  		</form>
			</div>
		</div>
	</div>
<script>
var storyIds;
$(function(){fixedTfootAction('#productStoryForm')});
$(document).ready(function(){
	if ($.zui.store.get("showTree")) {
		$('#myIcon').toggleClass('icon-caret-left icon-caret-right');
		$('.outer').removeClass('hide-side');
	}
	$.zui.store.forEach(function(key,value){
		if (key.indexOf("TPL") != -1) {
			$("#template").append("<option value='" + key + "'>" + key.substr(3,key.length) + "</option>");
		}
	});
	$("#exportForm").submit( function () {
		if ($("#exportFields").val() == null) {
			bootbox.alert("<h4><i class='icon icon-info-sign'></i><strong>请至少选择一个导出字段！</strong></h4>");
			return false;
		} else
			return true;
	});
	$("#template,#exportFields").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
    $('.dropdown-menu.with-search .menu-search').click(function(e){
 		e.stopPropagation();
  	    return false;
   	}).on('keyup change paste', 'input', function(){
 		var val = $(this).val().toLowerCase();
  	    var $options = $(this).closest('ul.dropdown-menu.with-search').find('.option');
  	    if(val == '') return $options.removeClass('hide');
  	    $options.each(function(){
        	var $option = $(this);
           	$option.toggleClass('hide', $option.text().toString().toLowerCase().indexOf(val) < 0 && $option.data('key').toString().toLowerCase().indexOf(val) < 0);
        });
    });
	$('[data-toggle="tooltip"]').tooltip();
	$('table.datatable').datatable({
		storage: false,
		scrollPos: 'out',
		colHover: ${isComplex},
		sort: function(event) {
			if (${isComplex} == false) {
				var s = ['id','pri','title','source','status','stage','estimate','plan','openedBy','assignedTo'];
			} else {
				if ("${currentProduct.type}" === "normal") {
					var s = ['id','pri','title','source','status','stage','estimate','plan','openedBy','openedDate','assignedTo','assignedDate','reviewedBy','reviewedDate','closedBy','closedDate','closedReason'];
				} else {
					var s = ['id','pri','title','branch','source','status','stage','estimate','plan','openedBy','openedDate','assignedTo','assignedDate','reviewedBy','reviewedDate','closedBy','closedDate','closedReason'];
				}
			}
			if (s[event.sorter.index] !== "${orderBy}" || event.sorter.type !== "${ascOrDesc}") {
				window.location = "./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_" + s[event.sorter.index] + "_" + event.sorter.type + "_${recPerPage}_${page}_${isComplex}"
			}
		},
		checksChanged: function(event) {
			storyIds = event.checks.checks;
			$("#storyIds").add("#storyIds2").val(storyIds);
			if (storyIds.length == 0) {
				$("#exportType").val("all");
			} else {
				$("#exportType").val("selected");
			}
		}
	});
	$("#productStoryForm").submit(function(){
		 if($('#storyIds').val() === '') {
			 bootbox.alert("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  请选择您要编辑的需求！</h4>");
			 return false;
		 } 
	});
	loadProductBranches("${productId}");
	loadProductModules("${productId}","${branchId}");
})
function showTree() {
	$('#myIcon').toggleClass('icon-caret-left icon-caret-right');
	$('.outer').toggleClass('hide-side');
	if (!$(".outer").hasClass("hide-side")) {
		$.zui.store.set("showTree",true);
	} else {
		$.zui.store.set("showTree",false);
	}
}
function batchChange(fieldName,fieldVal) {
	$.ajax({
		type:"post",
		url:"./story_batchChange_${productId}",
		traditional:true,
		data:{"storyIds":storyIds,"fieldName":fieldName,"fieldVal":fieldVal},
		beforeSend:function(){
			if (storyIds === undefined) {
				bootbox.alert("<h4>请选择您需要修改的需求！</h4>");
				return false;
			}
		},
		complete:function(){
			history.go(0);
		}
	});
}

function loadProductBranches(productId) {
	$.get("../ajaxGetBranches/" + productId,function(data){
		if (!$.isEmptyObject(data)) {
			for (var i = 0; i < data.length; i++) {
				$("#branchItem + ul").append("<li class='option' data-key='" + data[i].id + "'><a href='#' onclick='batchChange('Branch_id'," + data[i].id + ")'>" + data[i].name + "</a></li>");
				if (${branchId} != 0 && data[i].id == ${branchId}) {
					document.getElementsByClassName("nobr")[0].getElementsByTagName("i")[0].className = "icon-node";
					$(".nobr strong").text(data[i].name);
				}
			}
		}
	});	
}
function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
			iterateTree4Nav(data);
		}		
	})
}

function iterateTree(data,name) {
	var a,c,d;
	for (var i = 0,l = data.length; i < l; i++) {
		a = name + "/" + data[i].name;
		d = data[i].branchName;
		if (d !== "分支" && d !== "平台" && d !== "") {
			c = data[i].branchName + a;
			$("#moduleItem + ul").append("<li class='option' data-key='" + data[i].id + "'><a href='#' onclick='batchChange('Module_id'," + data[i].id + ")'>" + c + "</a></li>");
		} else {			
			$("#moduleItem + ul").append("<li class='option' data-key='" + data[i].id + "'><a href='#' onclick='batchChange('Module_id'," + data[i].id + ")'>" + a + "</a></li>");
		}
		iterateTree(data[i].children,a);
	}
}
function iterateTree4Nav(data) {
	var actions;
	var no_list;
	var has_list;
	var childrenLeng;
	var before = function(idStr,content) {
		$(idStr).before(content);
	};
	var append = function(idStr,content) {
		$(idStr).append(content);
	};
	for (var i = 0, l = data.length; i < l; i++) {
		var b = ${branchId} == 0 ? ${branchId} : data[i].branch_id;
		var active = ${moduleId} == data[i].id ? "class='active'" : "";
		no_list = "<li><a href='./story_browse_${productId}_" + b + "_" + data[i].id + "' " + active + ">" + data[i].name + "</a></li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./story_browse_${productId}_" + b + "_" + data[i].id + "' " + active + ">" + data[i].name + "</a><ul id='module" + data[i].id + "'></ul></li>";
		childrenLeng = data[i].children.length;
		if (data[i].id == ${moduleId}) {
			$(".with-close").append(data[i].name);
		}
		if (data[i].parent == 0 && ${branchId} == 0) {
			data[i].branch_id == 0 ? appendList(childrenLeng,"#branchModules",no_list,has_list,before) : appendList(childrenLeng,"#branch" + data[i].branch_id,no_list,has_list,append);
		} else {
			if (${branchId} != 0 && data[i].branch_id != 0) {
				data[i].parent == 0 ? appendList(childrenLeng,"#modulesTree",no_list,has_list,append) : appendList(childrenLeng,"#module" + data[i].parent,no_list,has_list,append);
			} else {
				appendList(childrenLeng,"#module" + data[i].parent,no_list,has_list,append);
			}
		}
		iterateTree4Nav(data[i].children);
	}
}
function appendList(childrenLeng,idStr,no_list,has_list,func) {
	childrenLeng == 0 ? func(idStr,no_list) : func(idStr,has_list);
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
function switchEncode(fileType) {
    $('#encode').removeAttr('disabled');
    if(fileType != 'csv')
    {
        $('#encode').val('utf-8');
        $('#encode').attr('disabled', 'disabled');
    }
}
function saveTemplate() {
	if (window.localStorage) {
		var exportFieldsVal = $("#exportFields").val();
		if (exportFieldsVal == null) {
			bootbox.alert("<h4><i class='icon icon-info-sign'></i><strong>请至少选择一个导出字段！</strong></h4>");
			return true;
		}
		if ($("#title").val() === "") {
			bootbox.prompt({title:"你似乎忘记了填写名称",value:"自定义模板",callback:function(result){$("#title").val(result);}});
			return true;
		}
		var titleVal = $("#title").val();
		if ($.zui.store.get("TPL" + titleVal) === undefined) {
			$.zui.store.set("TPL" + titleVal, exportFieldsVal);
		} else {
			bootbox.confirm("已存在模板“" + titleVal +"”，是否覆盖？", function(result){
				if (result === true) {
					$.zui.store.set("TPL" + titleVal, exportFieldsVal);
				} else {
					return true;
				}
			})
		}
		$("#title").val("");
		$("#template").append("<option value='TPL" + titleVal + "' selected>" + titleVal + "</option>");
		$("#template").trigger("chosen:updated");
	} else {
		console.log("localstorage is invalid");
	}
}
function setTemplate(templateKey) {
	
	var val;
	if(templateKey === "default")
		val = ["id", "product", "module", "plan", "source", "title", "spec", "verify", "keywords", "pri", "estimate", "status", "stage", "openedBy", "openedDate", "assignedTo", "assignedDate", "mailto", "reviewedBy", "reviewedDate", "closedBy", "closedDate", "closedReason", "lastEditedBy", "lastEditedDate", "childStories", "linkStories", "duplicateStory", "files"];
	else
		val = $.zui.store.get(templateKey);
	$("#exportFields").val(val);
	$("#exportFields").trigger("chosen:updated");
}
function deleteTemplate() {
    var templateKey = $("#template").val();
    if(templateKey == "default") return;
	$.zui.store.remove(templateKey);
	$("option[value='" + templateKey + "']").remove();
	$("#template").trigger("chosen:updated");
}

function setExportTPL() {
    $('#customFields').toggle();
    $('.mb-150px').toggle();
}
</script>
</body>
</html>