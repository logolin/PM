<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<style>
.parentModule {width:10%; vertical-align:middle;}
.copy {display:block; margin-bottom:5px;}

.outer .row .col-md-8 .table-form {max-width: 600px}

#sonModule {max-width: 500px}
#moduleBox span > .form-control {margin-bottom: 5px;}

.w-260px {width: 260px!important}
table.copy td {padding: 0!important}
table.copy td .form-control {border-right: 0}

.tree-toggle {cursor: pointer;}
.tree-actions, .tree li.hover > .tree-actions {opacity: 1}
.tree-item-branch > .tree-actions [data-type='sort'] {display: none}
.tree-item-branch > .tree-actions [data-type='add'] > .icon-plus:before {content: '\e6c7'}

#childrenForm table .chosen-container .chosen-single {border-right-color: transparent}
#childrenForm table .chosen-container .chosen-single {border-right-color: transparent}
#childrenForm .col-table + .col-table .form-control {border-left: transparent;}
</style>
<title>${currentProduct.name}::维护项目视图模块</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
  		<div class="outer" style="min-height: 494px;">
			<div id="featurebar">
  				<div class="heading">模块维护</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
    				<div class="panel">
      					<div class="panel-heading"><i class="icon icon-wrench"></i> <strong>${currentProduct.name}::维护项目视图模块</strong></div>
      					<div class="panel-body">
        					<div class="container">
          						<ul class="tree-lines tree" id="modulesTree" data-animate="true" data-ride="tree">
          							<li id="branchModules" style="display:none"></li>
          							<c:if test="${currentProduct.type != 'normal' && fn:length(branchList) > 0}">
	          							<li class="tree-item-branch open in">
	          								<span class="tree-toggle"><c:if test="${currentProduct.type == 'branch'}">分支</c:if><c:if test="${currentProduct.type == 'platform'}">平台</c:if></span>
	          								<ul>
	          									<c:forEach items="${branchList}" var="branch">
	       											<li class="tree-item-branch open in">
	        											<a href="./module_manage_${productId}_${branch[0].id}_0">${branch[0].name}</a>
	        											<c:if test="${branch[1]}">
		         											<ul id="branch${branch[0].id}">
		         											</ul>
	        											</c:if>
	       											</li>
	          									</c:forEach>
	          								</ul>
	          							</li>
          							</c:if>
          						</ul>
        					</div>
      					</div>
    				</div>
  				</div>
  				<div class="col-sm-8">
    				<form id="childrenForm" class="form-condensed" method="post">
      					<div class="panel">
        					<div class="panel-heading">
          						<i class="icon icon-branch"></i> 
                    			维护子模块                   
                  			</div>
        					<div class="panel-body">
          						<table class="table table-form">
            						<tbody>
            							<tr>
              								<td class="parentModule">
                								<nobr>
                									<a href="./module_manage_${currentProduct.id}_0_0">${currentProduct.name}</a>
													&nbsp;<i class="icon-angle-right"></i>&nbsp;
                									<c:forEach items="${path}" var="obj">
                										<a href="./module_manage_${module.root}_${module.branch_id}_${obj[0]}">${obj[1]}</a>
														&nbsp;<i class="icon-angle-right"></i>&nbsp;  
                									</c:forEach>
												</nobr>
              								</td>
              								<td id="moduleBox"> 
                								<div id="sonModule">
                									<c:forEach items="${module.children}" var="child" varStatus="s">
	                									<div class='row-table' style='margin-bottom:5px'>
	                										<input type="hidden" name="modules[${s.index}].id" id="modules[${s.index}].id" value="${child.id}"/>
	                										<div class='col-table'>
	                											<input type='text' name='modules[${s.index}].name' id='name[${s.index}].name' value='${child.name}' class="form-control" />
															</div>
															<c:if test="${currentProduct.type != 'normal'}">
																<div class='col-table'>
																	<select name='modules[${s.index}].barnch_id' id='modules[${s.index}].branch_id' class="form-control" disabled>
																		<option value='${child.branch_id}' selected='selected'>${child.branchName}</option>
																	</select>
																</div>
															</c:if>
															<div class='col-table' style='width:70px'>
																<input type='text' name='modules[${s.index}].shortname' id='modules[${s.index}].shortname' value='${child.shortname}' class='form-control' placeholder='简称'  />
															</div>
														</div>
													</c:forEach>
													<c:forEach begin="0" end="3">
														<div class='row-table' style='margin-bottom:5px'>
															<div class='col-table'>
																<input type='text' name='names' id='names' value='' class='form-control' placeholder='模块名称' />
															</div>
															<c:if test="${currentProduct.type != 'normal'}">
																<div class="col-table">
																	<select name='branch_ids' id='branch_ids' class="form-control">
																		<option value="${module.branch_id}">${module.branchName}</option>
																			<c:if test="${moduleId == 0}">
																				<c:forEach items="${branchList}" var="branch">
																					<option value='${branch[0].id}' <c:if test="${branch[0].id == branchId}">selected</c:if>>${branch[0].name}</option>
																				</c:forEach>
																			</c:if>
																	</select>
																</div>
															</c:if>
															<div class='col-table' style='width:120px'>
																<div class='input-group'>
																	<input type='text' name='shortnames' id='shortnames' value='' class='form-control' placeholder='简称' />
																	<span class='input-group-addon fix-border'><a href='javascript:;' onclick='addItem(this)'><i class='icon icon-plus'></i></a></span>
																	<span class='input-group-addon'><a href='javascript:;' onclick='deleteItem(this)'><i class='icon icon-remove'></i></a></span>
																</div>
															</div>
														</div>
													</c:forEach>
												</div>
             								</td>
            							</tr>
            							<tr>
              								<td></td>
              								<td colspan="2">
                 								<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
                 								<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
              								</td>
            							</tr>
          							</tbody>
          						</table>
			      				<%@ include file="/WEB-INF/jsp/include/history.jsp"%> 
							  	<fieldset id="actionbox" class="actionbox" style="margin-top: 15px">
					    			<legend>
					      				<i class="icon-time"></i>历史记录    
					      				<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
					      				<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
					    			</legend>
				  					<ol id="historyItem">
				  						<c:forEach items="${actionList}" var="action" varStatus="i">
				  							<li>
							            		<span class="item">
							              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}模块  <strong>#${action.objectId}</strong>。
							            			<c:if test="${action.histories.size() != 0}"><a id="switchButton${i.index + 2}" class="switch-btn btn-icon" onclick="switchChange(${i.index + 2})" href="javascript:;"><i class="icon- change-show"></i></a></c:if>
							            		</span>
							          			<div class="changes hide alert" id="changeBox${i.index + 2}" style="display: none;">
							          				<c:if test="${action.histories.size() != 0}">
								          				<c:forEach items="${action.histories}" var="history">
						        	  						修改了 <strong><i>${fieldNameMap[history.field]}</i></strong>，旧值为 "${history.oldValue}"，新值为 "${history.newValue}"。<br>
						        						</c:forEach>
					        						</c:if>
					        					</div>
						          			</li>
				  						</c:forEach>
				        			</ol>		
					  			</fieldset>
        					</div>
      					</div>
    				</form>
  				</div>
			</div>
	  	</div>
	</div>	
