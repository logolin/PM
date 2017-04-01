<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script src="${ctxResources}/zui/src/js/color.js"></script>
<script src="${ctxResources}/zui/src/js/colorpicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("select.chosen-select").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});	
	$('.form-date').datetimepicker({
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
<style>
.chosen-container .chosen-drop {min-width: 400px; border-top: 1px solid #ddd!important}
.colorpicker.input-group-btn > .btn {border-right: none}
button.btn.dropdown-toggle{height: 30px}
</style> 
<title>${project.name}::批量添加</title>
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
				    <strong><small class="text-muted"><i class="icon-edit-sign"></i></small> 批量添加任务</strong>
				    <div class="actions">
				    	<button type="button" class="btn btn-default" data-toggle="myModal">粘贴文本 </button>
				      	<button type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i> </button>
				    </div>
				  </div>
			</div>
			<form class="form-condensed" method="post">
				<table class="table table-form">
					<thead>
				    	<tr class="text-center">
					        <th class="w-30px">ID</th> 
					        <th class="w-150px">所属模块</th>
					        <th class="w-200px">相关需求</th>
					        <th>任务名称 <span class="required"></span></th>
					        <th class="w-80px" style="padding-left: 15px;">类型 <span class="required"></span></th>
					        <th class="w-150px" style="padding-left: 15px;">指派给</th>
					        <th class="w-50px hidden">预</th>
					        <th class="w-100px hidden">预计开始</th>
					        <th class="w-100px hidden">截止日期</th>
					        <th class="w-p20">任务描述</th>
					        <th class="w-70px">优先级</th>
						</tr>
				    </thead>
					<tbody>
						<c:forEach begin="0" end="9" step="1" var="i">
							<tr>
								<td>
									${i+1}
									<input type="hidden" value="${project.id}" name="tasks[${i}].project.id">
								</td>
								<td>
									<div class="input-group moduleIdBox">
	          							<select name="tasks[${i}].module_id" id="module${i}" class="form-control chosen module" onchange="loadStorys(${i})">
											<option value="0">/</option>
											<option value="-1" selected="selected">同上</option>
										</select>
	          						</div>
								</td>
								<td>
									<div class="input-group" id="storyIdBox${i}">
										<select name="tasks[${i}].story_id" id="story${i}" class="form-control chosen chosen-select story">
											<option value="-1" selected="selected">同上</option>
										</select>
									</div>
								</td>
								<td>
							        <div class="input-group">
										<input type='hidden' name='tasks[${i}].color' id='color[0]' value='' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#name${i}' />
		        						<input type="text" name="tasks[${i}].name" id="name${i}" value="" onkeyup="javascript:$(this).next('input').val(this.value);" class="form-control">
	        						</div>
						        </td>
								<td>
									<select name="tasks[${i}].type" class="form-control">
										<option value=""></option>
										<option value="design">设计</option>
										<option value="devel">开发</option>
										<option value="test">测试</option>
										<option value="study">研究</option>
										<option value="discuss">讨论</option>
										<option value="ui">界面</option>
										<option value="affair">事务</option>
										<option value="misc">其他</option>
										<option value="-1" selected="selected">同上</option>
									</select>
								</td>
								<td>
									<select class="form-control chosen-select assign" name="tasks[${i}].assignedTo">
										<option></option>
										<c:forEach items="${userList}" var="user">
											<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
										</c:forEach>
										<option value="-1" selected="selected">同上</option>
									</select>
								</td>
								<td>
									<textarea name="tasks[${i}].descript" id="descript[${i}]" rows="1" class="form-control autosize"></textarea>
								</td>
								<td>
									<select name="tasks[${i}].pri" class="form-control">
										<option value="0"></option>
										<option value="3" selected="selected">3</option>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="4">4</option>
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
			<table class="hidden" id="trTemp">
				<tbody>
	    			<tr class="text-center">
	      				<td>%s</td>
	      				<td class="text-left" style="overflow:visible">
	      				  	<input type="hidden" value="${project.id}" name="tasks[%s].project.id">
	      					<select name="tasks[%s].module_id" id="module%s" class="form-control">
								<option value="0">/</option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
	      				<td class="text-left" style="overflow:visible">
	      					<select name="tasks[%s].story_id" id="story[%s]" class="form-control chosen-select story">
								<option value="0">/</option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
	      				<td>
							<div class="input-group">
								<input type='hidden' name='tasks[%s].color' id='color[%s]' value='' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#name%s' />
		        				<input type="text" name="tasks[%s].name" id="name%s" value="" onkeyup="javascript:$(this).next('input').val(this.value);" class="form-control">
	        				</div>
						</td>
						<td>
							<select name="tasks[%s].type" class="form-control">
								<option value=""></option>
								<option value="design">设计</option>
								<option value="devel">开发</option>
								<option value="test">测试</option>
								<option value="study">研究</option>
								<option value="discuss">讨论</option>
								<option value="ui">界面</option>
								<option value="affair">事务</option>
								<option value="misc">其他</option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
						<td>
									<select class="form-control chosen-select assign" name="tasks[%s].assignedTo">
										<c:forEach items="${userList}" var="user">
											<option value="${user.account}">${user.realname}</option>
										</c:forEach>
										<option value="-1" selected="selected">同上</option>
									</select>
								</td>
								<td>
									<textarea name="tasks[%s].descript" id="descript[%s]" rows="1" class="form-control autosize"></textarea>
								</td>
								<td>
									<select name="tasks[%s].pri" class="form-control">
										<option value="0"></option>
										<option value="3" selected="selected">3</option>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="4">4</option>
									</select>
								</td>
	    			</tr>
  				</tbody>
			</table>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	loadProductModules("${projectId}");
}); 
//获得模块list
function loadProductModules(projectId) {
	
	$.ajax({
		url: "../ajaxGetModules/" + projectId,
		type: 'get',
		async: false,
		success: function(data) {
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"");
				
			}		
		
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			removeDitto();
		}
	});
	
	/* $.get("../ajaxGetModules/" + projectId,function(data){
			if (!$.isEmptyObject(data)) {
				iterateTree(data,"");
				
			}		
		
		$("select.chosen").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		});	
		removeDitto();
	}) */
}
//获得需求
function loadStorys(i) {
	var moduleId = $('#module'+i).val();
	loadStoryss(moduleId,i);
}

