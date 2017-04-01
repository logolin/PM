<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="../resources/dist/css/zui.min.css"></script>
<link href="../resources/dist/lib/datatable/zui.datatable.min.css" rel="stylesheet"/>
<link href="../resources/dist/css/default.css" rel="stylesheet"/>
<script src="../resources/jquery-1.12.4.min.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src='../resources/dist/js/all.js'></script>
<script src="../resources/dist/lib/datatable/zui.datatable.min.js"></script>
<style type="text/css">

</style>
<script type="text/javascript">
$(document).ready(function() {
$('table.datatable').datatable(
	{checkable: true,
	sortable: true,
	storage: true,
	});
});
</script>
<script type="text/javascript">
$(function() {
    if(typeof(replaceID) != 'undefined') setModal4List('iframe', replaceID);
    $(".date").bind('dateSelected', function()
    {
        computeWorkDays(this.id);
    })
});
$(function()
{
    setTimeout(function(){fixedTheadOfList('#groupTable')}, 100);
    $(document).on('click', '.expandAll', function()
    {
        $('.expandAll').addClass('hidden');
        $('.collapseAll').removeClass('hidden');
        $('table#groupTable').find('tbody').each(function()
        {
            $(this).find('tr').addClass('hidden');
            $(this).find('tr.group-collapse').removeClass('hidden');
        })
    });
    $(document).on('click', '.collapseAll', function()
    {
        $('.collapseAll').addClass('hidden');
        $('.expandAll').removeClass('hidden');
        $('table#groupTable').find('tbody').each(function()
        {
            $(this).find('tr').removeClass('hidden');
            $(this).find('tr.group-collapse').addClass('hidden');
        })
    });
    $('.expandGroup').closest('.groupby').click(function()
    {
        $tbody = $(this).closest('tbody');
        $tbody.find('tr').addClass('hidden');
        $tbody.find('tr.group-collapse').removeClass('hidden');
    });
    $('.collapseGroup').click(function()
    {
        $tbody = $(this).closest('tbody');
        $tbody.find('tr').removeClass('hidden');
        $tbody.find('tr.group-collapse').addClass('hidden');
    });
})
</script>
<title>项目视图::任务列表</title>
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
		<%@include file="/WEB-INF/jsp/include/taskhead.jsp" %>
		<div class="sub-featurebar">
			<ul class="nav nav nav-tabs">
		    	<li><a href="project-group-story.jsp">所有</a>
		    	</li>
		    	<li class="active"><a href="#">已关联需求的任务</a>
		    	</li>
		    </ul>
		</div>	
		

        <table class='table active-disabled table-condensed table-fixed' id='groupTable'>
  <thead>
    <tr>
      <th class='w-200px text-left'>
        <a href='###' class='expandAll' data-action='expand'><i class='icon-caret-down'></i> 相关需求</a>
        <a href='###' class='collapseAll' data-action='collapse'><i class='icon-caret-right'></i> 相关需求</a>
      </th>
      <th>任务名称</th>
      <th class='w-pri'> P</th>
      <th class='w-user'>指派给</th>
      <th class='w-user'>由谁完成</th>
      <th class='w-50px'>预</th>
      <th class='w-50px'>消耗</th>
      <th class='w-50px'>剩</th>
      <th class='w-50px'>类型</th>
      <th class='w-80px'>截止</th>
      <th class='w-80px'>任务状态</th>
      <th class='w-60px'>操作</th>
    </tr>
  </thead>
          <tbody>
              <tr class='text-center'>
            <td rowspan='2' class='groupby text-left'>
        <a href='###' class='expandGroup' data-action='expand' title='无需求'><i class='icon-caret-down'></i> 无需求</a>
      </td>
            <td class='text-left'>&nbsp;190::<a href='/task-view-190.html' >Test</a>
</td>
      <td><span class='pri'></span></td>
      <td ></td>
      <td>Demo</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>开发</td>
      <td class=>2016-07-22</td>
      <td class=closed >已关闭</td>
      <td>
        <a href='/task-edit-190.html' class='btn-icon ' title='编辑' ><i class='icon-common-edit icon-pencil'></i></a>        <a href='/task-delete-115-190.html' class='btn-icon ' title='删除'  target='hiddenwin'><i class='icon-common-delete icon-remove'></i></a>      </td>
    </tr>
                <tr class='text-center groupdivider'>
      <td colspan='4' class='text-left'>
        <div class='text'>
                本组共 <strong>1</strong> 个任务，未开始 <strong>0</strong>，进行中 <strong>0</strong></div>
      </td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td colspan='4'></td>
    </tr>
    <tr class='actie-disabled group-collapse hidden text-center group-title'>
      <td colspan='5' class='text-left'>
        <a href='###' class='collapseGroup' data-action='collapse' title='无需求'><i class='icon-caret-right'></i> 无需求</a>
        <span class='groupdivider' style='margin-left:10px;'>
          <span class='text'>
                        本组共 <strong>1</strong> 个任务，未开始 <strong>0</strong>，进行中 <strong>0</strong>          </span>
        </span>
      </td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td colspan='4'></td>
    </tr>
      </tbody>
  </table>
   </div>
</div>
</body>
</html>
