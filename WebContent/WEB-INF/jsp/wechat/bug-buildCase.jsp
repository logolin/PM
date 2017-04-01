<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/wxcss/style.css" rel="stylesheet"/>
<script src="../resources/zui/assets/jquery.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/zui/dist/lib/chosen/chosen.min.js"></script>
<title>Bug建用例</title>
</head>
<body>
	<form action="" method="post" onsubmit="return check()">
		<div class="title">
			<h2>建用例</h2>
		</div>
		<div class="main-wrap">
			<div class="info ">
				<label>所属产品</label>
				<select class="chosen-select form-control" name="product_id" id="product" onchange="getChange(this.value)">
					<option value=""></option>
					<c:forEach items="${productList}" var="pro">
						<option value="${pro.id}" <c:if test="${pro.id == bug.product.id}">selected</c:if>>${pro.name}</option>
					</c:forEach>
				</select>
			</div>
			<div class="info" id="branchIdBox">
				<label>所属平台</label>
				<select class="chosen-select chosen form-control" name="branch_id" id="branch">
					<option></option>
				</select>
			</div>
			<div class="info" id="moduleIdBox">
				<label>所属模块</label>
				<select class="chosen-select chosen form-control" name="module_id" id="module">
					<option></option>
				</select>
			</div>
			<div class="info">
				<label>用例类型<small>(必填项)</small></label>
				<select class="chosen-select form-control" name="type" id="type">
					<option value=""></option>
					<option value="feature">功能测试</option>
					<option value="performance">性能测试</option>
					<option value="config">配置相关</option>
					<option value="install">安装部署</option>
					<option value="security">安全相关</option>
					<option value="interface">接口测试</option>
					<option value="other">其他</option>
				</select>
			</div>
			<div class="info">
				<label>适用阶段</label>
				<select class="chosen-select form-control" name="stage" id="stage">
					<option value="" selected></option>
					<option value="unittest">单元测试阶段</option>
					<option value="feature">功能测试阶段</option>
					<option value="intergrate">集成测试阶段</option>
					<option value="system">系统测试阶段</option>
					<option value="smoke">冒烟测试阶段</option>
					<option value="bvt">版本验证阶段</option>
				</select>
			</div>
			<div class="info" id="storyIdBox">
				<label>相关需求</label>
				<select class="chosen-select chosen form-control" name="story_id" id="story">
					<option></option>
				</select>
			</div>
			<div class="info">
				<label>用例标题<small>(必填项)</small></label>
				<input type="text" class="form-control" name="title" id="title" value="${bug.title}"> 
			</div>
			<div class="info">
				<label>优先级<small>(必填项)</small></label>
				<select class="chosen-select form-control" name="pri" id="pri">
					<option value="0" <c:if test="${bug.pri == 0}">selected</c:if>></option>
					<option value="1" <c:if test="${bug.pri == 1}">selected</c:if>>1</option>
					<option value="2" <c:if test="${bug.pri == 2}">selected</c:if>>2</option>
					<option value="3" <c:if test="${bug.pri == 3}">selected</c:if>>3</option>
					<option value="4" <c:if test="${bug.pri == 4}">selected</c:if>>4</option>
				</select>
			</div>
			<div class="info">
				<label>前提条件</label>
				<textarea id="precondition" name="precondition" class="form-control"></textarea>
			</div>
			<div class="info">
				<label>用例步骤</label>
				<textarea id="step" name="step" class="form-control"></textarea>
			</div>
			<div class="info" >
				<label>关键字</label>
				<input type="text" name="keywords" id="keywords" value = "${bug.keywords}" class="form-control">
			</div>
			<!-- 	附件 -->
<!-- 			<div class="info panel" > -->
<!-- 				<div class="panel-heading"> -->
<!-- 					<label><i class="icon icon-file-o"></i>&nbsp;附件</label> -->
<!-- 				</div> -->
<!-- 				<div class=" panel-body"> -->
				  
				 
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
		<!-- 		按钮 -->
		<div class="btn1 " style="text-align: center;"> 
		  <button type="submit" data-loading="稍候..." class="btn btn-lg btn-save">保存</button>
		  <button type="button" data-loading="稍候..." class="btn btn-lg btn-save" onclick="history.go(-1)">返回</button>
		</div>
	</form>
