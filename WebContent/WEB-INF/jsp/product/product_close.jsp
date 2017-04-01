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
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<title>关闭产品</title>
</head>
<body>
	<div class="outer">
		<div class="container mw-1400px">
  			<div id="titlebar">
    			<div class="heading">
      				<span class="prefix"><i class="icon-cube"></i> <strong>${productId}</strong></span>
      				<strong>${currentProduct.name}</strong>
      				<small class="text-danger"><i class="icon-off"></i> 关闭</small>
    			</div>
  			</div>
		<div style="position: relative;height: 380px;overflow:auto;">
  			<form id="dataForm" class="form-condensed" method="post" style="margin: 10px 20px;padding: 5px 20px 10px 10px;">
    			<table class="table table-form">
      				<tbody>
      					<tr>
        					<th class="w-80px">备注</th>
        					<td>
        						<textarea name="comment" id="comment" rows="6" class="form-control kindeditor"></textarea>
							</td>
      					</tr>
      					<tr>
        					<td colspan="2" class="text-center"> 
        						<button type="button" id="submitForm" class="btn btn-primary" data-loading="稍候...">保存</button>
        					</td>
     					</tr>
    				</tbody>
    			</table>
  			</form>
  			<div class="main" style="padding: 10px 20px;">
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
		              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}。
		            			<c:if test="${action.histories.size() != 0}"><a id="switchButton${i.index + 2}" class="switch-btn btn-icon" onclick="switchChange(${i.index + 2})" href="javascript:;"><i class="icon- change-show"></i></a></c:if>
		            		</span>
		            		<c:if test="${action.comment != ''}"><div class="history"></c:if>
			          			<div class="changes hide alert" id="changeBox${i.index + 2}" style="display: none;">
			          				<c:if test="${action.histories.size() != 0}">
				          				<c:forEach items="${action.histories}" var="history">
		        	  						修改了 <strong><i>${fieldNameMap[history.field]}</i></strong>，旧值为 "${history.oldValue}"，新值为 "${history.newValue}"。<br>
		        						</c:forEach>
	        						</c:if>
	        					</div>
        						<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
	          				<c:if test="${action.comment != ''}"></div></c:if>
	          			</li>
 						</c:forEach>
       			</ol>		
  			</fieldset>
			</div>
		</div>	
	</div>
	</div>
<script>
var kEditorId = ["comment"];
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
	$("#submitForm").on("click",function(){
		$.post("./product_close_${productId}",$("#dataForm").serialize(),function(){
			window.parent.$.zui.closeModal();
			window.parent.location.reload();
		})
	})
})
</script>	
</body>
</html>