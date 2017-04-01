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
<link href="../resources/dist/lib/datetimepicker/datetimepicker.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/dist/lib/datetimepicker/datetimepicker.min.js"></script>
<style>
.linkbox{height:180px; overflow-y:auto}
.tab-pane .table-borderless {border: 1px solid #ddd!important}
.tab-pane .table-data.table-borderless {border: none!important}
#assignedTo_chosen a>div>b {
	margin-top: 9px;
}
</style>
<script type="text/javascript">
var defaultChosenOptions = {no_results_text: '没有匹配结果', width:'100%', allow_single_deselect: true, disable_search_threshold: 1, placeholder_text_single: ' ', placeholder_text_multiple: ' ', search_contains: true};
var kEditorId = ["comment"];
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
	$('select.chosen-select').chosen(defaultChosenOptions);	
	$("#reviewedBy").chosen(defaultChosenOptions);
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
</script>
<title>审查</title>
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
   					<strong><a href="./story_view_${story.product.id}_${story.id}_${story.version}">${story.title}</a></strong>
      				<small><i class="icon-search"></i> 评审</small>
    			</div>
			</div>
			<form:form modelAttribute="story" method="post" class="form-condensed">
   				<table class="table table-form">
       				<tbody>
       					<tr>
       						<th class="w-80px">评审时间</th>
       						<td class="w-p25-f">
   								<input type="text" name="reviewedDate" id="reviewedDate" class="form-control form-date" required/>
							</td>
							<td></td>
       					</tr>
       					<tr>
       						<th>评审结果</th>
       						<td>
       							<select name="result" id="result" class="form-control" onchange="switchShow(this.value)" required>
									<option value="" selected="selected"></option>
									<option value="pass">确认通过</option>
									<option value="clarify">有待明确</option>
									<c:choose>
										<c:when test="${story.status == 'changed' || (story.status == 'draft' && story.version > 1)}">
											<option value='revert'>撤销变更</option>
										</c:when>
										<c:otherwise>
											<option value="reject">拒绝</option>
										</c:otherwise>
									</c:choose>
								</select>
								<form:input type="hidden" path="status"/>
							</td>
							<td></td>
       					</tr>
       					<tr id="rejectedReasonBox" class="hide">
			          		<th>拒绝原因</th>
			          		<td>
       							<select name="closedReason" id="closedReason" class="form-control" onchange="setStory(this.value)">
									<option value="" selected="selected"></option>
									<c:forEach items="${closedReasonMap}" var="closedReason">
										<option value="${closedReason.key}">${closedReason.value}</option>
									</c:forEach>
								</select>
							</td>
							<td></td>
       					</tr>
       					<tr id="duplicateStoryBox" class="hide">
       						<th>重复需求</th>
       						<td>
       							<input type="text" name="duplicateStory" id="duplicateStory" value="" class="form-control">
							</td>
							<td></td>
       					</tr>
   						<tr id="childStoriesBox" class="hide">
       						<th>细分需求</th>
       						<td>
       							<input type="text" name="childStories" id="childStories" value="" class="form-control">
							</td>
							<td></td>
   						</tr>
	   					<c:if test="${story.status == 'changed' || (story.status == 'draft' && story.version > 1)}">
                		<tr id='preVersionBox' class='hide'>
          					<th>之前版本</th>
          					<td colspan='2'>
          						<c:forEach begin="1" end="${story.version - 1}" step="1" var="i">
          							<c:set var="num" value="${story.version - i}"/>
          							<label class='radio-inline'><input type='radio' name='preVersion' <c:if test="${i == 1}">checked</c:if> value='${num}' id='preVersion${num}' /> ${num}</label>
          						</c:forEach>
          					</td>
        				</tr>   
        				</c:if>						
               			<tr>
       						<th>指派给</th>
       						<td>
       							<div class="required required-wrapper"></div>
       							<select name="assignedTo" id="assignedTo" class="form-control chosen-select">
									<c:forEach items="${userMap}" var="user">
			          					<option value="${user.key}" <c:if test="${empty story.lastEditedBy ? user.key == story.openedBy : user.key == story.lastEditedBy}">selected</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>
								</select>
							</td>
							<td style="padding-left: 15px;"></td>
       					</tr>
       					<tr>
       						<th>由谁评审</th>
       						<td colspan="2">
       							<div class="required required-wrapper"></div>
       							<select name="reviewedBy" id="reviewedBy" class="form-control chosen-select" multiple="" data-placeholder="选择要发信通知的用户...">
									<option value=""></option>
									<c:set var="reviewedBy" value=",${story.reviewedBy}," />
	          						<c:forEach items="${userMap}" var="user">
	          							<c:set var="c" value=",${user.key}," />
			          					<option value="${user.key}" <c:if test="${fn:contains(reviewedBy,c)}">selected</c:if>>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
			          				</c:forEach>
								</select>
							</td>
       					</tr>
       					<tr>
       						<th>备注</th>
       						<td colspan="2">
       							<textarea name="comment" id="comment" rows="8" class="form-control"></textarea>
							</td>
       					</tr>
						<%@ include file="/WEB-INF/jsp/include/checkeffect.jsp"%>
       					<tr>
       						<td></td>
       						<td colspan="2">
       							<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>           
       							<button type="button" class="btn btn-default" onclick="javascript:history.go(-1)">返回</button>          
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
function switchShow(result)
{
    if(result == 'reject')
    {
    	$("#status").val("closed");
        $('#rejectedReasonBox').show();
        $('#preVersionBox').hide();
    }
    else if(result == 'revert')
    {
    	$("#status").val("active");
        $('#preVersionBox').show();
        $('#rejectedReasonBox').hide();
        $('#duplicateStoryBox').hide();
        $('#childStoriesBox').hide();
    }
    else  
    {
    	if (result == "pass") 
			$("#status").val("active");
    	if (result == "clarify")
    		$("#status").val()
        $('#preVersionBox').hide();
        $('#rejectedReasonBox').hide();
        $('#duplicateStoryBox').hide();
        $('#childStoriesBox').hide();
        $('#rejectedReasonBox').hide();
    }
}

function setStory(reason)
{
    if(reason == 'duplicate')
    {
    	$("#childStories").val("");
        $('#duplicateStoryBox').show();
        $('#childStoriesBox').hide();
    }
    else if(reason == 'subdivided')
    {
    	$("#duplicateStory").val(0);
        $('#duplicateStoryBox').hide();
        $('#childStoriesBox').show();
    }
    else
    {
    	$("#childStories").val("");
    	$("#duplicateStory").val(0);
        $('#duplicateStoryBox').hide();
        $('#childStoriesBox').hide();
    }
}

</script>			
</body>
</html>