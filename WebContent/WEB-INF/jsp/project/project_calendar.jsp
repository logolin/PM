<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/dist/lib/calendar/zui.calendar.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/jquery-1.12.4.min.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/calendar/zui.calendar.min.js"></script>

<script type="text/javascript">
		$(document).ready(function(){
			$('#calendar').calendar();
		});
</script>
<title>看板</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
	  <div class="outer with-side with-transition" style="min-height: 494px;">
		
		<div class="modal fade" id="showModuleModal" tabindex="-1" role="dialog" aria-hidden="true">
		  <div class="modal-dialog w-600px">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		        <h4 class="modal-title"><i class="icon-cog"></i> 列表页是否显示模块名</h4>
		      </div>
		      <div class="modal-body">
		        <form class="form-condensed" method="post" target="hiddenwin" action="">
		          <p>
		            <span><label class="radio-inline">
		            <input type="radio" name="showModule" value="0" checked="checked" id="showModule0"> 不显示</label>
		            <label class="radio-inline">
		            <input type="radio" name="showModule" value="base" id="showModulebase"> 只显示一级模块</label>
		            <label class="radio-inline">
		            <input type="radio" name="showModule" value="end" id="showModuleend"> 只显示最后一级模块</label></span>
		            <button type="button" id="setShowModule" class="btn btn-primary">保存</button>
		          </p>
		        </form>
		      </div>
		    </div>
		  </div>
		</div>
		<script language="Javascript">browseType = "unclosed";</script>
		<div id="featurebar">
		  <ul class="nav">
		     <li>
		      <div class="label-angle">
		        所有模块      </div>
		    </li>
            <li class="active"><a href="#">未关闭</a>
			</li>
            <li><a href="#">所有</a>
			</li>
            <li><a href="#">已延期</a>
			</li>
            <li><a href="#">需求变动</a>
			</li>
            <li><a href="#">更多<span class="caret"></span></a>
			</li>
		    <li><a href="#">日历</a>
			</li>
		    <li><a href="#">看板</a>
			</li>
		    <li><a href="#">甘特图</a>
			</li>
		    <li><a href="#">燃尽图</a>
			</li>
		    <li><a href="shuzhuangtu.jsp">树状图</a>
			</li>
		    <li><a href="#">分组查看<span class="caret"></span></a>
			</li>
			<li><a href="#"><i class="icon-search icon"></i>搜索</a>
			</li>
		  </ul>
		  <div class="actions">
		    <div class="btn-group">
		      <div class="btn-group">
		      </div>
		      <a href="#" class="btn create-story-btn"><i class="icon-common-report icon-bar-chart"></i>报表</a>
		        <a href="#" class="btn create-story-btn"><i class="icon-download-alt">导出</i> </a>
		        <a href="#" class="btn "><i class="icon-upload-alt"></i>导入</a>
		        <a href="#" class="btn "><i class="icon-task-batchCreate icon-plus-sign"></i>批量添加</a>
		        <a href="#" class="btn "><i class="icon-task-create icon-sitemap"></i>建任务</a>
		    </div>
		  </div>
		  <div id="querybox" class=""></div>
		</div>
		<div>
		<div id="calendar" class="calendar"></div>
		</div>
</div>
</body>
</html>