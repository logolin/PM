<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String last=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
    <script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
    <script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
    <script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
	<script src="${ctxResources}/zui/src/js/color.js"></script>
	<script src="${ctxResources}/zui/src/js/colorpicker.js"></script>
<script type="text/javascript">
var defaultChosenOptions = {
		no_results_text: '没有匹配结果',
		width:'100%', 
		allow_single_deselect: true, 
		disable_search_threshold: 1,
		placeholder_text_single: ' ', 
		placeholder_text_multiple: ' ', 
		search_contains: true
		};
$(function(){
	$('select.chosen-select').chosen(defaultChosenOptions);	
})
$(document).ready(function(){
		//选择时间
		$(".form-date").datetimepicker(
				{
				    language:  "zh-CN",
				    weekStart: 1,
				    todayBtn:  1,
				    autoclose: 1,
				    todayHighlight: 1,
				    startView: 2,
				    minView: 2,
				    forceParse: 0,
				    format: "yyyy-mm-dd"
				});
		//选择时间
		$(".form-datetime").datetimepicker(
				{
				    language:  "zh-CN",
				    weekStart: 1,
				    todayBtn:  1,
				    autoclose: 1,
				    todayHighlight: 1,
				    startView: 2,
				    minView: 2,
				    forceParse: 0,
				    format: "yyyy-mm-dd hh:mm:ss"
				});
	});
