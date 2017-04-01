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
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 批量编辑</strong>
				    <div class="actions">
				      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post" onsubmit="return check();" action="./user_batchEdit_post">
				<table class="table table-form table-fixed with-border">
					<thead>
      					<tr>
					        <th class="w-30px">ID</th> 
					        <th class="w-150px">所属部门</th>
					        <th class="">用户名</th>
					        <th class="">真实姓名</th>
					        <th class="w-120px">职位</th>
					        <th class="">源代码帐号</th>
					        <th class="">邮箱</th>
					        <th class="w-120px">入职日期</th>
					        <th class="w-120px hidden">Skype</th>
					        <th class="w-120px hidden">QQ</th>
					        <th class="w-120px hidden">雅虎通</th>
					        <th class="w-120px hidden">GTalk</th>
					        <th class="w-120px hidden">旺旺</th>
					        <th class="w-120px hidden">手机</th>
					        <th class="w-120px hidden">电话</th>
					        <th class="w-120px hidden">通讯地址</th>
					        <th class="w-120px hidden">邮编</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${userList}" var="user" varStatus="i">
							<tr class="text-center">
								<td>${user.id}<input type="hidden" name="users[${i.index}].id" id="id[${i.index}]" value="${user.id}"></td>
						        <td class="text-left" style="overflow:visible">
			        				<select name="users[${i.index}].dept_id" id="dept${i.index}" class="form-control chosen dept">
										<option></option>
										<option value="0" <c:if test="${user.dept_id == 0}">selected</c:if>>/</option>
										<option value='ditto'>同上</option>
									</select>
									<input type="hidden" value = "${user.dept_id}" id="deptid${i.index}" />
								</td>
								<td>
			        				<input type="text" name="users[${i.index}].account" id="account[${i.index}]" value="${user.account}" class="form-control" />
								</td>
								<td>
			        				<input type="text" name="users[${i.index}].realname" id="realname[${i.index}]" value="${user.realname}" class="form-control" />
								</td>
								<td>
			        				<select name="users[${i.index}].role" id="role[${i.index}]" class="form-control">
										<option value=""></option>
										<option value="dev" <c:if test="${user.role == 'dev'}">selected</c:if>>研发</option>
										<option value="qa" <c:if test="${user.role == 'qa'}">selected</c:if>>测试</option>
										<option value="pm" <c:if test="${user.role == 'pm'}">selected</c:if>>项目经理</option>
										<option value="po" <c:if test="${user.role == 'po'}">selected</c:if>>产品经理</option>
										<option value="td" <c:if test="${user.role == 'td'}">selected</c:if>>研发主管</option>
										<option value="pd" <c:if test="${user.role == 'pd'}">selected</c:if>>产品主管</option>
										<option value="qd" <c:if test="${user.role == 'qd'}">selected</c:if>>测试主管</option>
										<option value="top" <c:if test="${user.role == 'top'}">selected</c:if>>高层管理</option>
										<option value="others" <c:if test="${user.role == 'others'}">selected</c:if>>其他</option>
			        				</select>
								</td>
								<td>
			        				<input type="text" name="users[${i.index}].commiter" id="commiter[${i.index}]" value="${user.commiter}" class="form-control" />
								</td>
								<td>
			        				<input type="text" name="users[${i.index}].email" id="email[${i.index}]" value="${user.email}" class="form-control" />
								</td>
								<td>
									<input type="text" name="users[${i.index}].hiredate" id=hiredate[${i.index}] value="${user.hiredate}" autocomplete=off  class="form-date form-control" />
									<input style="display:none" >
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
				for(var i = 0; i < ${userList.size()}; i++) {
					iterateTree(data,"",i);
				}
			}
			$("select.chosen").chosen({
			    no_results_text: '没有找到',
			    search_contains: true,
			})
		}
	})
}

function iterateTree(data,name,index) {
	var leng = ${userList.size()};
	var s = "";
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		if($("#deptid" + index).val() == data[i].id) {
			s = "selected";
		}
		$("#dept" + index).append("<option value='" + data[i].id + "'"+ s +">" + a + "</option>");
		iterateTree(data[i].children,a,index);
	}
}

$(document).ready(removeDitto());//Remove 'ditto' in first row.

$(document).on('click', '.chosen-with-drop', function(){oldValue = $(this).prev('select').val();})//Save old value.

/* Set ditto value. */
$(document).on('change', 'select', function()
{
    if($(this).val() == 'ditto')
    {
        var index = $(this).closest('td').index();
        var row   = $(this).closest('tr').index();
        var tbody = $(this).closest('tr').parent();

        if($(this).attr('name').indexOf('closedReasons') != -1)
        {
            index = $(this).closest('tr').closest('td').index();
            row   = $(this).closest('tr').closest('td').parent().index();
            tbody = $(this).closest('tr').closest('td').parent().parent();
        }

        var value = '';
        for(i = row - 1; i >= 0; i--)
        {
            value = tbody.children('tr').eq(i).find('td').eq(index).find('select').val();
            if(value != 'ditto') break;
        }

        isModules = $(this).attr('name').indexOf('modules') != -1;
        isPlans   = $(this).attr('name').indexOf('plans')   != -1;

        if(isModules || isPlans)
        {

            var valueStr = ',' + $(this).find('option').map(function(){return $(this).val();}).get().join(',') + ',';
            if(valueStr.indexOf(',' + value + ',') != -1)
            {
                $(this).val(value);
            }
            else
            {
                alert(dittoNotice);
                $(this).val(oldValue);
            }
        }
        else
        {
            $(this).val(value);
        }

        $(this).trigger("chosen:updated");
        $(this).trigger("change");
    }
})

function removeDitto() {
    $firstTr = $(".table-form").find("tbody tr:first");
    $firstTr.find("td select").each(function() {
        $(this).find("option[value='ditto']").remove();
        $(this).trigger("chosen:updated")
    })
}

function check() {
	var password = $("#verifyPassword").val();
	if(password != ${userPassword}) {
		alert("安全验证密码错误，请输入您的登录密码");
		return false;
	}
}
</script>
</body>
</html>