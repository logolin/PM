<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chart/chart.min.js"></script>
<style>
.linkbox{height:180px; overflow-y:auto}
.tab-pane .table-borderless {border: 1px solid #ddd!important}
.tab-pane .table-data.table-borderless {border: none!important}
.table-bordered caption {border: 1px solid #ddd;}
.table-bordered tr > th:first-child, .table-bordered tr > td:first-child {border-left: 1px solid #ddd!important}
.table-bordered tr > th:last-child, .table-bordered tr > td:last-child {border-right: 1px solid #ddd!important}
.table-chart tr > td.chart-color {padding-left: 0!important; text-align: center; padding-right: 0!important; color: #f1f1f1}
.chart-wrapper {padding: 10px; background-color: #f1f1f1; border: 1px solid #e5e5e5}
.table-wrapper > .table-bordered > thead > tr:first-child th {border-top: 1px solid #ddd}
</style>
<title>报表</title>
</head>
<body>
	<header id="header">
	  	<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	<div class="outer" style="min-height: 494px">
		<div id="titlebar">
	  		<div class="heading">
		    	<span class="prefix"><i class="icon-lightbulb"></i></span>
		    	<strong><small class="text-muted"><i class="icon-bar-chart"></i></small> 报表</strong>
		  	</div>
		  	<div class="actions">
				<a href="./story_browse_${productId}_${branchId}_${moduleId}_${column}_${columnVal}_id_up_10_1_true" class="btn">返回</a>
		  	</div>
		</div>	
		<div class="row">
  			<div class="col-md-3 col-lg-2">
    			<div class="panel panel-sm">
      				<div class="panel-heading">
        				<strong>请选择报表类型</strong>
      				</div>
      				<div class="panel-body" style="padding-top:0">
        				<form class="form-condensed" method="post">
          					<div class="checkbox">
          						<label>
          							<input type="checkbox" name="charts" value="Product" id="chartsstorysPerProduct"> 
       								产品需求数量
   								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="charts" value="Module_id" id="chartsstorysPerModule"> 
									模块需求数量
								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="charts" value="Source" id="chartsstorysPerSource"> 
									需求来源统计
								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="charts" value="Plan" id="chartsstorysPerPlan"> 
									计划进行统计
								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="charts" value="Status" id="chartsstorysPerStatus"> 
									状态进行统计
								</label>
							</div>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="charts" value="Stage" id="chartsstorysPerStage">
									 所处阶段进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
							 		<input type="checkbox" name="charts" value="Pri" id="chartsstorysPerPri"> 
									 优先级进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
							 		<input type="checkbox" name="charts" value="Estimate" id="chartsstorysPerEstimate"> 
									 预计工时进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
								 	<input type="checkbox" name="charts" value="OpenedBy" id="chartsstorysPerOpenedBy"> 
									 由谁创建来进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
								 	<input type="checkbox" name="charts" value="AssignedTo" id="chartsstorysPerAssignedTo"> 
									 当前指派来进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
								 	<input type="checkbox" name="charts" value="ClosedReason" id="chartsstorysPerClosedReason"> 
									 关闭原因来进行统计
							 	</label>
						 	</div>
						 	<div class="checkbox">
							 	<label>
								 	<input type="checkbox" name="charts" value="Version" id="chartsstorysPerChange"> 
									 变更次数来进行统计
							 	</label>
						 	</div>          
							<input data-checked="true" type="button" name="allchecker" id="allchecker" class="btn btn-select-all btn btn-sm" value="全选" onclick="selectAll(this)">           
							<button type="submit" id="submit" class="btn btn-sm btn-primary" data-loading="稍候...">生成报表</button>        
						</form>
   					</div>
    			</div>
  			</div>
			<div class="col-md-9 col-lg-10">
    			<div class="panel panel-sm">
      				<div class="panel-heading">
        				<strong>报表</strong>
      				</div>
      				<table class="table active-disabled">
                		<tbody>
                			<c:forEach items="${chartTableMap}" var="chartTable">
                			<tr class="text-top">
          						<td>
            						<div class="chart-wrapper text-center">
              							<h5>${chartTitleMap[chartTable.key][0]}</h5>
              							<div class="chart-canvas">
              								<canvas id="${chartTable.key}" width="385" height="108" data-responsive="true" style="width: 385px; height: 108px;"></canvas>
           								</div>
            						</div>
          						</td>
       							<td style="width: 320px">
            						<div style="overflow: auto;max-height: 250px" class="table-wrapper">
              							<table class="table table-condensed table-hover table-striped table-bordered table-chart" data-chart="pie" data-target="#${chartTable.key}" data-animation="true">
                							<thead>
                  								<tr>
                    								<th class="chart-label" colspan="2">${chartTitleMap[chartTable.key][1]}</th>
                    								<th>需求数</th>
                    								<th>百分比</th>
                  								</tr>
                							</thead>
                                			<tbody>
                                				<c:forEach items="${chartTable.value}" var="chart">
	                                				<tr class="text-center" data-id="0">
	                  									<td class="chart-color w-20px">
	                  										<i class="chart-color-dot icon-circle"></i>
	               										</td>
	                  									<td class="chart-label"><c:choose><c:when test="${chartTable.key == 'Plan'}"><c:if test="${chart.key == 0}">未设定</c:if><c:if test="${chart.key != 0}">${planMap[chart.key]}</c:if></c:when><c:when test="${chartTable.key == 'Module_id'}">${moduleMap[chart.key]}</c:when><c:when test="${chartTable.key == 'Estimate'}">${chart.key}</c:when><c:when test="${chartTable.key == 'Pri'}"><c:if test="${chart.key == 0}">未设定</c:if><c:if test="${chart.key != 0}">${chart.key}</c:if></c:when><c:when test="${chartTable.key == 'Version'}">${chart.key - 1}</c:when><c:when test="${chartTable.key == 'Product'}">${chart.key.name}</c:when><c:otherwise>${chartColumnMap[chart.key]}</c:otherwise></c:choose></td>
	                  									<td class="chart-value">${chart.value}</td>
	                  									<td><fmt:formatNumber type="percent" value="${chart.value/size}" /></td>
	                								</tr>
                                				</c:forEach>
                              				</tbody>
                           				</table>
            						</div>
       							</td>
        					</tr>
        					</c:forEach>
              			</tbody>
           			</table>
    			</div>
  			</div>
		</div>			
	</div>
	</div>	
<script>
(function()
{
    var colorIndex = 0;
    function nextAccentColor(idx)
    {
        if(typeof idx === 'undefined') idx = colorIndex++;
        return new $.zui.Color({h: idx * 67 % 360, s: 0.5, l: 0.55});
    }

    jQuery.fn.tableChart = function()
    {
        $(this).each(function()
        {
            var $table    = $(this);
            var options   = $table.data();
            var chartType = options.chart || 'pie';
            var $canvas   = $(options.target);
            if(!$canvas.length) return;
            var chart = null;

            options = $.extend({scaleShowLabels: true, scaleLabel: "<" + "%=label%" + "> :" + " <" + "%=value%" + ">"}, options);
            var data = [];
            var $rows = $table.find('tbody > tr').each(function(idx)
            {
                var $row = $(this);
                var color = nextAccentColor().toCssStr();

                $row.attr('data-id', idx).find('.chart-color-dot').css('color', color);
                data.push({label: $row.find('.chart-label').text(), value: parseInt($row.find('.chart-value').text()), color: color, id: idx});
            });

            if(data.length > 1) options.scaleLabelPlacement = 'outside';
            else if(data.length === 1)
            {
                options.scaleLabelPlacement = 'inside';
                data.push({label: '', value: data[0].value/2000, color: '#fff', showLabel: false})
            }

            chart = $canvas.pieChart(data, options);
            $canvas.on('mousemove', function(e)
            {
                var activePoints = chart.getSegmentsAtEvent(e);
                $rows.removeClass('active');
                if(activePoints.length)
                {
                    $rows.filter('[data-id="' + activePoints[0].id + '"]').addClass('active');
                }
            });

            if(chart !== null) $table.data('zui.chart', chart);
        });
    };

    $(function()
    {
        $('.table-chart').tableChart();
    });
}());
function selectAll(obj)
{ 
	$('input[name="charts"]').prop("checked",$(obj).data("checked")); 
	if ($(obj).data("checked")) {
		$(obj).data("checked", false);
	} else {
		$(obj).data("checked", true);
	}
	
}
$(function(){
    var resizeChartTable = function()
    {
        $('.table-wrapper').each(function()
        {
            var $this = $(this);
            $this.css('max-height', $this.closest('.table').find('.chart-wrapper').outerHeight());
        });
    };
    resizeChartTable();
    fixedTableHead('.table-wrapper');
    $(window).resize(resizeChartTable);
});
function fixedTableHead(a) {
    $(a).scroll(function() {
        var b = $(this).find(".fixedHead").size() > 0;
        if (!b) {
            $(this).css("position", "relative");
            if ($(this).find("table").size() == 1) {
                var d = "<table class='fixedHead' style='position:absolute;top:0px'><thead>" + $(this).find("table thead").html() + "</thead></table>";
                $(this).prepend(d);
                var e = $(this).find("table.fixedHead");
                e.addClass($(this).find("table:last").attr("class"));
                var c = $(this).find("table:last thead th");
                e.find("thead th").each(function(f) {
                    e.find("thead th").eq(f).width(c.eq(f).width())
                })
            }
        }
        $(this).find("table.fixedHead").css("top", $(this).scrollTop())
    })
}
</script>
</body>
</html>