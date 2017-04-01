<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<!DOCTYPE html>
<html lang='zh-cn'>
<head>
<meta charset='utf-8'>
<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<meta name="renderer" content="webkit"> 
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<title></title>
</head>
<body>
	<div class='outer'>
		<div class='container'>
			<div id="titlebar">
		      	<div class="heading">
		        	<span class="prefix"><i class="icon-sitemap"></i></span>
		        	<strong><small class="text-muted"><i class="icon-pencil"></i></small> 编辑</strong>
		      	</div>
		    </div>
		    <form style="height:350px" class="form-condensed" method="post" id="dataform">
      			<table class="table table-form"> 
                	<tbody>
                		<tr>
          					<th class="w-80px">所属产品</th>
          					<td>
          						<select name="root" id="root" class="form-control chosen">
        							<c:forEach items="${productList}" var="product">
										<option value='${product.id}' <c:if test="${module.root == product.id}">selected</c:if>>${product.name}</option>
									</c:forEach>
								</select>
							</td>
        				</tr>
                        <tr>
          					<th class="w-80px">上级模块</th>
          					<td>
          						<select name="parent" id="parent" class="form-control chosen">
									<option value="0" selected="selected">/</option>
								</select>
							</td>
        				</tr>
        				<tr>
         	 				<th class="w-80px">模块名称</th>
          					<td><input type="text" name="name" id="name" value="${module.name}" class="form-control"></td>
        				</tr>
                		<tr>
				          	<th>简称</th>
				          	<td><input type="text" name="shortname" id="shortname" value="${module.shortname}" class="form-control"></td>
				        </tr>  
				        <tr>
				          	<td colspan="2" class="text-center">
				           	<button type="button" id="submitForm" class="btn btn-primary" data-loading="稍候...">保存</button>          </td>
				        </tr>
      				</tbody>
      			</table>
    		</form>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	$('select.chosen').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%',
    	drop_direction: "down"
	});
	$("#submitForm").on("click",function(){
		$.post("./module_edit_${productId}_${moduleId}",$("#dataform").serialize(),function(){
			window.parent.$.zui.closeModal();
			window.parent.location.reload();
		})
	});
	loadProductModules("${module.root}");
	$("#root").change(function(){
		var a = this.value;
		bootbox.confirm("<strong>模块的所属产品修改，会关联修改该模块下的需求、Bug、用例的所属产品，以及项目和产品的所属关系。该操作比较危险，请谨慎操作。是否确认修改？</strong>",function(result){
			if (result === false) {
				$("#root").val("${module.root}");
				$("#root").trigger("chosen:updated");
			} else {
				loadProductModules(a);
			}
		});
	});
})
function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		$("#parent").empty();
		$("#parent").append("<option value='0' selected>/</option>");
		if (!$.isEmptyObject(data)) 
			iterateTree(data,"");
		$("#parent").trigger("chosen:updated");			
	})
}

function iterateTree(data,name) {
	var s,a,c,d;
	for (var i = 0; i < data.length; i++) {
		a = name + "/" + data[i].name;
		s = "${module.parent}" == data[i].id ? "selected" : "";
		d = data[i].branchName;
		c = (d !== "分支" && d !== "平台" && d !== "") ? d + a : a;
		$("#parent").append("<option value='" + data[i].id + "' " + s + ">" + c + "</option>");
		iterateTree(data[i].children,a);
	}
}
</script>
</body>
</html>
