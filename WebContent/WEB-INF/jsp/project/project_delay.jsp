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
    <link href="${ctxResources}/dist/lib/kindeditor/themes/default/default.css" rel="stylesheet"/>
    <script src="${ctxResources}/zui/assets/jquery.js"></script>
    <script src="${ctxResources}/dist/js/zui.min.js"></script>
    <script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
    <script src="${ctxResources}/dist/lib/datetimepicker/datetimepicker.js"></script>
</head>
<body>
	<div id="titlebar">
		<div class="heading">
		    <span class="prefix"><i class="icon-check-sign"></i> <strong>${project.id}</strong></span>
		    <strong><strong class="heading-title">${project.name}</strong>
			</strong>
	    	<small class="text-muted"> 延期</small>
	    	<button type="button" onclick="history.go(0)" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
		</div>
	</div>
	<div id="wrap">
		<div class="outer">
			<form class="form-condensed" method="post" target="hiddenwin">
				<table class="table table-form">
					<tbody>
						<tr>
			        		<th class="w-80px">起始日期</th>
			        		<td class="w-p50">
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
			        		<td></td>
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
					        <th>备注</th>
					        <td colspan="2">
					        <textarea id="content" name="content" class="form-control kindeditor" style="height:150px;"></textarea>
					        </td>
			      		</tr>
			      		<tr>
				        	<th></th>
				        	<td> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></td>
			      		</tr>
			      	</tbody>
			      </table>
			  </form>
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
				        			<c:if test="${i.last && action.comment != ''}"><span class="pull-right comment${action.id}"><a href="javascript:toggleComment(${action.id})" class="btn btn-mini" style="border:none"><i class="icon-pencil"></i></a></span></c:if>
			        				<c:if test="${action.comment != ''}"><div class="article-content comment${action.id}">${action.comment}</div></c:if>
					          		<c:if test="${i.last && action.comment != ''}">
						          	<div class="hide" id="lastCommentBox">
		          						<form method="post" action="./action_editProjectComment_${projectId}_${action.id}">
		            						<table align="center" class="table table-form bd-0">
		              							<tbody>
		              								<tr>
		              									<td style="padding-right: 0">
		              										<textarea name="lastComment" id="lastComment" rows="5" class="form-control">${action.comment}</textarea>
														</td>
													</tr>
		              								<tr>
		              									<td> 
		              										<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button><a href="javascript:toggleComment(${action.id})" class="btn">返回</a>
														</td>
													</tr>
												</tbody>
											</table>
		          						</form>
									</div>
								</c:if>
				          		<c:if test="${action.comment != ''}"></c:if>
				       		</li>
		  				</c:forEach>
		        	</ol>		
				</fieldset>
			</div>
		</div>
	</div>
<script type="text/javascript">

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
</script>
</body>
</html>