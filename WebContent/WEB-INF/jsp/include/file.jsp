<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
        						<style>
								.fileBox {margin-bottom: 10px; width: 100%}
								table.fileBox td {padding: 0!important}
								.fileBox .input-control > input[type='file'] {width: 100%; height: 100%; height: 26px; line-height: 26px; border: none; position: relative;}
								.fileBox td .btn {border-radius: 0; border-left: none}
								.file-wrapper.form-control {border-right: 0}
								</style>
								<div id="fileform">
  									<script language="Javascript">dangerFiles = "php,php3,php4,phtml,php5,jsp,py,rb,asp,asa,cer,cdx,aspl";</script>
  									<table class="fileBox" id="fileBox1">
    									<tbody>
    										<tr>
      											<td class="w-p45">
      												<div class="form-control file-wrapper">
      													<input type="file" name="files" class="fileControl" tabindex="-1" onchange="checkSizeAndType(this)">
   													</div>
   												</td>
      											<td class="">
      												<input type="text" name="titles" class="form-control" placeholder="标题：" tabindex="-1">
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="addFile(this)" class="btn btn-block"><i class="icon-plus"></i></a>
      											</td>
      											<td class="w-30px">
      												<a href="javascript:void(0);" onclick="delFile(this)" class="btn btn-block"><i class="icon-remove"></i></a>
      											</td>
    										</tr>
  										</tbody>
  									</table>
  								</div>
								<script language="javascript">
								/**
								 * Add a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function addFile(clickedButton)
								{
								    fileRow = "  <table class='fileBox' id='fileBox$i'>\n    <tr>\n      <td class='w-p45'><div class='form-control file-wrapper'><input type='file' name='files[]' class='fileControl'  tabindex='-1' onchange='checkSizeAndType(this)'\/><\/div><\/td>\n      <td class=''><input type='text' name='title[]' class='form-control' placeholder='\u6807\u9898\uff1a' tabindex='-1' \/><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='addFile(this)' class='btn btn-block'><i class='icon-plus'><\/i><\/a><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='delFile(this)' class='btn btn-block'><i class='icon-remove'><\/i><\/a><\/td>\n    <\/tr>\n  <\/table>";
								    fileRow = fileRow.replace('$i', $('.fileID').size() + 1);
								
								    /* Get files and labels name.*/
								    fileName  = $(clickedButton).closest('tr').find('input[type="file"]').attr('name');
								    titleName = $(clickedButton).closest('tr').find('input[type="text"]').attr('name');
								
								    /* Add file input control and set files and labels name in it.*/
								    $fileBox = $(clickedButton).closest('.fileBox').after(fileRow).next('.fileBox');
								    $fileBox.find('input[type="file"]').attr('name', fileName);
								    $fileBox.find('input[type="text"]').attr('name', titleName);
								
								    updateID();
								}
								
								/**
								 * Delete a file input control.
								 * 
								 * @param  object $clickedButton 
								 * @access public
								 * @return void
								 */
								function delFile(clickedButton)
								{
								    if($('.fileBox').size() == 1) return;
								    $(clickedButton).closest('.fileBox').remove();
								    updateID();
								}
								
								/**
								 * Update the file id labels.
								 * 
								 * @access public
								 * @return void
								 */
								function updateID()
								{
								    i = 1;
								    $('.fileID').each(function(){$(this).html(i ++)});
								}
								</script>