</script>
<title>编辑TASK::${task.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<form class="form-condensed" id="task" name="task" onsubmit="return check();" method="post" enctype="multipart/form-data" data-type="ajax">
			<div id="titlebar">
  				<div class="heading" style="padding-right: 54px;">
    				<span class="prefix"><i class="icon-lightbulb"></i> <strong>${task.id}</strong></span>
    				<strong>
    					<a href="./task_view_${task.id}_${task.project.id}" class="story-title" style="color: ${task.color}">${task.name }</a>
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
								<input type='hidden' name='color' id='color' value='${task.color}' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#name'/>
						    	<input type="text" name="name" id="name" value="${task.name}" class="form-control">
	      					</div>
      					</div>
      					<fieldset class="fieldset-pure">
      						<legend>任务描述</legend>
					        <div class="form-group">
					          	<textarea name="descript" id="descript" rows="8" class="form-control" >${task.descript}</textarea>
					        </div>
						</fieldset>
      					<fieldset class="fieldset-pure">
        					<legend>备注</legend>
        					<div class="form-group">
          						<textarea name="comment" id="comment" rows="5" class="form-control"></textarea>
        					</div>
      					</fieldset>
      					<fieldset class="fieldset-pure">
        					<legend>附件 </legend>
        					<style>
							.fileBox {margin-bottom: 10px; width: 100%}
							table.fileBox td {padding: 0!important}
							.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
							.fileBox td .btn {border-radius: 0; border-left: none}
							.file-wrapper.form-control {border-right: 0}
							</style>
        					<div class="form-group">
								<div id="fileform">
  									<script language="Javascript">dangerFiles = "php,php3,php4,phtml,php5,jsp,py,rb,asp,asa,cer,cdx,aspl";</script>
  									<table class="fileBox" id="fileBox1">
    									<tbody>
    										<tr>
      											<td class="w-p45">
      												<div class="form-control file-wrapper">
      													<input type="file" name="files" class="fileControl" tabindex="-1" onchange="checkSizeAndType(this)">
   													</div>
   												</td>
      											<td class="">
      												<input type="text" name="titles" class="form-control" placeholder="标题：" tabindex="-1">
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="addFile(this)" class="btn btn-block"><i class="icon-plus"></i></a>
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="delFile(this)" class="btn btn-block"><i class="icon-remove"></i></a>
      											</td>
    										</tr>
  										</tbody>
  									</table>
  								</div>
								<script language="javascript">
								/**
								 * Add a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function addFile(clickedButton)
								{
								    fileRow = "  <table class='fileBox' id='fileBox$i'>\n    <tr>\n      <td class='w-p45'><div class='form-control file-wrapper'><input type='file' name='files[]' class='fileControl'  tabindex='-1' onchange='checkSizeAndType(this)'\/><\/div><\/td>\n      <td class=''><input type='text' name='title[]' class='form-control' placeholder='\u6807\u9898\uff1a' tabindex='-1' \/><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='addFile(this)' class='btn btn-block'><i class='icon-plus'><\/i><\/a><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='delFile(this)' class='btn btn-block'><i class='icon-remove'><\/i><\/a><\/td>\n    <\/tr>\n  <\/table>";
								    fileRow = fileRow.replace('$i', $('.fileID').size() + 1);
								
								    /* Get files and labels name.*/
								    fileName  = $(clickedButton).closest('tr').find('input[type="file"]').attr('name');
								    titleName = $(clickedButton).closest('tr').find('input[type="text"]').attr('name');
								
								    /* Add file input control and set files and labels name in it.*/
								    $fileBox = $(clickedButton).closest('.fileBox').after(fileRow).next('.fileBox');
								    $fileBox.find('input[type="file"]').attr('name', fileName);
								    $fileBox.find('input[type="text"]').attr('name', titleName);
								
								    updateID();
								}
								
								/**
								 * Delete a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function delFile(clickedButton)
								{
								    if($('.fileBox').size() == 1) return;
								    $(clickedButton).closest('.fileBox').remove();
								    updateID();
								}
								
								/**
								 * Update the file id labels.
								 * 
								 * @access public
								 * @return void
								 */
								function updateID()
								{
								    i = 1;
								    $('.fileID').each(function(){$(this).html(i ++)});
								}
								</script>
							</div>
      					</fieldset>
      					<div id="linkStoriesBOX">
      						<input type="hidden" name="linkStories" id="linkStories" value="">
						</div>
      					<div id="childStoriesBOX">
      						<input type="hidden" name="childStories" id="childStories" value="">
						</div>
      					<div class="actions actions-form">
       			 			<input type="hidden" name="lastEditedBy" id="lastEditedBy" value="${currentUser.account}">
       			 			<input type="hidden" name="lastEditedDate" id="lastEditedDate" value="<%=last%>">
 							<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button> 
 							<button type="button" class="btn btn-default" onclick="">返回</button>      
						</div>
						<fieldset id="actionbox" class="actionbox">
  							<legend>
    							<i class="icon-time"></i> 
    							历史记录    
    							<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> 
    								<span title="切换顺序" class="log-asc icon-"></span>
   								</a>
    							<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);">
    								<span title="切换显示" class="change-show icon-"></span>
   								</a>
  							</legend>
  							<ol id="historyItem">
                				<li value="1">
            						<span class="item">
        								2016-07-13 10:29:15, 由 <strong>Demo</strong> 创建。
              						</span>
          						</li>
          						<li value="2" class="">
						            <span class="item">
						        	2016-07-25 10:57:18, 由 <strong>admin</strong> 编辑。
							        	<a id="switchButton3" class="switch-btn btn-icon" onclick="switchChange(3)" href="javascript:;">
							        		<i class="icon- change-show"></i>
							        	</a>
						        	</span>
								</li>
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
            							<th class="w-80px">所属项目</th>
            							<td>
              								<div class="input-group">
                								<select name="project_id" id="project" class="form-control chosen-select" onchange="loadProjectModules(this.value)">
	                								<c:forEach items="${projectList}" var="projectlist">
														<option value="${projectlist.id}" <c:if test="${projectlist.id == project.id}">selected="selected"</c:if>>
														${projectlist.name}
														</option>
													</c:forEach>
												</select>
                              				</div>
            							</td>
          							</tr>
          							<tr>
							            <th>所属模块</th>
							            <td>
              								<div class="input-group" id="moduleIdBox">
              									<select name='module_id' id='module' class='form-control chosen'></select>
              								</div>
            							</td>
          							</tr>
						          	<tr>
						            	<th>相关需求</th>
							            <c:if test="${storyList != null}">
											<td colspan="3">
												<div class="input-group">
											    	<select name="story_id" id="story_id" class="form-control chosen-select">
														<option value=""> </option>
														<c:forEach items="${storyList}" var="story">
														<option value="${story.id}" <c:if test="${task.story_id == story.id}">selected</c:if>>${story.id}:${story.title}(优先级:${story.pri},预计工时:
														<fmt:formatNumber value="${story.estimate}" type="number" />)</option>
														</c:forEach>
													</select>
											    <span class="input-group-btn" id="preview" style="display:none">
											    <a href="#" class="btn iframe">查看</a></span>
											    </div>
											</td>
										</c:if>
          							</tr>
          							<tr>
							            <th>指派给</th>
							            <td>
							            	<select name="assignedTo" id="assignedTo" class="form-control chosen-select">
												<option value=""></option>
												<c:forEach items="${userList}" var="user">
												<option value="${user.account}" <c:if test="${task.assignedTo == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
												</c:forEach>
											</select>
										</td>
          							</tr>
          							<tr>
							        	<th>任务类型</th>
								        <td>
								        <select id="type" name="type" class="form-control chosen">
											<option value="" <c:if test="${task.type == 'design'}">selected="selected"</c:if>></option>
											<option value="design" <c:if test="${task.type == 'design'}">selected="selected"</c:if>>设计</option>
											<option value="devel" <c:if test="${task.type == 'devel'}">selected="selected"</c:if>>开发</option>
											<option value="test" <c:if test="${task.type == 'test'}">selected="selected"</c:if>>测试</option>
											<option value="study" <c:if test="${task.type == 'study'}">selected="selected"</c:if>>研究</option>
											<option value="discuss" <c:if test="${task.type == 'discuss'}">selected="selected"</c:if>>讨论</option>
											<option value="ui" <c:if test="${task.type == 'ui'}">selected="selected"</c:if>>界面</option>
											<option value="affair" <c:if test="${task.type == 'affair'}">selected="selected"</c:if>>事务</option>
											<option value="misc" <c:if test="${task.type == 'misc'}">selected="selected"</c:if>>其他</option>
										</select>
								        </td>
          							</tr>
                    				<tr>
							            <th>任务状态</th>
							            <td>
							            	<select name="status" id="status" class="form-control">
												<option value=""></option>
												<option value="wait" <c:if test="${task.status == 'wait'}">selected</c:if>>未开始</option>
												<option value="doing" <c:if test="${task.status == 'doing'}">selected</c:if>>进行中</option>
												<option value="done" <c:if test="${task.status == 'done'}">selected</c:if>>已完成</option>
												<option value="pause" <c:if test="${task.status == 'pause'}">selected</c:if>>已暂停</option>
												<option value="cancel" <c:if test="${task.status == 'cancel'}">selected</c:if>>已取消</option>
												<option value="closed" <c:if test="${task.status == 'closed'}">selected</c:if>>已关闭</option>
											</select>
										</td>
          							</tr>
          							<tr>
							            <th>优先级</th>
							            <td>
							            	<select name="pri" id="pri" class="form-control">
												<option value="0" selected="selected"></option>
												<option value="3">3</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="4">4</option>
											</select>
										</td>
          							</tr>
						          	<tr>
							            <th>抄送给</th>
							            <td>
            								<select name="mailto" id="mailto" class="form-control chosen-select" multiple="" data-placeholder="选择要发信通知的用户...">
												<c:forEach items="${userList}" var="user">
												<option value="${user.account}" <c:if test="${task.mailto == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
												</c:forEach>
											</select>
										</td>
          							</tr>
       		 					</tbody>
   		 					</table>
      					</fieldset>
      					<fieldset>
					        <legend>工时信息</legend>
					        <table class="table table-form"> 
					          <tbody>
								<tr>
						            <th class="w-70px">预计开始</th>
						            <td>
						            	<input type="hidden" name="estStarted" id="estStarted"/>
						            	<input type="text" id="copyestStart" value="${task.estStarted}" class="form-control form-date">
									</td>
								</tr>
								<tr>
						            <th>实际开始</th>
						            <td>
						            	<input type="hidden" name="realStarted" id="realStarted"/>
						            	<input type="text" id="copyrealStart" value="${task.realStarted}" class="form-control form-date">
						            </td>
								</tr>  
								<tr>
					            	<th>截止日期</th>
						            <td>
						            	<input type="hidden" name="deadline" id="deadline"/>
						            	<input type="text" id="copydeadline" value="${task.deadline}" class="form-control form-date">
						            </td>
								</tr>  
								<tr>
						          	<th>最初预计</th>
						            <td><input type="text" name="estimate" id="estimate" value="<fmt:formatNumber type="number" value="${task.estimate}" />" class="form-control">
									</td>
								</tr>  
					          	<tr>
					            	<th>总消耗</th>
					            	<td><fmt:formatNumber type="number" value="${task.consumed}" /> <a href="" class="btn-icon iframe" title="工时"><i class="icon-task-recordEstimate icon-time"></i></a></td>
					          	</tr>  
					          	<tr>
						            <th>预计剩余</th>
						            <td><input type="text" name="remain" id="remain" value="<fmt:formatNumber type="number" value="${task.remain}" />" class="form-control">
									</td>
								</tr>
							 </tbody>
						   </table>
						</fieldset>
      					<fieldset>
					        <legend>任务的一生</legend>
					        <table class="table table-form">
          						<tbody>
          							<tr>
							            <th class="w-80px">由谁创建</th>
							            <td>${task.openedBy}</td>
						          	</tr>
						          	<tr>
							            <th>由谁完成</th>
							            <td>
							            	<select name="finishedBy" id="finishedBy" class="form-control chosen-select">
							            		<option value=""></option>
												<c:forEach items="${userList}" var="user">
													<option value="${user.account}" <c:if test="${task.finishedBy == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
												</c:forEach>
											</select>
										</td>
          							</tr>
          							<tr>
							            <th>完成时间</th>
							            <td>
							            	<input type="hidden" name="finishedDate" id="finishedDate"/>
							            	<input type="text"  id="copyfinish" value="<fmt:formatDate value="${task.finishedDate}" type="both" />" class="form-control form-datetime">
										</td>
									</tr>
									<tr>
							            <th>由谁取消</th>
							            <td>
							            	<select id="canceledBy" name=canceledBy class="form-control chosen chosen-select">
							            		<option value=""></option>
												<c:forEach items="${userList}" var="user">
													<option value="${user.account}" <c:if test="${task.canceledBy == user.account}">seleted</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
												</c:forEach>
							            	</select>
										</td>
									</tr>
									<tr>
							            <th>取消时间</th>
							            <td>
							            	<input type="hidden" name="canceledDate" id="canceledDate"/>
							            	<input type="text" id="copycancel" value="<fmt:formatDate value="${task.canceledDate}" type="both"/>"class="form-control form-datetime">
										</td>
									</tr>
									<tr>
							            <th>由谁关闭</th>
							            <td>
							            	<select id="closedBy" name="closedBy" class="form-control chosen-select">
							            		<option value=""></option>
												<c:forEach items="${userList}" var="user">
													<option value="${user.account}" <c:if test="${task.closedBy == user.account}">seleted</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
												</c:forEach>
							            	</select>
										</td>
									</tr>
									<tr>
										<th>关闭原因</th>
										<td>
											<select id="closedReason" name="closedReason" class="form-control">
												<option value=""></option>
												<option value="done" <c:if test="${task.closedReason == 'done'}">seleted</c:if>>已完成</option>
												<option value="cancel" <c:if test="${task.closedReason == 'cancel'}">seleted</c:if>>已取消</option>
											</select>
										</td>
									</tr>
									<tr>
							            <th>关闭时间</th>
							            <td>
							            	<input type="hidden" name="closedDate" id="closedDate"/>
							            	<input type="text" id="copyclose" value="<fmt:formatDate value="${task.closedDate}" type="both"/>" class="form-control form-datetime">
										</td>
									</tr>
                            	</tbody>
                           	</table>
      					</fieldset>
    				</div>
  				</div>
			</div>
		</form>	
	</div>
	</div>		
