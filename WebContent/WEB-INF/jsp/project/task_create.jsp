<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script src="${ctxResources}/zui/src/js/color.js"></script>
<script src="${ctxResources}/zui/src/js/colorpicker.js"></script>
<script type="text/javascript">

//判断必填项是否为空
function check() {
	var type = $("#type").val();
	var name = $("#name").val();
	var estimate = $("#estimate").val();
	//供用户查看时间。
	var eststart = $("#estStart").val();
	var deadl = $("#deadl").val();
	//隐藏时间
	var eststarted = $("#estStarted").val();
	var deadline = $("#deadline").val();
	
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
	if(eststart == null || eststart == "") {
		$("#estStarted").val("1970-01-01");
	} else {
		$("#estStarted").val(eststart);
	}
	if(deadl== null || deadl == "") {
		$("#deadline").val("1970-01-01");
	} else {
		$("#deadline").val(deadl);
	}
	
}
</script>
<title>建任务</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 282px;">
	  <div class="container mw-1400px">
		<div id="titlebar">
		    <div class="heading" style="padding-right: 36px;">
		      <span class="prefix"><i class="icon-check-sign"></i></span>
		      <strong>
		      	<small class="text-muted">
		      		<i class="icon-plus"></i>
		      	</small> 建任务
		      </strong>
		    </div>
		    <div class="actions">
		      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
			</div>
		</div>
		<form class="form-condensed" id="task" name="task" onsubmit="return check()" action="./task_create_${projectId}_${storyId}" method="post" enctype="multipart/form-data" data-type="ajax" target="_parent">
			<table class="table table-form"> 
				<tbody>
					<tr>
						<th class="w-100px">所属模块</th>
					    <td class="w-p25-f">
							<div class="input-group" id="moduleIdBox">
          						<select name="module_id" id="module" class="form-control chosen-select" >
								</select>
          					</div>
						</td>
					    <td class="w-p25-f"></td><td></td>
					</tr>
					      <tr>
					        <th>任务类型</th>
					        <td>
						        <div class="required required-wrapper"></div>
						        <select id="type" name="type" class="form-control">
									<option value="" selected="selected"></option>
									<option value="design">设计</option>
									<option value="devel">开发</option>
									<option value="test">测试</option>
									<option value="study">研究</option>
									<option value="discuss">讨论</option>
									<option value="ui">界面</option>
									<option value="affair">事务</option>
									<option value="misc">其他</option>
								</select>
					        </td>
					        <td style="padding-left: 15px;"></td>
					      </tr>
					      <tr>
					        <th>指派给</th>
					        <td>
					        <select id="assignedTo" name="assignedTo" class="form-control chosen-select">
					        	<option value=""></option>
								<c:forEach items="${teamList}" var="user" varStatus="vs">
									<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
								</c:forEach>
							</select>
							<input type="hidden" name="openedBy" value="${currentUser.account}" />
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
											<option value="${story.id}" <c:if test="${storyId == story.id}">selected</c:if>>${story.id}:${story.title}(优先级:${story.pri},预计工时:
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
					        <th>任务名称</th>
					        <td colspan="3">
       							<div class="required required-wrapper"></div>
       							<div class="row-table">
           							<div class="col-table">
          								<div class="input-group w-p100">
											<input type='hidden' name='color' id='color' value='' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#name' />
            								<input type="text" name="name" id="name" value="" class="form-control">
            								<span class="input-group-btn"><a href="#"  id="copyButton" class="btn">同需求</a></span>
          								</div>
           							</div>
                                    <div class="col-table w-250px">
          								<div class="input-group">
                            				<span class="input-group-addon fix-border br-0">优先级</span>
                                            <div class="input-group-btn dropdown-pris" data-set="0,1,2,3,4">
              									<button type="button" class="btn dropdown-toggle br-0" data-toggle="dropdown">
                									<span class="pri-text"><span id="priSpan" class="pri0"></span></span> &nbsp;<span class="caret"></span>
              									</button>
              									<ul class="dropdown-menu pull-right">
	               									<li class="active">
	               										<a href="###" onclick="setPri(this)" data-pri="0"><span class="pri0"></span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="1"><span class="pri1">1</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="2"><span class="pri2">2</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="3"><span class="pri3">3</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="4"><span class="pri4">4</span></a>
	               									</li>
              									</ul>
              									<select name="pri" id="pri" class="hide">
													<option value="0" selected="selected"></option>
													<option value="3">3</option>
													<option value="1">1</option>
													<option value="2">2</option>
													<option value="4">4</option>
												</select>
											</div>
                                            <span class="input-group-addon fix-border br-0">预计</span>
            								<input type="text" name="estimate" id="estimate" value="" class="form-control minw-60px" placeholder="小时">
                        				</div>
        							</div>
           						</div>
       						</td>
					      </tr>
					      <tr>
					        <th>任务描述</th>
					        <td colspan="3">
						        <div class="form-group">
							        <textarea id="descript" name="descript" class="form-control kindeditor " style="height:150px;"></textarea>
						        </div>
					        </td>
					      </tr>  
					      <tr>
					        <th>日程规划</th>
					        	<td>
					          		<div class="input-group" id="dataPlanGroup">
					                	<input type="text" id="estStart" value="" class="form-control form-date" placeholder="预计开始" data-picker-position="top-right">
					                    <input type="hidden" name="estStarted" id="estStarted"/>
					                    	<span class="input-group-addon fix-border">~</span>
					                    <input type=hidden name="deadline" id="deadline" />
					                    <input type="text" id="deadl" value="" class="form-control form-date" placeholder="截止日期" data-picker-position="top-right">
					               </div> 
								</td>
					        	<td colspan="2">
					          		<div id="mailtoGroup" class="input-group">
					                   <span class="input-group-addon">抄送给</span>
					                   <select name="mailto" id="mailto" multiple class="form-control chosen-select" data-placeholder="选择要发信通知的用户..." >
					                   		<c:forEach items="${userList}" var="user" varStatus="vs">
					                   			<option value="${user.account}">${user.account.toCharArray()[0]}:${user.realname}</option>
					                   		</c:forEach>
									   </select>
										<select class="form-control chosen chosen-select">
											<option value="">联系人</option>				
										</select>
									</div>
					        		</td>
					              </tr>
					            <tr>
					        		<th>附件 </th>
						        		<td colspan="2">
		        						<style>
										.fileBox {margin-bottom: 10px; width: 100%}
										table.fileBox td {padding: 0!important}
										.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
										.fileBox td .btn {border-radius: 0; border-left: none}
										.file-wrapper.form-control {border-right: 0}
										</style>
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
									</td>
						      </tr>
						      <tr>
						        <th>添加之后</th>
						        <td colspan="3">
						        <label class="radio-inline">
						        <input type="radio" name="afterRadio" value="${ctxpj}/task_create_${project.id}" checked="checked" id="aftercontinueAdding">继续为该需求添加任务</label>
						        <label class="radio-inline">
						        <input type="radio" name="afterRadio" value="${ctxpj}/project_task_${project.id}" id="aftertoTaskList"> 返回任务列表</label>
						        <label class="radio-inline">
						        <input type="radio" name="afterRadio" value="${ctxpj}/project_story_${project.id}" id="aftertoStoryList"> 返回需求列表</label></td>
						      </tr>
						      <tr>
						        <td></td>
						        <td colspan="3">
									<button type="submit" id="submit" class="btn btn-primary"  data-loading="稍候...">保存</button>
									<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a></td>
						     </tr>
						   </tbody>
						</table>
					<span id="responser"></span>
				</form>
			</div>
		</div>
	</div>	
<script type="text/javascript">
	$(document).ready(function(){
		//chosen的初始化
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});
		//显示后面的查看按钮
		if($("#story_id").val()) {
			$("#preview").css("display","block");
		}
		$('select.chosen-select').on('change', function(){
		    if($("#story_id").val()) {
		    	$("#preview").css("display","block");
		    } else {
		    	$("#preview").css("display","none");
		    }
		    	
		});
		//选择时间
		$(".form-date").datetimepicker({
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
		loadProductModules("${project.id}");

	});
	function skip(){
		var obj = document.getElementsByName("afterRadio");
		for(var i=0; i<obj.length; i ++){
	        if(obj[i].checked){
	        	location.href="obj[i].value";
	        	task.submit();
	        }
	    }
	}
	

// 	显示模块
	function loadProductModules(projectId) {
		
		$.get("../ajaxGetModules/" + projectId,function(data){
			$("#module, #module + div, #module + div + span").remove();
			$("#moduleIdBox").append("<select name='module_id' id='module' class='form-control chosen-select'></select>");
			$("#module").append("<option value='0' selected>/</option>");
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			$("#moduleIdBox #module").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			    allow_single_deselect: true
			});			
		})
	}
	function iterateTree(data,name) {
		var s = "";
		for (var i = 0; i < data.length; i++) {
			a = name + "/" + data[i].name;
			var productNumber = 0;
			if(${storyId} != 0) {
				if(${story.module_id} == data[i].id) {
					s = "selected";
				}
			}
			
			if (productNumber === 0) {
				c = "/" + data[i].productName + a;
				$("#module").append("<option value='" + data[i].id + "' " + s +">" + c + "</option>");
				productNumber = 1;
			} else {
				$("#module").append("<option value='" + data[i].id + "'" + s +">" + a + "</option>");
			}
			iterateTree(data[i].children,a);
		}
	}
	//优先级
	function setPri(obj) {
		$("#priSpan").attr("class",$(obj).find("span").attr("class"));
		$("#priSpan").text($(obj).find("span").text());
		$(obj).parent().addClass("active");
		$(obj).parent().siblings().removeClass("active");
		$("#pri").find("option[value!='" + $(obj).find("span").text() + "']").removeAttr("selected");
		$("#pri").find("option[value='" + $(obj).find("span").text() + "']").attr("selected",true);
	}
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
	</script>
</body>
</html>