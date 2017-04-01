<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
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
<script>
 //chosen的初始化
$(document).ready(function(){
		//chosen的初始化
	$('select.chosen-select').chosen({
		no_results_text: '没有找到',    
		search_contains: true,      
		allow_single_deselect: true
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

<title>${project.name}::编辑版本</title>

<style>
.fileBox {margin-bottom: 10px; width: 100%}
table.fileBox td {padding: 0!important}
.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
.fileBox td .btn {border-radius: 0; border-left: none}
.file-wrapper.form-control {border-right: 0}
</style>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 282px;">
	  	<div class="container">
			<div id="titlebar">
	    		<div class="heading">
			      <span class="prefix"><i class="icon-tag"></i> <strong>${build.id}</strong></span>
			      <strong><a href="${ctxpj}/build_view_${build.id}_${build.project_id}" target="_blank">${build.name}</a></strong>
			      <small class="text-muted"> 编辑版本 <i class="icon-pencil"></i></small>
			    </div>
			</div>
				<form class="form-condensed" method="post" name="build" enctype="multipart/form-data">
				    <table class="table table-form"> 
				      <tbody>
					      <tr>
					      	<th class="w-110px">产品</th>
					        <td class="w-p25-f">
								<div class="required required-wrapper"></div>
							    <div class="input-group">
							          	<select name="product.id" id="product" onchange="loadProduct(this.value);" class="form-control chosen-select">
											<c:forEach items="${productList}" var="product" >
											<option value="${product.id}" <c:if test="${build.product.id == product.id}">selected="selected"</c:if>>${product.name}</option>
											</c:forEach>
										</select>
								</div>
						    </td>
					        <td style="padding-left: px;">
					      </tr>
					      <tr>
					      	<th>名称编号</th>
					      	<td>
					      		<div class="required required-wrapper"></div>
					      		<input type="text" name="name" id="name" value="${build.name}" class="form-control">
					      	</td>
					      </tr>
					      <tr>
					        <th>构建者</th>
					        <td>
					        <div class="required required-wrapper"></div>
					        <select name="builder" id="builder" class="form-control chosen-select">
					        	<c:forEach items="${userList}" var="user">
								<option value="${user.account}" <c:if test="${user.account == build.builder}">selected</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
								</c:forEach>
							</select>
					        </td>
					      </tr>
					      <tr>
					        <th>打包日期</th>
					        <td>
					        <div class="required required-wrapper"></div>
					        	<div class="required required-wrapper"></div>
					        	<input type="text" name="date" id="date" value="${build.date}" class="form-control form-date">
							</td>
					      </tr>
					      <tr>
					        <th>源代码地址</th>
							<td colspan="3">
								<input type="text" name="scmPath" value="${build.scmPath}" class="form-control" placeholder=" 软件源代码库，如Subversion、Git库地址">
							</td>
					      </tr>
				         <tr>
					        <th>下载地址</th>
							<td colspan="3">
								<input type="text" name="filePath" value="${build.filePath}" class="form-control" placeholder=" 该版本软件包下载存储地址">
							</td>
					      </tr>
					      <tr>
					        <th>上传发行包(<span class="red">50M</span>)</th>
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
					        <th>任务描述</th>
					        <td colspan="3">
						        <div class="form-group">
							        <textarea id="descript" name="descript" class="form-control kindeditor " style="height:150px;">${build.descript}</textarea>
						        </div>
					        </td>
					      </tr>
					      <tr>
						  	<td></td>
						   <td colspan="3">
								<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
								<a href="#" class="btn btn-back ">返回</a></td>
						  </tr>
						</tbody>
					</table>
					<span id="responser"></span>
					</form>
				</div>
			</div>
	</div>	
<script type="text/javascript">
$(function(){
	
	var productId = $("#product").val();
	loadProduct(productId);
	
})

function loadProduct(productId) {
	loadProductBranches(productId);

}

function loadProductBranches(productId) {
	$("#branch").remove();
	$.get("../ajaxGetBranches/" + productId,function(data){
		if (!$.isEmptyObject(data)) {
			$("#product").closest('.input-group').append("<select name='branch_id' id='branch' class='form-control' style='width:120px'></select>");
			for (var i = 0; i < data.length; i++) {
				$("#branch").append("<option value='" + data[i].id + "'>" + data[i].name + "</option>");
			}
		}
	});	
}
</script>
</body>
</html>