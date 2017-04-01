<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="../resources/dist/css/zui.min.css" rel="stylesheet"/>
<link href="../resources/style.css" rel="stylesheet"/>
<link href="../resources/dist/lib/chosen/chosen.min.css" rel="stylesheet"/>
<script src="../resources/jquery-1.12.4.min.js"></script>
<script src="../resources/dist/js/zui.min.js"></script>
<script src="../resources/dist/lib/chosen/chosen.min.js"></script>
<title>导出</title>
<style>
a>div>b {
	margin-top: 9px;
}
</style>
<script type="text/javascript">
$(function(){
	$("select.chosen-select").chosen({no_results_text: '没有匹配结果', width:'100%', allow_single_deselect: true, disable_search_threshold: 1, placeholder_text_single: ' ', placeholder_text_multiple: ' ', search_contains: true})
})

function setDownloading()
{
    if($.browser.opera) return true;   // Opera don't support, omit it.

    $.cookie('downloading', 0);
    time = setInterval("closeWindow()", 300);
    return true;
}

function switchEncode(fileType)
{
    $('#encode').removeAttr('disabled');
    if(fileType != 'csv')
    {
        $('#encode').val('utf-8');
        $('#encode').attr('disabled', 'disabled');
    }
}

function setExportTPL()
{
    $('#customFields').toggle();
    $('.mb-150px').toggle();
}

function saveTemplate()
{
    var $inputGroup = $('#customFields div.input-group');
    var $publicBox  = $inputGroup.find('input[id^="public"]');
    var title       = $inputGroup.find('#title').val();
    var content     = $('#customFields #exportFields').val();
    var isPublic    = ($publicBox.size() > 0 && $publicBox.prop('checked')) ? $publicBox.val() : 0;
    if(!title || !content) return;
    saveTemplateLink = '/file-ajaxSaveTemplate-story.html';
    $.post(saveTemplateLink, {title:title, content:content, public:isPublic}, function(data)
    {
        var defaultValue = $('#tplBox #template').val();
        $('#tplBox').html(data);
        if(data.indexOf('alert') >= 0) $('#tplBox #template').val(defaultValue);
        $("#tplBox #template").chosen(defaultChosenOptions).on('chosen:showing_dropdown', function()
        {
            var $this = $(this);
            var $chosen = $this.next('.chosen-container').removeClass('chosen-up');
            var $drop = $chosen.find('.chosen-drop');
            $chosen.toggleClass('chosen-up', $drop.height() + $drop.offset().top - $(document).scrollTop() > $(window).height());
        });
        $inputGroup.find('#title').val('');
    });
}

/* Set template. */
function setTemplate(templateID)
{
    $template    =  $('#tplBox #template' + templateID);
    exportFields = $template.size() > 0 ? $template.html() : defaultExportFields;
    exportFields = exportFields.split(',');
    $('#exportFields').val('');
    for(i in exportFields) $('#exportFields').find('option[value="' + exportFields[i] + '"]').attr('selected', 'selected');
    $('#exportFields').trigger("chosen:updated");
}

/* Delete template. */
function deleteTemplate()
{
    templateID = $('#tplBox #template').val();
    if(templateID == 0) return;
    hiddenwin.location.href = createLink('file', 'ajaxDeleteTemplate', 'templateID=' + templateID);
    $('#tplBox #template').find('option[value="'+ templateID +'"]').remove();
    $('#tplBox #template').trigger("chosen:updated");
    $('#tplBox #template').change();
}