<script type="text/javascript">
$(function(){
	loadProjectModules("${project.id}")
})

//检验必填项是否为空
function check() {
	
	var type = $("#type").val();
	var name = $("#name").val();
	var estimate = $("#estimate").val();
	
	if(type == null || type == "") {
		alert("『任务类型』不能为空");
		return false;
	}
	if(name == null || name == "") {
		alert("『任务名称』不能为空");
		return false;
	}
	if(estimate == null || estimate == "") {
		alert("『预计剩余』不能为空");
		return false;
	} else if(isNaN(estimate)) {
		alert("『预计剩余』应当为数字");
		return false;
	}
	
	//供用户查看时间。
	var copyestStart = $("#copyestStart").val();
	var copydeadline = $("#copydeadline").val();
	var copyrealStart = $("#copyrealStart").val();
	var copyfinish = $("#copyfinish").val();
	var copycancel = $("#copycancel").val();
	var copyclose = $("#copyclose").val();
	//隐藏时间
	var eststarted = $("#estStarted").val();
	var deadline = $("#deadline").val();
	var realStarted = $("#realStarted").val();
	var finishedDate = $("#finishedDate").val();
	var canceledDate = $("#canceledDate").val();
	var closedDate = $("#closedDate").val();
	
	
	if(copyestStart == null || copyestStart == "") {
		$("#estStarted").val("1970-01-01");
	} else {
		$("#estStarted").val(copyestStart);
	}
	if(copydeadline== null || copydeadline == "") {
		$("#deadline").val("1970-01-01");
	} else {
		$("#deadline").val(copydeadline);
	}
	if(copyrealStart == null || copyrealStart == "") {
		$("#realStarted").val("1970-01-01");
	} else {
		$("#realStarted").val(copyrealStart);
	}
	if(copyfinish== null || copyfinish == "") {
		$("#finishedDate").val("1970-01-01 00:00:00");
	} else {
		$("#finishedDate").val(copyfinish);
	}
	if(copycancel == null || copycancel == "") {
		$("#canceledDate").val("1970-01-01 00:00:00");
	} else {
		$("#canceledDate").val(copycancel);
	}
	if(copyclose== null || copyclose == "") {
		$("#closedDate").val("1970-01-01 00:00:00");
	} else {
		$("#closedDate").val(copyclose);
	}
	
}

