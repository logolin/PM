<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
<script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
<script type="text/javascript">
</script>
<script>
$(document).ready(function(){
	//chosen的初始化
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true
	});
	//chosen初始化
    $('select.chosen').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	});
});

$(function(){
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
})
</script>

<title>编辑项目::${project.name}</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
			<div class="container mw-1400px">
				<div id="titlebar">
					<div class="heading">
						<span class="prefix">
							<i class="icon-folder-close-alt"></i><strong>${project.id}</strong>
						</span>
						<strong><a href="#" target="_blank">${project.name}</a>
						</strong>
				      <small class="text-muted"> 编辑项目 <i class="icon-pencil"></i></small>
				    </div>
				</div>
				<form class="form-condensed" method="post" onsubmit="return check();" name="project" target="hiddenwin">
					<table class="table table-form"> 
						<tbody>
							<tr>
        						<th class="w-90px">项目名称</th>
        						<td class="w-p45">
        							<div class="required required-wrapper">
        							</div>
        							<input type="text" name="name" id="name" value="${project.name}" class="form-control">
								</td>
								<td style="padding-left: 15px;"></td>
      						</tr>  
							<tr>
        						<th>项目代号</th>
        						<td>
        						<div class="required required-wrapper"></div>
        						<input type="text" name="code" id="code" value="${project.code}" class="form-control">
								</td>
							</tr>
							<tr>
        						<th class="w-90px">起始日期</th>
						        <td>
						        <div class="required required-wrapper"></div>
						          <div class="input-group">
						            <input type="text" name="begin" id="begin" value="${project.begin}" class="form-control form-date" onchange="computeWorkDays()" placeholder="开始日期">
						            <span class="input-group-addon">至</span>
						            <input type="text" name="end" id="end" value="${project.end}" class="form-control form-date" onchange="computeWorkDays()" placeholder="结束日期">
						            <div class="input-group-btn">
						              <button type="button" class="btn dropdown-toggle" data-toggle="dropdown">按时间段 <span class="caret"></span></button>
						              <ul class="dropdown-menu">
						              	<li><a href='javascript:computeEndDate("7")'>一星期</a></li>
						              	<li><a href='javascript:computeEndDate("14")'>两星期</a></li>
						                <li><a href='javascript:computeEndDate("31")'>一个月</a></li>
						             	<li><a href='javascript:computeEndDate("62")'>两个月</a></li>
						                <li><a href='javascript:computeEndDate("93")'>三个月</a></li>
						                <li><a href='javascript:computeEndDate("186")'>半年</a></li>
						                <li><a href='javascript:computeEndDate("365")'>一年</a></li>
						              </ul>
						            </div>
						          </div>
						        </td>
							</tr>
							<tr>
					        <th>可用工作日</th>
					        <td>
					          <div class="input-group">
					          <input type="text" name="days" id="days" value="${project.days}" class="form-control">
					            <span class="input-group-addon">天</span>
					          </div>
					        </td>
					      </tr> 
					      <tr>
					        <th>项目类型</th>
					        <td>
					        	<select name="type" id="type" class="form-control">
									<option value="sprint" selected="selected">短期项目</option>
									<option value="waterfall">长期项目</option>
									<option value="ops">运维项目</option>
								</select>
							</td>
					      </tr>  
					      <tr>
					        <th>团队名称</th>
					        <td><input type="text" name="team" id="team" value="${project.team}" class="form-control">
							</td>
					      </tr>  
					      <tr>
					        <th>项目状态</th>
					        <td>
					        	<select name="status" id="status" class="form-control">
									<option value="wait" <c:if test="${project.status == 'wait'}">selected</c:if>>未开始</option>
									<option value="doing" <c:if test="${project.status == 'doing'}">selected</c:if>>进行中</option>
									<option value="suspended" <c:if test="${project.status == 'suspended'}">selected</c:if>>已挂起</option>
									<option value="done" <c:if test="${project.status == 'done'}">selected</c:if>>已完成</option>
								</select>
					        </td>
					      </tr>
					      <tr>
					        <th rowspan="2">负责人</th>
					        <td>
					          <div class="input-group">
					          		<span class="input-group-addon">产品负责人</span>
						            <select name="PO" id="PO" class="form-control chosen chosen-select" >
							            <option value=""></option>
										<c:forEach items="${userList}" var="user">
											<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
										</c:forEach>
									</select>
					          </div>
					        </td>
					        <td>
					          <div class="input-group">
					            <span class="input-group-addon">测试负责人</span>
						            <select name="QD" id="QD" class="form-control chosen chosen-select" >
						            <option value=""></option>
						            <c:forEach items="${userList}" var="user">
										<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
									</c:forEach>
									</select>
					          </div>
					        </td>
					      </tr>
					      <tr>
					        <td>
					          <div class="input-group">
					            <span class="input-group-addon">项目负责人</span>
						            <select name="PM" id="PM" class="form-control chosen chosen-select" >
						            <option value=""></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
									</c:forEach>
									</select>
					          </div>
					        </td>
					        <td>
					          <div class="input-group">
					            <span class="input-group-addon">发布负责人</span>
						            <select name="RD" id="RD" class="form-control chosen chosen-select" >
						            <option value=""></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.account}">${fn:toUpperCase(fn:substring(user.account,0,1))}:${user.realname}</option>
									</c:forEach>
									</select>
					          </div>
					        </td>
					      </tr>
					      <tr>
							<th>关联产品</th>
					        <td class="text-left" id="productsBox" colspan="2">
						    	<div class="row">
						    		<c:forEach items="${map}" var="map" varStatus="i">
							        <div class="col-sm-3">
							            <div class="input-group" id="inputs${i.index}" style="width:100%">
								            <select name='products' id='products${i.index}' class='form-control chosen' onchange='loadBranches(this)'>
												<option selected="selected" value=""></option>
												<c:forEach items="${productList}" var="product">
													<option value="${product.id}" <c:if test="${map.key.id == product.id}">selected</c:if>>${product.name}</option>
												</c:forEach>
											</select>
											<span class='input-group-addon fix-border' style='padding:0px'></span>
											<c:if test="${map.key.type != 'normal'}">
												<select name='branchs' id='branch${i.index}' class='form-control' style='width:80px'>
													<c:if test="${map.key.type == 'branch'}"><option value="0">所有分支</option></c:if>
													<c:if test="${map.key.type == 'platform'}"><option value="0">所有平台</option></c:if>
													<c:forEach items="${map.value}" var="branch">
														<option value="${branch.id}" <c:if test="${branchIds.get(i.index) == branch.id}">selected</c:if>>${branch.name}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${map.key.type == 'normal'}">
												<input type="hidden" id="branch" name="branchs" value="0" />
											</c:if>
							        	</div>
							    	</div>
							    	</c:forEach>
							    	<div class="col-sm-3">
							            <div class="input-group" style="width:100%">
								            <select name='products' id='products${linkProducts.size()}' class='form-control chosen' onchange='loadBranches(this)'>
												<option selected="selected" value=""></option>
												<c:forEach items="${productList}" var="product">
													<option value="${product.id}" <c:if test="${prod.id == product.id}">selected</c:if>>${product.name}</option>
												</c:forEach>
											</select>
											<span class='input-group-addon fix-border' style='padding:0px'></span>
							        	</div>
							    	</div>
						    	</div>
							</td>
					      </tr>
					      <tr>
					        <th>项目描述</th>
					        <td colspan="2"><textarea id="content" name="content" class="form-control kindeditor" style="height:150px;">${project.descript}</textarea></td>
					      </tr>  
					      <tr>
					        <th>访问控制</th>
					        <td colspan="2">
					        <div class="radio">
					        	<label>
					        		<input type="radio" name="acl" value="open" <c:if test="${project.acl == 'open'}">checked</c:if> onclick="setWhite(this.value);" id="aclopen"> 默认设置(有项目视图权限，即可访问)
					        	</label>
					        	</div>
					        <div class="radio">
					        	<label>
					        		<input type="radio" name="acl" value="private" <c:if test="${project.acl == 'private'}">checked</c:if> onclick="setWhite(this.value);" id="aclprivate"> 私有项目(只有项目团队成员才能访问)
					        	</label>
					        </div>
					        <div class="radio">
					        	<label>
					        		<input type="radio" name="acl" value="custom" <c:if test="${project.acl == 'custom'}">checked</c:if> onclick="setWhite(this.value);" id="aclcustom"> 自定义白名单(团队成员和白名单的成员可以访问)
					        	</label>
					        </div>
					        </td>
					      </tr>
					      <tr id="whitelistBox" <c:if test="${project.acl != 'custom'}">class="hidden"</c:if> >
					        <th>分组白名单</th>
					        <td colspan="2">
					        	<c:forEach items="${groupList}" var="group" varStatus="vs">
							        <label class="checkbox-inline">
							        <input type="checkbox" <c:forEach items="${whiteList}" var="white"><c:if test="${white == group.id}">checked</c:if></c:forEach> name="whitelist" value="${group.id}" id="whitelist1"> ${group.name}</label>
						        </c:forEach>
					       	</td>
					      </tr>
					      <tr>
					        <td></td>
					        <td colspan="2" class="text-center"> 
					        <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
					        	<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a></td>
					      </tr>
			     		</tbody>
			     	</table>
				</form>
			</div>
		</div>
	</div>