</script>
</head>
<body>
	<div id="titlebar">
  		<div class="heading">
    		<span class="prefix"><i class="icon-download-alt"></i></span>
    		<strong>导出</strong>
  		</div>
	</div>
	<form class="form-condensed" method="post" target="hiddenwin" style="padding: 40px 1% 50px">
  		<table class="w-p100 table-fixed">
    		<tbody>
    			<tr>
      				<td>
        				<div class="input-group">
          					<span class="input-group-addon">文件名：</span>
          					<input type="text" name="fileName" id="fileName" value="" class="form-control">
        				</div>
      				</td>
      				<td class="w-60px">
        				<select name="fileType" id="fileType" onchange="switchEncode(this.value)" class="form-control">
							<option value="word">word</option>
							<option value="xlsx">xlsx</option>
							<option value="xls">xls</option>
							<option value="csv">csv</option>
							<option value="xml">xml</option>
							<option value="mht">mht</option>
						</select>
      				</td>
      				<td class="w-80px">
        				<select name="encode" id="encode" class="form-control" disabled="disabled">
							<option value="utf-8" selected="selected">UTF-8</option>
							<option value="gbk">GBK</option>
						</select>
      				</td>
      				<td class="w-90px">
	        			<select name="exportType" id="exportType" class="form-control">
							<option value="all" selected="selected">全部记录</option>
							<option value="selected">选中记录</option>
						</select>
      				</td>
            		<td class="w-110px" style="overflow:visible">
        				<span id="tplBox">
        					<select name="template" id="template" class="form-control chosen-select" onchange="setTemplate(this.value)">
								<option value="0" selected="selected">默认模板</option>
							</select>
						</span>
      				</td>
            		<td style="width:94px">
        				<div class="input-group">
           					<button type="submit" id="submit" class="btn btn-primary" onclick="setDownloading();" data-loading="稍候...">导出</button>                    
           					<button type="button" onclick="setExportTPL()" class="btn">设置</button>
                  		</div>
      				</td>
    			</tr>
  			</tbody>
		</table>
      	<div class="mb-150px" style="margin-bottom:245px">
      	</div>
  		<div class="panel" id="customFields" style="margin-bottom:150px;display:none">
    		<div class="panel-heading"><strong>要导出字段</strong></div>
    		<div class="panel-body">
      			<p>
      				<select name="exportFields[]" id="exportFields" class="form-control chosen-select" multiple="">
						<option value="id" selected="selected">编号</option>
						<option value="product" selected="selected">所属产品</option>
						<option value="module" selected="selected">所属模块</option>
						<option value="plan" selected="selected">所属计划</option>
						<option value="source" selected="selected">需求来源</option>
						<option value="title" selected="selected">需求名称</option>
						<option value="spec" selected="selected">需求描述</option>
						<option value="verify" selected="selected">验收标准</option>
						<option value="keywords" selected="selected">关键词</option>
						<option value="pri" selected="selected">优先级</option>
						<option value="estimate" selected="selected">预计工时</option>
						<option value="status" selected="selected">当前状态</option>
						<option value="stage" selected="selected">所处阶段</option>
						<option value="openedBy" selected="selected">由谁创建</option>
						<option value="openedDate" selected="selected">创建日期</option>
						<option value="assignedTo" selected="selected">指派给</option>
						<option value="assignedDate" selected="selected">指派日期</option>
						<option value="mailto" selected="selected">抄送给</option>
						<option value="reviewedBy" selected="selected">由谁评审</option>
						<option value="reviewedDate" selected="selected">评审时间</option>
						<option value="closedBy" selected="selected">由谁关闭</option>
						<option value="closedDate" selected="selected">关闭日期</option>
						<option value="closedReason" selected="selected">关闭原因</option>
						<option value="lastEditedBy" selected="selected">最后修改</option>
						<option value="lastEditedDate" selected="selected">最后修改日期</option>
						<option value="childStories" selected="selected">细分需求</option>
						<option value="linkStories" selected="selected">相关需求</option>
						<option value="duplicateStory" selected="selected">重复需求</option>
						<option value="files" selected="selected">附件</option>
					</select>
				</p>
      			<div>
        			<div class="input-group">
          				<span class="input-group-addon">模板名称</span>
          				<input type="text" name="title" id="title" value="" class="form-control">
                    	<span class="input-group-addon">
                    		<label class="checkbox-inline">
                    			<input type="checkbox" name="public[]" value="1" id="public1"> 
                    			公共
                   			</label>
               			</span>
                   		<span class="input-group-btn">
                   			<button id="saveTpl" type="button" onclick="saveTemplate()" class="btn btn-primary">保存</button>
               			</span>
          				<span class="input-group-btn">
          					<button type="button" onclick="deleteTemplate()" class="btn">删除</button>
       					</span>
        			</div>
      			</div>
    		</div>
  		</div>
  		<script language="Javascript">
  		defaultExportFields = "id,product,module,plan,source,title,spec,verify,keywords,pri,estimate,status,stage,openedBy,openedDate,assignedTo,assignedDate,mailto,reviewedBy,reviewedDate,closedBy,closedDate,closedReason,lastEditedBy,lastEditedDate,childStories,linkStories,duplicateStory,files";</script>
  </form>	
</body>
</html>