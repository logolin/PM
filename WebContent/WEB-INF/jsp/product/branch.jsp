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
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<style>
#branches .input-group{
	margin-bottom:5px; width:100%
}
</style>
<title><c:if test="${currentProduct.type == 'platform'}">平台</c:if><c:if test="${currentProduct.type == 'branch'}">分支</c:if>分支管理</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
  		<div class="outer" style="min-height: 494px;">
			<div class="container mw-900px">
		  		<div id="titlebar">
		  			<c:set var="c" value="${(c+0).intValue()}"/>
		    		<div class="heading"><strong>${branchMap[c]}管理</strong></div>
		  		</div>
		  		<div class="row">
		  			<div class="col-sm-6">
		  				<div class="panel-body">
				  		<form method="post">
					  		<table class="table table-form">
								<tbody>
									<tr>
							  			<td class="w-50px"></td>
							  			<td class="w-300px">
							    			<div id="branches">
							    				<c:forEach items="${branchMap}" var="branch">
							    					<c:if test="${branch.key != 0}">		
								    				<div class='input-group'>
								    					<input type='text' name="branch[${branch.key}]" id="branch[${branch.key}]" value='${branch.value}' class='form-control' />
													</div>
													</c:if>	
												</c:forEach>
							      				<div class="input-group">
							        				<input type="text" name="newbranch[]" id="newbranch[]" value="" class="form-control">
							         				<span class="input-group-addon"><a href="javascript:;" onclick="addItem()"><i class="icon icon-plus"></i></a></span>
							      					<span class="input-group-addon"><a href="javascript:;" onclick="deleteItem(this)"><i class="icon icon-remove"></i></a></span>
							      				</div>
							      				<div class="input-group">
							        				<input type="text" name="newbranch[]" id="newbranch[]" value="" class="form-control">
							         				<span class="input-group-addon"><a href="javascript:;" onclick="addItem()"><i class="icon icon-plus"></i></a></span>
							      					<span class="input-group-addon"><a href="javascript:;" onclick="deleteItem(this)"><i class="icon icon-remove"></i></a></span>
							      				</div>					      				
							    			</div>
							   			</td>
							  			<td></td>
									</tr>
									<tr>
							  			<td></td>
							  			<td> 
							  				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button> 
							  			</td>
							  			<td></td>
									</tr>
								</tbody>
					  		</table>
				  		</form>
				  		</div>
			  		</div>
			  		<div class="col-sm-6">
			  			<div class="panel-body">
		      				<%@ include file="/WEB-INF/jsp/include/history.jsp"%> 
						  	<fieldset id="actionbox" class="actionbox">
				    			<legend>
				      				<i class="icon-time"></i>历史记录    
				      				<a class="btn-icon" href="javascript:;" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
				      				<a class="btn-icon" href="javascript:;" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
				    			</legend>
			  					<ol id="historyItem">
			  						<c:forEach items="${actionList}" var="action" varStatus="i">
			  							<li>
						            		<span class="item">
						              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}  ${branchMap[c]}<strong>#${action.objectId}</strong>。
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
		  		</div>
			</div>
	  	</div>
	</div>
<script type="text/javascript">
function addItem()
{
    var $inputgroup = $('#branches .input-group:last');
    $('#branches').append($inputgroup.clone()).find('.input-group:last').find('input').val('');
}

function deleteItem(obj)
{
    if($(obj).closest('#branches').find("input[id^='newbranch']").size() <= 1) return;
    $(obj).closest('.input-group').remove();
}	
</script>
</body>
</html>