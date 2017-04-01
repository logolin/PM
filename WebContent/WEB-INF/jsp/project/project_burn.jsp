<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<script src="${ctxResources}/zui/src/js/Chart.Core.js"></script>
<script src="${ctxResources}/zui/src/js/chart.line.js"></script>
<script src="${ctxResources}/zui/src/js/Chart.Doughnut.js"></script>
<script src="${ctxResources}/zui/src/js/Chart.Bar.js"></script>
<style>
.mgr-5px{margin-right:5px;}
.container {max-width: 950px!important;}
.container .actions {margin-bottom: 10px; padding: 0}
.container .actions > .text {padding: 5px 5px 5px 15px; line-height: 20px}
.mw-220px {max-width: 220px!important}
#wrap h1{font-size:14px;}
#interval{margin-right:10px;}
.canvas-wrapper {padding: 15px; border: 1px solid #ddd;}
.table-chart tr > td.chart-color {padding-left: 0!important; text-align: center; padding-right: 0!important; color: #f1f1f1}
.chart-wrapper {padding: 10px; background-color: #f1f1f1; border: 1px solid #e5e5e5}
.table-wrapper > .table-bordered > thead > tr:first-child th {border-top: 1px solid #ddd}
</style>
<title>${project.name}::燃尽图</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer with-side with-transition" style="min-height: 494px;">
			<%@include file="/WEB-INF/jsp/include/taskhead.jsp" %>
				<div class="container text-center bd-0">
					<div class="clearfix">
				    	<div class="actions pull-right">
							<div class="input-group input-group-sm pull-left w-100px">
				        		<select name="interval" id="interval" class="form-control" onchange="interval(this.value)">
									<option value="full" <c:if test="${days == 'full'}">selected</c:if>>间隔1天</option>
									<option value="2" <c:if test="${days == '2'}">selected</c:if>>间隔2天</option>
									<option value="3" <c:if test="${days == '3'}">selected</c:if>>间隔3天</option>
									<option value="4" <c:if test="${days == '4'}">selected</c:if>>间隔4天</option>
									<option value="5" <c:if test="${days == '5'}">selected</c:if>>间隔5天</option>
									<option value="6" <c:if test="${days == '6'}">selected</c:if>>间隔6天</option>
									<option value="7" <c:if test="${days == '7'}">selected</c:if>>间隔7天</option>
									<option value="8" <c:if test="${days == '8'}">selected</c:if>>间隔8天</option>
									<option value="9" <c:if test="${days == '9'}">selected</c:if>>间隔9天</option>
									<option value="10" <c:if test="${days == '10'}">selected</c:if>>间隔10天</option>
								</select>
							</div>
							<c:choose>
								<c:when test="${weekend == 'noweekend'}"><a href="./project_burn_${projectId}_withweekend_${days}" class="btn btn-sm">显示周末</a></c:when>
								<c:otherwise><a href="./project_burn_${projectId}_noweekend_${days}" class="btn btn-sm">去除周末</a></c:otherwise>
							</c:choose>
							<a type="button" class="btn btn-sm iframe" data-toggle="modal" data-target="#myModal">修改首天工时</a>
							<a href="" title="更新燃尽图" class="btn btn-primary btn-sm" onclick="history(0)" id="computeBurn" target="hiddenwin">更新</a>
				    	</div>
				  	</div>
					<div class="canvas-wrapper">
						<div class="chart-canvas">
							<canvas id="burnChart" width="836" height="418" data-bezier-curve="false" data-responsive="true" style="width: 836px; height: 418px;"></canvas>
						</div>
					</div>
				  <h1>${project.name} 燃尽图</h1>
				</div>
		</div>
	</div>
<!-- 对话框HTML -->
<div class="modal fade" id="myModal">
	<div class="modal-dialog modal-iframe" style="width: 500px; margin-top: 134px;">
		<div class="modal-content">
			<div class="modal-header"><button class="close" data-dismiss="modal">×</button>
			<h4 class="modal-title"><i class="icon-file-text"></i> 修改首天工时</h4>
			</div>
			<div class="modal-body" style="height: 110px;">
				<form target="_parent" method="post" action="./burn_editFirstHours_${projectId}_${weekend}_${days}" id="updateHours" style="padding:20px 40px">
				<table class="table table-form">
					<tbody>
						<tr>
							<td>
								<div class="input-group">
									<span class="input-group-addon">${burnList.get(0).id.date}</span>
									<input type="text" name="remain" id="left" value=<fmt:formatNumber type="number" value="${burnList.get(0).remain}" /> class="form-control" placeholder="项目开始时的总预计工时">
									<span class="input-group-btn"> <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button></span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				</form>
			</div>
		</div>
	</div>
</div>
<script>
$(function() {
	//初始化燃尽图数据
    initBurnChar();
    $('#burnTab').addClass('active');
})

function interval(interval) {
	location.href = "${ctxpj}/project_burn_${projectId}_${weekend}_" + interval;
}
function initBurnChar(){
	//燃尽图数据
	var burnRemain = new Array();
	<c:forEach items="${burnList}" var="burn" varStatus="i">
	burnRemain["${i.index}"] = "${burn.remain}";
	</c:forEach>
	
	//是否显示周末
	var isweekend = "${weekend}";
	//间隔天数
	var daynum = "${days}";
	//begin字符串
	var begin1 = "${project.begin}";
	var begin = new Date(begin1);
	//end字符串
	var end1 = "${project.end}";
	var end = new Date(end1);
	//总天数
	var days = (end - begin) / (24*1000*60*60) + 1;
	//周末数
	var weekEnds = 0;
	//计算begin-end所有日期
	var ab = begin1.split("-");
	var ae = end1.split("-");
	//begin日期
	var db = new Date();
	db.setUTCFullYear(ab[0], ab[1]-1, ab[2]);
	//end日期
	var de = new Date();
	de.setUTCFullYear(ae[0], ae[1]-1, ae[2]);
	var unixDb=db.getTime();
	var unixDe=de.getTime();
	
	//X轴数组
	var arrDays = new Array();

	//根据是否显示周末来计算days(去除周末)
	if(isweekend === "noweekend") {
		for(var k=unixDb, i = 0, j = 0; i < days; i++) {
			if(begin.getDay() == 0 || begin.getDay() == 6) {
				weekEnds++;
					
		    	} else {
		    	//X轴数组
				var da = (new Date(parseInt(k))).format();
			    var date = da.split("-");
			    arrDays[j] = date[2] + "\/" + date[1];
			   	j++;
		     }
			k=k+24*60*60*1000;
		    begin = begin.valueOf();
		   	begin += 1000 * 60 * 60 * 24;
		   	begin = new Date(begin);
		}
		//去除周末后的天数
		days = days - weekEnds;
	} else {
		for(var k=unixDb, i = 0; i < days; i++) {
		
	    	//X轴数组
			var da = (new Date(parseInt(k))).format();
		    var date = da.split("-");
		    arrDays[i] = date[2] + "\/" + date[1];
	     
			k=k+24*60*60*1000;
		    begin = begin.valueOf();
		   	begin += 1000 * 60 * 60 * 24;
		   	begin = new Date(begin);
		}
	}
	
	//首日工时
	var remain = ${burnList.get(0).remain};
	//每个间隔相差的工时
	var remainPercent = remain / (days - 1);
	//Y轴数组
	var arrRemain = new Array();
	console.log("y天数"+days)
	for(var i = 0; i < days; i++) {
		//判断首日工时
		if(remain != 0) {
			arrRemain[i] = remain - remainPercent * i;
		} else {
			arrRemain[i] = 0;
		}
	}
	
	//间隔天数（新数组）
	var intervalXarr = new Array();
	//间隔剩余（新数组，基准线）
	var intervalYarr = new Array();
	//间隔燃尽图剩余（新数组）
	var intervalBurn = new Array();
	console.log(days);
	//间隔天数
	if(daynum !=="full") {
		daynum = parseInt(daynum);
		if(isNaN(daynum) || daynum == 0) {
			daynum = parseInt(days / 25);
			if(daynum == 0) {
				daynum = 1;
			}
			console.log("daynum:" + daynum);
		}
		//间隔大小
		var interval = days / daynum;
		interval = parseInt(interval);
		
		console.log("interval:"+interval);
		//间隔的日期（x轴数组）
		intervalXarr[0] = arrDays[0];
		//有间隔天数的y轴数组
		intervalYarr[0] = arrRemain[0];
		//间隔燃尽图剩余
		intervalBurn[0] = burnRemain[0];
		for(var i = 1; i < interval; i++) {
			//根据间隔天数来获取X轴数组
			intervalXarr[i] = arrDays[i*daynum];
			//获取Y轴数据
			intervalYarr[i] = arrRemain[i*daynum];
			//
			if(i*daynum <= burnRemain.length) {
				//获取燃尽图剩余天数
				intervalBurn[i] = burnRemain[i*daynum];
			}
		}
		if(daynum !== 1) {
			intervalXarr[interval] = arrDays[days-1];
			intervalYarr[interval] = arrRemain[days-1];
		}
	}
	
	//描绘燃尽图
    var data =
    {
        labels:daynum === "full"?arrDays:intervalXarr,
        datasets: [
        {
            label: "基准线",
            color: "#CCC",
            pointStrokeColor: '#FFFFFF',
            pointHighlightStroke: '0033CC',
            showTooltips: false,
			data:daynum === "full"?arrRemain:intervalYarr,
        },
        {
            label: "剩余",
            color: "#0033CC",
            fillColor: "rgba(220,220,220,0.2)",
            //线条颜色
            strokeColor: "#0033CC",
            pointColor: "rgba(220,220,220,1)",
            pointHighlightFill: "#fff",
            pointStrokeColor: '#0033CC',
            pointHighlightStroke: '0033CC',
            data:daynum === "full"?burnRemain:intervalBurn,
        }]
    };

    var options = {
    		
            animation: !($.zui.browser && $.zui.browser.ie === 8),
            pointDotStrokeWidth: 0,
            pointDotRadius: 1,
            datasetFill: false,
            datasetStroke: true,
            scaleShowBeyondLine: false,
          ///Boolean - 是否在图表上显示网格
            scaleShowGridLines : true,

            //String - 网格线条颜色
            scaleGridLineColor : "rgba(0,0,0,.05)",

            //Number - 网格宽度
            scaleGridLineWidth : 1,

            //Boolean - 是否显示水平坐标，即X轴
            scaleShowHorizontalLines: true,

            //Boolean - 是否显示垂直坐标，即Y轴
            scaleShowVerticalLines: true,

          //Boolean - 是否显示为平滑曲线
            bezierCurve : false,

            //Number - 检测鼠标点击所使用依据的半径大小，单位像素
            pointHitDetectionRadius : 20,

            //Boolean - 是否
            datasetStroke : true,

            //Number - 数据集线条宽度，单位为像素
            datasetStrokeWidth : 2,


        }
    var burnChart = $("#burnChart").lineChart(data, options);
}

</script>
<script type="text/javascript">

Date.prototype.format=function (){
	var s='';
	s+=this.getFullYear()+'-';// 获取年份。
	s+=(this.getMonth()+1)+"-";         // 获取月份。
	s+= this.getDate();                 // 获取日。
	return(s);                          // 返回日期。
};

</script>
</body>
</html>