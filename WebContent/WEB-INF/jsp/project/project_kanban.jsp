<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang='zh-cn'>
<head>
<meta charset='utf-8'>
<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<meta name="renderer" content="webkit"> 
<link href="../resources/dist/css/default.css" rel="stylesheet"/>
<link href="../resources/dist/css/kanban.css" rel="stylesheet"/>
<script src='../resources/dist/js/all.js'></script>
<title>看板</title>
  
<script language='Javascript'>
var config={"webRoot":"\/","appName":"","cookieLife":30,"requestType":"PATH_INFO","requestFix":"-","moduleVar":"m","methodVar":"f","viewVar":"t","defaultView":"html","themeRoot":"\/theme\/","currentModule":"project","currentMethod":"kanban","clientLang":"zh-cn","requiredFields":"","router":"\/index.php","save":"\u4fdd\u5b58","runMode":"","timeout":30000,"pingInterval":""};
var lang={"submitting":"\u7a0d\u5019...","save":"\u4fdd\u5b58","timeout":"\u8fde\u63a5\u8d85\u65f6\uff0c\u8bf7\u68c0\u67e5\u7f51\u7edc\u73af\u5883\uff0c\u6216\u91cd\u8bd5\uff01"};
</script>
</head>
<body>
	<header id="header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp"%>
		<%@ include file="/WEB-INF/jsp/include/projectmenu.jsp" %>
	</header>
