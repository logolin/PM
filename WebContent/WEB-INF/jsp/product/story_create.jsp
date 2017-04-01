<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/src/js/color.js"></script>
<script src="../resources/zui/src/js/colorpicker.js"></script>
<style>
#mailto {width:90.3%}
select {border:1px solid #ccc}
#module_chosen.chosen-container .chosen-drop {min-width: 400px; border-top: 1px solid #ddd!important}

.row .col-sm-8{width:76%}
.row .col-sm-2{padding-left:0px; padding-right:0px; width:12%}

#dataform .input-group-btn > .btn + .btn {margin-left: -1px;}
#dataform .input-group-addon > .checkbox-inline {padding-right: 10px;}
#dataform .input-group .chosen-container-single .chosen-single {border-top-right-radius: 0; border-bottom-right-radius: 0}
#title.form-control {border-top-right-radius: 0; border-bottom-right-radius: 0}

.dropdown-pris > .btn {background-color: #fff;}

.minw-60px {min-width: 60px;}
.w-230px{width:230px;}

.colorpicker.input-group-btn > .btn {border-right: none}
</style>    
<title>${currentProduct.name}::提需求</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div class="container mw-1400px">
			<div id="titlebar">
			    <div class="heading">
			      <span class="prefix"><i class="icon-lightbulb"></i></span>
			      <strong><small class="text-muted"><i class="icon-plus"></i></small> 提需求</strong>
			    </div>
			</div>
			<form class="form-condensed" method="post" enctype="multipart/form-data" id="dataform" data-type="ajax">
    			<table class="table table-form"> 
      				<tbody>
      					<tr>
        					<th class="w-80px">所属产品</th>
        					<td class="w-p45-f">
          						<div class="input-group">
            						<select name="product.id" id="product" onchange="loadProduct(this.value);" class="form-control chosen-select">
										<option value="${currentProduct.id}" selected>${currentProduct.name}</option>
										<c:forEach items="${productList}" var="product">
											<option value='${product.id}'>${product.name}</option>
										</c:forEach>
									</select>
              					</div>
        					</td>
        					<td>
          						<div class="input-group" id="moduleIdBox">
          							<span class="input-group-addon">所属模块</span>
          							<select name="module_id" id="module" class="form-control chosen-select">
										<option value="0" selected="selected">/</option>
									</select>
          						</div>
        					</td>
        					<td></td>
      					</tr>
      					<tr>
        					<th>所属计划</th>
        					<td>
          						<div class="input-group" id="planIdBox">
          							<select name='plan' id='plan' class='form-control chosen-select'>
          								<option value=''></option>
          							</select>
								</div>
        					</td>
                			<td>
          						<div class="input-group">
            						<span class="input-group-addon">需求来源</span>
            						<select name="source" id="source" class="form-control">
										<option value="" selected="selected"></option>
										<c:forEach items="${sourceMap}" var="source">
											<option value="${source.key}">${source.value}</option>
										</c:forEach>
									</select>
            						<span class="input-group-addon fix-border">备注</span>
            						<input type="text" name="sourceNote" id="sourceNote" value="" class="form-control">
          						</div>
        					</td>
              			</tr>
      					<tr>
        					<th>指派给</th>
  	 						<td>
     							<div class="input-group">
	       							<select name="assignedTo" id="assignedTo" class="form-control chosen-select">
										<option value="" selected="selected"></option>
		          						<c:forEach items="${userMap}" var="user">
				          					<option value="${user.key}" <c:if test="${product.RD == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
				          				</c:forEach>
									</select>            
									<span class="input-group-addon">
										<label class="checkbox-inline">
											<input type="hidden" name="status" id="status" value="active">
											<input type="checkbox" name="needNotReview[]" onchange="javascript:$(this).prop('checked')?$('#status').val('active'):$('#status').val('draft');" id="needNotReview">
									 		不需要评审
									 	</label>
									</span>
     							</div>
							</td>
   						</tr> 
      					<tr>
        					<th>需求名称</th>
       						<td colspan="2">
       							<div class="required required-wrapper"></div>
       							<div class="row-table">
           							<div class="col-table">
          								<div class="input-group w-p100">
            								<input type='hidden' name='color' id='color' value='' data-provide='colorpicker' data-wrapper='input-group-btn fix-border-right' data-pull-menu-right='false' data-btn-tip='颜色标签' data-update-text='#title ' />
            								<input type="text" name="title" id="title" value="" class="form-control" required>
          								</div>
           							</div>
                                    <div class="col-table w-230px">
          								<div class="input-group">
                            				<span class="input-group-addon fix-border br-0">优先级</span>
                                            <div class="input-group-btn dropdown-pris" data-set="0,1,2,3,4">
              									<button type="button" class="btn dropdown-toggle br-0" data-toggle="dropdown">
                									<span class="pri-text"><span id="priSpan" class="pri0"></span></span> &nbsp;<span class="caret"></span>
              									</button>
              									<ul class="dropdown-menu pull-right">
	               									<li class="active">
	               										<a href="###" onclick="setPri(this)" data-pri="0"><span class="pri0"></span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="1"><span class="pri1">1</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="2"><span class="pri2">2</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="3"><span class="pri3">3</span></a>
	               									</li>
	               									<li>
	               										<a href="###" onclick="setPri(this)" data-pri="4"><span class="pri4">4</span></a>
	               									</li>
              									</ul>
              									<select name="pri" id="pri" class="hide">
													<option value="0" selected="selected"></option>
													<option value="3">3</option>
													<option value="1">1</option>
													<option value="2">2</option>
													<option value="4">4</option>
												</select>
											</div>
                                            <span class="input-group-addon fix-border br-0">预计</span>
            								<input type="number" min="0" required name="estimate" id="estimate" value="" class="form-control minw-60px" placeholder="小时">
                        				</div>
        							</div>
           						</div>
       						</td>
   						</tr>  
      					<tr>
        					<th>需求描述</th>
        					<td colspan="2">
        						<textarea name="spec" id="spec" rows="9" class="form-control kindeditor"></textarea>
								<div class="help-block">建议参考的模板：作为一名&lt;<i class="text-important">某种类型的用户</i>&gt;，我希望&lt;<i class="text-important">达成某些目的</i>&gt;，这样可以&lt;<i class="text-important">开发的价值</i>&gt;。</div>
							</td>
      					</tr>  
            			<tr>
        					<th>验收标准</th>
        					<td colspan="2">
        						<textarea name="verify" id="verify" rows="6" class="form-control kindeditor"></textarea>
							</td>
      					</tr>
                        <tr>
        					<th>抄送给</th>
                			<td>
          						<div class="input-group" id="mailtoGroup">
           							<select name="mailto" id="mailto" multiple="" data-placeholder="选择要发信通知的用户..." class="form-control chosen-select">
										<option value=""></option>
		          						<c:forEach items="${userMap}" var="user">
				          					<option value="${user.key}" <c:if test="${product.RD == user.key}">selected="selected"</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
				          				</c:forEach>
									</select>
          						</div>
        					</td>
                        	<td>
          						<div class="input-group">
                        			<span class="input-group-addon">关键词</span>
                        			<input type="text" name="keywords" id="keywords" value="" class="form-control">
          						</div>
        					</td>
              			</tr>
      					<tr>
        					<th>附件 (<span class="red">50M</span>)</th>
        					<td colspan="2">
        						<style>
								.fileBox {margin-bottom: 10px; width: 100%}
								table.fileBox td {padding: 0!important}
								.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
								.fileBox td .btn {border-radius: 0; border-left: none}
								.file-wrapper.form-control {border-right: 0}
								</style>
								<div id="fileform">
  									<script language="Javascript">dangerFiles = "php,php3,php4,phtml,php5,jsp,py,rb,asp,asa,cer,cdx,aspl";</script>
  									<table class="fileBox" id="fileBox1">
    									<tbody>
    										<tr>
      											<td class="w-p45">
      												<div class="form-control file-wrapper">
      													<input type="file" name="files" class="fileControl" tabindex="-1" onchange="checkSizeAndType(this)">
   													</div>
   												</td>
      											<td class="">
      												<input type="text" name="titles" class="form-control" placeholder="标题：" tabindex="-1">
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="addFile(this)" class="btn btn-block"><i class="icon-plus"></i></a>
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="delFile(this)" class="btn btn-block"><i class="icon-remove"></i></a>
      											</td>
    										</tr>
  										</tbody>
  									</table>
  								</div>
								<script language="javascript">
								/**
								 * Add a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function addFile(clickedButton)
								{
								    fileRow = "  <table class='fileBox' id='fileBox$i'>\n    <tr>\n      <td class='w-p45'><div class='form-control file-wrapper'><input type='file' name='files[]' class='fileControl'  tabindex='-1' onchange='checkSizeAndType(this)'\/><\/div><\/td>\n      <td class=''><input type='text' name='title[]' class='form-control' placeholder='\u6807\u9898\uff1a' tabindex='-1' \/><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='addFile(this)' class='btn btn-block'><i class='icon-plus'><\/i><\/a><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='delFile(this)' class='btn btn-block'><i class='icon-remove'><\/i><\/a><\/td>\n    <\/tr>\n  <\/table>";
								    fileRow = fileRow.replace('$i', $('.fileID').size() + 1);
								
								    /* Get files and labels name.*/
								    fileName  = $(clickedButton).closest('tr').find('input[type="file"]').attr('name');
								    titleName = $(clickedButton).closest('tr').find('input[type="text"]').attr('name');
								
								    /* Add file input control and set files and labels name in it.*/
								    $fileBox = $(clickedButton).closest('.fileBox').after(fileRow).next('.fileBox');
								    $fileBox.find('input[type="file"]').attr('name', fileName);
								    $fileBox.find('input[type="text"]').attr('name', titleName);
								
								    updateID();
								}
								
								/**
								 * Delete a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function delFile(clickedButton)
								{
								    if($('.fileBox').size() == 1) return;
								    $(clickedButton).closest('.fileBox').remove();
								    updateID();
								}
								
								/**
								 * Update the file id labels.
								 * 
								 * @access public
								 * @return void
								 */
								function updateID()
								{
								    i = 1;
								    $('.fileID').each(function(){$(this).html(i ++)});
								}
								</script>
							</td>
      					</tr>   
      					<tr>
      						<td></td>
      						<td colspan="2" class="text-center"> 
      							<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
      							<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
   							</td>
						</tr>
    				</tbody>
   				</table>
    			<span id="responser"></span>
  			</form>
		</div>
	</div>
	</div>
<script type="text/javascript">
var kEditorId = ["spec","verify"];
$(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
	loadProduct("${productId}");
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
});
function loadProduct(productId) {
	loadProductBranches(productId);
	loadProductModules(productId);
	loadProductPlans(productId);
}

