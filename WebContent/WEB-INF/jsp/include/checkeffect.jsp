<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
      					<tr>
        					<th>检查影响</th>
        					<td colspan="2">
        						<div class="tabs">
  									<ul class="nav nav-tabs">
    									<li class="active"><a data-toggle="tab" href="#affectedProjects">影响的项目 <span class="label label-danger label-badge label-circle">${fn:length(projectList)}</span> </a></li>
    									<li class=""><a data-toggle="tab" href="#affectedBugs">影响的Bug <span class="label label-danger label-badge label-circle">${fn:length(bugList)}</span></a></li>
    									<li class=""><a data-toggle="tab" href="#affectedCases">影响的用例 <span class="label label-danger label-badge label-circle">${fn:length(caseList)}</span></a></li>
  									</ul>
  									<div class="tab-content">
    									<div class="tab-pane active" id="affectedProjects">
    										<c:forEach items="${projectList}" var="project">
	    										<h6>
	    											<i class="icon-folder-close-alt icon"></i> 
	    											<strong>${project[1]}</strong> &nbsp; 
	    											<small><i class="icon-group"></i> ${fn:toUpperCase(fn:substring(project[2],0,1))}:${project[3]} </small>
	    										</h6>
	          									<table class="table table-borderless table-condensed">
									            	<thead>
									             		<tr>
											              	<th>编号</th>
											              	<th>任务名称</th>
											              	<th>指派给</th>
											              	<th>任务状态</th>
											              	<th>总消耗</th>
											              	<th>预计剩余</th>
									            		</tr>
	            									</thead>
	                      							<tbody class="">
	                      								<c:forEach items="${project[4]}" var="task">
		              										<tr class="text-center">
		                										<td>${task[0]}</td>
		                										<td class="text-left">
		                											<a href="../project/task_view_${task[0]}" target="_blank">${task[1]}</a>
																</td>
		                										<td>${fn:toUpperCase(fn:substring(task[2],0,1))}:${task[6]}</td>
		                										<td class="task-${task[3]}">
		                											<c:choose>
		                												<c:when test="${task[3]=='wait'}">未开始</c:when>
		                												<c:when test="${task[3]=='doing'}">进行中</c:when>
		                												<c:when test="${task[3]=='done'}">已完成</c:when>
		                												<c:when test="${task[3]=='pause'}">已暂停</c:when>
		                												<c:when test="${task[3]=='cancel'}">已取消</c:when>
		                												<c:when test="${task[3]=='closed'}">已关闭</c:when>
		                												<c:otherwise></c:otherwise>
		                											</c:choose>
		                										</td>
		                										<td>${task[4]}</td>
		                										<td>${task[5]}</td>
		              										</tr>
		              									</c:forEach>
		              									</tbody>
		               								</table>
               								</c:forEach>
          								</div>
    									<div class="tab-pane" id="affectedBugs">
      										<table class="table table-borderless table-condensed">
        										<thead>
          											<tr>
											            <th class="w-60px">Bug编号</th>
											            <th>Bug标题</th>
											            <th class="w-60px">Bug状态</th>
											            <th class="w-70px">由谁创建</th>
											            <th>解决者</th>
											            <th>解决方案</th>
											            <th>最后修改者</th>
          											</tr>
        										</thead>
        										<tbody class="">
        											<c:forEach items="${bugList}" var="bug">
	        											<tr class='text-center'>
	        												<td>${bug[0]}</td>
	            											<td class='text-left'>
	            												<a href=''  target='_blank'>${bug[1]}</a>
	            											</td>
	            											<td class='bug-${bug[2]}'>
	            												<c:choose>
	            													<c:when test="${bug[2]=='active'}">激活</c:when>
	            													<c:when test="${bug[2]=='closed'}">已关闭</c:when>
	            													<c:when test="${bug[2]=='resolved'}">已解决</c:when>
	            													<c:otherwise></c:otherwise>
	            												</c:choose>
	            											</td>
	            											<td>${fn:toUpperCase(fn:substring(bug[3],0,1))}:${bug[7]}</td>
												            <td>${fn:toUpperCase(fn:substring(bug[4],0,1))}:${bug[8]}</td>
												            <td>
												            	<c:choose>
												            		<c:when test="${bug[5]=='bydesign'}">设计如此</c:when>
												            		<c:when test="${bug[5]=='duplicate'}">重复Bug</c:when>
												            		<c:when test="${bug[5]=='external'}">外部原因</c:when>
												            		<c:when test="${bug[5]=='fixed'}">已解决</c:when>
												            		<c:when test="${bug[5]=='notrepro'}">无法重现</c:when>
												            		<c:when test="${bug[5]=='postponed'}">延期处理</c:when>
												            		<c:when test="${bug[5]=='willnotfix'}">不予解决</c:when>
												            		<c:otherwise></c:otherwise>
												            	</c:choose>
												            </td>
												            <td>${fn:toUpperCase(fn:substring(bug[6],0,1))}:${bug[9]}</td>
	          											</tr>
          											</c:forEach>
                  								</tbody>
      										</table>
    									</div>
    									<div class="tab-pane" id="affectedCases">
      										<table class="table table-borderless table-condensed">
        										<thead>
          											<tr>
											            <th class="w-70px">用例编号</th>
											            <th>用例标题</th>
											            <th class="w-70px">用例状态</th>
											            <th class="w-70px">由谁创建 </th>
											            <th>最后修改者</th>
          											</tr>
        										</thead>
        										<tbody class="">
        											<c:forEach items="${caseList}" var="cas">
	                  									<tr class="text-center">
	            											<td>${cas[0]}</td>
												            <td class="text-left">
												            	<a href="" target="_blank">${cas[1]}</a>
															</td>
												            <td class="case-${cas[2]}">
												            	<c:choose>
												            		<c:when test="${cas[2]=='normal'}">正常</c:when>
												            		<c:when test="${cas[2]=='blocked'}">被阻塞</c:when>
												            		<c:when test="${cas[2]=='investigate'}">研究中</c:when>
												            		<c:otherwise></c:otherwise>
												            	</c:choose>
												            </td>
												            <td>${fn:toUpperCase(fn:substring(cas[3],0,1))}:${cas[5]}</td>
												            <td>${fn:toUpperCase(fn:substring(cas[4],0,1))}:${cas[6]}</td>
	          											</tr>
          											</c:forEach>
                  								</tbody>
      										</table>
   										</div>
  									</div>
								</div>
							</td>
      					</tr>