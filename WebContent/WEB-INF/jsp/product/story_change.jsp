<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    
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
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<style>
.linkbox{height:180px; overflow-y:auto}
.tab-pane .table-borderless {border: 1px solid #ddd!important}
.tab-pane .table-data.table-borderless {border: none!important}
#assignedTo_chosen a>div>b {
	margin-top: 9px;
}
.btn-block {
	height: 30px;
}
</style>
<title>变更STORY::${story.title}</title>
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
      				<span class="prefix"><i class="icon-lightbulb"></i> <strong>${story.id}</strong></span>
   					<strong><a href="./story_view_${story.product.id}_${story.id}_0">${story.title}</a></strong>
      				<small><i class="icon-search"></i> 变更</small>
    			</div>
			</div>
			<form:form modelAttribute="story" method="post" enctype="multipart/form-data" class="form-condensed">
    			<table class="table table-form">
      				<tbody>
      					<tr>
        					<th class="w-80px">由谁评审</th>
        					<td>
          						<div class="input-group w-p35-f">
	            					<form:select path="assignedTo" id="assignedTo" class="form-control chosen-select">
										<form:option value="" label=""/>
		          						<c:forEach items="${userMap}" var="user">
				          					<form:option value="${user.key}">${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</form:option>
				          				</c:forEach>
									</form:select>            
									<span class="input-group-addon">
										<label class="checkbox-inline">
											<input type="checkbox" name="needNotReview[]" value="0" id="needNotReview">
									 		不需要评审
									 	</label>
									</span>
          						</div>
        					</td>
      					</tr>
      					<tr>
        					<th>需求名称</th>
        					<td>
        						<div class="required required-wrapper"></div>
        						<form:input path="title" id="title" class="form-control"/>
							</td>
      					</tr>
     		 			<tr>
        					<th>需求描述</th>
        					<td>
        						<textarea name="spec" id="spec" rows="8" class="form-control">${storySpec.spec}</textarea>
								<span class="help-block">建议参考的模板：作为一名&lt;<i class="text-important">某种类型的用户</i>&gt;，我希望&lt;<i class="text-important">达成某些目的</i>&gt;，这样可以&lt;<i class="text-important">开发的价值</i>&gt;。</span>
							</td>
      					</tr>
      					<tr>
        					<th>验收标准</th>
        					<td>
        						<textarea name="verify" id="verify" rows="6" class="form-control">${storySpec.verify}</textarea>
							</td>
      					</tr>
      					<tr>
        					<th>备注</th>
        					<td>
        						<textarea name="comment" id="comment" rows="5" class="form-control"></textarea>
							</td>
      					</tr>
      					<tr>
        					<th>附件</th>
        					<td>
        						<%@ include file="/WEB-INF/jsp/include/file.jsp"%>
        					</td>
      					</tr>
 						<%@ include file="/WEB-INF/jsp/include/checkeffect.jsp"%>
      					<tr>
        					<td></td>
        					<td class="text-center">
 								<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button> 
 								<button type="button" class="btn btn-default" onclick="">返回</button>        
							</td>
      					</tr>
    				</tbody>
   				</table>
  			</form:form>
  			<hr class="small">
  			<div class="main">
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
		              			${action.date}, 由 <strong>${userMap[action.actor]}</strong> ${actionMap[action.action]}
		              			<c:if test="${action.action == 'linkplan'}">
		              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
		              				<c:if test="${fn:startsWith(a,',')}">
		              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
		              				</c:if>
		              				<a href="./plan_view_${productId}_${a}">#${a}</a>。
		              			</c:if>
		              			<c:if test="${action.action == 'linkstories'}">
		              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
		              				<c:if test="${fn:startsWith(a,',')}">
		              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
		              				</c:if>
		              				#${a}。
		              			</c:if>
		              			<c:if test="${action.action == 'childstories'}">
		              				<c:set var="a" value="${fn:substringAfter(action.histories[0].newValue,action.histories[0].oldValue)}"/>
		              				<c:if test="${fn:startsWith(a,',')}">
		              					<c:set var="a" value="${fn:substring(a,1,a.length())}"/>
		              				</c:if>
		              				#${a}。
		              			</c:if>
		              			<c:if test="${action.action == 'close'}">，原因为 <strong>${closedReasonMap[action.histories[1].newValue]}</strong></c:if>			              			
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
<script language='Javascript'>
var kEditorId = ["spec","verify","comment"];
$(function(){
	$('select.chosen-select').chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
});
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
})

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
})

</script>		
</body>
</html>