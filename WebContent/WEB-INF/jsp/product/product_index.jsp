<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
 	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
    <link href="../resources/style.css" rel="stylesheet"/>
    <script src="../resources/jquery-1.12.4.min.js"></script>
    <script src="../resources/dist/js/zui.min.js"></script>
    <script src="../resources/zui/src/js/dashboard.js"></script>
<script>
$(document).ready(function() {
    $('#dashboard').dashboard({
        height            : 240,
        shadowType        : false,
        sensitive         : true,
    });
});
</script>
    <style type="text/css">
body {background: #fafafa;}

.page-content {margin-top: -19px; border-top: 1px solid #3280fc;}

.dashboard {position: relative;}
.dashboard .row {margin: 0 auto;}
.dashboard .panel-actions {margin-top: 0; margin-right: 0;}
.dashboard .panel-heading {line-height: 17px; height: 30px; position: relative;}
.dashboard .panel-actions {position: absolute; top: 0; right: 0; height: 30px;}
.dashboard .panel-action {display: block; float: left; height: 30px; min-width: 26px; text-align: center; line-height: 30px; padding-left: 3px; padding-right: 3px;}
.dashboard .panel-actions > a {color: #666}
.dashboard .panel-action-more {font-size: 12px; font-weight: 200}
.dashboard .panel-action:hover, .dashboard .panel-actions > .dropdown > a:hover {color: #333; background-color: #ddd; background-color: rgba(0,0,0,0.1)}
.dashboard .panel-title {font-size: 13px; color: #333}
.dashboard a.panel-title > .icon-double-angle-right {position: relative; filter: alpha(opacity=0); opacity: 0; transition: opacity .2s, left .2s; left: -5px}
.dashboard .panel:hover a.panel-title > .icon-double-angle-right {filter: alpha(opacity=100); opacity: 1; left: 0}
.dashboard a.panel-title:hover {color: #1a53ff}
.dashboard .panel {box-shadow: 0 1px 3px rgba(0,0,0,.05); position: relative; overflow-x: hidden;}
.dashboard .panel.with-fixed-header {overflow-x: hidden;}
.dashboard .panel-heading + .panel-body {position: absolute; left: 0; top: 30px; right: 0; bottom: 0}
.dashboard .panel-dragging-shadow {position: absolute;}
.dashboard-empty-message {text-align: center; margin-top: 100px;}
.dashboard-empty-message > h5 {margin-bottom: 20px;}
.dashboard-actions {position: absolute; top:-20px; right:-10px;}
.dashboard-actions > a {display: inline-block; width: 40px; height: 20px; text-align: center; color: #999; border: 1px solid #999; line-height: 20px; background: #1a4f85; color: #fff}
.dashboard-actions > a:hover {background: #2e6dad; border-color: #2e6dad}

#wrap .outer {background-color: #fafafa;}
#wrap .outer > .dashboard {margin-left: -10px; margin-right: -10px;}

/* panel style */
.panel-block .table th {background-color: #fafafa}
.panel-primary {border-color: transparent;!important;}
.panel-success > .panel-heading,
.panel-warning > .panel-heading,
.panel-primary > .panel-heading,
.panel-info > .panel-heading,
.panel-danger > .panel-heading {color: #333; border: none; border-bottom: 1px solid rgba(0,0,0,.04);}
.panel-success, .panel-success .table-header-fixed th {background: #d1fecb!important; border-color: #b0e4ac!important}
.panel-success > .panel-heading {background: #c5f7c1!important; }
.panel-warning, .panel-warning .table-header-fixed th {background: #fdfdc7!important; border-color: #e1e09a!important}
.panel-warning > .panel-heading {background: #f8f7b6!important;}
.panel-primary, .panel-primary .table-header-fixed th {background: #d8f2fa!important; border-color: #badfeb!important}
.panel-primary > .panel-heading {background: #c9ecf8!important; color: #333!important; border:none!important;}
.panel-info, .panel-info .table-header-fixed th {background: #dcd8fe!important; border-color: #d0c9ee!important}
.panel-info > .panel-heading {background: #d4cdf3!important;}
.panel-danger, .panel-danger .table-header-fixed th {background: #f5d0f5!important; border-color: #e9b9e9!important}
.panel-danger > .panel-heading {background: #f1c3f1!important;}
.panel-success .table td, .panel-success .table th,
.panel-warning .table td, .panel-warning .table th,
.panel-primary .table td, .panel-primary .table th,
.panel-info .table td, .panel-info .table th,
.panel-danger .table td, .panel-danger .table th {border: none; background-color: transparent}
.panel-success .table tr:nth-child(even) > td, .panel-success .table th,
.panel-warning .table tr:nth-child(even) > td, .panel-warning .table th,
.panel-primary .table tr:nth-child(even) > td, .panel-primary .table th,
.panel-info .table tr:nth-child(even) > td, .panel-info .table th,
.panel-danger .table tr:nth-child(even) > td, .panel-danger .table th {background: rgba(255,255,255,.25);}
.panel-success .table tr:nth-child(odd) > td,
.panel-warning .table tr:nth-child(odd) > td,
.panel-primary .table tr:nth-child(odd) > td,
.panel-info .table tr:nth-child(odd) > td,
.panel-danger .table tr:nth-child(odd) > td {background: rgba(0,0,0,.03);}
.panel-success .table tr:last-child > td,
.panel-warning .table tr:last-child > td,
.panel-primary .table tr:last-child > td,
.panel-info .table tr:last-child > td
.panel-danger .table tr:last-child > td {border-bottom: 1px solid rgba(0,0,0,0.05)}
.panel-success .table tr:hover > th,
.panel-warning .table tr:hover > th,
.panel-primary .table tr:hover > th,
.panel-info .table tr:hover > th,
.panel-danger .table tr:hover > th {background: none;}
.panel-success .table.table-hover tr:hover > td,
.panel-warning .table.table-hover tr:hover > td,
.panel-primary .table.table-hover tr:hover > td,
.panel-info .table.table-hover tr:hover > td,
.panel-danger .table.table-hover tr:hover > td {background: rgba(255,255,255,.4);}

.block.input-group-btn .btn-success {background: #d1fecb; color: #333; text-shadow: none; border-color: #ccc}
.block.input-group-btn .btn-warning {background: #fdfdc7; color: #333; text-shadow: none; border-color: #ccc}
.block.input-group-btn .btn-info    {background: #dcd8fe; color: #333; text-shadow: none; border-color: #ccc}
.block.input-group-btn .btn-danger  {background: #f5d0f5; color: #333; text-shadow: none; border-color: #ccc}
.block.input-group-btn .btn-primary, .block.input-group-btn .btn-primary:focus {background: #d8f2fa; color: #333; text-shadow: none; border-color: #ccc}
.block.input-group-btn .btn-success:hover {border-color: #aaa}
.block.input-group-btn .btn-warning:hover {border-color: #aaa}
.block.input-group-btn .btn-primary:hover {border-color: #aaa}
.block.input-group-btn .btn-info:hover    {border-color: #aaa}
.block.input-group-btn .btn-danger:hover  {border-color: #aaa}
.block.input-group-btn .btn-primary .caret, .block.input-group-btn .btn-success .caret, .block.input-group-btn .btn-warning .caret, .block.input-group-btn .btn-danger .caret, .block.input-group-btn .btn-info .caret {border-top-color: #333}
    </style>
<title>产品</title>
</head>
<body>
	<header id="header" style="padding-top: 0px">
	
	<nav id="mainmenu" style="margin-top:0">
		<ul class="nav">
			<li data-id="my"><a href=""><i class="icon-home"></i><span> 我的地盘</span></a></li>
			<li class="active" data-id="product"><a href="" class="active">项目</a></li>
			<li data-id="project"><a href="">迭代</a></li>
			<li data-id="qa"><a href="">测试</a></li>
			<li data-id="doc"><a href="">文档</a></li>
			<li data-id="report"><a href="">统计</a></li>
			<li data-id="company"><a href="">组织</a></li>
			<li data-id="admin"><a href="">后台</a></li>
			<li class="custom-item"><a href="" data-toggle="modal" data-type="iframe" title="自定义导航" data-icon="cog" data-width="80%"><i class="icon icon-cog"></i></a></li>
		</ul>
		<div class="input-group input-group-sm" id="searchbox">
		<div class="input-group-btn" id="typeSelector" style="display: none;">
		<button type="button" class="btn dropdown-toggle" data-toggle="dropdown">
		<span id="searchTypeName">项目</span> 
		<span class="caret"></span>
		</button>
		<input type="hidden" name="searchType" id="searchType" value="product">
		</div>
		
		<input type="text" name="searchQuery" id="searchQuery" value="" onclick="this.value='';" onkeydown="if(event.keyCode==13) shortcut()" class="form-control" placeholder="">
		<div id="objectSwitcher" class="input-group-btn"><a href="javascript:shortcut();" class="btn">搜索</a></div>
	</nav>
		<nav id="modulemenu">
		    <ul class="nav">
				<li data-id="list"><a id="currentItem" href="javascript:showDropMenu('product', '1033', 'product', 'all', '')">实施 <span class="icon-caret-down"></span></a></li>
				<li class=" " data-id="story"><a href="">需求</a>
				</li>
				<li class=" " data-id="dynamic"><a href="">动态</a>
				</li>
				<li class=" " data-id="plan"><a href="">计划</a>
				</li>
				<li class=" " data-id="release"><a href="">发布</a>
				</li>
				<li class=" " data-id="roadmap"><a href="">路线图</a>
				</li>
				<li class=" " data-id="doc"><a href="">文档</a>
				</li>
				<li class=" " data-id="project"><a href="">项目</a>
				</li>
				<li class=" " data-id="module"><a href="">模块</a>
				</li>
				<li class=" " data-id="view"><a href="">概况</a>
				</li>
				<li class="right " data-id="create"><a href=""><i class="icon-plus"></i>&nbsp;添加产品</a>
				</li>
				<li class="right " data-id="all"><a href=""><i class="icon-cubes"></i>&nbsp;所有产品</a>
				</li>
				<li class="right " data-id="index"><a href=""><i class="icon-home"></i>产品主页</a>
				</li>
			</ul>
		  </nav>	
	</header>
	<div id="wrap">
		<div class="outer" style="min-height: 494px;">
		<div id="dashboard" class="dashboard dashboard-draggable" style="margin-top: 20px">
		<div class='dashboard-actions' style="position: absolute;top:-40px"><a href='./block-admin-0-product.html' data-toggle='modal' data-type='ajax' data-width='700' data-title='添加区块'><i class='icon icon-plus' title='添加区块' data-toggle='tooltip' data-placement='left'></i></a></div>
		<div class="row">
          <div class="col-md-4 col-sm-6" data-id='1'>
            <div class="panel panel-block panel-default">
              <div class="panel-heading">
                <div class="panel-actions">
					<a href="" class="panel-action drag-disabled panel-action-more">更多 <i class="icon-double-angle-right"></i></a>                
					<div class="dropdown">
		              <a href="javascript:;" data-toggle="dropdown" class="panel-action"><i class="icon icon-ellipsis-v"></i></a>
		              <ul class="dropdown-menu pull-right">
		                <li><a href="javascript:;" class="refresh-panel"><i class="icon-repeat"></i> 刷新</a></li>
		                <li><a data-toggle="modal" href="./block-set-558-plan-product.html" class="edit-block" data-title="计划列表" data-icon="icon-pencil"><i class="icon-pencil"></i> 编辑</a></li>
		               	<li><a href="javascript:;" class="remove-panel"><i class="icon-remove"></i> 删除</a></li>
		              </ul>
		            </div>
                </div>
                <span class="panel-title">需求列表</span>
              </div>
                
              <div class="panel-body">

              </div>
            </div>
          </div>
          <div class="col-md-4 col-sm-6" data-id='2'>
            <div class="panel">
              <div class="panel-heading">
                <div class="panel-actions">
                  <a href="#"><i class="icon-refresh"></i></a>
                    <div class="dropdown">
                      <a href='#' role="button" data-toggle="dropdown"><span class="caret"></span></a>
                      <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dropdownMenu1">
                        <li><a href="./block-admin-0-product.html"><i class="icon-pencil"></i> 编辑</a></li>
                        <li><a href="#" class='refresh-panel'><i class="icon-refresh"></i> 刷新</a></li>
                        <li><a href="#" class="remove-panel"><i class="icon-remove"></i> 移除</a></li>
                      </ul>
                    </div>
                  </div>2 <i class="icon-list-ul"></i>
                </div>
              <div class="panel-body">
				<table id="myTable" class="table table-data table-hover block-story table-fixed">
				  <thead>
				  <tr>
				    <th width="50" style="text-align: center">ID</th>
				    <th width="30" style="text-align: center">P</th>
				    <th width="">需求名称</th>
				    <th width="50" style="text-align: center">预计</th>
				    <th width="70" style="text-align: center">状态</th>
				    <th width="70" style="text-align: center">阶段</th>
				  </tr>
				  </thead>
				      <tbody><tr data-url="/story-view-2622.html">
				    <td class="text-center">2622</td>
				    <td class="text-center"></td>
				    <td style="color: " title="登录">登录</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2606.html">
				    <td class="text-center">2606</td>
				    <td class="text-center"></td>
				    <td style="color: " title="事实上事实上">事实上事实上</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2576.html">
				    <td class="text-center">2576</td>
				    <td class="text-center">3</td>
				    <td style="color: #f57c00" title="这个是已经发布产品的需求">这个是已经发布产品的需求</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已立项
				  </td></tr>
				      <tr data-url="/story-view-2568.html">
				    <td class="text-center">2568</td>
				    <td class="text-center"></td>
				    <td style="color: " title="ddd">ddd</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2558.html">
				    <td class="text-center">2558</td>
				    <td class="text-center"></td>
				    <td style="color: " title="44">44</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2550.html">
				    <td class="text-center">2550</td>
				    <td class="text-center">1</td>
				    <td style="color: " title="abc">abc</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2546.html">
				    <td class="text-center">2546</td>
				    <td class="text-center"></td>
				    <td style="color: " title="新建用户">新建用户</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2485.html">
				    <td class="text-center">2485</td>
				    <td class="text-center">2</td>
				    <td style="color: " title="CHRIS测试产品-需求2">CHRIS测试产品-需求2</td>
				    <td class="text-center">70</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已立项
				  </td></tr>
				  </tbody>
				  </table>
              </div>
            </div>
          </div>
          <div class="col-md-4 col-sm-6" data-id='3'>
            <div class="panel panel-block panel-default with-fixed-header" style="height: 240px;">
              <div class="panel-heading">
                <div class="panel-actions">
					<a href="" class="panel-action drag-disabled panel-action-more">更多 <i class="icon-double-angle-right"></i></a>                
					<div class="dropdown">
		              <a href="javascript:;" data-toggle="dropdown" class="panel-action"><i class="icon icon-ellipsis-v"></i></a>
		              <ul class="dropdown-menu pull-right">
		                <li><a href="javascript:;" class="refresh-panel"><i class="icon-repeat"></i> 刷新</a></li>
		                <li><a data-toggle="modal" href="" class="edit-block" data-title="计划列表" data-icon="icon-pencil"><i class="icon-pencil"></i> 编辑</a></li>
		               	<li><a href="javascript:;" class="remove-panel"><i class="icon-remove"></i> 删除</a></li>
		              </ul>
		            </div>
                </div>
                <span class="panel-title">需求列表</span>
			  </div>
              <div class="panel-body no-padding" style="height: 200px">
				<table id="myTable" class="table table-data table-hover block-story table-fixed">
				  <thead style="visibility: hidden;">
				  <tr>
				    <th width="50" style="text-align: center">ID</th>
				    <th width="30" style="text-align: center">P</th>
				    <th width="">           需求名称</th>
				    <th width="50" style="text-align: center">预计</th>
				    <th width="70" style="text-align: center">状态</th>
				    <th width="70" style="text-align: center">阶段</th>
				  </tr>
				  </thead>
				      <tbody><tr data-url="/story-view-2622.html">
				    <td class="text-center">2622</td>
				    <td class="text-center"></td>
				    <td style="color: " title="登录">登录</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2606.html">
				    <td class="text-center">2606</td>
				    <td class="text-center"></td>
				    <td style="color: " title="事实上事实上">事实上事实上</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2576.html">
				    <td class="text-center">2576</td>
				    <td class="text-center">3</td>
				    <td style="color: #f57c00" title="这个是已经发布产品的需求">这个是已经发布产品的需求</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已立项
				  </td></tr>
				      <tr data-url="/story-view-2568.html">
				    <td class="text-center">2568</td>
				    <td class="text-center"></td>
				    <td style="color: " title="ddd">ddd</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2558.html">
				    <td class="text-center">2558</td>
				    <td class="text-center"></td>
				    <td style="color: " title="44">44</td>
				    <td class="text-center">0</td>
				    <td class="text-center">草稿
				    </td><td class="text-center">未开始
				  </td></tr>
				      <tr data-url="/story-view-2550.html">
				    <td class="text-center">2550</td>
				    <td class="text-center">1</td>
				    <td style="color: " title="abc">abc</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2546.html">
				    <td class="text-center">2546</td>
				    <td class="text-center"></td>
				    <td style="color: " title="新建用户">新建用户</td>
				    <td class="text-center">0</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已计划
				  </td></tr>
				      <tr data-url="/story-view-2485.html">
				    <td class="text-center">2485</td>
				    <td class="text-center">2</td>
				    <td style="color: " title="CHRIS测试产品-需求2">CHRIS测试产品-需求2</td>
				    <td class="text-center">70</td>
				    <td class="text-center">激活
				    </td><td class="text-center">已立项
				  </td></tr>
				  </tbody>
				  </table>
				</div>
				<div style="position: absolute;right: 10px;">
					<table class="table table-fixed table-data table-hover block-story">
						<thead style="visibility: visible;">
						 <tr>
						   <th width="50" style="text-align: center">ID</th>
						   <th width="30" style="text-align: center">P</th>
						   <th>           需求名称</th>
						   <th width="50" style="text-align: center">预计</th>
						   <th width="70" style="text-align: center">状态</th>
						   <th width="70" style="text-align: center">阶段</th>
						 </tr>
						</thead>
					</table>
				</div>
              </div>
            </div>
          </div>
		
		</div>
		</div>
	</div>
</body>
</html>