function loadBranch() {
	var branchId = $("#branch").val();
	if(typeof(branchId) == "undefined")
		branchId = 0;
	loadProductModules($("#product").val(),branchId)
	loadProductPlans($("#product").val(),branchId);
}

function loadProductBranches(productId) {
	$("#branch").remove();
	$.get("../ajaxGetBranches/" + productId,function(data){
		if (!$.isEmptyObject(data)) {
			$("#product").closest('.input-group').append("<select name='branch_id' id='branch' onchange='loadBranch();' class='form-control' style='width:120px'></select>");
			for (var i = 0; i < data.length; i++) {
				$("#branch").append("<option value='" + data[i].id + "'>" + data[i].name + "</option>");
			}
		}
	});	
}

function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		$("#module, #module + div, #module + div + span").remove();
		$("#moduleIdBox").append("<select name='module_id' id='module' class='form-control chosen-select'></select>");
		$("#module").append("<option value='0' selected>/</option>");
		if (!$.isEmptyObject(data)) {
			iterateTree(data,"");
		} else {
			$("#moduleIdBox").append("<span class='input-group-btn'><a href='./plan_create_" + productId + "_0' class='btn' data-toggle='tooltip' title='创建计划' target='_blank'><i class='icon icon-plus'></i></a>&nbsp; <a href='javascript:loadProductModules(" + productId + ")' class='btn' data-toggle='tooltip' title='刷新'><i class='icon icon-refresh'></i></a></span>");
		}
		$("#moduleIdBox #module").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});			
	})
}