<script type="text/javascript">
$(function(){
	loadProductModules("${productId}");
})
function loadProductModules(productId, branchId) {
	if(typeof(branchId) == "undefined")
		branchId = 0;
	if(!branchId) 
		branchId = 0;
	$.get("../ajaxGetModules/" + productId + "/" + branchId,function(data){
		if (!$.isEmptyObject(data)) {
			iterateTree(data);
		} else {
		}			
	});
}

function iterateTree(data) {
	var actions;
	var no_list;
	var has_list;
	var childrenLeng;
	var before = function(idStr,content) {
		$(idStr).before(content);
	};
	var append = function(idStr,content) {
		$(idStr).append(content);
	};
	for (var i = 0, l = data.length; i < l; i++) {
		actions = "<div class='tree-actions'><a style='cursor: pointer' class='tree-action' title='编辑' data-show-header='false' data-type='iframe' data-url='./module_edit_${productId}_" + data[i].id + "' data-toggle='modal'><i class='icon icon-edit'></i></a><a data-id='" + data[i].id + "' href='javascript:;' class='tree-action' title='删除' onclick='deleteModule(this)'><i class='icon icon-trash'></i></a></div>";
		no_list = "<li><a href='./module_manage_${productId}_" + data[i].branch_id + "_" + data[i].id + "'>" + data[i].name + "</a>" + actions + "</li>";
		has_list = "<li class='has-list open in'><i class='list-toggle icon'></i><a href='./module_manage_${productId}_" + data[i].branch_id + "_" + data[i].id + "'>" + data[i].name + "</a>" + actions + "<ul id='module" + data[i].id + "'></ul></li>";
		childrenLeng = data[i].children.length;
		if (data[i].parent == 0) {
			if (data[i].branch_id == 0) {
				appendList(childrenLeng,"#branchModules",no_list,has_list,before);
			} else {
				appendList(childrenLeng,"#branch" + data[i].branch_id,no_list,has_list,append);
			}
		} else {
			appendList(childrenLeng,"#module" + data[i].parent,no_list,has_list,append);
		}
		iterateTree(data[i].children);
	}
}
function appendList(childrenLeng,idStr,no_list,has_list,func) {
	if (childrenLeng == 0) {
		func(idStr,no_list);
	} else {
		func(idStr,has_list);
	}
}
function deleteModule(obj) {
	bootbox.confirm("<h4><i class='icon icon-warning-sign' style='color: red'></i>  该模块及其子模块都会被删除，您确定要删除吗？</h4>",function(result){
		if (result === false)
			return true;
		else {
			var id = $(obj).data("id");
			$.ajax({
				type: "DELETE",
				url: "../ajaxDeleteModule/" + id,
				success: function(msg){
					var ul = $(obj).closest("ul");
					var rootLi = ul.closest("li");
					$(obj).closest("li").remove();
					if (ul.has("li").length == 0) {
						rootLi.removeClass("has-list").find(".list-toggle").remove();
					}
					if(id == "${moduleId}") 
						$("#submit").attr("disabled",true);
					$("input[value='" + id + "']").closest("div").remove();
				},
				error: function(XMLHttpRequest) {
					bootbox.alert(XMLHttpRequest.status+"，删除出错！");
				}
			})
		}
	});  
}
function addItem(obj)
{
    var $inputgroup = $(obj).closest('.row-table');
    $inputgroup.after($inputgroup.clone()).next('.row-table').find('input').val('');
}

function deleteItem(obj)
{
    if($(obj).closest('.row-table').parent().find('i.icon-remove').size() <= 1) return;
    $(obj).closest('.row-table').remove();
}
</script>
</body>
</html>