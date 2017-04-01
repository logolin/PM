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
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/zui/src/js/color.js"></script>
<script src="${ctxResources}/zui/src/js/colorpicker.js"></script>

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
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 需求::批量编辑</strong>
				    <div class="actions">
				      <button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post" action="./story_batchEdit_${project.id}_update">
				<table class="table table-form table-fixed with-border">
				    <thead>
				      	<tr class="text-center">
				        	<th class="w-40px"> ID</th> 
				        	<th class="w-150px">所属模块</th>
					        <th class="w-150px">计划</th>
					        <th class="w-140px"> 需求名称 <span class="required"></span></th>
					        <th class="w-50px" style="padding-left: 15px;"> 预计</th>
					        <th class="w-70px"> P</th>
					        <th class="w-100px"> 指派给</th>
					        <th class="w-100px"> 需求来源</th>
					        <th class="w-80px"> 当前状态</th>
					        <th class="w-100px"> 阶段</th>
					        <th class="w-100px">由谁关闭</th>
					        <th class="w-100px"> 关闭原因</th>
					        <th class="w-80px">关键词</th>
				      	</tr>
				    </thead>
		    		<tbody>
		    		<c:forEach items="${storyList}" var="story" varStatus="i">
		            	<tr class="text-center">
					        <td>${story.id}<input type="hidden" name="stories[${i.index}].id" id="storyId${i.index}" value="${story.id}">
					        </td>
					        <td class="text-left" style="overflow:visible">    
					        	<input type="hidden" id="module${i.index}" value="${story.module_id}" />
					        	<select name="stories[${i.index}].module_id" id="modules${i.index}" data-module="${story.module_id}" class="form-control chosen module">
									<option value='ditto'>同上</option>
									<option value="0" selected>/</option>
								</select>
							</td>
					        <td class="text-left" style="overflow:visible"> 
					        	<input type="hidden" id="plan${i.index}" value="${story.plan}" />
					        	<select name="stories[${i.index}].plan" id="plans${i.index}" data-plan="${story.plan}" class="form-control chosen-select plan">
									<option value=""></option>
									<option value='ditto'>同上</option>
								</select>
							</td>
					        <td style="overflow:visible">
					          	<div class="input-group">
					          		<input type='hidden' name='stories[${i.index}].color' id='color[${i.index}]' value='${story.color}' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#title${i.index}'/>
					          		<input type="text" name="stories[${i.index}].title" id="title${i.index}" value="${story.title}" class="form-control">
					          	</div>
					        </td>
		        			<td>
		        				<input type="text" name="stories[${i.index}].estimate" id="estimates[32]" value="${story.estimate}" class="form-control" autocomplete="off">
							</td>
		        			<td>
		        				<select name="stories[${i.index}].pri" id="pris32" class="form-control">
									<option value="0" <c:if test="${story.pri == 0}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<option value="1" <c:if test="${story.pri == 1}">selected="selected"</c:if>>1</option>
									<option value="2" <c:if test="${story.pri == 2}">selected="selected"</c:if>>2</option>
									<option value="3" <c:if test="${story.pri == 3}">selected="selected"</c:if>>3</option>
									<option value="4" <c:if test="${story.pri == 4}">selected="selected"</c:if>>4</option>
								</select>
							</td>
		        			<td class="text-left" style="overflow:visible">
		        				<select name="stories[${i.index}].assignedTo" id="assignedTo${i.index}" class="form-control chosen-select">
									<option value="" <c:if test="${story.assignedTo == user.account}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<c:forEach items="${userList}" var="user">
			          					<option value="${user.account}" <c:if test="${story.assignedTo == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
			          				</c:forEach>
