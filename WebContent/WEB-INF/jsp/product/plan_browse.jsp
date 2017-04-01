<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<script src="../resources/jquery-1.12.4.min.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<style type="text/css">
#productplan tbody > tr > td{border-right:1px solid #E4E4E4;}
.table td .article-content {padding: 0}
.table td .article-content *{margin:0px;}
.table td .article-content ol,.table td .article-content ul{padding-left:20px;}
</style>
<title>${currentProduct.name}::浏览计划</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer" style="min-height: 494px;">
		  	<div id="titlebar">
		  		<div class="heading">	      			
		  			<i class="icon-tags"></i>
	      			浏览计划
	      			<span class="label label-info"><c:if test="${branchId == 0}">所有</c:if>${branchMap[branchId]}</span>     
	      		</div>
	      		<div class="actions">
	      			<a href="./plan_create_${productId}_0" class="btn "><i class="icon-release-create icon-plus"></i> 创建计划</a>
	      		</div>	      		
	      	</div>
			<form method="post" id="productplanForm" action="./plan_batchEdit_${productId}_${branchId}_form">
				<table class="table table-condensed table-hover table-striped tablesorter" id="productplan">
				  	<thead>
				    	<tr class="colhead">
				    		<th class="w-id">    
				    			<div class="header<c:if test="${orderBy == 'id'}">${ascOrDesc}</c:if>">
				    				<c:choose>
				    					<c:when test="${ascOrDesc == 'SortUp'}">
				    						<a href="./plan_browse_${productId}_${branchId}_id_SortDown_${recPerPage}_${page}">ID</a>
				    					</c:when>
				    					<c:otherwise>
				    						<a href="./plan_browse_${productId}_${branchId}_id_SortUp_${recPerPage}_${page}">ID</a>
				    					</c:otherwise>
				    				</c:choose>
				    			</div>
				    		</th>
				    		<th>                 
 							    <div class="header<c:if test="${orderBy == 'title'}">${ascOrDesc}</c:if>">
				    				<c:choose>
				    					<c:when test="${ascOrDesc == 'SortUp'}">
				    						<a href="./plan_browse_${productId}_${branchId}_title_SortDown_${recPerPage}_${page}">名称</a>
				    					</c:when>
				    					<c:otherwise>
				    						<a href="./plan_browse_${productId}_${branchId}_title_SortUp_${recPerPage}_${page}">名称</a>
				    					</c:otherwise>
				    				</c:choose>
				    			</div>
				    		</th>
				      		<c:if test="${currentProduct.type != 'normal'}">
				      			<th data-width="100" style="text-align: center">
				      				<c:set var="c" value="${(c+0).intValue()}"/>
				      				所属${branchMap[c]}
				      			</th>
				      		</c:if>
				        	<th class="w-p50">   描述</th>
				    		<th class="w-100px"> 
				     			<div class="header<c:if test="${orderBy == 'begin'}">${ascOrDesc}</c:if>">
				    				<c:choose>
				    					<c:when test="${ascOrDesc == 'SortUp'}">
				    						<a href="./plan_browse_${productId}_${branchId}_begin_SortDown_${recPerPage}_${page}">开始日期</a>
				    					</c:when>
				    					<c:otherwise>
				    						<a href="./plan_browse_${productId}_${branchId}_begin_SortUp_${recPerPage}_${page}">开始日期</a>
				    					</c:otherwise>
				    				</c:choose>
				    			</div>
				    		</th>
				    		<th class="w-100px">
				    			<div class="header<c:if test="${orderBy == 'end'}">${ascOrDesc}</c:if>">
				    				<c:choose>
				    					<c:when test="${ascOrDesc == 'SortUp'}">
				    						<a href="./plan_browse_${productId}_${branchId}_end_SortDown_${recPerPage}_${page}">结束日期</a>
				    					</c:when>
				    					<c:otherwise>
				    						<a href="./plan_browse_${productId}_${branchId}_end_SortUp_${recPerPage}_${page}">结束日期</a>
				    					</c:otherwise>
				    				</c:choose>
				    			</div>
				    		</th>
				    		<th class="w-110px">操作</th>
			  			</tr>
			  		</thead>
				  	<tbody>
				  		<c:forEach items="${planPage.content}" var="plan">
					    	<tr class="text-center">
					    		<td class="text-left">
					      			<input type="checkbox" name="planIdList" value="${plan.id}">${plan.id}   
					      		</td>
					    		<td class="text-left" title="${plan.title}">
					    			<a href="./plan_view_${plan.product.id}_${plan.id}">${plan.title}</a>
								</td>
								<c:if test="${currentProduct.type != 'normal'}">
					        		<td><c:if test="${plan.branch_id == 0}">所有</c:if>${branchMap[plan.branch_id]}</td>
					        	</c:if>
					        	<td class="text-left content"><div class="article-content">${plan.descript}</div></td>
					    		<td>${plan.begin}</td>
					    		<td>${plan.end}</td>
					    		<td class="text-center">
					    			<a style="cursor: pointer;" class="btn-icon" title="关联需求" data-size="lg" data-type="iframe" data-url="./plan_linkStories_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-link"></i></a>
									<a style="cursor: pointer;" class="btn-icon" title="关联Bug" data-size="lg" data-type="iframe" data-url="./plan_linkBugs_${plan.product.id}_${plan.id}" data-toggle="modal"><i class="icon-bug"></i></a>
									<a href="./plan_edit_${plan.product.id}_${plan.id}" class="btn-icon " title="编辑计划"><i class="icon-common-edit icon-pencil"></i></a>    
								</td>
				  			</tr>
			  			</c:forEach>
			    	</tbody>
				  	<tfoot>
				    	<tr>
				      		<td colspan="7">
				      			<c:if test="${planPage.totalElements != 0}">
				        		<div class="table-actions clearfix">
				          			<div class="checkbox btn">
				          				<label><input type="checkbox" data-scope="" class="rows-selector" onclick="selectAll(this)"> 选择</label>
				          			</div>           
				          			<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">编辑</button>  
				          		</div>
				          		</c:if>
				          		<c:if test="${planPage.totalElements != 0}">
				        		<div style="float:right; clear:none;" class="pager form-inline">
				        			共 <strong>${planPage.totalElements}</strong> 条记录，
				        			<div class="dropdown dropup">
				        				<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
				        				<ul class="dropdown-menu">
				        					<c:forEach begin="5" end="50" step="5" var="i">
				        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
				        					</c:forEach>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
				        					<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
				        				</ul>
				        			</div> 
				        			<strong>${planPage.number + 1}/${planPage.totalPages}</strong> &nbsp; 
				        			<c:choose>
				        				<c:when test="${planPage.isFirst()}">
				        					<i class="icon-step-backward" title="首页"></i>
				        					<i class="icon-play icon-rotate-180" title="上一页"></i>
				        				</c:when>
				        				<c:otherwise>
											<a href="./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
				        					<a href="./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
										</c:otherwise>
				        			</c:choose>
				        			<c:choose>
				        				<c:when test="${planPage.isLast()}">
				        					<i class="icon-play" title="下一页"></i>
				        					<i class="icon-step-forward" title="末页"></i>
				        				</c:when>
				        				<c:otherwise>
											<a href="./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
				        					<a href="./plan_browse_${productId}_${branchId}_${orderBy}_${ascOrDesc}_${recPerPage}_${planPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
										</c:otherwise>
				        			</c:choose>
								</div>   
								</c:if>
								<c:if test="${planPage.totalElements == 0}"> 
									<div style="float:right; clear:none;" class="page">暂时没有记录</div>
								</c:if>  
							</td>
				    	</tr>
				  	</tfoot>
				</table>
			</form>
	  	</div>
	</div>
