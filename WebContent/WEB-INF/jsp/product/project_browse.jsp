<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
<script src='http://cdn.zentao.net/8.2.4/js/chartjs/chart.line.min.js?v=8.2.4' type='text/javascript'></script>
<style>
.projectline {padding: 2px!important}
</style>
<title>::产品列表</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp"%>
	</header>
	<div id="wrap">
	  <div class="outer" style="min-height: 494px;">
		<div>
		  	<div id="titlebar">
		  		<div class="heading"><i class="icon-folder-close"></i> 项目列表  </div>
	      	</div>
			<table class="table table-condensed table-striped">
			  <thead>
				<tr class="colhead">
			      <th class="w-150px">项目名称</th>
			      <th>项目代号</th>
			      <th>结束日期</th>
			      <th>项目状态</th>
			      <th>总预计</th>
			      <th>总消耗</th>
			      <th>总剩余</th>
			      <th class="w-150px">进度</th>
			      <th class="w-100px">燃尽图</th>
			    </tr>
			  </thead>
			  <tbody>
				 <c:forEach items="${projectList}" var="project">
				<tr class="text-center">
				   	<td class="text-left">
				   		<shiro:hasPermission name="project:view"><a href="../project/project_task_${project.id}_unclosed" target="_parent"></shiro:hasPermission>
				   		${project.name}<shiro:hasPermission name="project:view"></a></shiro:hasPermission>
					</td>
				    <td>${project.code}</td>
				    <td>${project.end}</td>
				    <td class="status-${project.status}">${project.statusStr}</td>
				    <td>${project.estimate}</td>
				    <td>${project.consumed}</td>
				    <td>${project.remain}</td>
				    <td>
						<div class="progress progress-striped active" style="margin-bottom: 0">
						  <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:<c:choose><c:when test="${(project.consumed+project.remain) == 0}">0%</c:when><c:otherwise><fmt:formatNumber type="percent" value="${project.consumed/(project.consumed+project.remain)}" /></c:otherwise></c:choose>">
						    <span style="color: black;text-align: center;"><c:choose><c:when test="${(project.consumed+project.remain) == 0}">0%</c:when><c:otherwise><fmt:formatNumber type="percent" value="${project.consumed/(project.consumed+project.remain)}" /></c:otherwise></c:choose></span>
						  </div>
						</div>
				    </td>
				    <td class="projectline text-left" values="${project.burnStr}">
				   	</td>
				 </tr>	
				 </c:forEach>			 
			  </tbody>
			</table>
		</div>
	  </div>
	</div>
<script>
var isIE = $.zui.browser.isIE();
jQuery.fn.projectLine = function(setting)
{
    var $lines = $(this);
    if(isIE && $.zui.browser.ie < 9 && $lines.length > 10) return;
    
    $lines.each(function()
    {
        var $e = $(this);
        var options = $.extend({values: $e.attr('values')}, $e.data(), setting),
            height = $e.height() - 4,
            values = [],
            maxWidth = $e.width() - 4;
        var strValues = options.values.split(','), maxValue = 0;
        for(var i in strValues)
        {
            var v = parseFloat(strValues[i]);
            if(v != NaN)
            {
                values.push(v);
                maxValue = Math.max(v, maxValue);
            }
        }

        var scaleSteps = Math.min(maxValue, 30);
        var scaleStepWidth = Math.ceil(maxValue/scaleSteps);

        var width = Math.min(maxWidth, Math.max(10, values.length*maxWidth/30));
        var canvas = $e.children('canvas');
        if(!canvas.length)
        {
            $e.append('<canvas class="projectline-canvas"></canvas>');
            canvas = $e.children('canvas');
            if(navigator.userAgent.indexOf("MSIE 8.0")>0) G_vmlCanvasManager.initElement(canvas[0]);
        }
        canvas.attr('width', width).attr('height',height);
        $e.data('projectLineChart',new Chart(canvas[0].getContext("2d")).Line({
            labels : values,
            datasets: [{
                fillColor : "rgba(0,0,255,0.25)",
                strokeColor : "rgba(0,0,255,1)",
                pointColor : "rgba(255,136,0,1)",
                pointStrokeColor : "#fff",
                data : values
            }]
        }, {
            animation: !isIE,
            scaleOverride: true,
            scaleStepWidth: Math.ceil(maxValue/10),
            scaleSteps: 10,
            scaleStartValue: 0
        }));
    });
}

$(function(){$('.projectline').projectLine();});
</script>	
</body>
</html>