function loadStoryss(moduleId,i) {
	var sele = "";
	$.ajax({
		url: "../ajaxGetStoryForModule/" + moduleId,
		type: 'get',
		async: false,
		success: function(data) {
			$('#storyIdBox'+i).empty();
			$("#storyIdBox"+i).append("<select name='tasks["+i+"].story_id' id='story"+i+"' class='form-control chosen chosen-select'></select>");
	 		$("#story"+i).append("<option value='0'></option>");
			if (data != null) {
				for (var index = 0; index < data.length; index++) {
					if(index == 0 && ${storyId} == data[i].id) {
						sele = "selected";
					}
					$("#story"+i).append("<option value='" + data[index].id + "' "+ sele +">" + data[index].id + ":" + data[index].title +"[p" + data[index].pri + "," +data[index].estimate+ "h]" + "</option>");
				}
			} 
			$("#storyIdBox" +i+" #story"+i).chosen({
			    no_results_text: '没有找到',
			    search_contains: true,
			    allow_single_deselect: true
			});	
		}
		
	});
	
}

function iterateTree(data,name) {
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		var s = "";
		var productNumber = 0;
		if(${storyId} != 0 && i == 0) {
			if(${story.module_id} == data[i].id) {
				s = "selected";
			}
		}
		if (productNumber === 0) {
			c = "/" + data[i].productName + a;
			$(".module").append("<option value='" + data[i].id + "' " + s +">" + c + "</option>");
			productNumber = 1;
		} else {
			$(".module").append("<option value='" + data[i].id + "' " + s +">" + a + "</option>");
		}
		iterateTree(data[i].children,a);
	}
}
//去除第一行同上选项
function removeDitto() {
    $firstTr = $(".table-form").find("tbody tr:first");
    $firstTr.find("td select").each(function() {
        $(this).find("option[value='-1']").remove();
        $(this).trigger("chosen:updated")
    })
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
</script>
</body>
</html>