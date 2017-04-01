<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>

<title>编辑公司::${company.name}</title>
</head>
<body class="m-company-edit body-modal">
	<div class="outer">
		<div id="titlebar">
			<div class="heading">
				<strong>${company.name}</strong>
				<small class="text-muted"> 编辑公司 <i class="icon-pencil"></i></small>
			</div>
		</div>
		<form class="form-condensed mw-500px pdb-20" name="company" method="post" target="_parent">
			<table align="center" class="table table-form"> 
				<tbody>
					<tr>
						<th class="w-100px">公司名称</th>
						<td><div class="required required-wrapper"></div>
						<input type="text" name="name" id="name" value="${company.name}" class="form-control">
						</td>
					</tr>  
					<tr>
					<th>联系电话</th>
						<td><input type="text" name="phone" id="phone" value="${company.phone}" class="form-control">
						</td>
					</tr>  
					<tr>
						<th>传真</th>
						<td><input type="text" name="fax" id="fax" value="${company.fax}" class="form-control">
						</td>
					</tr>  
					<tr>
						<th>通讯地址</th>
						<td><input type="text" name="address" id="address" value="${company.address}" class="form-control">
					</td>
					</tr>  
					<tr>
						<th>邮政编码</th>
						<td><input type="text" name="zipcode" id="zipcode" value="${company.zipcode}" class="form-control">
					</td>
					</tr>  
					<tr>
						<th>官网</th>
						<td><input type="text" name="website" id="website" value="${company.website}" class="form-control">
					</td>
					</tr>  
					<tr>
					<th>内网</th>
						<td><input type="text" name="backyard" id="backyard" value="${company.backyard}" class="form-control">
						</td>
					</tr>  
					<tr>
						<th>匿名登录</th>
						<td><label class="radio-inline"><input type="radio" name="guest" value="0" checked="checked" id="guest0"> 不允许</label><label class="radio-inline"><input type="radio" name="guest" value="1" id="guest1"> 允许</label></td>
					</tr>  
					<tr>
						<td></td>
						<td> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</body>
</html>