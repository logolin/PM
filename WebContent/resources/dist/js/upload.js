//上传文件
	$(function()
			{
			    var maxUploadInfo = maxFilesize();
			    parentTag = $('#fileform').parent();
			    if(parentTag.get(0).tagName == 'TD')
			    {
			        parentTag.parent().find('th').append(maxUploadInfo); 
			    }
			    if(parentTag.get(0).tagName == 'FIELDSET')
			    {
			        parentTag.find('legend').append(maxUploadInfo);
			    }
			});

			/**
			 * Check file size and type.
			 * 
			 * @param  obj $obj 
			 * @access public
			 * @return void
			 */
			function checkSizeAndType(obj)
			{
			    if(typeof($(obj)[0].files) != 'undefined')
			    {
			        var maxUploadInfo = '50M';
			        var sizeType = {'K': 1024, 'M': 1024 * 1024, 'G': 1024 * 1024 * 1024};
			        var unit = maxUploadInfo.replace(/\d+/, '');
			        var maxUploadSize = maxUploadInfo.replace(unit,'') * sizeType[unit];
			        var fileSize = 0;
			        $(obj).closest('#fileform').find(':file').each(function()
			        {
			            /* Check file type. */
			            fileName = $(this)[0].files[0].name;
			            dotPos   = fileName.lastIndexOf('.');
			            fileType = fileName.substring(dotPos + 1);
			            if((',' + dangerFiles + ',').indexOf((',' + fileType + ',')) != -1) alert(' 您选择的文件存在安全风险，系统将不予上传。');

			            if($(this).val()) fileSize += $(this)[0].files[0].size;
			        })
			        if(fileSize > maxUploadSize) alert(' 文件大小已经超过限制，可能不能成功上传！');//Check file size.
			    }
			}

			/**
			 * Show the upload max filesize of config.  
			 */
			function maxFilesize(){return "(<span class='red'>50M</span>)";}

			/**
			 * Set the width of the file form.
			 * 
			 * @param  float  $percent 
			 * @access public
			 * @return void
			 */
			function setFileFormWidth(percent)
			{
			    totalWidth = Math.round($('#fileform').parent().width() * percent);
			    titleWidth = totalWidth - $('.fileControl').width() - $('.fileLabel').width() - $('.icon').width();
			    if($.browser.mozilla) titleWidth  -= 8;
			    if(!$.browser.mozilla) titleWidth -= 12;
			    $('#fileform .text-3').css('width', titleWidth + 'px');
			};

			/**
			 * Add a file input control.
			 * 
			 * @param  object $clickedButton 
			 * @access public
			 * @return void
			 */
			function addFile(clickedButton)
			{
			    fileRow = "  <table class='fileBox' id='fileBox$i'>\n    <tr>\n      <td class='w-p45'><div class='form-control file-wrapper'><input type='file' name='files[]' class='fileControl'  tabindex='-1' onchange='checkSizeAndType(this)'\/><\/div><\/td>\n      <td class=''><input type='text' name='labels[]' class='form-control' placeholder='\u6807\u9898\uff1a' tabindex='-1' \/><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='addFile(this)' class='btn btn-block'><i class='icon-plus'><\/i><\/a><\/td>\n      <td class='w-30px'><a href='javascript:void(0);' onclick='delFile(this)' class='btn btn-block'><i class='icon-remove'><\/i><\/a><\/td>\n    <\/tr>\n  <\/table>";
			    fileRow = fileRow.replace('$i', $('.fileID').size() + 1);

			    /* Get files and labels name.*/
			    filesName  = $(clickedButton).closest('tr').find('input[type="file"]').attr('name');
			    labelsName = $(clickedButton).closest('tr').find('input[type="text"]').attr('name');

			    /* Add file input control and set files and labels name in it.*/
			    $fileBox = $(clickedButton).closest('.fileBox').after(fileRow).next('.fileBox');
			    $fileBox.find('input[type="file"]').attr('name', filesName);
			    $fileBox.find('input[type="text"]').attr('name', labelsName);

			    setFileFormWidth(0.9);
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

			$(function(){setFileFormWidth(0.9)});