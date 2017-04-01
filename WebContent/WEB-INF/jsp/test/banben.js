var noResultsMatch       = '没有匹配结果';
var chooseUsersToMail    = '选择要发信通知的用户...';
var defaultChosenOptions = {no_results_text: noResultsMatch, width:'100%', allow_single_deselect: true, disable_search_threshold: 1, placeholder_text_single: ' ', placeholder_text_multiple: ' ', search_contains: true};
$(document).ready(function()
{
    $("#mailto").attr('data-placeholder', chooseUsersToMail);
    $("#mailto, .chosen, #productID").chosen(defaultChosenOptions).on('chosen:showing_dropdown', function()
    {
        var $this = $(this);
        var $chosen = $this.next('.chosen-container').removeClass('chosen-up');
        var $drop = $chosen.find('.chosen-drop');
        $chosen.toggleClass('chosen-up', $drop.height() + $drop.offset().top - $(document).scrollTop() > $(window).height());
    });
});