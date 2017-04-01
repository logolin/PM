<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
    <script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("select.chosen-select").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true, 
	    allow_single_deselect: true,
	})
	//选择时间
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
});
</script>
<title>组织视图::批量编辑</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 406px;">
			<div id="titlebar">
				<div class="heading">
				    <span class="prefix"><i class="icon-check-sign"></i></span>
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 批量添加用户</strong>
				    <div class="actions">
				      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post" onsubmit="return check();" id="userForm">
				<table class="table table-form table-fixed with-border">
					<thead>
      					<tr>
					        <th class="w-40px">ID</th> 
					        <th class="w-150px">所属部门</th>
					        <th class="w-130px">用户名 <span class="required"></span></th>
					        <th class="w-130px" style="padding-left: 15px;">真实姓名 <span class="required"></span></th>
					        <th class="w-120px" style="padding-left: 15px;">职位 <span class="required"></span></th>
					        <th class="w-120px" style="padding-left: 15px;">分组</th>
					        <th class="">邮箱</th>
					        <th class="w-90px">性别</th>
					        <th class="">密码 <span class="required"></span></th>
					        <th class="w-120px hidden" style="padding-left: 15px;">源代码帐号</th>
					        <th class="w-120px hidden">    入职日期</th>
					        <th class="w-120px hidden">   Skype</th>
					        <th class="w-120px hidden">      QQ</th>
					        <th class="w-120px hidden">   雅虎通</th>
					        <th class="w-120px hidden">   GTalk</th>
					        <th class="w-120px hidden">旺旺</th>
					        <th class="w-120px hidden">  手机</th>
					        <th class="w-120px hidden">   电话</th>
					        <th class="w-120px hidden"> 通讯地址</th>
					        <th class="w-120px hidden"> 邮编</th>
      					</tr>
					</thead>
					<tbody>
						<c:forEach begin="0" end="9" step="1" var="i">
							<tr class="text-center">
								<td>${i+1}</td>
						        <td class="text-left" style="overflow:visible">
			        				<select name="users[${i}].dept_id" id="dept" class="form-control chosen dept">
										<option value='0'>/</option>
										<option value="-1" selected="selected">同上</option>
									</select>
								</td>
								<td>
			        				<input type="text" name="users[${i}].account" id="account[${i}]" value="" class="form-control" />
								</td>
								<td>
			        				<input type="text" name="users[${i}].realname" id="realname[${i}]" value="" class="form-control" />
								</td>
								<td>
			        				<select name="users[${i}].role" id="role[${i}]" class="form-control">
										<option value=""></option>
										<option value="dev">研发</option>
										<option value="qa">测试</option>
										<option value="pm">项目经理</option>
										<option value="po">产品经理</option>
										<option value="td">研发主管</option>
										<option value="pd">产品主管</option>
										<option value="qd">测试主管</option>
										<option value="top">高层管理</option>
										<option value="others">其他</option>
										<option value="-1" selected="selected">同上</option>
			        				</select>
								</td>
								<td class="text-left" style="overflow:visible">
									<select name="groupId" id="groupId" class="form-control chosen-select">
										<c:forEach items="${groupList}" var="group">
											<option value="${group.id}">${group.name}</option>
										</c:forEach>
										<option value="-1" selected="selected">同上</option>
									</select>
								</td>
								<td>
			        				<input type="text" name="users[${i}].email" id="email[${i}]" value="${user.email}" class="form-control" />
								</td>
								<td>
									<label class="radio-inline">
										<input type="radio" name="users[${i}].gender" value="m" checked="checked" id="gender[${i}]m">男
									</label>
									<label class="radio-inline">
										<input type="radio" name="users[${i}].gender" value="f" id="gender[${i}]f">女
									</label>
								</td>
								<td align="left">
							        <div class="input-group">
							        <input type="password" name="users[${i}].password" id="password${i}" value="" class="form-control" autocomplete="off" onkeyup="toggleCheck(this, ${i})">
									<c:if test="${i != 0}"><span id="dittospan${i}" class="input-group-addon"><input type="checkbox" name="dittoPW" id="ditto${i}" checked> 同上</span></div></c:if>
								</td>
							</tr>
						</c:forEach>
							<tr>
						    	<th colspan="2">请输入你的密码</th>
						    	<td colspan="6">
							        <div class="required required-wrapper"></div>
							        <input  style="display:none">
							        <input type="password" name="verifyPassword" id="verifyPassword" value="" class="form-control disabled-ie-placeholder" autocomplete="off" placeholder="需要输入你的密码加以验证">
						      	</td>
							</tr>
					</tbody>
					<tfoot>
				    	<tr>
				    		<td colspan="8"> 
				    			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
				    			<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
				    		</td>
				    	</tr>
				    </tfoot>
				</table>
			</form>
		</div>
	</div>
