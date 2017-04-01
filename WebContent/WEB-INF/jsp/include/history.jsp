		      			<style>
					  	#actionbox a{font-weight:normal}
					  	.col-side fieldset#actionbox{padding-right:5px;}
					  	.col-side #actionbox #historyItem li span.item{white-space:nowrap}
					  	.changes blockquote{font-family: monospace, serif;}
					  	</style>
			  			<script language="Javascript">
						var fold   = '-';
						var unfold = '+';
						function switchChange(historyID)
						{
						    $swbtn = $('#switchButton' + historyID);
						    $showTag = $swbtn.find('.change-show');
						    if($showTag.length)
						    {
						        $swbtn.closest('li').addClass('show-changes');
						        $showTag.removeClass('change-show').addClass('change-hide');
						        $('#changeBox' + historyID).show();
						        $('#changeBox' + historyID).prev('.changeDiff').show();
						    }
						    else
						    {
						        $swbtn.closest('li').removeClass('show-changes');
						        $swbtn.find('.change-hide').removeClass('change-hide').addClass('change-show');
						        $('#changeBox' + historyID).hide();
						        $('#changeBox' + historyID).prev('.changeDiff').hide();
						    }
						}
				
						function toggleShow(obj)
						{
						    $showTag = $(obj).find('.change-show');
						    if($showTag.length)
						    {
						        $showTag.removeClass('change-show').addClass('change-hide');
						        $('#historyItem > li:not(.show-changes) .switch-btn').click();
						    }
						    else
						    {
						        $(obj).find('.change-hide').removeClass('change-hide').addClass('change-show');
						        $('#historyItem > li.show-changes .switch-btn').click();
						    }
						}
				
						function toggleOrder(obj)
						{
						    var $orderTag = $(obj).find('.log-asc');
						    if($orderTag.length)
						    {
						        $orderTag.attr('class', 'icon- log-desc');
						    }
						    else
						    {
						        $(obj).find('.log-desc').attr('class', 'icon- log-asc');
						    }
						    $("#historyItem li").reverseOrder();
						}
						function toggleComment(actionID)
						{
						    $('.comment' + actionID).toggle();
						    $('#lastCommentBox').toggle();
						    $('.ke-container').css('width', '100%');
						}
					  	(function($) {
						  	$.fn.reverseOrder = function() {
						  		return this.each(function() {
						  			$(this).prependTo( $(this).parent() );
						  		});
						  	};
						})(jQuery);
					  	</script>
