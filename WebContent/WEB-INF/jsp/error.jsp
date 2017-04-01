<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<style>#featurebar ul.nav li .chosen-container a.chosen-single{background:#F8FAFE; border:none; -webkit-box-shadow:none;box-shadow:none; padding-top:5px;}
#featurebar ul.nav li .chosen-container .chosen-drop {min-width: 200px;!important}
#dept_chosen.chosen-container .chosen-drop {min-width: 400px;!important}
body{background: #f1f1f1;}
.container{padding: 0}
.modal-dialog{width: 500px!important; margin-top: 10%;}
.modal-footer{text-align: center;margin-top: 0;}

@media (max-width: 700px){.modal-dialog{padding: 0;} .modal-content{box-shadow: none;border-width: 1px 0;border-radius: 0}}

.alert {display: table;}
.btn {transition:none;}
</style>
<title>无权限</title>
</head>
<body>
	<div class="container">
		<div class="modal-dialog">
			<div class="modal-header"><strong>${userName} 访问受限</strong></div>
			<div class="modal-body">
				<div class="alert with-icon alert-pure">
					<i class="icon-info-sign"></i>
					<div class="content">抱歉，您无权访问『<b>${objectTypeMap[mainUrl]}视图</b>』模块的『<b>${subUrl}</b>』功能。请联系管理员获取权限。点击后退返回上页。        </div>
				</div>
			</div>
			<div class="modal-footer">
				<a href="javascript:history.go(-1);" class="btn">返回上一页</a>
				<a href="./user_login" class="btn btn-primary">重新登录</a>
			</div>
	  </div>
	</div>
</body>
</html>