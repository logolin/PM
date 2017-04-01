//历史操作记录伸缩和排序
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

function toggleStripTags(obj)
{
    var btn = $(obj);
    var diffTag = btn.find('.icon-file-code');
    if(diffTag.length)
    {
        diffTag.removeClass('icon-file-code').addClass('diff-short');
        btn.attr('title', '文本格式');
    }
    else
    {
        btn.find('.diff-short').removeClass('diff-short').addClass('icon-file-code');
        btn.attr('title', '原始格式');
    }
    var boxObj  = $(obj).next();
    var oldDiff = '';
    var newDiff = '';
    $(boxObj).find('blockquote').each(function(){
        oldDiff = $(this).html();
        newDiff = $(this).next().html();
        $(this).html(newDiff);
        $(this).next().html(oldDiff);
    })
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

$(function()
{
    var diffButton = "<a href='javascript:;' onclick='toggleStripTags(this)' class='changeDiff btn-icon' style='display:none;' title='原始格式'><i class='icon- icon-file-code'></i></a>";
    var newBoxID = ''
    var oldBoxID = ''
    $('blockquote').each(function()
    {
        newBoxID = $(this).parent().attr('id');
        if(newBoxID != oldBoxID) 
        {
            oldBoxID = newBoxID;
            if($(this).html() != $(this).next().html()) $(this).parent().before(diffButton);
        }
    })
})
