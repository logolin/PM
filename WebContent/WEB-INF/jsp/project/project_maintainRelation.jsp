<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
 	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel='stylesheet' href='http://cdn.zentao.net/8.2.4/theme/default/zh-cn.default.css?v=pro5.3.1' type='text/css' media='screen' />
    <link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
    <script src='http://cdn.zentao.net/8.2.4/js/all.js?v=pro5.3.1' type='text/javascript'></script>
    <script src="../resources/dist/lib/chosen/chosen.min.js"></script>
    <script type="text/javascript">
	$(document).ready(function(){
		//chosen的初始化
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    
		    search_contains: true,      
		    allow_single_deselect: true
		});
	});
	</script>
<title>项目视图::维护任务关系</title>
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
		<div id="featurebar">
		  <ul class="nav">
		     <li>
		      <div class="label-angle">
		        所有模块      </div>
		    </li>
            <li class="active"><a href="#">未关闭</a>
			</li>
            <li><a href="suoyou.jsp">所有</a>
			</li>
            <li><a href="yiyanqi.jsp">已延期</a>
			</li>
            <li><a href="xuqiubiandong.jsp">需求变动</a>
			</li>
			<li id="statusTab" class="dropdown">
				<a data-toggle="dropdown">更多 <span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="/project-task-103-wait.html">未开始</a>
					</li><li><a href="/project-task-103-doing.html">进行中</a>
					</li><li><a href="/project-task-103-finishedbyme.html">我完成</a>
					</li><li><a href="/project-task-103-done.html">已完成</a>
					</li><li><a href="/project-task-103-closed.html">已关闭</a>
					</li><li><a href="/project-task-103-cancel.html">已取消</a>
					</li>
				</ul>
			</li>
		    <li><a href="rili.jsp">日历</a>
			</li>
		    <li><a href="kanban.jsp">看板</a>
			</li>
		    <li><a href="project-gantt.jsp">甘特图</a>
			</li>
		    <li><a href="ranjintu.jsp">燃尽图</a>
			</li>
		    <li><a href="shuzhuangtu.jsp">树状图</a>
			</li>
		    <li class="dropdown">
				<a href="#" data-toggle="dropdown">分组查看 <span class="caret"></span></a>
			    <ul class="dropdown-menu">
			    	<li><a href="#">需求分组</a></li><li><a href="/project-groupTask-103-status.html">状态分组</a>
					</li><li><a href="#">优先级分组</a></li>
					<li><a href="#">指派给分组</a></li>
					<li><a href="#">完成者分组</a></li>
					<li><a href="#">关闭者分组</a></li>
					<li><a href="#">类型分组</a></li>
					<li><a href="#">截止分组</a></li>
				</ul>
			</li>
		  </ul>
		  <div class="actions">
		    <div class="btn-group">
		      <div class="btn-group">
		      </div>
		      <a href="#" class="btn create-story-btn"><i class="icon-common-report icon-bar-chart"></i>报表</a>
		        <div class="btn-group">
        			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="exportAction">
            		<i class="icon-download-alt"></i> 导出            <span class="caret"></span>
        			</button>
        				<ul class="dropdown-menu" id="exportActionMenu">
        					<li>
        					<a href="#" class="export iframe" data-width="700">导出数据</a>
        					</li>
						</ul>
      			</div>
		        <div class="btn-group">
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="importAction">
				    <i class="icon-upload-alt"></i> 导入   <span class="caret"></span>
				    </button>
				        <ul class="dropdown-menu" id="importActionMenu">
				        <li><a href="/project-importTask-103.html">转入任务</a></li>
						<li><a href="/project-importBug-103.html">导入Bug</a></li>        
						</ul>
				</div>
		        <a href="#" class="btn "><i class="icon-task-batchCreate icon-plus-sign"></i>批量添加</a>
		        <a href="#" class="btn "><i class="icon-task-create icon-sitemap"></i>建任务</a>
		    </div>
		  </div>
		  <div id="querybox" class=""></div>
		</div>
		
		<div class="sub-featurebar">
			<ul class="nav">
		    	<li id="relation">
		    	<a href="project-relation.jsp">查看任务关系</a>
		    	</li>
		    	<li id="maintainRelation" class="active">
		    	<a href="project-maintainRelation.jsp">维护任务关系</a>
		    	</li>
		    </ul>
		</div>
		
		<form method="post" class="form-condensed" target="hiddenwin">
			<table class="table table-fixed mgb-20 table-form with-border">
				<thead>
			    <tr class="colhead">
			      <th class="w-id">编号</th>
			      <th>条件任务</th>
			      <th class="w-100px">条件动作</th>
			      <th>任务</th>
			      <th class="w-110px">动作</th>
			    </tr>
			    </thead>
			    <tbody>
			    </tbody>
			</table>
			<table class="table table-form table-fixed with-border">
			    <caption class="text-left"><strong>新增任务关系</strong></caption>
			    <thead>
			    <tr class="colhead">
			      <th class="w-id">编号</th>
			      <th>条件任务</th>
			      <th class="w-100px">条件动作</th>
			      <th>任务</th>
			      <th class="w-110px">动作</th>
			    </tr>
			    </thead>
			    <tbody>
			      <tr>
			      	<td class="text-center">1<input type="hidden" name="newid[1]" id="newid[1]" value="1">
					</td>
					<td style="overflow:visible">
					<select class="form-control chosen chosen-select">
						<option value=""></option>
						<option value="73">A:admin</option>
						<option value="77">D:demo</option>
						<option value="78">D:开发甲</option>
						<option value="79">P:项目经理</option>
						<option value="80">T:测试乙</option>
					</select>
			 		</td>
					<td>
					<select class="form-control">
					<option value="" selected="selected"></option>
					<option value="begin">开始后</option>
					<option value="end">完成后</option>
					</select>
					</td>
					<td style="overflow:visible">
					<select name="newpretask[1]" id="newpretask1" class="form-control chosen chosen-select">
						<option value="" selected="selected"></option>
						<option value="184">184::333</option>
						<option value="183">183::1234</option>
						<option value="178">178::121212121</option>
						<option value="177">177::12121212</option>
						<option value="175">175::数据库优化</option>
						<option value="174">174:Demo:排队积分</option>
						<option value="173">173:Demo:排队积分</option>
						<option value="172">172:Demo:排队积分</option>
						<option value="171">171:Demo:第二个模块</option>
						<option value="170">170:Demo:第一个模块</option>
					</select>
			 		</td>
					<td><select name="newaction[1]" id="newaction1" class="form-control">
						<option value="" selected="selected"></option>
						<option value="begin">才能开始</option>
						<option value="end">才能完成</option>
						</select>
			 		</td>
			    </tr>
			    <tr>
			      	<td class="text-center">2<input type="hidden" name="newid[1]" id="newid[1]" value="1">
					</td>
					<td style="overflow:visible">
					<select class="form-control chosen chosen-select">
						<option value=""></option>
						<option value="73">A:admin</option>
						<option value="77">D:demo</option>
						<option value="78">D:开发甲</option>
						<option value="79">P:项目经理</option>
						<option value="80">T:测试乙</option>
					</select>
			 		</td>
					<td>
					<select class="form-control">
					<option value="" selected="selected"></option>
					<option value="begin">开始后</option>
					<option value="end">完成后</option>
					</select>
					</td>
					<td style="overflow:visible">
					<select name="newpretask[1]" id="newpretask1" class="form-control chosen chosen-select">
						<option value="" selected="selected"></option>
						<option value="184">184::333</option>
						<option value="183">183::1234</option>
						<option value="178">178::121212121</option>
						<option value="177">177::12121212</option>
						<option value="175">175::数据库优化</option>
						<option value="174">174:Demo:排队积分</option>
						<option value="173">173:Demo:排队积分</option>
						<option value="172">172:Demo:排队积分</option>
						<option value="171">171:Demo:第二个模块</option>
						<option value="170">170:Demo:第一个模块</option>
					</select>
			 		</td>
					<td><select name="newaction[1]" id="newaction1" class="form-control">
						<option value="" selected="selected"></option>
						<option value="begin">才能开始</option>
						<option value="end">才能完成</option>
						</select>
			 		</td>
			    </tr>
			    <tr>
			      	<td class="text-center">3<input type="hidden" name="newid[1]" id="newid[1]" value="1">
					</td>
					<td style="overflow:visible">
					<select class="form-control chosen chosen-select">
						<option value=""></option>
						<option value="73">A:admin</option>
						<option value="77">D:demo</option>
						<option value="78">D:开发甲</option>
						<option value="79">P:项目经理</option>
						<option value="80">T:测试乙</option>
					</select>
			 		</td>
					<td>
					<select class="form-control">
					<option value="" selected="selected"></option>
					<option value="begin">开始后</option>
					<option value="end">完成后</option>
					</select>
					</td>
					<td style="overflow:visible">
					<select name="newpretask[1]" id="newpretask1" class="form-control chosen chosen-select">
						<option value="" selected="selected"></option>
						<option value="184">184::333</option>
						<option value="183">183::1234</option>
						<option value="178">178::121212121</option>
						<option value="177">177::12121212</option>
						<option value="175">175::数据库优化</option>
						<option value="174">174:Demo:排队积分</option>
						<option value="173">173:Demo:排队积分</option>
						<option value="172">172:Demo:排队积分</option>
						<option value="171">171:Demo:第二个模块</option>
						<option value="170">170:Demo:第一个模块</option>
					</select>
			 		</td>
					<td><select name="newaction[1]" id="newaction1" class="form-control">
						<option value="" selected="selected"></option>
						<option value="begin">才能开始</option>
						<option value="end">才能完成</option>
						</select>
			 		</td>
			    </tr>
			    <tr>
			      	<td class="text-center">4<input type="hidden" name="newid[1]" id="newid[1]" value="1">
					</td>
					<td style="overflow:visible">
					<select class="form-control chosen chosen-select">
						<option value=""></option>
						<option value="73">A:admin</option>
						<option value="77">D:demo</option>
						<option value="78">D:开发甲</option>
						<option value="79">P:项目经理</option>
						<option value="80">T:测试乙</option>
					</select>
			 		</td>
					<td>
					<select class="form-control">
					<option value="" selected="selected"></option>
					<option value="begin">开始后</option>
					<option value="end">完成后</option>
					</select>
					</td>
					<td style="overflow:visible">
					<select name="newpretask[1]" id="newpretask1" class="form-control chosen chosen-select">
						<option value="" selected="selected"></option>
						<option value="184">184::333</option>
						<option value="183">183::1234</option>
						<option value="178">178::121212121</option>
						<option value="177">177::12121212</option>
						<option value="175">175::数据库优化</option>
						<option value="174">174:Demo:排队积分</option>
						<option value="173">173:Demo:排队积分</option>
						<option value="172">172:Demo:排队积分</option>
						<option value="171">171:Demo:第二个模块</option>
						<option value="170">170:Demo:第一个模块</option>
					</select>
			 		</td>
					<td><select name="newaction[1]" id="newaction1" class="form-control">
						<option value="" selected="selected"></option>
						<option value="begin">才能开始</option>
						<option value="end">才能完成</option>
						</select>
			 		</td>
			    </tr>
				</tbody>
				<tfoot>
			    <tr>
			      <td colspan="5" class="text-center">
			      <button type="submit" id="submit" class="btn btn-primary" data-loading="稍候...">保存</button>
			      <a href="javascript:history.go(-1);" class="btn btn-back ">返回</a>
			      </td>
				</tr>
			    </tfoot>
			  </table>
			</form>
</div>
</div>
</body>
</html>