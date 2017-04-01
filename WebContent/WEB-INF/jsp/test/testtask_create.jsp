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
<link href="${ctxResources}/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<link href="${ctxResources}/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<link href="${ctxResources}/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/datatable/zui.datatable.min.js"></script>
<script src="${ctxResources}/dist/lib/chosen/chosen.min.js"></script>
<script src="${ctxResources}/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="${ctxResources}/resources/dist/lib/datetimepicker/datetimepicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true
	});
	//时间
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
<title>提交测试</title>
</head>
<body>
	<header id="header" style="padding-top: 0px">
		<nav id="mainmenu" style="margin-top:0">
		<ul class="nav">
			<li data-id="my"><a href=""><i class="icon-home"></i><span> 我的地盘</span></a></li>
			<li class="active" data-id="product"><a href="" class="active">项目</a></li>
			<li data-id="project"><a href="">迭代</a></li>
			<li data-id="qa"><a href="">测试</a></li>
			<li data-id="doc"><a href="">文档</a></li>
			<li data-id="report"><a href="">统计</a></li>
			<li data-id="company"><a href="">组织</a></li>
			<li data-id="admin"><a href="">后台</a></li>
			<li class="custom-item"><a href="" data-toggle="modal" data-type="iframe" title="自定义导航" data-icon="cog" data-width="80%"><i class="icon icon-cog"></i></a></li>
		</ul>
		<div class="input-group input-group-sm" id="searchbox">
			<div class="input-group-btn" id="typeSelector" style="display: none;">
				<button type="button" class="btn dropdown-toggle" data-toggle="dropdown">
					<span id="searchTypeName">项目</span> 
					<span class="caret"></span>
				</button>
				<input type="hidden" name="searchType" id="searchType" value="product">
			</div>
			<input type="text" name="searchQuery" id="searchQuery" value="" onclick="" onkeydown="if(event.keyCode==13) shortcut()" class="form-control" placeholder="">
			<div id="objectSwitcher" class="input-group-btn"><a href="javascript:shortcut();" class="btn">搜索</a></div>
		</div>
		</nav>
		<nav id="modulemenu">
		    <ul class='nav'>
				<li data-id='product'><a id='currentItem' href="javascript:showDropMenu('product', '12', 'testtask', 'browse', '')">P2P <span class='icon-caret-down'></span></a><div id='dropMenu'><i class='icon icon-spin icon-spinner'></i></div></li>
				<li class='right ' data-id='index'><a href='/qa-index-no-12.html' ><i class='icon-home'></i>测试主页</a>
				</li>
				<li class=' ' data-id='bug'><a href='/bug-browse-12.html' >Bug</a>
				</li>
				<li class=' ' data-id='testcase'><a href='/testcase-browse-12.html' >用例</a>
				</li>
				<li class=' active' data-id='testtask'><a href='/testtask-browse-12.html' >版本</a>
				</li>
			</ul>
		  </nav>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div class="container mw-1400px">
			<div id="titlebar">
			    <div class="heading">
			      <span class="prefix"><i class="icon-cube"></i></span>
			      <strong><small class="text-muted"><i class="icon icon-plus"></i></small> 提交测试</strong>
			    </div>
		  	</div>
			<form class="form-condensed" method="post" target="hiddenwin" id="product">
			    <table class="table table-form"> 
		      		<tbody>
			      		<tr>
					        <th class="w-90px">所属产品</th>
					        <td class="w-p25-f">
					        	<select name="product_id" id="product_id" class="form-control chosen-select">
					        		<option value=""></option>
					        		<option value="1">P2P</option>
					        		<option value="2">校园商城</option>
					        	</select>
							</td>
			      		</tr>  
			      		<tr>
					        <th class='w-90px'>所属项目</th>
					        <td class='w-p25-f'>
						        <div class="required required-wrapper"></div>
						        <select name='project' id='project' class='form-control chosen' onchange='loadProjectRelated(this.value)'>
									<option value='22'>33332555</option>
								</select>
								</td>
								<td></td>
					      </tr>   
			      		<tr>
					        <th>版本</th>
					        <td>
					        	<div class="required required-wrapper"></div>
				          		<select id="build" name="build" class="chosen-select form-control">
				          			<option value=""></option>
					          	</select>
							</td>
							<td></td>
			      		</tr>  
			      		<tr>
					        <th>负责人</th>
					        <td>
			          			<select id="owner" name="owner" class="chosen-select form-control">
			          				<option value=""></option>
			          				<option value="admin">admin</option>
								</select>
							</td>
							<td></td>
			      		</tr> 
			      		<tr>
					        <th>优先级</th>
					        <td>
		          				<select id="pri" name="pri" class="form-control">
			          	 	 		<option value=""></option>
	          						<option value="1">1</option>
	          						<option value="2">2</option>
	          						<option value="3">3</option>
	          						<option value="4">4</option>
								</select>
							</td>
							<td></td>
			      		</tr> 
			      		<tr>
					        <th>开始日期</th>
					        <td>
			          			<input type="text" name="begin" id="begin" value="" class="form-control form-date">             
							</td>
							<td></td>
			      		</tr> 				      				      				       
			      		<tr>
					        <th>结束日期</th>
					        <td>
					        	<input id="end" name="end" class="form-control form-date" >
				        	</td>
			      		</tr>  
			      		<tr>
			        		<th>当前状态</th>
			        		<td colspan="2">
					        	<div class="radio">
					        		<label>
					        			<input type="radio" name="acl" value="open" onclick="setWhite(this.value);" id="aclopen" <c:if test="${'open' == product.acl}">checked="checked"</c:if>> 
					        			默认设置(有产品视图权限，即可访问)
				        			</label>
			        			</div>
			        			<div class="radio">
			        				<label>
			        					<input type="radio" name="acl" value="private" onclick="setWhite(this.value);" id="aclprivate" <c:if test="${'private' == product.acl}">checked="checked"</c:if>> 
			        					私有产品(只有项目团队成员才能访问)
		        					</label>
		       					</div>
		       					<div class="radio">
		       						<label>
		       							<input type="radio" name="acl" value="custom" onclick="setWhite(this.value);" id="aclcustom" <c:if test="${'custom' == product.acl}">checked="checked"</c:if>> 
		       							自定义白名单(团队成员和白名单的成员可以访问)
		       						</label>
		       					</div>
      						</td>
	      				</tr>  
		      			<!--  <tr id="whitelistBox" class="hidden">
	        				<th>分组白名单</th>
					        <td colspan="2">
					        	<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="1" id="whitelist1" <c:if test="${!fn:startsWith(product.whitelist,'10') && !fn:startsWith(product.whitelist,'11') && fn:startsWith(product.whitelist,'1')}">checked="checked"</c:if>> 
					        		管理员
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="2" id="whitelist2" <c:if test="${fn:contains(product.whitelist,'2')}">checked="checked"</c:if>> 
					        		研发
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="3" id="whitelist3" <c:if test="${fn:contains(product.whitelist,'3')}">checked="checked"</c:if>> 
					        		测试
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="4" id="whitelist4" <c:if test="${fn:contains(product.whitelist,'4')}">checked="checked"</c:if>> 
					        		项目经理
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="5" id="whitelist5" <c:if test="${fn:contains(product.whitelist,'5')}">checked="checked"</c:if>> 
					        		产品经理
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="6" id="whitelist6" <c:if test="${fn:contains(product.whitelist,'6')}">checked="checked"</c:if>> 
					        		研发主管
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="7" id="whitelist7" <c:if test="${fn:contains(product.whitelist,'7')}">checked="checked"</c:if>> 
					        		产品主管
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="8" id="whitelist8" <c:if test="${fn:contains(product.whitelist,'8')}">checked="checked"</c:if>> 
					        		测试主管
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="9" id="whitelist9" <c:if test="${fn:contains(product.whitelist,'9')}">checked="checked"</c:if>> 
					        		高层管理
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="10" id="whitelist10" <c:if test="${fn:contains(product.whitelist,'10')}">checked="checked"</c:if>> 
					        		其他
				        		</label>
				        		<label class="checkbox-inline">
					        		<input type="checkbox" name="whitelist" value="11" id="whitelist11" <c:if test="${fn:contains(product.whitelist,'11' )}">checked="checked"</c:if>> 
					        		guest
				        		</label>
			        		</td>
				      	</tr>
				      	<tr>-->
				      		<td></td>
				      		<td colspan="2"> 
				      			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			      			</td>
		      			</tr>
		    		</tbody>
	    		</table>
			</form>
		</div>
	</div>
	</div>
<script>
$(function(){
	var a = '${product.acl}';
	if(a === '')
		$("#aclopen").attr("checked",true);
	else
		setWhite(a);
})
function setWhite(acl)
{
    acl == 'custom' ? $('#whitelistBox').removeClass('hidden') : $('#whitelistBox').addClass('hidden');
}

</script>
<script>
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea', {
           width:'100%',
		resizeType : 1,
		urlType:'relative',

		allowFileManager : true,
		items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
		          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
		          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
	});
});
</script>
</body>
</html>