<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<title>创建版本库</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/repomenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 406px;">
			<div class="container">
				<div id="titlebar"><div class="heading"><strong>创建版本库</strong></div></div>
  				<form class="form-condensed" method="post" target="hiddenwin">
				<table class="table table-form"> 
					<tbody>
						<tr>
							<th class="w-100px">类型</th>
							<td class="w-p35-f">
								<select name="SCM" id="SCM" class="form-control">
									<option value="Subversion" selected="selected">Subversion</option>
									<option value="Git">Git</option>
								</select>
							</td>
      					</tr>
						<tr>
							<th class="rowhead">名称</th>
							<td><input type="text" name="name" id="name" value="" class="form-control"></td>
						</tr>
						<tr>
							<th class="rowhead">地址</th>
							<td><input type="text" name="path" id="path" value="" class="form-control"></td>
							<td><div class="help-block">例如：SVN: http://example.googlecode.com/svn/,  GIT: /homt/test</div></td>
						</tr>
						<tr>
							<th class="rowhead">编码</th>
							<td><input type="text" name="encoding" id="encoding" value="utf-8" class="form-control"></td>
						</tr> 
						<tr>
							<th class="rowhead">客户端</th>
							<td><input type="text" name="client" id="client" value="" class="form-control"></td>
							<td><div class="help-block">例如：/usr/bin/svn, C:\subversion\svn.exe, /usr/bin/git</div></td>
						</tr>
						<tr>
							<th class="rowhead">用户名</th>
							<td><input type="text" name="account" id="account" value="" class="form-control"></td>
						</tr>
						<tr>
							<th class="rowhead">密码</th>
							<td><input type="password" name="password" id="password" value="" class="form-control"></td>
						</tr>
						<tr>
							<th>权限</th>
							<td>
								<div class="input-group">
						            <span class="input-group-addon">分组</span>
						            <select name="" id="aclgroups" class="form-control chosen" multiple="" style="display: none;">
									</select>
							</td>
						</tr>
						<tr>
							<td></td>
							<td class="text-center"><button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
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