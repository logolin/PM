<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="${ctxResources}/dist/css/zui.min.css" rel="stylesheet"/>
<link href="${ctxResources}/style.css" rel="stylesheet"/>
<script src="${ctxResources}/zui/assets/jquery.js"></script>
<script src="${ctxResources}/dist/js/zui.min.js"></script>
<style>.form-condensed select.form-control {height:250px}
#featurebar > .nav > li > a > .icon-home {display: none}
.group-item {display:block; width:200px; float:left; font-size: 14px}
.outer .table.table-form tbody > tr:last-child td {border-top: 1px solid #ddd}
@-moz-document url-prefix(){.outer .table.table-form tbody > tr:last-child td, .outer .table.table-form tbody > tr:last-child th {border-bottom: 1px solid #ddd}}
</style>
<title>组织视图::${group.name}::权限维护</title>
</head>
<body>
<header id="header">
	<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/include/companymenu.jsp" %>
</header>
<div id="wrap">
	<div class="outer" style="min-height: 486px;">
		<form class="form-condensed" method="post" target="_parent">
  			<div id="featurebar">
    			<div class="heading"><i class="icon-lock"> ${group.name}</i></div>
				<ul class="nav">
					<li <c:if test="${status == 'all'}">class="active"</c:if>>
						<a href="./group_managepriv_byGroup_${groupId}_all">所有权限</a>
					</li>
					<li <c:if test="${status == 'my'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_my">我的地盘</a></li>
					<li <c:if test="${status == 'product'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_product">产品</a></li>
					<li <c:if test="${status == 'project'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_project">项目</a></li>
					<li <c:if test="${status == 'qa'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_qa">测试</a></li>
					<li <c:if test="${status == 'doc'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_doc">文档</a></li>
					<li <c:if test="${status == 'report'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_report">统计</a></li>
					<li <c:if test="${status == 'company'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_company">组织</a></li>
					<li <c:if test="${status == 'admin'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_admin">后台</a></li>
					<li <c:if test="${status == 'other'}">class="active"</c:if>><a href="./group_managepriv_byGroup_${groupId}_other">其他</a></li>
				</ul>
  			</div>
  			<table class="table table-hover table-striped table-bordered table-form">
  				<thead>
  					<tr>
  						<th>模块</th>
  						<th>方法</th>
  					</tr>
  				</thead>
  				<tbody>
  					<input type="hidden" name="groupId" value="${groupId}" />
  					<c:forEach items="${map}" var="map">
  							<tr>
  								<th class="text-right w-150px">${fieldNameMap[map.key]}
  									<input type="checkbox" name="" id="" value="" onclick="selectAll(this, '${map.key}', 'checkbox')" />
  								</th>
  								<td id="${map.key}" class="pv-10px">
  									<c:forEach items="${map.value}" var="perm">
  									<c:set var="ischeck" value="${perm.module}${perm.method}"></c:set>
	  									<div class="group-item">
		  									<input type="checkbox" name="actions" ${havaMap[ischeck]} value="${perm.module}-${perm.method}" />
											<span class="priv" id="">${perm.name}</span>
										</div>
									</c:forEach>
  								</td>
  							</tr>
  					</c:forEach>
  					<tr>
  						<th class="text-right w-150px">全选
  							<input type="checkbox" name="allchecker[]" onclick="selectAll(this, '', 'checkbox')" />
  						</th>
  						<td>
  							<button type="submit" id="submit" class="btn btn-primary" onclick="setNoChecked()" data-loading="稍候...">保存</button> 
  							<button type="button" class="btn btn-default" onclick="javaScript:history.go(-1)">返回</button>
  							<input type="hidden" name="foo" id="foo" value="">
							<input type="hidden" name="noChecked" id="noChecked" value="">
						</td>
  					</tr>
  				</tbody>
  			</table>
		</form>
  </div> 
</div>
<script type="text/javascript">
function selectAll(checker, scope, type)
{ 
    if(scope)
    {
        if(type == 'button')
        {
            $('#' + scope + ' input').each(function() 
            {
                $(this).prop("checked", true)
            });
        }
        else if(type == 'checkbox')
        {
            $('#' + scope + ' input').each(function() 
            {
                $(this).prop("checked", checker.checked)
            });
         }
    }
    else
    {
        if(type == 'button')
        {
            $('input:checkbox').each(function() 
            {
                $(this).prop("checked", true)
            });
        }
        else if(type == 'checkbox')
        { 
            $('input:checkbox').each(function() 
            {
                $(this).prop("checked", checker.checked)
            });
        }
    }
}

</script>
</body>
</html>