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
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<title>关闭STORY::</title>
<script language='Javascript'>
var kEditorId = ["comment"];
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
})
function checkForm() {
	event.preventDefault();
	$.post("./story_close_${productId}_${storyId}",$("#dataForm").serialize(),function(){
		window.parent.$.zui.closeModal();
		window.parent.location.reload();
	})
}
</script>
</head>
<body>
	<div class='outer'>
		<div class='container'>
  			<div id='titlebar'>
    			<div class='heading'>
      				<span class='prefix'><i class='icon-lightbulb'></i> <strong>${storyId}</strong></span>
      				<strong>${storyTitle}</strong>
      				<small>关闭</small>
    			</div>
  			</div>
  			<div style="position: relative;height: 380px;overflow:auto;">
	  			<form id="dataForm" method='post' class='form-condensed' action="" onsubmit="checkForm()" style="margin: 10px 20px;padding: 5px 20px 10px 10px;">
	    			<table class='table table-form'>
	      				<tr>
	        				<th class='w-80px'>关闭原因</th>
	        				<td class='w-p25-f'>
	        					<select name='closedReason' id='closedReason' class=form-control onchange="setStory(this.value)" required>
									<option value='' selected='selected'></option>
									<c:forEach items="${closedReasonMap}" var="closedReason">
										<option value="${closedReason.key}">${closedReason.value}</option>
									</c:forEach>
								</select>
							</td>
							<td></td>
	      				</tr>
	      				<tr id='duplicateStoryBox' style='display:none'>
	        				<th>重复需求</th>
	        				<td>
	        					<input type='text' name='duplicateStory' id='duplicateStory' value='' class=form-control />
							</td>
							<td></td>
	      				</tr>
	      				<tr id='childStoriesBox' style='display:none'>
	        				<th>细分需求</th>
	        				<td>
	        					<input type='text' name='childStories' id='childStories' value='' class=form-control />
							</td>
							<td></td>
						</tr>
				      	<tr>
				        	<th>备注</th>
				        	<td colspan='2'>
				        		<textarea id="comment" name="comment" class="form-control kindeditor" style="height:150px;"></textarea>
							</td>
	      				</tr>
	      				<tr>
	        				<td></td>
	        				<td colspan='2'>
	         					<button type='submit' id='submitForm' class='btn btn-primary'  data-loading='稍候...'>保存</button>                
	       					</td>
	      				</tr>
	    			</table>
	  			</form>
	  			<hr class='small'>
	  			<div class='main' style="padding: 10px 20px;">
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
