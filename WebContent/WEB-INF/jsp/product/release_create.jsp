<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<link href="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.js"></script>
<script type="text/javascript">
var kEditorId = ["descript"];
$(function(){
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
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width:'100%',
	    disable_search_threshold: 1, 
	    placeholder_text_single: ' ', 
	    placeholder_text_multiple: ' '
	});	
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
</script>
<style>
.btn-block {
	height: 30px;
}
a>div>b {
	margin-top: 9px;
}
.contentDiv { 
	height:190px; 
	overflow-y:auto; 
	margin-bottom: 10px!important
}
.contentDiv .panel-heading {
	line-height: 14px;
}
.red {
	color:red
}
.green {
	color:green
}
input[type=checkbox].ml-10px{
	margin-left:10px;
}
.pdl-8px{
	padding-left:8px;
}
</style>
<title>${currentProduct.name}::<c:if test="${operate == 'create'}">创建</c:if><c:if test="${operate == 'edit'}">编辑</c:if>发布</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div class="container mw-1400px">	
			<div id="titlebar">
    			<div class="heading">
      				<c:choose>
      					<c:when test="${operate == 'create'}">
  				    		<strong><small class="text-muted"><i class="icon icon-plus"></i></small> 创建发布</strong>
						</c:when>
						<c:otherwise>
							<span class="prefix"><i class="icon-tags"></i> <strong>${release.id}</strong></span>
							<strong><a href="./release_view_${release.id}">${release.name}</a></strong>
							<small><i class="icon-pencil"></i> 编辑发布</small>
     					</c:otherwise>
      				</c:choose>
    			</div>
  			</div>
			<form class="form-condensed" method="post" enctype="multipart/form-data">
    			<table class="table table-form"> 
      				<tbody>
      					<tr>
        					<th class="w-90px">发布名称</th>
        					<td class="w-p25-f">
        						<div class="required required-wrapper"></div>
          						<input type="text" name="name" id="name" value="${release.name}" class="form-control" required>
        					</td>
        					<td>
          						<span class="help-block"> &nbsp;<c:if test="${lastRelease != null}">(上次发布:  ${lastRelease.name})</c:if></span>        
          					</td>
    					</tr>
      					<tr>
        					<th>版本</th>
        					<td>
        						<span id="buildBox">
        							<select name="build.id" id="build.id" class="form-control chosen-select">
										<c:if test="${operate == 'create'}"><option value="" selected="selected"></option></c:if>
										<c:forEach items="${buildList}" var="build">
											<option value="${build.id}" <c:if test="${build.id == release.build.id}">selected</c:if>><c:if test="${build.branch_id != 0}">${branchMap[build.branch_id]}/</c:if>${build.name}</option>
										</c:forEach>
									</select>
								</span>
							</td>
      					</tr>  
      					<tr>
        					<th>发布日期</th>
        					<td>
        						<div class="required required-wrapper"></div>
        						<input type="text" name="date" id="date" value="${release.date}" class="form-control form-date" required>
							</td>
							<td></td>
      					</tr>
      					<c:if test="${operate == 'edit'}">
						<tr>
        					<th>状态</th>
        					<td>
        						<select name="status" id="status" class="form-control">
									<option value="" <c:if test="${release.status == ''}">selected</c:if>></option>
									<option value="normal" <c:if test="${release.status == 'normal'}">selected</c:if>>正常</option>
									<option value="terminate" <c:if test="${release.status == 'terminate'}">selected</c:if>>停止维护</option>
								</select>
							</td>
							<td></td>
      					</tr> 
      					</c:if>     					
      					<tr>
        					<th>描述</th>
        					<td colspan="2">
        						<textarea name="descript" id="descript" rows="10" class="form-control">${release.descript}</textarea>
							</td>
      					</tr>
      					<tr>
        					<th>附件 (<span class="red">50M</span>)</th>
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
      						<td></td>
      						<td colspan="2"> 
      							<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
      							<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
      						</td>
      					</tr>
    				</tbody>
    			</table>
  			</form>  			  				
		</div>
	</div>
	</div>		
</body>
</html>