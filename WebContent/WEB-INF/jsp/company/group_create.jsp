<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
<title>组织视图::新增分组</title>
</head>
<body>
<header id="header">
	<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
</header>
<div class="wrap">
	<div class="outer" style="min-height:406px;">
		<div class="container mw-500px" style="margin-top:20px">
			<div id="titlebar">
				<div class="heading">
					<span class="prefix" title="GROUP"><i class="icon-group"></i></span>
					<strong><small><i class="icon-plus"></i></small> 新增分组</strong>
				</div>
			</div>
			<form class="form-condensed mw-500px pdb-20" method="post" id="dataform">
				<table align="center" class="table table-form"> 
					<tbody>
						<tr>
							<th class="w-80px">分组名称</th>
							<td><div class="required required-wrapper"></div>
								<input type="text" name="name" id="name" value="" class="form-control">
							</td>
						</tr>  
						<tr>
							<th>分组描述</th>
							<td>
								<textarea name="descript" id="descript" rows="5" class="form-control"></textarea>
								<input type="text" name="role" class="hide">
								<input type="text" name="acl" class="hide">
							</td>
						</tr>  
						<tr><th></th><td> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td></tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</div>
</body>
</html>