</body>
<script type="text/javascript">
	$(function() {
		//单项选择
		$('select.chosen-select').chosen({
		    no_results_text: '没有找到',    // 当检索时没有找到匹配项时显示的提示文本
		    disable_search_threshold: 10, // 10 个以下的选择项则不显示检索框
		    search_contains: true,         // 从任意位置开始检索
		    allow_single_deselect:true,
		});
		getChange("${bug.product.id}");
	});
	function getChange(productId) {
		//获取模块列表
		getProductModules(productId);
		//获取相关需求
		getProductStorys(productId);
		//获取平台列表
		getProductBranch(productId);
	}
	//根据productId获取模块
	function getProductModules(productId) {
		//通过链接获取方法返回值（tree）
		$.get("../ajaxGetModulesForproduct/" + productId, function(data) {
			//移去原模块list
			$("#module, #module + div, #module + div +span").remove();
			//添加新模块list
			$("#moduleIdBox").append("<select name='module_id' id='module' class='chosen-select chosen form-control'></select>");
			//添加模块list默认值"/"
			$("#module").append("<option value='0' select>/</option>");
			//若模块list不为空，执行循环
			if(!$.isEmptyObject(data)) {
				iterateTree(data,"");
			}
			$("select.chosen").chosen ({
				no_results_text:'没有找到',
				search_contains:true,
			});
		})
	}
	//模块list分隔显示出来
	function iterateTree(data,name) {
		var modId = ${bug.module_id};
		for (var i = 0; i < data.length; i++) {
			a = name + "/" + data[i].name;
			s = modId == data[i].id ? "selected" : "";
			$("#module").append("<option value='" + data[i].id + "' "+ s +">" + a + "</option>");
			iterateTree(data[i].children,a);
		}
	} 
	//获取相关需求list
	function getProductStorys(productId) {
		$.get("../getPdStorys/"+ productId,function(data){
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#story").remove();
			//添加需求list
			$("#storyIdBox").append("<select name='story_id' id='story' class='chosen-select chosen form-control'></select>");
			//添加需求list默认值
			$("#story").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var styId = ${bug.story_id};
				for (var i = 0; i < data.length; i++) {
					s = styId == data[i].id ? "selected" : "";
					$("#story").append("<option value='" + data[i].id + "' "+ s +">" + data[i].id + ":"+ data[i].title +" (优先级："+data[i].pri+","+"预计工时："+data[i].estimate+")</option>");
				}
			}
		})
	}
	//获取相关平台list
	function getProductBranch(productId) {
		$.get("../getPdBranch/"+ productId,function(data){
			$("select.chosen").chosen({
			    no_results_text: '没有找到',    
			    search_contains: true,      
			});	
			//移去需求list
			$("#branch").remove();
			//添加需求list
			$("#branchIdBox").append("<select name='branch_id' id='branch' class='chosen-select chosen form-control'></select>");
			//添加需求list默认值
			$("#branch").append("<option value='0' selected></option>");
			//若需求list不为空，执行循环，添加需求list显示出来
			if (!$.isEmptyObject(data)) {
				var branchId = ${bug.branch_id};
				for (var i = 0; i < data.length; i++) {
					b = branchId == data[i].id ? "selected" : "";
					$("#branch").append("<option value='" + data[i].id + "' "+ b +">" + data[i].name +"</option>");
				}
			}
		})
	}
	//检查
	function check() {
		var type = $('#type').val();
		var title = $('#title').val();
		var pri = $('#pri').val();
		if(!type) {
			alert('“用例类型”不能为空！');
			return false;
		}
		if(!title) {
			alert('“用例标题”不能为空！');
			return false;
		}
		if(pri == 0) {
			alert('“优先级”不能为空！');
			return false;
		}
	}
	
</script>
</html>