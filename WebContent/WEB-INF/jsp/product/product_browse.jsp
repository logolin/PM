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
<script src="../resources/zui.sortable.min.js"></script>
<style>
tbody.sortable > tr {position: relative; z-index: 5}
tbody.sortable > tr.drag-shadow {display: none}
tbody.sortable > tr > td.sort-handler {cursor: move; color: #999;}
tbody.sortable > tr > td.sort-handler > i {position: relative; top: 2px}
tbody.sortable-sorting > tr {transition: all .2s;}
tbody.sortable-sorting {cursor: move;}
tbody.sortable-sorting > tr {opacity: .3;}
tbody.sortable-sorting > tr.drag-row {opacity: 1; z-index: 10; box-shadow: 0 2px 4px red}
tbody.sortable-sorting > tr.drag-row + tr > td {box-shadow: inset 0 4px 2px rgba(0,0,0,.2)}
tbody.sortable-sorting > tr.drag-row > td {background-color: #edf3fe!important}
tbody.sortable > tr.drop-success > td {background-color: #cfe0ff; transition: background-color 2s;}
.border-right-show {border-right: 1px solid #ddd;}
</style>
<title>全部产品</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
	  	<div class="outer" style="min-height: 494px;">
			<div id="featurebar">
			  	<ul class="nav">
			    	<li id="noclosedTab" <c:if test="${status == 'closed'}">class="active"</c:if>><a href="./product_browse_${productId}_closed_${orderBy}_${ascOrDesc}_${recPerPage}_${page}">未关闭</a></li>    
			    	<li id="closedTab" <c:if test="${status == 'normal'}">class="active"</c:if>><a href="./product_browse_${productId}_normal_${orderBy}_${ascOrDesc}_${recPerPage}_${page}">结束</a></li>    
			    	<li id="allTab" <c:if test="${status == 'all'}">class="active"</c:if>><a href="./product_browse_${productId}_all_${orderBy}_${ascOrDesc}_${recPerPage}_${page}">全部产品</a></li>  
				</ul>
			  	<div class="actions">
			  		<shiro:hasPermission name="product:create">
			    		<a href="./product_create_${productId}" class="btn"><i class="icon-plus"></i> 新增产品</a>
			  		</shiro:hasPermission>
			  	</div>				
			</div>
			<div class="block" id="productbox">
				<form method="post" action="./product_batchEdit_${productId}_form" id="productsForm">
  					<table class="table table-condensed table-hover table-striped tablesorter table-datatable" id="productList">
        				<thead>
      						<tr>
        						<th class="w-id">
									<div class="header<c:if test="${orderBy == 'id'}">${ascOrDesc}</c:if>">
					    				<c:choose>
					    					<c:when test="${ascOrDesc == 'SortUp'}">
					    						<a href="./product_browse_${productId}_${status}_id_SortDown_${recPerPage}_${page}">ID</a>
					    					</c:when>
					    					<c:otherwise>
					    						<a href="./product_browse_${productId}_${status}_id_SortUp_${recPerPage}_${page}">ID</a>
					    					</c:otherwise>
					    				</c:choose>
				    				</div>
								</th>
						        <th>
	 							    <div class="header<c:if test="${orderBy == 'name'}">${ascOrDesc}</c:if>">
					    				<c:choose>
					    					<c:when test="${ascOrDesc == 'SortUp'}">
					    						<a href="./product_browse_${productId}_${status}_name_SortDown_${recPerPage}_${page}">产品名称</a>
					    					</c:when>
					    					<c:otherwise>
					    						<a href="./product_browse_${productId}_${status}_name_SortUp_${recPerPage}_${page}">产品名称</a>
					    					</c:otherwise>
					    				</c:choose>
					    			</div>
								</th>
						        <th class="w-80px">激活需求</th>
						        <th class="w-80px">已变更需求</th>
						        <th class="w-80px">草稿需求</th>
						        <th class="w-80px">已关闭需求</th>
						        <th class="w-80px">计划数</th>
						        <th class="w-80px">发布数</th>
						        <th class="w-80px">相关BUG</th>
						        <th class="w-80px">未解决</th>
						        <th class="w-80px <c:if test="${orderBy != 'sort'}">border-right-show</c:if>">未指派</th>
						        <c:if test="${orderBy == 'sort'}">
	                				<th class="w-60px sort-default">
		 							    <div class="header<c:if test="${orderBy == 'sort'}">${ascOrDesc}</c:if>">
						    				<c:choose>
						    					<c:when test="${ascOrDesc == 'SortUp'}">
						    						<a href="./product_browse_${productId}_${status}_sort_SortDown_${recPerPage}_${page}">排序</a>
						    					</c:when>
						    					<c:otherwise>
						    						<a href="./product_browse_${productId}_${status}_sort_SortUp_${recPerPage}_${page}">排序</a>
						    					</c:otherwise>
						    				</c:choose>
						    			</div>
									</th>
								</c:if>
              				</tr>
    					</thead>
				        <tbody class="sortable" id="productTableList">
				        	<c:forEach items="${productPage.content}" var="product">
				            <tr class="text-center" data-id="${product[0]}" data-order="${product[2]}">
				        		<td>
				                    <input type="checkbox" name="productIdList" value="${product[0]}"> 
				                    <a href="./produdct_view_${product[0]}"><fmt:formatNumber value="${product[0]}" pattern="#000"/></a>
				        		</td>
						        <td class="text-left" title="${product[1]}">
						        	<a href="./produdct_view_${product[0]}">${product[1]}</a>
								</td>
						        <td>${countMap[product[0]][0]}</td>
						        <td>${countMap[product[0]][1]}</td>
						        <td>${countMap[product[0]][2]}</td>
						        <td>${countMap[product[0]][3]}</td>
						        <td>${countMap[product[0]][4]}</td>
						        <td>${countMap[product[0]][5]}</td>
						        <td>${countMap[product[0]][6]}</td>
						        <td>${countMap[product[0]][7]}</td>
						        <td <c:if test="${orderBy != 'sort'}">class="border-right-show"</c:if>>${countMap[product[0]][8]}</td>
						        <c:if test="${orderBy == 'sort'}">
                					<td class="sort-handler"><i class="icon icon-move"></i></td>
                				</c:if>
			              	</tr>
			              	</c:forEach>
			          	</tbody>
			    		<tfoot>
      						<tr>
        						<td colspan="12">
          							<div class="table-actions clearfix">
          								<shiro:hasPermission name="product:batchEdit">
	                    					<div class="checkbox btn">
					          					<label><input type="checkbox" data-scope="" class="rows-selector" onclick="selectAll(this)"> 选择</label>
					          				</div>      
					          				<button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">批量编辑</button>
				          				</shiro:hasPermission>
				          				<shiro:hasPermission name="product:updateOrder">
					          				<c:if test="${orderBy != 'sort'}">
					          					<a href="./product_browse_${productId}_${status}_sort_SortUp_${recPerPage}_${page}" class="btn">排序</a>                                  
					          				</c:if>
				          				</shiro:hasPermission>
				          			</div>
          							<div class="text-right">
          								<div style="float:right; clear:none;" class="pager form-inline">共 <strong>${productPage.totalElements}</strong> 条记录，
          									<div class="dropdown dropup">
          										<a href="javascript:;" data-toggle="dropdown" id="_recPerPage" data-value="5">每页 <strong>${recPerPage}</strong> 条<span class="caret"></span></a>
	          									<ul class="dropdown-menu">
					        						<c:forEach begin="5" end="50" step="5" var="i">
					        							<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_${i}_1'>${i}</a></li>
					        						</c:forEach>
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_100_1'>100</a></li>
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_200_1'>200</a></li>
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_500_1'>500</a></li>
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_1000_1'>1000</a></li>
					        						<li <c:if test="${recPerPage == i}">class="active"</c:if>><a href='./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_2000_1'>2000</a></li>
					        					</ul>
				        					</div>
				        					<strong>${productPage.number + 1}/${productPage.totalPages}</strong> &nbsp;
						        			<c:choose>
						        				<c:when test="${productPage.isFirst()}">
						        					<i class="icon-step-backward" title="首页"></i>
						        					<i class="icon-play icon-rotate-180" title="上一页"></i>
						        				</c:when>
						        				<c:otherwise>
													<a href="./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_${recPerPage}_1"><i class="icon-step-backward" title="首页"></i></a>
						        					<a href="./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_${recPerPage}_${page - 1}"><i class="icon-play icon-rotate-180" title="上一页"></i></a>
												</c:otherwise>
						        			</c:choose>
						        			<c:choose>
						        				<c:when test="${productPage.isLast()}">
						        					<i class="icon-play" title="下一页"></i>
						        					<i class="icon-step-forward" title="末页"></i>
						        				</c:when>
						        				<c:otherwise>
													<a href="./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_${recPerPage}_${page + 1}"><i class="icon-play" title="下一页"></i></a> 
						        					<a href="./product_browse_${productId}_${status}_${orderBy}_${ascOrDesc}_${recPerPage}_${planPage.totalPages}"><i class="icon-step-forward" title="末页"></i></a>
												</c:otherwise>
						        			</c:choose>				        					 
				        				</div>
				        			</div>
        						</td>
      						</tr>
    					</tfoot>
  					</table>
				</form>
			</div>
	  	</div>
	</div>
<script> 
$(document).ready(function()
{
    $('.sortable:not(tbody)').sortable();
    $('tbody.sortable').each(function()
    {
        var $tbody = $(this);
        $tbody.sortable(
        {
            reverse: true,
            selector: 'tr',
            dragCssClass: 'drag-row',
            trigger: $tbody.find('.sort-handler').length ? '.sort-handler' : null,
            finish: function(e)
            {
                var orders = {};
                e.list.each(function(){
                    var $this = $(this);
                    orders[$this.data('id')] = parseInt($this.attr('data-order'));
                });
                e.orders = orders;
                $tbody.trigger('sort.sortable', e);
                var $thead = $tbody.closest('table').children('thead');
                $thead.find('.headerSortDown, .headerSortUp').removeClass('headerSortDown headerSortUp').addClass('header');
                $thead.find('th.sort-default .header').removeClass('header').addClass('headerSortDown');
                e.element.addClass('drop-success');
                setTimeout(function(){e.element.removeClass('drop-success');}, 800)
            }
        });
    });
});
$(function(){
	$("#productsForm").submit(function(){
		 if($(":checkbox:not(.rows-selector):checked").size() === 0) {
			 bootbox.alert("<h4><i class='icon icon-warning-sign' style='color: orange'></i>  请选择您要编辑的产品！</h4>");
			 return false;
		 } 
	});
    $('#productTableList').on('sort.sortable', function(e, data){
	    var ids = new Array(), sorts = new Array();
	    for ( var i in data.orders) {
			ids.push(i);
			sorts.push(data.orders[i]);
		}
 	    $.post("../ajaxSort", {ids : ids, sorts : sorts});
 	});
    fixedTfootAction('#productsForm');
    fixedTheadOfList('#productList');
});
function selectAll(obj){ 
    $('input[name="productIdList"]').prop("checked",obj.checked); 
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