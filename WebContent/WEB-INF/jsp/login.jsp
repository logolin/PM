<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="./resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="./resources/style.css" rel="stylesheet"/>
<script src="./resources/zui/assets/jquery.js"></script>
<script src="./resources/dist/js/zui.min.js"></script>

<style>#featurebar ul.nav li .chosen-container a.chosen-single{background:#F8FAFE; border:none; -webkit-box-shadow:none;box-shadow:none; padding-top:5px;}
#featurebar ul.nav li .chosen-container .chosen-drop {min-width: 200px;!important}
#dept_chosen.chosen-container .chosen-drop {min-width: 400px;!important}
body{background-color: #036}
#container{margin: 10% auto 0 auto}
#login-panel{margin: 0 auto;width: 540px;min-height: 280px;background-color: #fff;border: 1px solid #dfdfdf;-moz-border-radius:3px; -webkit-border-radius:3px; border-radius:3px;-moz-box-shadow:0px 0px 30px rgba(0,0,0,0.75); -webkit-box-shadow:0px 0px 30px rgba(0,0,0,0.75); box-shadow:0px 0px 30px rgba(0,0,0,0.75)}
#login-panel .panel-head{min-height: 70px;background-color: #edf3fe;border-bottom: 1px solid #dfdfdf;position: relative}
#login-panel .panel-head h4{margin: 0 0 0 20px;padding: 0;line-height: 70px; font-size: 14px}
#login-panel .panel-actions{float: right;position: absolute;right: 15px;top: 18px;padding: 0}
#login-panel .panel-actions .dropdown {display: inline-block; margin-right: 2px}
#mobile {font-size: 28px; padding: 1px 12px; line-height: 28px}
#mobile i {font-size: 28px;}
#login-panel .panel-content{padding-left: 150px;background: 50px top no-repeat; min-height: 161px}
#login-panel .panel-content table{border: none;width: 300px;margin: 20px auto}
#login-panel .panel-content .button-s{width: 80px}
#login-panel .panel-content .button-c{width: 88px;margin-right: 0}
#login-panel .panel-foot{text-align: center;padding: 15px;line-height: 2em;background-color: #e5e5e5;border-top: 1px solid #dfdfdf}
#poweredby{float: none; color: #eee;text-align: center;margin: 10px auto}
#poweredby a{color: #fff}
#keeplogin label {font-weight: normal}
.popover {max-width: 500px}
.popover-content {padding: 0; width: 297px}
.btn-submit {min-width: 70px}
</style>

<title>用户登录</title>
</head>
<body class="m-user-login">
<div id='container'>
	<div id='login-panel' style="width:400px">
		<div class="panel-head">
	    	<h4>力德科技管理系统</h4>
	    </div>
		<div class="panel-content" id="" style="padding-left:0px">
			<form method="post" class='form-condensed' onsubmit="return check()">
				<table class='table table-form'>
					<tbody>
						<tr>
							<th>用户名</th>
							<td><input type="text" class='form-control' name="account" id="account" /></td>
						</tr>
						<tr>
							<th>密码</th>
							<td><input type="password" class='form-control' name="password" id="password" /></td>
						</tr>
						<tr>
							<th></th>
							<td id="keeplogin">
								<label class='checkbox-inline'>
									<input type='checkbox' name='keepLogin' value='on'  checked ='checked' id='keepLoginon' /> 保持登录
								</label>${err}
							</td>
						</tr>
						<tr>
							<th></th>
							<td>
								<button type="submit" id="submit" class='btn btn-primary'  data-loading="请稍后...">登录</button>
								<input type='hidden' name='referer' id='referer' value='' />
								<a href="" style="margin-left:8px">忘记密码</a>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">
function check() {
	
	var account = $("#account").val();
	var password = $("#password").val();
	if(!account || account == "") {
		alert("用户名不能为空");
		return false;
	} else if(!password || password=="") {
		alert("密码不能为空");
		return false;
	}
}

</script>
</body>
</html>