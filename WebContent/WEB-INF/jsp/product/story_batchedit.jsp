<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/src/js/color.js"></script>
<script src="../resources/zui/src/js/colorpicker.js"></script>
<style>
button.btn.dropdown-toggle{height: 30px}
a>div>b {
	margin-top: 9px;
}
.colorpicker.input-group-btn > .btn {border-right: none}
.chosen-container .chosen-drop {min-width: 400px; border-top: 1px solid #ddd!important}
</style>
<title>${currentProduct.name}::批量编辑</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div id="titlebar">
	  		<div class="heading">
	    		<span class="prefix"><i class="icon-lightbulb"></i></span>
	    		<strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 需求::批量编辑</strong>
	        	<small class="text-muted"><i class="icon-cube"></i> 所属产品:: ${currentProduct.name}</small>
	        	<div class="actions">
	      			<button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
	    		</div>
	  		</div>
		</div>
		<form class="form-condensed" method="post" action="./story_batchEdit_${productId}" style="overflow-x: auto;">
 		<div style="min-height:400px;">
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
    		<c:forEach items="${stories}" var="story" varStatus="i">
            	<tr class="text-center">
			        <td>${story.id}<input type="hidden" name="stories[${i.index}].id" id="storyIDList[32]" value="${story.id}"></td>
			        <td class="text-left" style="overflow:visible">    
			        	<select name="stories[${i.index}].module" id="modules" data-module="${story.module_id}" class="form-control chosen module">
							<option value='ditto'>同上</option>
							<option value="0" selected>/</option>
						</select>
					</td>
			        <td class="text-left" style="overflow:visible">    
			        	<select name="stories[${i.index}].plan" id="plans" data-plan="${story.plan}" class="form-control chosen plan" <c:if test="${story.branch_id == 0}">multiple</c:if>>
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
        				<select name="stories[${i.index}].assignedTo" id="assignedTo32" class="form-control chosen">
							<option value="" <c:if test="${story.assignedTo == ''}">selected="selected"</c:if>></option>
							<option value='ditto'>同上</option>
							<c:forEach items="${userMap}" var="user">
	          					<option value="${user.key}" <c:if test="${story.assignedTo == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
	          				</c:forEach>
	          				<option value="closed" <c:if test="${story.assignedTo == 'closed'}">selected="selected"</c:if>>Closed</option>
						</select>
					</td>
        			<td>
        				<select name="stories[${i.index}].source" id="sources32" class="form-control">
							<option value="" <c:if test="${story.source == ''}">selected="selected"</c:if>></option>
							<option value='ditto'>同上</option>
							<c:forEach items="${sourceMap}" var="source">
								<option value="${source.key}" <c:if test="${source.key == story.source}">selected</c:if>>${source.value}</option>
							</c:forEach>
						</select>
					</td>
        			<td class=' story-${story.status}'>${statusMap[story.status]}</td>
        			<td>
        				<select name="stories[${i.index}].stage" id="stages32" class="form-control" <c:if test="${story.status == 'draft'}">disabled</c:if>>
							<option value="" <c:if test="${story.stage == ''}">selected="selected"</c:if>></option>
							<option value='ditto'>同上</option>
							<c:forEach items="${stageMap}" var="stage">
								<option value="${stage.key}" <c:if test="${story.stage == stage.key}">selected</c:if>>${stage.value}</option>
							</c:forEach>
						</select>
					</td>
        			<td class="text-left" style="overflow:visible">
        				<select name="stories[${i.index}].closedBy" id="closedBys32" class="form-control" <c:if test="${story.status != 'closed'}">disabled</c:if>>
							<option value="" <c:if test="${story.closedBy == ''}">selected="selected"</c:if>></option>
							<option value='ditto'>同上</option>
							<c:forEach items="${userMap}" var="user">
	          					<option value="${user.key}" <c:if test="${story.closedBy == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
	          				</c:forEach>
	          				<option value="closed" <c:if test="${story.closedBy == 'closed'}">selected="selected"</c:if>>Closed</option>							
						</select>
					</td>
                	<td>
                		<select name="stories[${i.index}].closedReason" id="closedReasons32" class="form-control" <c:if test="${story.status != 'closed'}">disabled</c:if>>
							<option value="" <c:if test="${story.closedReason == ''}">selected="selected"</c:if>></option>
							<option value='ditto'>同上</option>
							<c:forEach items="${closedReasonMap}" var="closedReason">
								<option value="${closedReason.key}" <c:if test="${story.closedReason == closedReason.key}">selected</c:if>>${closedReason.value}</option>
							</c:forEach>
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
  		</div>
		</form>
	</div>
	</div>
<script>
(function(){
	loadProductPlans("${productId}","${branchId}");
	loadProductModules("${productId}","${branchId}");
})();
function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
		}		
		$("select.chosen.module").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});	
	})
}
function iterateTree(data,name) {
	var s,a,c,d;
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		d = data[i].branchName;
		c = (d !== "分支" && d !== "平台" && d !== "") ? d + a : a;
		$(".module").each(function(){
			s = $(this).data("module") == data[i].id ? "selected" : "";
			$(this).append("<option value='" + data[i].id + "' " + s + ">" + c + "</option>");
		});
		iterateTree(data[i].children,a);
	}
}
function loadProductPlans(productId, branchId) {
	var s;
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetPlans/false/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			for (var i = 0, l = data.length; i < l; i++) {
				$(".plan").each(function(){
					s = ("," + $(this).data("plan") + ",").indexOf(","+data[i].id+",") == -1 ? "" : "selected";
					$(this).append("<option value='" + data[i].id + "' " + s + ">" + data[i].title + " [" + data[i].begin + " ~ " + data[i].end + "]" + "</option>");
				});
			}
		}
		$("select.chosen.plan").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});	
	});
}

$(document).ready(removeDitto());//Remove 'ditto' in first row.

$(document).on('click', '.chosen-with-drop', function(){oldValue = $(this).prev('select').val();})//Save old value.

/* Set ditto value. */
$(document).on('change', 'select', function()
{
    if($(this).val().indexOf('ditto') != -1)
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

        $(this).val(value);


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