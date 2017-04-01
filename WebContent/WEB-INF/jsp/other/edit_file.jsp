<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>编辑文档</title>
</head>
<body class="m-file-edit body-modal">

<style>
body{padding-bottom:0px}
</style>

<script>
function setFileName()
{
    time = setInterval("closeWindow()", 200);
    return true;
}

function closeWindow()
{
    parent.$.closeModal();
    clearInterval(time);
}
</script>
	<div id="titlebar">
		<div class="heading">
			<span class="prefix"><i class="icon-pencil"></i></span>
			<strong>请输入附件名称</strong>
		</div>
	</div>
	<form class="form-condensed" method="post" target="hiddenwin" onsubmit="setFileName();" style="padding: 30px 5%">
		<table class="w-p100">
	    	<tbody>
	    		<tr>
	    			<td>
				        <div class="input-group">
				          <input type="text" name="fileName" id="fileName" value="${file.title}" class="form-control">
				          <strong class="input-group-addon">${file.extension}</strong>
				        </div>
	    			</td>
	    			<td> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td>
	    		</tr>
	  		</tbody>
	  	</table>
	</form>
</body>
</html>