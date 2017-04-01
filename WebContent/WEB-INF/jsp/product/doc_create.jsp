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
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/dist/lib/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/dist/lib/kindeditor/kindeditor.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
	    search_contains: true,      // 从任意位置开始检索
	    allow_single_deselect: true,
	    width: "100%"
	});
});
</script>
<style>.outer{overflow:auto}
</style>
<title>创建文档</title>
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
		     	 	<span class="prefix"><i class="icon-cube"></i></span>
		     	 	<strong><small class="text-muted"><i class="icon icon-plus"></i></small> 创建文档</strong>
		    	</div>
	  	</div>
			<div class="contaioner">
				<form class='form-condensed' method='post' enctype='multipart/form-data' id='dataform'>
				    <table class='table table-form'> 
				        <tr>
					        <th class='w-80px'>所属产品</th>
					        <td class='w-p25-f'>
						        <select name='product_id' id='product' class='form-control chosen-select'>
						        	<c:forEach items="${productList}" var="product">
						        		<option value="${product[0]}" <c:if test="${product[0] == productId}">selected</c:if>>${product[1]}</option>
						        	</c:forEach>
								</select>
							</td>
							<td></td>
				      	</tr>  
				        <tr>
					        <th class='w-80px'>所属分类</th>
					        <td>
						        <select name='module' id='module' class='form-control chosen-select'>
						        	<option value=""></option>
								</select>
							</td>
							<td></td>
				      	</tr>  
						<tr>
							<th>文档类型</th>
							<td colspan='2'>
								<label class='radio-inline'><input type='radio' name='type' value='file'  checked ='checked' onclick=setType(this.value) id='typefile' /> 文件</label>
								<label class='radio-inline'><input type='radio' name='type' value='url' onclick=setType(this.value) id='typeurl' /> 链接</label>
								<label class='radio-inline'><input type='radio' name='type' value='text' onclick=setType(this.value) id='typetext' /> 网页</label>
							</td>
							<td></td>
						</tr>  
						<tr>
							<th>文档标题</th>
							<td colspan='2'><input type='text' name='title' id='title' value='' class='form-control' /></td>
					    </tr> 
						<tr id='urlBox' class='hide'>
							<th>文档URL</th>
							<td colspan='2'><input type='text' name='url' id='url' value='' class='form-control' /></td>
							<td></td>
						</tr>  
						<tr id='contentBox' class='hide'>
							<th>文档正文</th>
							<td colspan='2'><textarea name='content' id='content' class='form-control' style='width:90%; height:200px'></textarea></td>
						</tr>  
						<tr>
							<th>关键字</th>
							<td colspan='2'><input type='text' name='keywords' id='keywords' value='' class='form-control' /></td>
						</tr>  
						<tr>
							<th>文档摘要</th>
							<td colspan='2'><textarea name='digest' id='digest' class='form-control' rows=3></textarea></td>
						</tr>  
						<tr id='fileBox'>
							<th>附件 (<span class="red">50M</span>)</th>
							<td colspan='2'>        						
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
							<td> <button type='submit' id='submit' class='btn btn-primary'  data-loading='稍候...'>保存</button><a href='javascript:history.go(-1);' class='btn btn-back ' >返回</a><input type='hidden' name='lib' id='lib' value='product'  /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	</div>
<script>
function setWhite(acl)
{
    acl == 'custom' ? $('#whitelistBox').removeClass('hidden') : $('#whitelistBox').addClass('hidden');
}
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="content"]', {
           width:'100%',
		resizeType : 1,
		urlType:'relative',
		afterBlur: function(){this.sync();$("#content").prev('.ke-container').removeClass('focus');},
  		afterFocus: function(){$("#content").prev('.ke-container').addClass('focus');},
		allowFileManager : true,
		items :[ 'formatblock', 'fontname', 'fontsize', 'lineheight', '|', 'forecolor', 'hilitecolor', '|', 'bold', 'italic','underline', 'strikethrough', '|',
		         'justifyleft', 'justifycenter', 'justifyright', 'justifyfull', '|',
		         'insertorderedlist', 'insertunorderedlist', '|',
		         'emoticons', 'image', 'insertfile', 'hr', '|', 'link', 'unlink', '/',
		         'undo', 'redo', '|', 'selectall', 'cut', 'copy', 'paste', '|', 'plainpaste', 'wordpaste', '|', 'removeformat', 'clearhtml','quickformat', '|',
		         'indent', 'outdent', 'subscript', 'superscript', '|',
		         'table', 'code', '|', 'pagebreak', 'anchor', '|', 
		         'fullscreen', 'source', 'preview', 'about']
	});
});
function setType(type)
{
    if(type == 'url')
    {
        $('#urlBox').show();
        $('#fileBox').hide();
        $('#contentBox').hide();
    }
    else if(type == 'text')
    {
        $('#urlBox').hide();
        $('#fileBox').hide();
        $('#contentBox').show();
    }
    else
    {
        $('#urlBox').hide();
        $('#fileBox').show();
        $('#contentBox').hide();
    }
}
</script>
</body>
</html>