<script type="text/javascript">
$(function(){
	$("#productplanForm").submit(function(){
		 if($(":checkbox:not(.rows-selector):checked").size() === 0) {
			 bootbox.alert("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  请选择您要编辑的计划！</h4>");
			 return false;
		 } 
	});
	fixedTfootAction('#productplanForm');
	fixedTheadOfList('#productplan');
});
function selectAll(obj){ 
    $('input[name="planIdList"]').prop("checked",obj.checked); 
}
function fixedTfootAction(a) {
    if ($(a).size() == 0) {
        return false
    }
    if ($(a).find("table:last").find("tfoot").size() == 0) {
        return false
    }
    c();
    $(window).scroll(h);
    $(".side-handle").click(function() {
        setTimeout(c, 300)
    });
    var f, e, g, d, j, b;
    function h() {
        f = $(a).find("table:last");
        e = f.find("tfoot");
        d = f.width();
        b = e.hasClass("fixedTfootAction");
        offsetHeight = $(window).height() + $(window).scrollTop();
        j = f.offset().top + f.height() - e.height() / 5;
        g = e.find(".table-actions").children(".input-group");
        if (!b && offsetHeight <= j) {
            e.addClass("fixedTfootAction");
            e.width(d);
            e.find("td").width(d);
            if (g.size() > 0) {
                g.width(g.width())
            }
        }
        if (b && (offsetHeight > j || $(document).height() == offsetHeight)) {
            e.removeClass("fixedTfootAction");
            e.removeAttr("style");
            e.find("td").removeAttr("style")
        }
    }
    function c() {
        e = $(a).find("table:last").find("tfoot");
        if (e.hasClass("fixedTfootAction")) {
            e.removeClass("fixedTfootAction")
        }
        h()
    }
}
function fixedTheadOfList(d) {
    if ($(d).size() == 0) {
        return false
    }
    if ($(d).css("display") == "none") {
        return false
    }
    if ($(d).find("thead").size() == 0) {
        return false
    }
    e();
    $(window).scroll(g);
    $(".side-handle").click(function() {
        setTimeout(e, 300)
    });
    var b, f, c, a;
    function g() {
        f = $(d).find("thead").offset().top;
        a = $(d).parent().find(".fixedTheadOfList");
        if (a.size() <= 0 && f < $(window).scrollTop()) {
            b = $(d).width();
            c = "<table class='fixedTheadOfList'><thead>" + $(d).find("thead").html() + "</thead></table>";
            $(d).before(c);
            $(".fixedTheadOfList").addClass($(d).attr("class")).width(b)
        }
        if (a.size() > 0 && f >= $(window).scrollTop()) {
            a.remove()
        }
    }
    function e() {
        a = $(d).parent().find(".fixedTheadOfList");
        if (a.size() > 0) {
            a.remove()
        }
        g()
    }
}
</script>	
</body>
</html>