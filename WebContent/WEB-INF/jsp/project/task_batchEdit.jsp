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
<script src="${ctxResources}/zui/src/js/color.js"></script>
<script src="${ctxResources}/zui/src/js/colorpicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
});
</script>
<title>${project.name}::批量编辑</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div id="titlebar">
				<div class="heading">
				    <span class="prefix"><i class="icon-check-sign"></i></span>
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 批量编辑 任务</strong>
				    <div class="actions">
				      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post" action="${ctxpj}/task_batchEdit_${project.id}_post">
				<table class="table table-form table-fixed with-border">
					<thead>
      					<tr>
							<th class="w-50px">ID</th>
					        <th class="w-150px" style="padding-left: 15px;">任务名称 <span class="required"></span></th>
					        <th class="w-150px" style="padding-left: 15px;">所属模块</th>
					        <th class="w-150px">指派给</th>
					        <th class="w-80px">类型 <span class="required"></span></th>
					        <th class="w-100px" style="padding-left: 15px;">任务状态</th>
					        <th class="w-70px">优先级</th>
					        <th class="w-40px">预</th>
					        <th class="w-50px">工时</th>
					        <th class="w-40px">剩</th>
					        <th class="w-90px hidden">预计开始</th>
					        <th class="w-90px hidden">截止日期</th>
					        <th class="w-100px">由谁完成</th>
					        <th class="w-100px hidden">由谁取消</th>
					        <th class="w-100px">由谁关闭</th>
					        <th class="w-100px">关闭原因</th>
      					</tr>
					</thead>
					<tbody>
						<c:forEach items="${tasks}" var="task" varStatus="i">
							<tr>
								<td>${task.id}<input type="hidden" name="tasks[${i.index}].id" id="id[${i.index}]" value="${task.id}"></td>
								<td style="overflow:visible">
							        <div class="input-group">
							        	<input type='hidden' name='tasks[${i.index}].color' id='color[${i.index}]' value='${task.color}' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#name${i.index}'/>
					          			<input type="text" name="tasks[${i.index}].name" id="name${i.index}" value="${task.name}" class="form-control">
							        </div>
						        </td>
						        <td class="text-left" style="overflow:visible">
						        	<input type="hidden" id="module${i.index}" value="${task.module_id}" />
			        				<select name="tasks[${i.index}].module_id" id="modules${i.index}" class="form-control chosen module">
										<option value='ditto'>同上</option>
										<option value="0" <c:if test="${task.module_id == 0}">selected</c:if>>/</option>
									</select>
								</td>
								<td class="text-left" style="overflow:visible">
			        				<select name="tasks[${i.index}].assignedTo" id="assigned${i.index}" class="form-control chosen-select">
										<option></option>
										<c:forEach items="${userList}" var="user">
				          					<option value="${user.account}" <c:if test="${task.assignedTo == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
				          				</c:forEach>
				          				<option value="closed" <c:if test="${task.assignedTo == user.account}">selected="selected"</c:if>>Closed</option>
				          				<option value='ditto'>同上</option>
									</select>
								</td>
								<td>
									<select name="tasks[${i.index}].type" class="form-control">
										<option value=""></option>
										<option value='ditto'>同上</option>
										<option value="design" <c:if test="${task.type == 'design'}">selected="selected"</c:if>>设计</option>
										<option value="devel" <c:if test="${task.type == 'devel'}">selected="selected"</c:if>>开发</option>
										<option value="test" <c:if test="${task.type == 'test'}">selected="selected"</c:if>>测试</option>
										<option value="study" <c:if test="${task.type == 'study'}">selected="selected"</c:if>>研究</option>
										<option value="discuss" <c:if test="${task.type == 'discuss'}">selected="selected"</c:if>>讨论</option>
										<option value="ui" <c:if test="${task.type == 'ui'}">selected="selected"</c:if>>界面</option>
										<option value="affair" <c:if test="${task.type == 'affair'}">selected="selected"</c:if>>事务</option>
										<option value="misc" <c:if test="${task.type == 'misc'}">selected="selected"</c:if>>其他</option>
									</select>
								</td>
								<td>
									<select name="tasks[${i.index}].status" class="form-control">
										<option value=""></option>
										<option value='ditto'>同上</option>
										<option value="wait" <c:if test="${task.status == 'wait'}">selected="selected"</c:if>>未开始</option>
										<option value="doing" <c:if test="${task.status == 'doing'}">selected="selected"</c:if>>进行中</option>
										<option value="done" <c:if test="${task.status == 'done'}">selected="selected"</c:if>>已完成</option>
										<option value="pause" <c:if test="${task.status == 'pause'}">selected="selected"</c:if>>已暂停</option>
										<option value="cancel" <c:if test="${task.status == 'cancel'}">selected="selected"</c:if>>已取消</option>
										<option value="closed" <c:if test="${task.status == 'closed'}">selected="selected"</c:if>>已关闭</option>
									</select>
								</td>
								<td>
									<select name="tasks[${i.index}].pri" class="form-control">
										<option value='ditto'>同上</option>
										<option value="0" <c:if test="${task.pri == 0}">selected</c:if>></option>
										<option value="3" <c:if test="${task.pri == 3}">selected</c:if>>3</option>
										<option value="1" <c:if test="${task.pri == 1}">selected</c:if>>1</option>
										<option value="2" <c:if test="${task.pri == 2}">selected</c:if>>2</option>
										<option value="4" <c:if test="${task.pri == 4}">selected</c:if>>4</option>
									</select>
								</td>
								<td style="overflow:visible">
									<input type="text" name="tasks[${i.index}].estimate" value="<fmt:formatNumber value="${task.estimate}" pattern="" type="number" />" class="form-control text-center" autocomplete="off">
								</td>
								<td>
									<input type="text" name="tasks[${i.index}].consumed" value="<fmt:formatNumber value="${task.consumed}" pattern="" type="number" />" class="form-control text-center" autocomplete="off"></td>
								<td>
									<input type="text" name="tasks[${i.index}].remain" value="<fmt:formatNumber value="${task.remain}" pattern="" type="number" />" class="form-control text-center" autocomplete="off">
								</td>
								<td class="text-left" style="overflow:visible">
									<select name="tasks[${i.index}].finishedBy" class="form-control chosen-select">
										<option></option>
										<option value="ditto">同上</option>
										<c:forEach items="${userList}" var="user">
				          					<option value="${user.account}" <c:if test="${task.finishedBy == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
				          				</c:forEach>
				          				<option value="closed" <c:if test="${task.finishedBy == user.account}">selected="selected"</c:if>>Closed</option>
									</select>
								</td>
								<td class="text-left hidden" style="overflow:visible">
									<select name="tasks[${i.index}].canceledBy" class="form-control chosen-select">
										<option></option>
										<option value='ditto'>同上</option>
										<c:forEach items="${userList}" var="user">
				          					<option value="${user.account}" <c:if test="${task.canceledBy == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
				          				</c:forEach>
				          				<option value="closed" <c:if test="${task.canceledBy == user.account}">selected="selected"</c:if>>Closed</option>
									</select>
								</td>	
								<td class="text-left" style="overflow:visible">
									<select name="tasks[${i.index}].closedBy" class="form-control chosen-select">
										<option></option>
										<option value='ditto'>同上</option>
										<c:forEach items="${userList}" var="user">
				          					<option value="${user.account}" <c:if test="${task.closedBy == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
				          				</c:forEach>
				          				<option value="closed" <c:if test="${task.closedBy == user.account}">selected="selected"</c:if>>Closed</option>
									</select>
								</td>
								<td class="text-left" style="overflow:visible">
									<select name="tasks[${i.index}].closedReason" class="form-control chosen-select">
										<option></option>
										<option value="done">已完成</option>
										<option value="cancel">已取消</option>
									</select>
								</td>	
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
				    	<tr>
				    		<td colspan="13"> 
				    			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
				    		</td>
				    	</tr>
				    </tfoot>
				</table>
			</form>
		</div>
	</div>
<script>
$(function(){
	loadProjectModules("${projectId}");
}); 
//获得模块list
function loadProjectModules(projectId) {
	$.get("../ajaxGetModules/" + projectId,function(data){
			if (!$.isEmptyObject(data)) {
				var leng = ${tasks.size()};
				for(var i = 0; i < leng; i++) {
					iterateTree(data,"",i);
				}
			}		
		$("select.chosen").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		});	
		removeDitto();
	})
}

function iterateTree(data,name,index) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		var s = "";
		var productNumber = 0;
		if(data[i].id == $("#module" + index).val()) {
			s = "selected";
		}
		if (productNumber === 0) {
			c = "/" + data[i].productName + a;
			$("#modules" + index).append("<option value='" + data[i].id + "' "+ s +">" + c + "</option>");
			productNumber = 1;
		} else {
			$("#modules" + index).append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
		}
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
</script>
</body>
</html>