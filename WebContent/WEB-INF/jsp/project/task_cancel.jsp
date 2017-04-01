<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<% String canceled = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<script src="${ctxResources}/dist/lib/kindeditor/kindeditor.min.js"></script>
<script src="${ctxResources}/dist/js/color.js"></script>
</head>
<body>
	<div id="titlebar">
	  <div class="heading">
	    <span class="prefix"><i class="icon-check-sign"></i> <strong>${task.id}</strong></span>
	    <strong><strong class="heading-title" style="color: ${task.color}">${task.name}</strong>
	</strong>
	    <small class="text-muted"> 取消</small>
	    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">关闭</span></button>
	  </div>
	  
	</div>
	<div id="wrap">
		<div class="outer" style="min-height: ;">
			<form class='form-condensed' method='post' target='_parent'>
			  <table class='table table-form'>
			    <tr>
			      <th>备注</th>
			      <td>
			      	<div class="form-group">
						<textarea name="comment" class="form-control kindeditor " style="height:150px;"></textarea>
					</div>
					<input type="hidden" name="canceledBy" value="${currentUser.account}" />
					<input type="hidden" name="canceledDate" value="<%=canceled %>" />
			      </td>
			    </tr>
			    <tr>
			      <th></th><td> <button type='submit' id='submit' class='btn btn-primary'  data-loading='稍候...'>关闭</button></td>
			    </tr>
			  </table>
			</form>
			<div class="main" style="position: relative; height: 380px; overflow:auto;">
				<fieldset id="actionbox" class="actionbox">
				    <legend>
				      <i class="icon-time"></i>历史记录    
				      <a class="btn-icon" onclick="toggleOrder(this)"> <span title="切换顺序" class="log-asc icon-"></span></a>
				      <a class="btn-icon" onclick="toggleShow(this);"><span title="切换显示" class="change-show icon-"></span></a>
				    </legend>
			  		<ol id="historyItem">
			          <li value="1">
			            <span class="item">
			              2016-07-08 16:38:19, 由 <strong>Demo</strong> 创建。
			            </span>
			          </li>
			          <li value="2" class="">
			            <span class="item">
			        	  2016-07-08 17:41:10, 由 <strong>Demo</strong> 编辑。
			        	  <a id="switchButton3" class="switch-btn btn-icon" onclick="switchChange(3)" href="javascript:;"><i class="icon- change-show"></i></a>      
			        	</span>
			            <div class="changes hide alert" id="changeBox3" style="display: none;">
			        	  修改了 <strong><i>color</i></strong>，旧值为 ""，新值为 "#00bcd4"。<br>
			        	</div>
			          </li>
			        </ol>		
				  </fieldset>
			</div>
		  </div>
		</div>
</body>
</html>