<div id='wrap'>
  <div class='outer'>
		<%@ include file="/WEB-INF/jsp/include/taskhead.jsp" %>
		<div id="kanban">
			<table class="boards-layout table" id="kanbanHeader">
			    <thead>
	      			<tr>
	                	<th class='w-p15 col-story'>
				          <div class='dropdown inline-block'>
				            <a data-toggle='dropdown' href="${ctxpj}/project_kanban_${project.id}-pri_asc">需求优先级正序 <span class='icon-caret-down'></span> </a>
				            <ul class='dropdown-menu text-left'>
				            	<li><a href="${ctxpj}/project_kanban_${project.id}-pri_asc" >需求优先级正序</a>
				                <li ><a href="${ctxpj}/project_kanban_${project.id}-pri_desc" >需求优先级倒序</a>
				             	<li ><a href="${ctxpj}/project_kanban_${project.id}-id_asc" >需求ID正序</a>
				              	<li ><a href="${ctxpj}/project_kanban_${project.id}-id_desc" >需求ID倒序</a>
				             	<li ><a href="${ctxpj}/project_kanban_${project.id}-stage_asc" >需求阶段正序</a>
				             	<li ><a href="${ctxpj}/project_kanban_${project.id}-stage_desc" >需求阶段倒序</a>
				      		</ul>
				          </div>
	                	</th>
	                	<th class="col-wait">未开始</th>
				        <th class="col-doing">进行中</th>
				        <th class="col-done">已完成</th>
				        <th class="col-cancel">已取消</th>
				        <th class="col-closed">已关闭         
				        <div class="actions"></div>
				        </th>
	      			</tr>
    			</thead>
			</table>
    		<table class='boards-layout table active-disabled table-bordered' id='kanbanWrapper'>
    			<thead>
      				<tr>
				        <th class='w-p15 col-story'> </th>
			            <th class='col-wait'></th>
			            <th class='col-doing'></th>
			            <th class='col-done'></th>
			            <th class='col-cancel'></th>
			            <th class='col-closed'></th>      
			       </tr>
    			</thead>
    			<tbody>
    			<c:forEach items="${map}" var="map" varStatus="vs">
                	<tr data-id='0'>
                		<td class='col-story'>
                		<c:if test="${map.key.id != null}">
				            <div class='board board-story stage-projected' data-id='80'>
					            <div class='board-title'>
					              <a href='' class="kanbanFrame" title="${map.key.title}">${map.key.title}</a>
					              <div class='board-actions'>
					                <button type='button' class='btn btn-mini btn-link btn-info-toggle'><i class='icon-angle-down'></i></button>
					                <div class='dropdown'>
					                  <button type='button' class='btn btn-mini btn-link dropdown-toggle' data-toggle='dropdown'>
					                    <span class='icon-ellipsis-v'></span>
					                  </button>
					                  <div class='dropdown-menu pull-right'>
					                    <a href='' class='kanbanFrame'>分解任务</a>
										<a href=''  target='hiddenwin'>移除需求</a>
										<a href='' class='kanbanFrame'>关闭</a>
					                  </div>
					                </div>
					              </div>
					            </div>
					            <div class='board-footer clearfix'>
					              <span class='story-id board-id' title='编号'>${map.key.id}</span> 
					              <span class='story-pri pri-${map.key.pri}' title='优先级'></span>
					              <span class='story-stage' title='所处阶段'>${map.key.stage}</span>
					              <div class='pull-right story-estimate' title='预计工时'>${map.key.estimate}h </div>
					            </div>
					          </div>
					    </c:if>
	                	</td>
	                    <td class="col-droppable col-wait" data-id="wait">
	                    <c:forEach items="${map.value}" var="tasklist">
                		<c:if test="${tasklist.key == 'waitTask'}">
                			<c:forEach items="${tasklist.value}" var="task">
	                   		<div class="board board-task board-task-wait" data-id="" id="task-">
	            				<div class="board-title">
	              					<a href="" class="kanbanFrame" title="${task.name}">${task.name}</a>
					              	<div class="board-actions">
							        	<button type="button" class="btn btn-mini btn-link btn-info-toggle"><i class="icon-angle-down"></i></button>
							            <div class="dropdown">
							            	<button type="button" class="btn btn-mini btn-link dropdown-toggle" data-toggle="dropdown">
							                    <span class="icon-ellipsis-v"></span>
							                </button>
							                <div class="dropdown-menu pull-right">
							                    <a href="" class="kanbanFrame">指派</a>
												<a href="" class="kanbanFrame">完成</a>
												<a href="" class="kanbanFrame">取消</a>
												<a href="" class="kanbanFrame">编辑</a>
												<a href="" target="hiddenwin">删除</a>
							                </div>
							            </div>
					              	</div>
	            				</div>
					            <div class="board-footer clearfix">
					            	<span class="task-id board-id" title="编号">${task.id}</span> 
					              	<span class="task-pri pri-${task.pri}" title="优先级"></span>
					              	<span class="task-assignedTo" title="指派给">
					                <a href="" class="kanbanFrame"><i class="icon-hand-right"></i></a>
					                <small>${task.assignedTo}</small>
					              	</span>
					              	<div class="pull-right">
					                	<span class="task-left" title="预计剩余">${task.remain}h </span>
					              	</div>
					            </div>
	                   		</div>
				  			</c:forEach>
				  		</c:if>
				  		</c:forEach>
	                	</td>
                		<td class="col-droppable col-doing" data-id="doing">
                		<c:forEach items="${map.value}" var="tasklist">
                		<c:if test="${tasklist.key == 'doingTask'}">
                			<c:forEach items="${tasklist.value}" var="task">
	                   		<div class="board board-task board-task-doing" data-id="" id="task-">
	            				<div class="board-title">
	              					<a href="" class="kanbanFrame" title="${task.name}">${task.name}</a>
					              	<div class="board-actions">
							        	<button type="button" class="btn btn-mini btn-link btn-info-toggle"><i class="icon-angle-down"></i></button>
							            <div class="dropdown">
							            	<button type="button" class="btn btn-mini btn-link dropdown-toggle" data-toggle="dropdown">
							                    <span class="icon-ellipsis-v"></span>
							                </button>
							                <div class="dropdown-menu pull-right">
							                    <a href="" class="kanbanFrame">指派</a>
												<a href="" class="kanbanFrame">完成</a>
												<a href="" class="kanbanFrame">取消</a>
												<a href="" class="kanbanFrame">编辑</a>
												<a href="" target="hiddenwin">删除</a>
							                </div>
							            </div>
					              	</div>
	            				</div>
					            <div class="board-footer clearfix">
					            	<span class="task-id board-id" title="编号">${task.id}</span> 
					              	<span class="task-pri pri-${task.pri}" title="优先级"></span>
					              	<span class="task-assignedTo" title="指派给">
					                <a href="" class="kanbanFrame"><i class="icon-hand-right"></i></a>
					                <small>${task.assignedTo}</small>
					              	</span>
					              	<div class="pull-right">
					                	<span class="task-left" title="预计剩余">${task.remain}h </span>
					              	</div>
					            </div>
	                   		</div>
				  			</c:forEach>
				  		</c:if>
				  		</c:forEach>
                	</td>
                	<td class="col-droppable col-done" data-id="done">
                	<c:forEach items="${map.value}" var="tasklist">
                		<c:if test="${tasklist.key == 'doneTask'}">
                			<c:forEach items="${tasklist.value}" var="task">
	                    	<div class="board board-task board-task-done">
					            <div class="board-title">
					              <a href="" class="kanbanFrame" title="${task.name}">${task.name}</a>
					              <div class="board-actions">
					                <button type="button" class="btn btn-mini btn-link btn-info-toggle"><i class="icon-angle-down"></i></button>
					                <div class="dropdown">
					                  <button type="button" class="btn btn-mini btn-link dropdown-toggle" data-toggle="dropdown">
					                    <span class="icon-ellipsis-v"></span>
					                  </button>
					                  <div class="dropdown-menu pull-right">
					                    <a href="" class="kanbanFrame">指派</a>
										<a href="" class="kanbanFrame">激活</a>
										<a href="" class="kanbanFrame">关闭</a>
										<a href="" class="kanbanFrame">编辑</a>
										<a href="" target="hiddenwin">删除</a>
					                  </div>
					                </div>
					              </div>
					            </div>
					            <div class="board-footer clearfix">
					              <span class="task-id board-id" title="编号">${task.id}</span> 
					              <span class="task-pri pri-2" title="优先级"></span>
					              <span class="task-assignedTo" title="指派给">
					                <a href="" class="kanbanFrame"><i class="icon-hand-right"></i></a>
					                <small>${task.assignedTo}</small>
					              </span>
					              <div class="pull-right">
					                <span class="task-left" title="预计剩余">$s{task.remain}h </span>
					              </div>
					            </div>
	                    	</div>
                        </c:forEach>
				  	</c:if>
				  	</c:forEach>
                	</td>
                	<td class="col-droppable col-cancel" data-id="cancel">
                    <c:forEach items="${map.value}" var="tasklist">
                		<c:if test="${tasklist.key == 'cancelTask'}">
                			<c:forEach items="${tasklist.value}" var="task">
	                    	<div class="board board-task board-task-cancel">
					            <div class="board-title">
					              <a href="" class="kanbanFrame" title="${task.name}">${task.name}</a>
					              <div class="board-actions">
					                <button type="button" class="btn btn-mini btn-link btn-info-toggle"><i class="icon-angle-down"></i></button>
					                <div class="dropdown">
					                  <button type="button" class="btn btn-mini btn-link dropdown-toggle" data-toggle="dropdown">
					                    <span class="icon-ellipsis-v"></span>
					                  </button>
					                  <div class="dropdown-menu pull-right">
					                    <a href="" class="kanbanFrame">指派</a>
										<a href="" class="kanbanFrame">激活</a>
										<a href="" class="kanbanFrame">关闭</a>
										<a href="" class="kanbanFrame">编辑</a>
										<a href="" target="hiddenwin">删除</a>
					                  </div>
					                </div>
					              </div>
					            </div>
					            <div class="board-footer clearfix">
					              <span class="task-id board-id" title="编号">${task.id}</span> 
					              <span class="task-pri pri-2" title="优先级"></span>
					              <span class="task-assignedTo" title="指派给">
					                <a href="" class="kanbanFrame"><i class="icon-hand-right"></i></a>
					                <small>${task.assignedTo}</small>
					              </span>
					              <div class="pull-right">
					                <span class="task-left" title="预计剩余">$s{task.remain}h </span>
					              </div>
					            </div>
	                    	</div>
                        </c:forEach>
				  	</c:if>
				  	</c:forEach>    
                	</td> 
                	<td class="col-droppable col-closed" data-id="closed">
                    <c:forEach items="${map.value}" var="tasklist">
                		<c:if test="${tasklist.key == 'closedTask'}">
                			<c:forEach items="${tasklist.value}" var="task">
	                    	<div class="board board-task board-task-closed">
					            <div class="board-title">
					              <a href="" class="kanbanFrame" title="${task.name}">${task.name}</a>
					              <div class="board-actions">
					                <button type="button" class="btn btn-mini btn-link btn-info-toggle"><i class="icon-angle-down"></i></button>
					                <div class="dropdown">
					                  <button type="button" class="btn btn-mini btn-link dropdown-toggle" data-toggle="dropdown">
					                    <span class="icon-ellipsis-v"></span>
					                  </button>
					                  <div class="dropdown-menu pull-right">
					                    <a href="" class="kanbanFrame">指派</a>
										<a href="" class="kanbanFrame">激活</a>
										<a href="" class="kanbanFrame">关闭</a>
										<a href="" class="kanbanFrame">编辑</a>
										<a href="" target="hiddenwin">删除</a>
					                  </div>
					                </div>
					              </div>
					            </div>
					            <div class="board-footer clearfix">
					              <span class="task-id board-id" title="编号">${task.id}</span> 
					              <span class="task-pri pri-2" title="优先级"></span>
					              <span class="task-assignedTo" title="指派给">
					                <a href="" class="kanbanFrame"><i class="icon-hand-right"></i></a>
					                <small>${task.assignedTo}</small>
					              </span>
					              <div class="pull-right">
					                <span class="task-left" title="预计剩余">$s{task.remain}h </span>
					              </div>
					            </div>
	                    	</div>
                        </c:forEach>
				  	</c:if>
				  	</c:forEach>
                	</td>
              </tr>
              </c:forEach>
          </tbody>
  </table>
</div>
<script>
var projectID = 54;
$('#kanbanTab').addClass('active');
</script>
</div>  <script>setTreeBox()</script>
<script>config.onlybody = 'no';</script>
<script src="../resources/dist/js/kanban.js"></script>
<div class='hidden'><script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_4553360'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s5.cnzz.com/stat.php%3Fid%3D4553360' type='text/javascript'%3E%3C/script%3E"));</script></div>
</body>
</html>