function iterateTree(data,name) {
	var a,c,d;
	for (var i = 0, l = data.length; i < l; i++) {
		a = name + "/" + data[i].name;
		d = data[i].branchName;
		c = (d !== "分支" && d !== "平台" && d !== "") ? d + a : a;
		$("#module").append("<option value='" + data[i].id + "'>" + c + "</option>");
		iterateTree(data[i].children,a);
	}
}

function loadProductPlans(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetPlans/true/" + productId + "/" + branchId,function(data){
		$('#planIdBox').empty();
		$("#planIdBox").append("<select name='plan' id='plan' class='form-control chosen-select'></select>");
		$("#plan").append("<option value=''></option>");
		if (!$.isEmptyObject(data)) {
			for (var i = 0; i < data.length; i++) {
				$("#plan").append("<option value='" + data[i].id + "'>" + data[i].title + " [" + data[i].begin + " ~ " + data[i].end + "]" + "</option>");
			}
		} else {
			$("#planIdBox").append("<span class='input-group-btn'><a href='./plan_create_" + productId + "_0' class='btn' data-toggle='tooltip' title='创建计划' target='_blank'><i class='icon icon-plus'></i></a>&nbsp; <a href='javascript:loadProductPlans(" + productId + ")' class='btn' data-toggle='tooltip' title='刷新'><i class='icon icon-refresh'></i></a></span>");
		}
		$("#planIdBox #plan").chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});	
	})
}
$(function()
{
    if($('#needNotReview').prop('checked'))
    {
        $('#assignedTo').attr('disabled', 'disabled');
    }
    else
    {
        $('#assignedTo').removeAttr('disabled');
    }
    $('#assignedTo').trigger("chosen:updated");

    $('#needNotReview').change(function()
    {
        if($('#needNotReview').prop('checked'))
        {
            $('#assignedTo').attr('disabled', 'disabled');
        }
        else
        {
            $('#assignedTo').removeAttr('disabled');
        }
        $('#assignedTo').trigger("chosen:updated");
    });

    $('[data-toggle=tooltip]').tooltip();
});
function setPri(obj) {
	$("#priSpan").attr("class",$(obj).find("span").attr("class"));
	$("#priSpan").text($(obj).find("span").text());
	$(obj).parent().addClass("active");
	$(obj).parent().siblings().removeClass("active");
	$("#pri").find("option[value!='" + $(obj).find("span").text() + "']").removeAttr("selected");
	$("#pri").find("option[value='" + $(obj).find("span").text() + "']").attr("selected",true);
}

</script>
</body>
</html>