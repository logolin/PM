<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/src/js/color.js"></script>
<script src="../resources/zui/src/js/colorpicker.js"></script>
<style>
button.btn.dropdown-toggle{height: 30px}
a>div>b {
	margin-top: 9px;
}
#assignedTo_chosen a>div>b {
	margin-top: 9px;
}
#dataform .input-group-btn > .btn + .btn {margin-left: -1px;}
#dataform .input-group-addon > .checkbox-inline {padding-right: 10px;}
#dataform .input-group .chosen-container-single .chosen-single {border-top-right-radius: 0; border-bottom-right-radius: 0}
#linkStoriesBox > li ,#childStoriesBox > li {margin-left:-56px}
</style>
<title>编辑STORY::${story.title}</title>
</head>
<body>
	<header id="header">
	  	<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<form:form modelAttribute="story" class="form-condensed" method="post" id="dataform">
			<div id="titlebar">
  				<div class="heading">
    				<span class="prefix"><i class="icon-lightbulb"></i> <strong>${story.id}</strong></span>
    				<strong>
    					<a href="./story_view_${story.product.id}_${story.id}" class="story-title">${story.title}</a>
					</strong>
    				<small><i class="icon-pencil"></i> 编辑</small>
  				</div>
  				<div class="actions">
     				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>  
   				</div>
			</div>
			<div class="row-table">
  				<div class="col-main">
    				<div class="main">
      					<div class="form-group">
        					<div class="input-group">
 								<form:hidden id='color' path='color' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#title, .story-title' />
          						<form:input path="title" id="title" class="form-control disabled" readonly="true" />
        					</div>
      					</div>
      					<fieldset>
        					<legend>需求描述</legend>
       						<div class="article-content">${storySpec.spec}</div>
      					</fieldset>
      					<fieldset>
        					<legend>验收标准</legend>
        					<div class="article-content">${storySpec.verify}</div>
      					</fieldset>
      					<fieldset class="fieldset-pure">
        					<legend>备注</legend>
        					<div class="form-group">
          						<textarea name="comment" id="comment" rows="5" class="form-control"></textarea>
        					</div>
      					</fieldset>
      					<div class="actions actions-form">
 							<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button> 
 							<button type="button" class="btn btn-default" onclick="javascript:history.go(-1)">返回</button>      
						</div>
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
					              			<c:if test="${action.action == 'close'}">，原因为 <strong>${closedReasonMap[action.histories[1].newValue]}。</strong></c:if>
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
		        						<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
			          				<c:if test="${action.comment != ''}"></div></c:if>
			          			</li>
		 						</c:forEach>
		       				</ol>		
		  				</fieldset>
    				</div>
  				</div>
  				<div class="col-side">
    				<div class="main main-side">
      					<fieldset>
        					<legend>基本信息</legend>
        					<table class="table table-form">
          						<tbody>
          							<tr>
            							<th class="w-80px">所属产品</th>
            							<td>
              								<div class="input-group">
                								<form:select path="product.id" id="product" onchange="loadProduct(this.value);" class="form-control chosen-select">
													<form:option value="${currentProduct.id}" label="${currentProduct.name}"/>
													<form:options items="${productList}" itemValue="id" itemLabel="name"/>
												</form:select>
                              				</div>
            							</td>
          							</tr>
          							<tr>
							            <th>所属模块</th>
							            <td>
              								<div class="input-group" id="moduleIdBox">
              									<select name="module_id" id="module" class="form-control chosen-select">
													<option value="0" selected="selected">/</option>
												</select>
              								</div>
            							</td>
          							</tr>
						          	<tr>
						            	<th>所属计划</th>
							            <td>
              								<div class="input-group" id="planIdBox">
                            					<select name="plan" id="plan" class="form-control chosen-select" <c:if test="${story.branch_id == '0'}">multiple=""</c:if>>
													<option value=""></option>
												</select>
              								</div>
            							</td>
          							</tr>
          							<tr>
							            <th>需求来源</th>
							            <td>
							            	<form:select path="source" id="source" class="form-control">
							            		<form:option value=""></form:option>
							            		<c:forEach items="${sourceMap}" var="source">
							            			<form:option value="${source.key}">${source.value}</form:option>
							            		</c:forEach>
											</form:select>
										</td>
          							</tr>
          							<tr>
							            <th>当前状态</th>
							            <td class="story-${story.status}">${statusMap[story.status]}</td>
          							</tr>
          							<tr>
							            <th>所处阶段</th>
							            <td>
							            	<form:select path="stage" id="stage" class="form-control">
												<c:forEach items="${stageMap}" var="stage">
													<form:option value="${stage.key}">${stage.value}</form:option>
												</c:forEach>
											</form:select>
										</td>
          							</tr>
                    				<tr>
							            <th>优先级</th>
							            <td>
							            	<form:select path="pri" id="pri" class="form-control">
							            		<form:option value="0" label=""></form:option>
							            		<form:option value="1">1</form:option>
							            		<form:option value="2">2</form:option>
							            		<form:option value="3">3</form:option>
							            		<form:option value="4">4</form:option>
											</form:select>
										</td>
          							</tr>
          							<tr>
							            <th>预计工时</th>
							            <td>
							            	<form:input path="estimate" id="estimate" class="form-control" />
										</td>
          							</tr>
          							<tr>
            							<th>关键词</th>
							            <td>
							            	<form:input path="keywords" id="keywords" class="form-control" />
										</td>
						          	</tr>
						          	<tr>
							            <th>抄送给</th>
							            <td>
            								<select name="mailto" id="mailto" class="form-control chosen-select" multiple="" data-placeholder="选择要发信通知的用户...">
												<option value=""></option>
												<c:set var="mailto" value=",${story.mailto}," />
				          						<c:forEach items="${userMap}" var="user">
				          							<c:set var="c" value=",${user.key}," />
						          					<option value="${user.key}" <c:if test="${fn:contains(mailto,c)}">selected</c:if>>
						          						${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}
						          					</option>
						          				</c:forEach>
											</select>
										</td>
          							</tr>
       		 					</tbody>
   		 					</table>
      					</fieldset>
      					<fieldset>
					        <legend>需求的一生</legend>
					        <table class="table table-form">
          						<tbody>
          							<tr>
							            <th class="w-80px">由谁创建</th>
							            <td>${fn:toUpperCase(fn:substring(story.openedBy,0,1))}:${userMap[story.openedBy]}</td>
						          	</tr>
						          	<tr>
							            <th>指派给</th>
							            <td>
            								<form:select path="assignedTo" id="assignedTo" class="form-control chosen-select">
												<form:option value=""></form:option>
												<c:forEach items="${userMap}" var="user">
						          					<form:option value="${user.key}" >${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</form:option>
						          				</c:forEach>
											</form:select>
										</td>
          							</tr>
          							<c:if test="${story.status == 'closed'}">
	          							<tr>
	          								<th>由谁关闭</th>
	          								<td>
	            								<form:select path="closedBy" id="closedBy" class="form-control chosen-select">
													<form:option value=""></form:option>
													<c:forEach items="${userMap}" var="user">
							          					<form:option value="${user.key}" >${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</form:option>
							          				</c:forEach>
												</form:select>
											</td>
	          							</tr>
	          							<tr>
	          								<th>关闭原因</th>
	          								<td>
	          									<form:select path="closedReason" id="closedReason" class="form-control">
	          										<c:forEach items="${closedReasonMap}" var="closedReason">
	          											<form:option value="${closedReason.key}" label="${closedReason.value}"/>
	          										</c:forEach>
	          									</form:select>
	          								</td>
	          							</tr>
          							</c:if>
                            	</tbody>
                           	</table>
      					</fieldset>
      					<fieldset>
        					<legend>其他相关</legend>
        					<table class="table table-form">
                    			<tbody>
                    				<c:if test="${story.status == 'closed'}">
	                    				<tr id="duplicateStoryBox">
	            							<th class="w-70px">重复需求</th>
	           								<td>
	           									<form:input path="duplicateStory" id="duplicateStory" class="form-control"/>
											</td>
	          							</tr>
	          						</c:if>
                    				<tr class="text-top">
							            <th class="w-80px">相关需求</th>
							            <td>
              								<a style="cursor:pointer" data-toggle="modal" data-type="iframe" data-url="./story_LinkStories_${story.product.id}_${story.id}" data-width="95%">关联需求</a>
           									<ul class="list-unstyled" id="linkStoriesBox">
											</ul>
            							</td>
          							</tr>
          							<c:if test="${story.status == 'closed'}">
	          							<tr class="text-top">
	            							<th>细分需求</th>
	            							<td>
	              								<a style="cursor:pointer" data-toggle="modal" data-type="iframe" data-url="./story_ChildStories_${story.product.id}_${story.id}" data-width="95%">关联需求</a>
	              								<ul class="list-unstyled" id="childStoriesBox">
	                            				</ul>
	            							</td>
	          							</tr>
	          						</c:if>
                 				</tbody>
               				</table>
      					</fieldset>
    				</div>
  				</div>
			</div>
		</form:form>	
	</div>
	</div>	
<script type="text/javascript">
var kEditorId = ['comment']
$(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
	loadProduct($("#product").val());
	loadStories("${storyId}","LinkStories","linkStoriesBox");
	if ("${story.status}" == "closed")
		loadStories("${storyId}","ChildStories","childStoriesBox");
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
function loadProduct(productId) {
	loadProductBranches(productId);
	loadProductModules(productId);
	loadProductPlans(productId);
}

function loadBranch() {
	var branchId = $("#branch").val();
	if(typeof(branchId) == "undefined")
		branchId = 0;
	loadProductModules($("#product").val(),branchId)
	loadProductPlans($("#product").val(),branchId);
}

function loadProductBranches(productId) {
	$("#branch").remove();
	$.get("../ajaxGetBranches/" + productId,function(data){
		if (!$.isEmptyObject(data)) {
			$("#product").closest('.input-group').append("<select name='branch_id' id='branch' onchange='loadBranch();' class='form-control' style='width:60px'></select>");
			for (var i = 0; i < data.length; i++) {
				$("#branch").append("<option value='" + data[i].id + "'>" + data[i].name + "</option>");
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
		$("#module, #module + div, #module + div + span").remove();
		$("#moduleIdBox").append("<select name='module_id' id='module' class='form-control chosen-select'></select>");
		$("#module").append("<option value='0' selected>/</option>");
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
		} else {
			$("#moduleIdBox").append("<span class='input-group-btn'><a href='./plan_create_" + productId + "_0' class='btn' data-toggle='tooltip' title='创建计划' target='_blank'><i class='icon icon-plus'></i></a>&nbsp; <a href='javascript:loadProductModules(" + productId + ")' class='btn' data-toggle='tooltip' title='刷新'><i class='icon icon-refresh'></i></a></span>");
		}
		$("#moduleIdBox #module").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});			
	})
}

function iterateTree(data,name) {
	var a,c,d;
	for (var i = 0, l = data.length; i < l; i++) {
		a = name + "/" + data[i].name;
		d = data[i].branchName;
		c = (d !== "分支" && d !== "平台" && d !== "") ? d + a : a;
		$("#module").append("<option value='" + data[i].id + "'>" + c + "</option>");
		iterateTree(data[i].children,a);
	}
}

function loadProductPlans(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetPlans/false/" + productId + "/" + branchId,function(data){
		$('#planIdBox').empty();
		$("#planIdBox").append("<select name='plan' id='plan' class='form-control chosen-select' <c:if test="${story.branch_id == 0}">multiple=''</c:if>></select>");
		$("#plan").append("<option value=''></option>");
		if (!$.isEmptyObject(data)) {
			for (var i = 0; i < data.length; i++) {
				s = ",${story.plan},".indexOf(","+data[i].id+",") == -1 ? "" : "selected";
				$("#plan").append("<option value='" + data[i].id + "'" + s + ">" + data[i].title + " [" + data[i].begin + " ~ " + data[i].end + "]" + "</option>");
			}
		} else {
			$("#planIdBox").append("<span class='input-group-btn'><a href='./plan_create_" + productId + "_0' class='btn' data-toggle='tooltip' title='创建计划' target='_blank' style='height: 30px'><i class='icon icon-plus'></i></a>&nbsp; <a href='javascript:loadProductPlans(" + productId + ")' class='btn' data-toggle='tooltip' title='刷新' style='height: 30px'><i class='icon icon-refresh'></i></a></span>");
		}
		$("#planIdBox #plan").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});	
	});
}

function loadStories(storyId,linkOrChildStories,storiesBox) {
	var l = $("#" + storiesBox);
	l.empty();
	$.get("../ajaxGet" + linkOrChildStories + "/" + storyId,function(data){
		if(data.length > 0) {
			for (var i = 0; i < data.length; i++) {
				l.append("<li class='" + linkOrChildStories + "' data-id='" + data[i].id + "'><a href='./story_view_${productId}_" + data[i].id + "_0' target='_blank'>#" + data[i].id + " " + data[i].title + "</a><a href='javascript:ajaxUnlinkOrChildStoryFromStory(" + data[i].id + ",\"" + linkOrChildStories + "\")' title='移除' style='float:right'><i class='icon-remove'></i></a></li>");
			}
		}
	});
}

function ajaxUnlinkOrChildStoryFromStory(storyId,linkOrChildStories) {
	bootbox.confirm("<h4>所选需求将会被移除，您确定要移除吗？</h4>",function(result){
		if (result === false)
			return true;
		else {
			$.post("../ajaxUn" + linkOrChildStories + "FromStory/${story.id}", {storyId: storyId}, function(){
				$("li[data-id='" + storyId + "']." + linkOrChildStories).remove();
			});
		}
	});
}
</script>		
</body>
</html>