<script>
$(function(){
	loadDept();
	
});
//显示部门
function loadDept() {
	$.ajax({
		url: "../getDept",
		type: 'get',
		async: false,
		success: function(data){
			if(!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			})
			
			removeDitto();
		}
	})
}
function iterateTree(data,name) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		$(".dept").append("<option value='" + data[i].id + "'>" + a + "</option>");
		iterateTree(data[i].children,a);
	}
}

//验证密码和用户名等
function check() {
	var pw;
	var password = $("#verifyPassword").val();
	for(var i = 0; i < 9; i++) {
		if(checkName(i) == false) {
			return false;
		}
		pw = $("#password" + i).val();
		if(pw.length > 0 && pw.length < 6 && i != 0) {
			alert("ID"+ i+1 +", 密码必须六位以上");
			return false;
		}
		if(password != ${userPassword}) {
			alert("安全验证密码错误，请输入您的登录密码");
			return false;
		}
	}
	
	document.getElementById("userForm").submit();
}
//验证用户名
function checkName(i) {
	var name = $("#account" + i).val();
	if(!name) {
		alert("ID"+ (i+1) +"用户名不能为空！");
		return false;
	}
	$.get("../getAllUser", function(data){
		for(var i = 0; i < data.length; i++) {
			if(data[i].account == name) {
				alert("【用户名】已经有『"+ name +"』这条记录了。如果您确认该记录已删除，请到后台管理-回收站还原。");
				return false;
			}
		}
	})
	
}
//去除第一行同上选项
function removeDitto() {
    $firstTr = $(".table-form").find("tbody tr:first");
    $firstTr.find("td select").each(function() {
        $(this).find("option[value='-1']").remove();
        $(this).trigger("chosen:updated")
    })
//     $("#dittospan0").remove();
}
//获得上一行数据
$(document).on('click', '.chosen-with-drop', function()
{
    var select = $(this).prev('select');
    if($(select).val() == '-1')
    {
        var index = $(select).closest('td').index();
        var row   = $(select).closest('tr').index();
        var table = $(select).closest('tr').parent();
        var value = '';
        for(i = row - 1; i >= 0; i--)
        {
            value = $(table).find('tr').eq(i).find('td').eq(index).find('select').val();
            if(value != '-1') break;
        }
        $(select).val(value);
        $(select).trigger("chosen:updated");
    }
});
$(document).on('mousedown', 'select', function()
{
    if($(this).val() == '-1')
    {
        var index = $(this).closest('td').index();
        var row   = $(this).closest('tr').index();
        var table = $(this).closest('tr').parent();
        var value = '';
        for(i = row - 1; i >= 0; i--)
        {
            value = $(table).find('tr').eq(i).find('td').eq(index).find('select').val();
            if(value != '-1') break;
        }
        $(this).val(value);
    }
})
function toggleCheck(obj, i)
{
    if($(obj).val() == '')
    {
        $('#ditto' + i).prop('checked', true);
    }
    else
    {
        $('#ditto' + i).prop('checked', false);
    }
}
</script>
</body>
</html>