<script>
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

//设置白名单
function setWhite(acl)
{
    acl == 'custom' ? $('#whitelistBox').removeClass('hidden') : $('#whitelistBox').addClass('hidden');
}

/**
 * Convert a date string like 2011-11-11 to date object in js.
 * 
 * @param  string $date 
 * @access public
 * @return date
 */

 function convertStringToDate(dateString)
 {
 	dateString = dateString.split('-');
    dateString = dateString[1] + '/' + dateString[2] + '/' + dateString[0];
     
     return Date.parse(dateString);
 }
/**
 * Compute the end date for productplan.
 * 
 * @param  int    $delta 
 * @access public
 * @return void
 */
 function computeEndDate(delta)
 {
     beginDate = $('#begin').val();
     if(!beginDate) return;

     endDate = addDays(convertStringToDate(beginDate),parseInt(delta));
     year = endDate.getFullYear();
     month = endDate.getMonth() < 9 ? "0" + (endDate.getMonth() + 1) : (endDate.getMonth() + 1);
     day = endDate.getDate() < 10 ? "0" + endDate.getDate() : endDate.getDate();
     endDate = year + "-" + month + "-" + day;
     $('#end').val(endDate);
     getDays();
     
 }
 function addDays(date, days) {
     var result = new Date(date);
     result.setDate(result.getDate() + days);
     return result;
 }
 function getDays() {
	 var begin = new Date($('#begin').val());
	 var end = new Date($('#end').val());
     var days = (end - begin) / (24*1000*60*60) + 1;
     var weekEnds = 0;
     for(var i = 0; i < days; i++) {
    	 if(begin.getDay() == 0 || begin.getDay() == 6)
    		 weekEnds++;
    	 begin = begin.valueOf();
    	 begin += 1000 * 60 * 60 * 24;
    	 begin = new Date(begin);
     }
     days = days - weekEnds;
	 $('#days').val(days);
 }
 
