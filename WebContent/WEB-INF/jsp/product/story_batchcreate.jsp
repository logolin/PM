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
.chosen-container .chosen-drop {min-width: 400px; border-top: 1px solid #ddd!important}
.colorpicker.input-group-btn > .btn {border-right: none}
button.btn.dropdown-toggle{height: 30px}
a>div>b {
	margin-top: 9px;
}
</style>
<title>${currentProduct.name}::批量添加</title>
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
	    		<strong><small class="text-muted"><i class="icon-plus-sign"></i></small>批量添加      <span class="label label-info">${branchName}</span></strong>
	    		<div class="actions">
		             <button type="button" class="btn btn-default" data-toggle="myModal">粘贴文本 </button>      
		             <button style="padding-top: 9px;padding-bottom: 9px" type="button" class="btn btn-default" data-toggle="customModal"><i class="icon icon-cog"></i></button>
		    	</div>
		  	</div>
		</div>	
		<form class="form-condensed" method="post" style="overflow-x: auto;">
  			<table class="table table-form table-fixed with-border"> 
    			<thead>
      				<tr class="text-center">
				        <th class="w-30px"></th> 
				        <th class="w-150px">所属模块</th>
				        <th class="w-150px">所属计划</th>
				        <th class="w-150px">需求名称 <span class="required"></span></th>
				        <th class="w-80px" style="padding-left: 15px;">需求来源</th>
				        <th class="w-150px">需求描述</th>
				        <th class="w-150px">验收标准</th>
				        <th class="w-80px">优先级</th>
				        <th class="w-80px">预计工时</th>
				        <th class="w-70px">评审</th>
				        <th class="w-100px">关键词</th>
      				</tr>
    			</thead>
                <tbody>
                	<c:forEach begin="0" end="9" step="1" var="i">
                	<tr class="text-center">
      					<td>${i + 1}</td>
   						<td class="text-left" style="overflow:visible">
   							<input type="hidden" name="stories[${i}].product.id" value="${productId}">
   							<input type="hidden" name="stories[${i}].branch_id" value="${branchId}">
	   						<select name="stories[${i}].module_id" id="module${i}" class="form-control chosen module">
								<option value="0">/</option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
      					<td class="text-left" style="overflow:visible">
	      					<select name="stories[${i}].plan" id="plan${i}" class="form-control chosen plan">
								<option value=""></option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
      					<td style="overflow:visible">
        					<div class="input-group">
								<input type='hidden' name='stories[${i}].color' id='color[0]' value='' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#title${i}' />
        						<input type="text" name="stories[${i}].title" id="title${i}" value="" onkeyup="javascript:$(this).next('input').val(this.value);" class="form-control">
        						<input type="hidden" name="storySpecs[${i}].title">
        					</div>
      					</td>
      					<td class="text-left">
      						<select name="stories[${i}].source" id="source0" class="form-control">
								<option value="" selected="selected"></option>
								<c:forEach items="${sourceMap}" var="source">
									<option value="${source.key}">${source.value}</option>
								</c:forEach>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
	      				<td class="">
	      					<textarea name="storySpecs[${i}].spec" id="spec[0]" rows="1" class="form-control autosize"></textarea>
						</td>
	      				<td class="">
	      					<textarea name="storySpecs[${i}].verify" id="verify[0]" rows="1" class="form-control autosize"></textarea>
						</td>
      					<td class="text-left" style="overflow:visible">
	      					<select name="stories[${i}].pri" id="pri0" class="form-control">
								<option value="0"></option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="-1" selected="selected">同上</option>
							</select>
						</td>
	      				<td class="">
	      					<input type="number" min="0" name="stories[${i}].estimate" id="estimate[0]" value="0" class="form-control" autocomplete="off">
						</td>
	      				<td class="">
	      					<select name="needReview[${i}]" id="needReview0" class="form-control" onchange="javascript:$(this).next('input').val(this.value);">
								<option value="active" selected="selected">否</option>
								<option value="draft">是</option>
							</select>
							<input type="hidden" name="stories[${i}].status" value="active">
						</td>
	      				<td class="">
	      					<input type="text" name="stories[${i}].keywords" id="keywords[0]" value="" class="form-control" autocomplete="off">
						</td>
   					</tr> 
   					</c:forEach> 
	        		<tr>
	        			<td colspan="11" class="text-center"> 
	        				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
	        				<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
	       				</td>
   					</tr>
  				</tbody>
			</table>
		</form>	
		<table class="hidden" id="trTemp">
  			<tbody>
    			<tr class="text-center">
      				<td>%s</td>
      				<td class="text-left" style="overflow:visible">
      				  	<input type="hidden" name="stories[%s].product.id" value="${productId}">
   						<input type="hidden" name="stories[%s].branch_id" value="${branchId}">
      					<select name="stories[%s].module_id" id="module%s" class="form-control">
							<option value="0">/</option>
							<option value="-1" selected="selected">同上</option>
						</select>
					</td>
      				<td class="text-left" style="overflow:visible">
      					<select name="stories[%s].plan" id="plan%s" class="form-control">
							<option value=""></option>
							<option value="-1" selected="selected">同上</option>
						</select>
					</td>
      				<td style="overflow:visible">
        				<div class="input-group">
					        <input type="hidden" name="stories[%s].color" id="color[%s]" value="" data-wrapper="input-group-btn fix-border-right" data-pull-menu-right="false" data-btn-tip="颜色标签" data-update-text="#title\[%s\]">
					        <input type="text" name="title" id="title[%s]" value="" class="form-control">
        				</div>
   	 				</td>
      				<td class="text-left">
      					<select name="stories[%s].source" id="source%s" class="form-control">
							<option value=""></option>
							<c:forEach items="${sourceMap}" var="source">
								<option value="${source.key}">${source.value}</option>
							</c:forEach>
							<option value="-1" selected="selected">同上</option>
						</select>
					</td>
      				<td class="">
      					<textarea name="storySpecs[%s].spec" id="spec[%s]" rows="1" class="form-control autosize"></textarea>
					</td>
      				<td class="">
      					<textarea name="storySpecs[%s].verify" id="verify[%s]" rows="1" class="form-control autosize"></textarea>
					</td>
      				<td class="text-left" style="overflow:visible">
      					<select name="stories[%s].pri" id="pri%s" class="form-control">
							<option value="0"></option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="-1" selected="selected">同上</option>
						</select>
					</td>
      				<td class="">
      					<input type="number" min="0" name="stories[%s].estimate" id="estimate[%s]" value="0" class="form-control autocomplete=">
					</td>
      				<td class="">
      					<select name="needReview[%s]" id="needReview%s" class="form-control" onchange="javascript:$(this).next('input').val(this.value);">
							<option value="active" selected="selected">否</option>
							<option value="draft">是</option>
						</select>
						<input type="hidden" name="stories[%s].status" value="active">
					</td>
      				<td class="">
      					<input type="text" name="stories[%s].keywords" id="keywords[%s]" value="" class="form-control autocomplete=" off''="">
					</td>
    			</tr>
  			</tbody>
		</table>
		<div class="modal fade" id="customModal" tabindex="-1" role="dialog" aria-hidden="false">
  			<div class="modal-dialog w-800px" style="margin-top: 174px;">
    			<div class="modal-content">
      				<form class="form-condensed" method="post" target="hiddenwin" action="">
        				<div class="modal-header">
          					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          					<h4 class="modal-title">
            					<i class="icon-cog"></i> 自定义           
            				 	<div class="pull-right" style="margin-right:15px;"> 
            				 		<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
          				 		</div>
          					</h4>
        				</div>
        				<div class="modal-body">
          					<p>
          						<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="module" checked="checked" id="fieldsmodule"> 
          							所属模块
          						</label>
       							<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="plan" checked="checked" id="fieldsplan"> 
          							所属计划
          						</label>
       							<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="source" checked="checked" id="fieldssource"> 
          							需求来源
          						</label>
       							<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="spec" checked="checked" id="fieldsspec"> 
          							需求描述
          						</label>
       							<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="verify" checked="checked" id="fieldsverify"> 
          							验收标准
          						</label>
          						<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="pri" checked="checked" id="fieldspri"> 
          							优先级
          						</label>
          						<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="estimate" checked="checked" id="fieldsestimate"> 
          							预计工时
          						</label>
          						<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="review" checked="checked" id="fieldsreview"> 
          							评审
          						</label>
          						<label class="checkbox-inline">
          							<input type="checkbox" name="fields[]" value="keywords" checked="checked" id="fieldskeywords"> 
          							关键词
          						</label>
          					</p>
        				</div>
      				</form>
    			</div>
  			</div>
		</div>	
		<style>
		#customModal .checkbox-inline{width:90px}
		#customModal .checkbox-inline+.checkbox-inline{margin-left:0px;}
		</style>		
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-hidden="true">
  			<div class="modal-dialog w-800px">
    			<div class="modal-content">
      				<div class="modal-header">
        				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        				<h4 class="modal-title"><i class="icon-file-text"></i> 粘贴文本 </h4>
      				</div>
      				<div class="modal-body">
        				<textarea name="pasteText" id="pasteText" class="form-control mgb-10" rows="10" placeholder="粘贴文本到文本域中，每行文字作为一条数据的标题。"></textarea>
         				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>      
       				</div>
   				</div>
			</div>
		</div>
		<script>
		$("button[data-toggle='customModal']").click(function(){$('#customModal').modal('show')});
		$(function()
		{
		    $table = $('.outer form table:first');
		    $form = $table.closest('form');
		    if($table.width() > $form.width())$form.css('overflow-x', 'auto')
		})
		</script>
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-hidden="true">
	  		<div class="modal-dialog w-800px">
	    		<div class="modal-content">
	      			<div class="modal-header">
	        			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	        			<h4 class="modal-title"><i class="icon-file-text"></i> 粘贴文本 </h4>
	      			</div>
	      			<div class="modal-body">
	        			<textarea name='pasteText' id='pasteText' class='form-control mgb-10' rows='10' placeholder='粘贴文本到文本域中，每行文字作为一条数据的标题。'></textarea>
	         			<button type='submit' id='submit' class='btn btn-primary'  data-loading='稍候...'>保存</button>      
	         		</div>
	    		</div>
	  		</div>
		</div>
		<script>
		$("button[data-toggle='myModal']").click(function(){$('#myModal').modal('show')})
		$("#myModal button[type='submit']").click(function()
		{
		    var pasteText = $('#myModal #pasteText').val();
		
		    $('#myModal').modal('hide')
		    $('#myModal #pasteText').val('');
		
		    var dataList = pasteText.split("\n");
		
		    if(typeof(mainField) == 'undefined') mainField = 'title';
		    var index = 0;
		    for(i in dataList)
		    {
		        var data = dataList[i].replace(/(^\s*)|(\s*$)/g, "");;
		
		        if(data.length == 0) continue;
		        while(true)
		        {
		            var title = $('form tbody tr').eq(index).find("input[id*='" + mainField + "']");
		            if($(title).size() == 0)
		            {
		                if(index == 0) break;
		                cloneTr = $('#trTemp tbody').html();
		                cloneTr = cloneTr.replace(/%s/g, index);
		                $('form tbody tr').eq(index - 1).after(cloneTr);
		                $('form tbody tr').eq(index).find('td:first').html(index + 1);
		                $('form tbody tr').eq(index - 1).find('td').each(function()
		                {
		                    if($(this).find('div.chosen-container').size() != 0)
		                    {
		                        $('form tbody tr').eq(index).find("td").eq($(this).index()).find('select').chosen({
		                		    no_results_text: '没有找到',    
		                		    search_contains: true,      
		                		    allow_single_deselect: true
		                		});
		                    }
		                });
		                title = $('form tbody tr').eq(index).find("input[id*='" + mainField + "']");
		                $('#color\\[' + index + '\\]').colorPicker();//Update color picker.
		            }
		
		            index++;
		
		            if($(title).val() != '') continue;
		            if($(title).val() == '')$(title).val(data);
		            break;
		        }
		    }
		});
		</script>
	</div>
	</div>	
<script type="text/javascript">
$(function(){
	loadProductPlans("${productId}","${branchId}");
	loadProductModules("${productId}","${branchId}");
}); 
function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
		}		
		$("select.chosen").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});	
		removeDitto();
	})
}
function iterateTree(data,name) {
	var s,a,c,d;
	for (var i = 0,l = data.length; i < l; i++) {
		a = name + "/" + data[i].name;
		d = data[i].branchName;
		c = (d !== "分支" && d !== "平台" && d !== "") ? d + a : a;
		$(".module").add(document.getElementById("module%s")).each(function(index){
			s = (data[i].id == "${moduleId}" && index == 0) ? "selected" : "";
			$(this).find("option[value='-1']").before("<option value='" + data[i].id + "' " + s + ">" + c + "</option>");
		});
		iterateTree(data[i].children,a);
	}
}
function loadProductPlans(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetPlans/true/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			for (var i = 0; i < data.length; i++) {
				$(".plan").add(document.getElementById("plan%s")).each(function(){
					$(this).find("option[value='-1']").before("<option value='" + data[i].id + "'>" + data[i].title + " [" + data[i].begin + " ~ " + data[i].end + "]" + "</option>");
				});
			}
		}
	});
}
function removeDitto() {
    $firstTr = $(".table-form").find("tbody tr:first");
    $firstTr.find("td select").each(function() {
        $(this).find("option[value='-1']").remove();
        $(this).trigger("chosen:updated")
    })
}
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