<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/zui/assets/kindeditor/themes/default/default.css" rel="stylesheet"/>
<link href="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/assets/kindeditor/kindeditor-min.js"></script>
<script src="../resources/zui/dist/lib/datetimepicker/datetimepicker.min.js"></script>
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
</script>
<title>${currentProduct.name}::<c:if test="${operate == 'create'}">创建</c:if><c:if test="${operate == 'edit'}">编辑</c:if>计划</title>
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
      				<span class="prefix"><i class="icon-flag"></i></span>
      				<c:choose>
      					<c:when test="${operate == 'create'}">
  				    		<strong><small class="text-muted"><i class="icon icon-plus"></i></small> 创建计划</strong>
						</c:when>
						<c:otherwise>
							<strong><a href="./plan_view_${plan.id}">自己计划</a></strong>
							<small><i class="icon-pencil"></i> 编辑计划</small>
     					</c:otherwise>
      				</c:choose>
    			</div>
  			</div>	
  			<form class="form-condensed" method="post" id="plan">
    			<table class="table table-form"> 
      				<tbody>
      					<tr>
        					<th class="w-80px">产品</th>
        					<td class="w-p25-f">${currentProduct.name}</td>
        					<td></td>
      					</tr>
						<tr <c:if test="${currentProduct.type == 'normal'}">class="hidden"</c:if>>
							<c:set var="c" value="${(c+0).intValue()}"/>
        					<th>所属${branchMap[c]}
        					</th>
       						<td>
       							<select name="branch_id" id="branch_id" class="form-control">
									<c:forEach items="${branchMap}" var="branch">
										<option value="${branch.key}" <c:if test="${branch.key == plan.branch_id}">selected</c:if>><c:if test="${branch.key == 0}">所有</c:if>${branch.value}</option>
									</c:forEach>
								</select>
							</td>
    					</tr>      					
            			<tr>
        					<th>名称</th>
        					<td>
        						<div class="required required-wrapper"></div>
        						<input type="text" name="title" id="title" value="${plan.title}" class="form-control" required>
							</td>
      					</tr>
      					<tr>
        					<th>开始日期</th>
        					<td>
        						<div class="required required-wrapper"></div>
        						<input type="text" name="begin" id="begin" value="${plan.begin}" class="form-control form-date" required>
							</td>
      					</tr>
      					<tr>
        					<th>结束日期</th>
        					<td>
        						<div class="required required-wrapper"></div>
          						<input type="text" name="end" id="end" value="${plan.end}" class="form-control form-date" required>
        					</td>
        					<td style="padding-left: 15px;">&nbsp; &nbsp; 
        						<label class="radio-inline">
        							<input type="radio" name="delta" value="7" onclick="computeEndDate(this.value)" id="delta7"> 
       								一星期
   								</label>
       							<label class="radio-inline">
       								<input type="radio" name="delta" value="14" onclick="computeEndDate(this.value)" id="delta14"> 
       								两星期
   								</label>
   								<label class="radio-inline">
   									<input type="radio" name="delta" value="31" onclick="computeEndDate(this.value)" id="delta31"> 
   									一个月
								</label>
								<label class="radio-inline">
									<input type="radio" name="delta" value="62" onclick="computeEndDate(this.value)" id="delta62"> 
									两个月
								</label>
								<label class="radio-inline">
									<input type="radio" name="delta" value="93" onclick="computeEndDate(this.value)" id="delta93"> 
									三个月
								</label>
								<label class="radio-inline">
									<input type="radio" name="delta" value="186" onclick="computeEndDate(this.value)" id="delta186"> 
									半年
								</label>
								<label class="radio-inline">
									<input type="radio" name="delta" value="365" onclick="computeEndDate(this.value)" id="delta365"> 
									一年
								</label>        
							</td>
      					</tr>
      					<tr>
        					<th>描述</th>
        					<td colspan="2">
        						<textarea name="descript" id="descript" rows="10" class="form-control kindeditor">${plan.descript}</textarea>
							</td>
      					</tr>
      					<tr>
        					<td></td>
        					<td colspan="2">
           						<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
           						<a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
           						<!-- <input type="hidden" name="product" id="product" value="28"> -->
        					</td>
      					</tr>
    				</tbody>
   				</table>
  			</form>		
		</div>
	</div>
	</div>
<script type="text/javascript">
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
}
function addDays(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}
</script>	
<script>
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
</script>	
</body>
</html>