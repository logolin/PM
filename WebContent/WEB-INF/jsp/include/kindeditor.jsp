    $.each(kEditorId, function(key, editorID){ 
   	 var K = KindEditor, $editor = $('#' + editorID);
   	 var keditor = K.create('#' + editorID, {
   	        width:'100%',
   			resizeType : 1,
   			urlType:'relative',
   			afterBlur: function(){this.sync();$editor.prev('.ke-container').removeClass('focus');},
   			afterFocus: function(){$editor.prev('.ke-container').addClass('focus');},
   			allowFileManager : true,
   			items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
   			          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
   			          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
   		});
   })