<%-- 			          				<option value="closed" <c:if test="${story.assignedTo == user.account}">selected="selected"</c:if>>Closed</option> --%>
								</select>
							</td>
		        			<td>
		        				<select name="stories[${i.index}].source" id="sources32" class="form-control">
									<option value="" <c:if test="${story.source == ''}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<option value="customer" <c:if test="${story.source == 'customer'}">selected="selected"</c:if>>客户</option>
									<option value="user" <c:if test="${story.source == 'user'}">selected="selected"</c:if>>用户</option>
									<option value="po" <c:if test="${story.source == 'po'}">selected="selected"</c:if>>项目经理</option>
									<option value="market" <c:if test="${story.source == 'market'}">selected="selected"</c:if>>市场</option>
									<option value="service" <c:if test="${story.source == 'service'}">selected="selected"</c:if>>客服</option>
									<option value="operation" <c:if test="${story.source == 'operation'}">selected="selected"</c:if>>运营</option>
									<option value="support" <c:if test="${story.source == 'support'}">selected="selected"</c:if>>技术支持</option>
									<option value="competitor" <c:if test="${story.source == 'competitor'}">selected="selected"</c:if>>竞争对手</option>
									<option value="partner" <c:if test="${story.source == 'partner'}">selected="selected"</c:if>>合作伙伴</option>
									<option value="dev" <c:if test="${story.source == 'dev'}">selected="selected"</c:if>>开发人员</option>
									<option value="tester" <c:if test="${story.source == 'tester'}">selected="selected"</c:if>>测试人员</option>
									<option value="bug" <c:if test="${story.source == 'bug'}">selected="selected"</c:if>>Bug</option>
									<option value="other" <c:if test="${story.source == 'other'}">selected="selected"</c:if>>其他</option>
								</select>
							</td>
		        			<td class=' story-${story.status}' >
		        				<c:choose>
				            		<c:when test="${story.status == 'draft'}">草稿</c:when>
				            		<c:when test="${story.status == 'active'}">激活</c:when>
				            		<c:when test="${story.status == 'changed'}">已变更</c:when>
				            		<c:when test="${story.status == 'closed'}">已关闭</c:when>
				            		<c:otherwise></c:otherwise>
				            	</c:choose>
		        			</td>
		        			<td>
		        				<select name="stories[${i.index}].stage" id="stages32" class="form-control" <c:if test="${story.status == 'draft'}">disabled</c:if>>
									<option value="" <c:if test="${story.stage == ''}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<option value="wait" <c:if test="${story.stage == 'wait'}">selected="selected"</c:if>>未开始</option>
									<option value="planned" <c:if test="${story.stage == 'planned'}">selected="selected"</c:if>>已计划</option>
									<option value="projected" <c:if test="${story.stage == 'projected'}">selected="selected"</c:if>>已立项</option>
									<option value="developing" <c:if test="${story.stage == 'developing'}">selected="selected"</c:if>>研发中</option>
									<option value="developed" <c:if test="${story.stage == 'developed'}">selected="selected"</c:if>>研发完毕</option>
									<option value="testing" <c:if test="${story.stage == 'testing'}">selected="selected"</c:if>>测试中</option>
									<option value="tested" <c:if test="${story.stage == 'tested'}">selected="selected"</c:if>>测试完毕</option>
									<option value="verified" <c:if test="${story.stage == 'verified'}">selected="selected"</c:if>>已验收</option>
									<option value="released" <c:if test="${story.stage == 'released'}">selected="selected"</c:if>>已发布</option>
								</select>
							</td>
		        			<td class="text-left" style="overflow:visible">
		        				<select name="stories[${i.index}].closedBy" id="closedBys32" class="form-control" <c:if test="${story.closedBy == ''}">disabled="disabled"</c:if>>
									<option value="" <c:if test="${story.closedBy == user.account}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<c:forEach items="${users}" var="user">
			          					<option value="${user.account}" <c:if test="${story.closedBy == user.account}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
			          				</c:forEach>
<%-- 			          				<option value="closed" <c:if test="${story.closedBy == user.account}">selected="selected"</c:if>>Closed</option>							 --%>
								</select>
							</td>
		                	<td>
		                		<select name="stories[${i.index}].closedReason" id="closedReasons32" class="form-control" <c:if test="${story.closedReason == ''}">disabled="disabled"</c:if>>
									<option value="" <c:if test="${story.closedReason == ''}">selected="selected"</c:if>></option>
									<option value='ditto'>同上</option>
									<option value="done" <c:if test="${story.closedReason == 'done'}">selected="selected"</c:if>>已完成</option>
									<option value="subdivided" <c:if test="${story.closedReason == 'subdivided'}">selected="selected"</c:if>>已细分</option>
									<option value="duplicate" <c:if test="${story.closedReason == 'duplicate'}">selected="selected"</c:if>>重复</option>
									<option value="postponed" <c:if test="${story.closedReason == 'postponed'}">selected="selected"</c:if>>延期</option>
									<option value="willnotdo" <c:if test="${story.closedReason == 'willnotdo'}">selected="selected"</c:if>>不做</option>
									<option value="cancel" <c:if test="${story.closedReason == 'cancel'}">selected="selected"</c:if>>已取消</option>
									<option value="bydesign" <c:if test="${story.closedReason == 'bydesign'}">selected="selected"</c:if>>设计如此</option>
								</select>
							</td>
		                	<td><input type="text" name="stories[${i.index}].keywords" id="keywords[32]" value="${story.keywords}" class="form-control"></td>
		      			</tr>
		      		</c:forEach>
		           	</tbody>
		    		<tfoot>
		      			<tr>
		      				<td colspan="13" class="text-center"> 
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
	<c:forEach items="${storyList}" var="story" varStatus="i">
	loadProductModules("${story.product.id}","${i.index}","${story.module_id}");
	loadProductPlans("${story.product.id}","${i.index}","${story.plan}");
	</c:forEach>
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
	$("select.chosen").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	});	
}); 

//获得模块
function loadProductModules(productId,i,moduleId) {
	$.ajax({
		url: "../ajaxGetModulesForproduct/" + productId,
		type: 'get',
		async: false,
		success: function(data) {
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"",i,moduleId);
			}
			removeDitto();
		}
		
	});
}

//获取计划
function loadProductPlans(productId,index,planId) {
	
	$.ajax({
		url: "../ajaxGetPlans/" + productId,
		type: 'get',
		async: false,
		success: function(data) {
			if (!$.isEmptyObject(data)) {
				for (var i = 0; i < data.length; i++) {
					var plid = $("#plan" + index).val();
					var s = "";
					s = data[i].id + "" == plid ? "selected" : "";
					$("#plans" + index).append("<option value='" + data[i].id +"' "+ s +">" + data[i].title +" [" + data[i].begin + "~" + data[i].end +"]" +"</option>");
				}
			}
		}
	});
}

function iterateTree(data,name,index,moduleId) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		var modId = $("#module" + index).val();
		var productNumber = 0;
		console.log(data[i].id + ":" + modId);
		s = data[i].id == modId ? "selected" : "";
		if (productNumber === 0) {
			c = "/" + data[i].productName + a;
			$("#modules" + index).append("<option value='" + data[i].id + "' " + s + ">" + c + "</option>");
			productNumber = 1;
		} else {
			$("#modules" + index).append("<option value='" + data[i].id + "' " + s + ">" + a + "</option>");
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