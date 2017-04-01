<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String finished=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); %>
<% String finish=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
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
<script src="${ctxResources}/dist/js/flex.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
		no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
		search_contains: true,      // 从任意位置开始检索
		allow_single_deselect: true,
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
});
</script>
</head>
<body>
<div id="titlebar">
	<div class="heading">
		<span class="prefix"><i class="icon-check-sign"></i> <strong>${task.id}</strong></span>
	    <strong class="heading-title" style="color: ${task.color}">${task.name}</strong>
		<small class="text-muted"> 完成</small>
	    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
	</div>
</div>
<form name="task" method="post" enctype="multipart/form-data"  data-type="ajax" target="_parent">
	<table class="table table-form"> 
		<tbody>
			<tr>
				<th class="w-80px">总消耗</th>
				<td class="w-p25-f"><div class="required required-wrapper"></div>
					<div class="input-group">
					 	<input type="text" name="consumed" value="<fmt:formatNumber value="${task.consumed}" type="number"/>" class="form-control">
	 					<span class="input-group-addon">小时</span>
	 				</div>
				</td>
				<td></td>
			</tr> 
			<tr>
				<th>指派给</th>
				<td>
					<div class="input-group">
						<select id="assignedTo" name="assignedTo" class="form-control chosen-select">
							<option value=""></option>
							<c:forEach items="${userList}" var="user" varStatus="vs">
								<option value="${user.account}" <c:if test="${user.account == task.assignedTo}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
							</c:forEach>
						</select>
					</div>
				</td>
				<td></td>
			</tr>
			<tr>
				<th>完成时间</th>
				<td>
					<div class="datepicker-wrapper">
						<input type=text value="<%=finished %>" class="form-control form-date">
					 	<input type="hidden" name="finishedDate" id="finishedDate" value="<%=finish %>" class="form-control form-date">
					</div>
					<input type="hidden" name="finishedBy" value="${currentUser.account}" />
				</td>
				<td></td>
			</tr>
			<tr>
				<th>附件</th>
				<td colspan="2">
					<style>
					.fileBox {margin-bottom: 10px; width: 100%}
					table.fileBox td {padding: 0!important}
					.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
					.fileBox td .btn {border-radius: 0; border-left: none}
					.file-wrapper.form-control {border-right: 0}
					</style>
					<div class="from-group">
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
  					<script type="text/javascript">
  				//上传文件
  					function addFile(clickedButton) {
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
  					function delFile(clickedButton) {
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
  					function updateID() {
  						i = 1;
  						$('.fileID').each(function(){$(this).html(i ++)});
  					}
  					</script>
  					</div>
				</td>
			</tr>
			<tr>
				<th>备注</th>
				<td colspan="2">
					<div class="form-group">
						<textarea name="comment" class="form-control kindeditor " style="height:150px;"></textarea>
					</div>
				</td>
			</tr>
			<tr>
	      		<th></th>
	      		<td colspan="2"> 
	      			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
	      		</td>
			</tr>
		</tbody>
	</table>
</form>
<div class="main" style="position: relative; height: 380px; overflow:auto;">
	<fieldset id="actionbox" class="actionbox">
		<legend>
			<i class="icon-time"></i>历史记录    
			<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
			<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
		</legend>
		<ol id="historyItem">
			<li value="1">
				<span class="item">
			    	2016-07-08 16:38:19, 由 <strong>Demo</strong> 创建。
			    </span>
			</li>
			<li value="2" class="">
				<span class="item">
			    2016-07-08 17:41:10, 由 <strong>Demo</strong> 编辑。
			    <a id="switchButton3" class="switch-btn btn-icon" onclick="switchChange(3)" href="javascript:;"><i class="icon- change-show"></i></a>      
			    </span>
				<div class="changes hide alert" id="changeBox3" style="display: none;">
			     	 修改了 <strong><i>color</i></strong>，旧值为 ""，新值为 "#00bcd4"。<br>
			    </div>
			</li>
		</ol>		
	</fieldset>
</div>
<script type="text/javascript">
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

</script>
</body>
</html>