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
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<style>
.roadmap {width:180px; margin:10px auto 10px auto; padding:15px 10px; font-weight:bold}
.roadmap a{color:#ccc;}
.roadmap p{margin:2px}
.release {background:#006400; color:#ccc}
.plan {background:#ffcc00;}
.plan a{color:#006400}
</style>
<title>${currentProduct.name}::路线图</title>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/mainmenu.jsp"%> 
		<%@ include file="/WEB-INF/jsp/include/productmenu.jsp" %>
	</header>
	<div id="wrap">
		<div class="outer">
			<div>
	  			<div id="titlebar"><div class="heading"><i class="icon-code-fork"></i> 路线图</div></div>
				<div id='roadmapBox' style='overflow-x:auto'>
    				<table class='table table-grid active-disabled'>
	    				<tbody>
	    					<tr class="text-center">
	    					<c:forEach items="${roadmap}" var="year">
	    						<c:forEach items="${year.value}" var="branch" varStatus="i">
	    							<c:if test="${i.last}">
	    								<th colspan='${i.count}' style='border-right:1px solid #ddd'><h4>${year.key}年</h4></th>
	    							</c:if>
	    						</c:forEach>
	    					</c:forEach>
	    					</tr>
	    					<tr class="text-center text-top">
							<c:forEach items="${roadmap}" var="year">
								<c:forEach items="${year.value}" var="branch">							
									<td><div class='roadmap branch'><c:if test="${branch.key == 0}">所有</c:if>${branchMap[branch.key]}</div>
									<c:forEach items="${branch.value}" var="object" varStatus="c">
										<c:choose>
											<c:when test="${object.getClass().name == 'com.projectmanager.entity.Plan'}">
												<div class='roadmap plan'>
													<h5><a href='./plan_view_${object.product.id}_${object.id}'  target='_blank'>${object.title}</a></h5>
													${object.begin} ~ ${object.end}
												</div>
											</c:when>
											<c:otherwise>
												<div class='roadmap release'><h5><a href='./release_view_${object.product.id}_${object.id}'  target='_blank'>${object.name}</a>
												</h5>${object.date}</div>
											</c:otherwise>
										</c:choose>	
										<c:if test="${c.last == false}">
											<i class="icon icon-arrow-down"></i>	
										</c:if>		
									</c:forEach>
									</td>
								</c:forEach>
							</c:forEach>
	    					</tr>
						</tbody>
	  				</table>
				</div>
	  		</div>
		</div>
	</div>
</body>
</html>