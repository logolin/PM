<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="${ctxResources}/style.css" rel="stylesheet"/>
    <link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
  <title> - 禅道</title>

<link rel="icon" href="/zentao/favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="/zentao/favicon.ico" type="image/x-icon">
<style>#featurebar ul.nav li .chosen-container a.chosen-single{background:#F8FAFE; border:none; -webkit-box-shadow:none;box-shadow:none; padding-top:5px;}
#featurebar ul.nav li .chosen-container .chosen-drop {min-width: 200px;!important}
#dept_chosen.chosen-container .chosen-drop {min-width: 400px;!important}
</style>
</head>
<body class="m-user-delete body-modal">
	<div id="titlebar">
	  <div class="heading">
	    <strong>删除用户</strong>
	  </div>
	</div>
	<form class='form-condensed' method='post' target='hiddenwin' style='padding: 20px 5% 40px'>
	  <table class='w-p100 table-form'>
	    <tr>
	      <th class='w-120px text-right'>请输入你的密码      </th>
	      <td>
	        <div class="required required-wrapper"></div> 
	        <input type='password' name='verifyPassword' id='verifyPassword' value='' class='form-control disabled-ie-placeholder' placeholder='需要输入你的密码加以验证' />
	      </td>
	      <td class='w-100px'> <button type='submit' style="margin-left:10px" id='submit' class='btn btn-primary'  data-loading='稍候...'> 删除</button></td>
	    </tr>
	  </table>
	</form>
</body>
</html>