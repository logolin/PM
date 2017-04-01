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
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<title>激活STORY::${currentProduct.name}</title>
</head>
<body>
	<div class='outer'>
		<div class='container'>
  			<div id='titlebar'>
    			<div class='heading'>
      				<span class='prefix'><i class='icon-lightbulb'></i> <strong>${storyId}</strong></span>
      				<strong>${storyTitle}</strong>
      				<small>激活</small>
    			</div>
  			</div>
  			<div style="position: relative;height: 380px;overflow:auto;">
	  			<form id="dataForm" method='post' class='form-condensed' style="margin: 10px 20px;padding: 5px 20px 10px 10px;">
	    			<table class='table table-form'>
						<tr>
	      					<th class='w-80px'>指派给</th>
	      					<td class='w-p45'>
	      						<select name='assignedTo' id='assignedTo' class="form-control chosen">
									<option value=''></option>
									<c:forEach items="${userMap}" var="user">
										<option value='${user.key}'>${fn:toUpperCase(fn:substring(user.key,0,1))}:${user.value}</option>
									</c:forEach>
									<option value="closed">Closed</option>
								</select>
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
	         					<button type='button' id='submitForm' class='btn btn-success'  data-loading='稍候...'><i class='icon-off'></i> 激活</button>                
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
var kEditorId = ["comment"];
var fold   = '-';
var unfold = '+';
$(function(){
	<%@ include file="/WEB-INF/jsp/include/kindeditor.jsp"%> 
	$("#submitForm").on("click",function(){
		$.post("./story_activate_${productId}_${storyId}",$("#dataForm").serialize(),function(){
			window.parent.$.zui.closeModal();
			window.parent.location.reload();
		})
	});
	$("#assignedTo").chosen({
	    no_results_text: '没有找到',    
	    search_contains: true,      
	    allow_single_deselect: true,
	    width: '100%'
	});
})
function switchChange(historyID)
{
    $swbtn = $('#switchButton' + historyID);
    $showTag = $swbtn.find('.change-show');
    if($showTag.length)
    {
        $swbtn.closest('li').addClass('show-changes');
        $showTag.removeClass('change-show').addClass('change-hide');
        $('#changeBox' + historyID).show();
        $('#changeBox' + historyID).prev('.changeDiff').show();
    }
    else
    {
        $swbtn.closest('li').removeClass('show-changes');
        $swbtn.find('.change-hide').removeClass('change-hide').addClass('change-show');
        $('#changeBox' + historyID).hide();
        $('#changeBox' + historyID).prev('.changeDiff').hide();
    }
}

function toggleShow(obj)
{
    $showTag = $(obj).find('.change-show');
    if($showTag.length)
    {
        $showTag.removeClass('change-show').addClass('change-hide');
        $('#historyItem > li:not(.show-changes) .switch-btn').click();
    }
    else
    {
        $(obj).find('.change-hide').removeClass('change-hide').addClass('change-show');
        $('#historyItem > li.show-changes .switch-btn').click();
    }
}

function toggleOrder(obj)
{
    var $orderTag = $(obj).find('.log-asc');
    if($orderTag.length)
    {
        $orderTag.attr('class', 'icon- log-desc');
    }
    else
    {
        $(obj).find('.log-desc').attr('class', 'icon- log-asc');
    }
    $("#historyItem li").reverseOrder();
}

function toggleComment(actionID)
{
    $('.comment' + actionID).toggle();
    $('#lastCommentBox').toggle();
    $('.ke-container').css('width', '100%');
}
(function($) {
	$.fn.reverseOrder = function() {
		return this.each(function() {
 			$(this).prependTo( $(this).parent() );
 		});
	};
})(jQuery);
</script>
</body>
</html>