//获得模块list
function loadProjectModules(projectId) {
	
	$.get("../ajaxGetModules/" + projectId,function(data){
		$("#module, #module + div, #module + div + span").remove();
		$("#moduleIdBox").append("<select name='module_id' id='module' class='form-control chosen'></select>");
		$("#module").append("<option value='0' selected>/</option>");
		
			if (!$.isEmptyObject(data)) {
				console.log(data);
				iterateTree(data,"");
			}
		$("select.chosen").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		});	
	})
}

function iterateTree(data,name) {
	var modId = ${task.module_id};
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		s = modId == data[i].id ? "selected" : "";
		$("#module").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
		iterateTree(data[i].children,a);
	}
}




//富文本框
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea', {
           width:'100%',
		resizeType : 1,
		urlType:'relative',
		afterBlur: function(){this.sync();},
		allowFileManager : true,
		items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
		          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
		          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
	});
});

//历史操作记录伸缩和排序
var fold   = '-';
var unfold = '+';
function switchChange(historyID)
{
    $swbtn = $('#switchButton' + historyID);
    $showTag = $swbtn.find('.change-show');
    if($showTag.length)
    {
        $swbtn.closest('li').addClass('show-changes');
        $showTag.removeClass('change-show').addClass('change-hide');
        $('#changeBox' + historyID).show();
        $('#changeBox' + historyID).prev('.changeDiff').show();
    }
    else
    {
        $swbtn.closest('li').removeClass('show-changes');
        $swbtn.find('.change-hide').removeClass('change-hide').addClass('change-show');
        $('#changeBox' + historyID).hide();
        $('#changeBox' + historyID).prev('.changeDiff').hide();
    }
}

</script>
</body>
</html>