//富文本框
 var editor;
 KindEditor.ready(function(K) {
 	editor = K.create('textarea', {
            width:'100%',
 		resizeType : 1,
 		urlType:'relative',
 		afterBlur: function(){this.sync();},
 		allowFileManager : true,
 		items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
 		          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
 		          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
 	});
 });
 
//点击最后一个产品input，就再添加一个input
 function loadBranches(product)
 {
	 
     if($('#productsBox .input-group:last select:first').val() != 0)
     {
         var length = $('#productsBox .input-group').size();
         $('#productsBox .row').append('<div class="col-sm-3">' + $('#productsBox .col-sm-3:last').html() + '</div>');
         if($('#productsBox .input-group:last select').size() >= 2)$('#productsBox .input-group:last select:last').remove();
         $('#productsBox .input-group:last .chosen-container').remove();
         $('#productsBox .input-group:last select:first').attr('name', 'products').attr('id', 'products' + length);
        //chosen初始化
         $('select.chosen').chosen({
 		    no_results_text: '没有找到',    
 		    search_contains: true,      
 		    allow_single_deselect: true,
 		});
//          $('#productsBox .input-group:last .chosen').chosen(defaultChosenOptions);
     }
     
	var $inputgroup = $(product).closest('.input-group');
	if($inputgroup.find('select').size() >= 2)$inputgroup.find('select:last').remove();
	var index = $inputgroup.find('select:first').attr('id').replace('products' , '');
	if($(product).val()) {
		$.get("../ajaxGetBranches/" + $(product).val(), function(data) {
			if(!$.isEmptyObject(data)){
				$("#branch" + index).remove();
				$inputgroup.append("<select name='branchs' id='branch"+ index +"' class='form-control' style='width:80px'></select>");
				for (var i = 0; i < data.length; i++) {
					$("#branch" + index).append("<option value='" + data[i].id + "'>" + data[i].name + "</option>");
				}
			} else {
				$("#branch" + index).remove();
				$("#products" + index).append("<input type='hidden' id='branch'"+ index +" name='branchs' value='0' />");
			}
		})
	}
 }
 
 function check(){
		var name = $("#name").val();
		var code = $("#code").val();
		var begin = $("#begin").val();
		var end = $("#end").val();
		if(!name) {
			alert("『任务名称』不能为空");
			return false;
		}
		if(!code) {
			alert("『任务代号』不能为空");
			return false;
		}
		if(!begin) {
			alert("『起始日期』不能为空");
			return false;
		}
		if(!end) {
			alert("『结束日期』不能为空");
			return false;
		}
	}
</script>
</body>
</html>