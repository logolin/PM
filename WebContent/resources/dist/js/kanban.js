function setWhite(acl)
{
    acl == 'custom' ? $('#whitelistBox').removeClass('hidden') : $('#whitelistBox').addClass('hidden');
}

function switchStatus(projectID, status)
{
  if(status) location.href = createLink('project', 'task', 'project=' + projectID + '&type=' + status);
}

function switchGroup(projectID, groupBy)
{
    link = createLink('project', 'groupTask', 'project=' + projectID + '&groupBy=' + groupBy);
    location.href=link;
}

/**
 * Convert a date string like 2011-11-11 to date object in js.
 * 
 * @param  string $date 
 * @access public
 * @return date
 */
function convertStringToDate(dateString)
{
    dateString = dateString.split('-');
    return new Date(dateString[0], dateString[1] - 1, dateString[2]);
}

/**
 * Compute delta of two days.
 * 
 * @param  string $date1 
 * @param  string $date1 
 * @access public
 * @return int
 */
function computeDaysDelta(date1, date2)
{
    date1 = convertStringToDate(date1);
    date2 = convertStringToDate(date2);
    delta = (date2 - date1) / (1000 * 60 * 60 * 24) + 1;

    weekEnds = 0;
    for(i = 0; i < delta; i++)
    {
        if(date1.getDay() == 0 || date1.getDay() == 6) weekEnds ++;
        date1 = date1.valueOf();
        date1 += 1000 * 60 * 60 * 24;
        date1 = new Date(date1);
    }
    return delta - weekEnds; 
}

/**
 * Compute work days.
 * 
 * @access public
 * @return void
 */
function computeWorkDays(currentID)
{
    isBactchEdit = false;
    if(currentID)
    {
        index = currentID.replace('begins[', '');
        index = index.replace('ends[', '');
        index = index.replace(']', '');
        if(!isNaN(index)) isBactchEdit = true;
    }

    if(isBactchEdit)
    {
        beginDate = $('#begins\\[' + index + '\\]').val();
        endDate   = $('#ends\\[' + index + '\\]').val();
    }
    else
    {
        beginDate = $('#begin').val();
        endDate   = $('#end').val();
    }

    if(beginDate && endDate) 
    {
        if(isBactchEdit)  $('#dayses\\[' + index + '\\]').val(computeDaysDelta(beginDate, endDate));
        if(!isBactchEdit) $('#days').val(computeDaysDelta(beginDate, endDate));
    }
    else if($('input[checked="true"]').val()) 
    {
        computeEndDate();
    }
}

/**
 * Compute the end date for project.
 * 
 * @param  int    $delta 
 * @access public
 * @return void
 */
function computeEndDate(delta)
{
    beginDate = $('#begin').val();
    if(!beginDate) return;

    endDate = convertStringToDate(beginDate).addDays(parseInt(delta));
    endDate = endDate.toString('yyyy-MM-dd');
    $('#end').val(endDate);
    computeWorkDays();
}

/**
 * Load branches.
 * 
 * @param  int $product 
 * @access public
 * @return void
 */
function loadBranches(product)
{
    if($('#productsBox .input-group:last select:first').val() != 0)
    {
        var length = $('#productsBox .input-group').size();
        $('#productsBox .row').append('<div class="col-sm-3">' + $('#productsBox .col-sm-3:last').html() + '</div>');
        if($('#productsBox .input-group:last select').size() >= 2)$('#productsBox .input-group:last select:last').remove();
        $('#productsBox .input-group:last .chosen-container').remove();
        $('#productsBox .input-group:last select:first').attr('name', 'products[' + length + ']').attr('id', 'products' + length);
        $('#productsBox .input-group:last .chosen').chosen(defaultChosenOptions);
    }

    var $inputgroup = $(product).closest('.input-group');
    if($inputgroup.find('select').size() >= 2)$inputgroup.find('select:last').remove();
    var index = $inputgroup.find('select:first').attr('id').replace('products' , '');
    $.get(createLink('branch', 'ajaxGetBranches', "productID=" + $(product).val()), function(data)
    {
        if(data)
        {
            $inputgroup.append(data);
            $inputgroup.find('select:last').attr('name', 'branch[' + index + ']').attr('id', 'branch' + index).css('width', '80px');
        }
    })
}
function loadBranch(){}

/* Auto compute the work days. */
$(function() 
{
    if(typeof(replaceID) != 'undefined') setModal4List('iframe', replaceID);
    $(".date").bind('dateSelected', function()
    {
        computeWorkDays(this.id);
    })
});
$(function()
{
    var boardID  = '';
    var onlybody = config.requestType == 'GET' ? "&onlybody=yes" : "?onlybody=yes";
    $('#printKanban').modalTrigger({type:'iframe', width: 400, url: createLink('project', 'printKanban', 'projectID=' + projectID), icon: 'print'});
    $(".kanbanFrame").modalTrigger({type: 'iframe', width: '80%', afterShow:function(){ $('#ajaxModal').data('cancel-reload', true)}, afterHidden: function(){refresh()}});

    $.cookie('selfClose', 0, {expires:config.cookieLife, path:config.webRoot});

    var $kanban = $('#kanban');
    var $kanbanWrapper = $('#kanbanWrapper');

    initBoards();

    var statusMap =
    {
        task:
        {
            wait   : {doing: 'start', done: 'finish', cancel: 'cancel'},
            doing  : {done: 'finish'},
            done   : {doing: 'activate', closed: 'close'},
            cancel : {doing: 'activate', closed: 'close'},
            closed : {doing: 'activate'}
        },
        bug:
        {
            wait   : {done: 'resolve', cancel: 'resolve'},
            doing  : {},
            done   : {wait: 'activate', closed: 'close'},
            cancel : {wait: 'activate', closed: 'close'},
            closed : {wait: 'activate'}
        }
    };

    var lastOperation;

    function dropTo(id, from, to, type)
    {
        if(statusMap[type][from] && statusMap[type][from][to])
        {
            lastOperation = {id: id, from: from, to: to};
            $.modalTrigger({type: 'iframe', url: createLink(type, statusMap[type][from][to], 'id=' + id) + onlybody, afterShow:function(){ $('#ajaxModal').data('cancel-reload', true)}, afterHidden: function()
            {
                var selfClose = $.cookie('selfClose');
                $.cookie('selfClose', 0, {expires:config.cookieLife, path:config.webRoot});
                if(selfClose != 1 && lastOperation)
                {
                    $item = $('#' + type + '-' + lastOperation.id);
                    for(var status in statusMap[type])
                    {
                        $item.removeClass('board-' + type + '-' + status);
                    }
                    $item.addClass('board-' + type + '-' + lastOperation.from).insertBefore($item.closest('tr').find('.col-'+lastOperation.from + ' .board-shadow'));
                }
                else
                {
                    $.get(createLink(type, 'ajaxGetByID', 'id=' + id), function(data)
                    {
                        $('div#' + type + '-' + id).find('.' + type + '-assignedTo small').html(data.assignedTo);
                        if(type == 'task')
                        {
                            $('div#task-' + id).find('.task-left').html(data.left + 'h');
                            if(data.story)$('div.board-story[data-id="' + data.story + '"]').find('.story-stage').html(data.storyStage);
                        }
                    }, 'json');
                }
            }});
            return true;
        }
        return false;
    }

    function initBoards()
    {
        $('.col-droppable').append('<div class="board-shadow"></div>');

        var $boardTasks = $kanban.find('.board-task');
        $boardTasks.droppable(
        {
            target: '.col-droppable',
            flex: true,
            before: function(e)
            {
                if(e.element.find('.dropdown.open').length) return false;
            },
            start: function(e)
            {
                e.element.closest('td').addClass('drag-from').closest('tr').addClass('dragging');
                $kanban.addClass('dragging').find('.board-item-shadow').height(e.element.outerHeight());
            },
            drag: function(e)
            {
                if(e.isNew)
                {
                    var $dargShadow = $('.drag-shadow.board-task');
                    for(var status in statusMap['task'])
                    {
                        $dargShadow.removeClass('board-task-' + status);
                    }
                    $dargShadow.addClass('board-task-' + e.target.data('id'));
                }
            },
            drop: function(e)
            {
                if(e.isNew && e.element.closest('tr').data('id') == e.target.closest('tr').data('id'))
                {
                    var result = dropTo(e.element.data('id'), e.element.closest('td').data('id'), e.target.data('id'), 'task');
                    if(result !== false)
                    {
                        for(var status in statusMap['task'])
                        {
                            e.element.removeClass('board-task-' + status);
                        }
                        e.element.addClass('board-task-' + e.target.data('id')).insertBefore(e.target.find('.board-shadow'));
                    }
                }
            },
            finish: function(e)
            {
                $kanban.removeClass('dragging drop-in');
                $kanbanWrapper.find('tr.dragging').removeClass('dragging').find('.drop-in, .drag-from').removeClass('drop-in drag-from');
            }
        });

        var $boardBugs = $kanban.find('.board-bug');
        $boardBugs.droppable(
        {
            target: '.col-droppable',
            flex: true,
            start: function(e)
            {
                e.element.closest('td').addClass('drag-from').closest('tr').addClass('dragging');
                $kanban.addClass('dragging').find('.board-item-shadow').height(e.element.outerHeight());
            },
            drag: function(e)
            {
                if(e.isNew)
                {
                    var $dargShadow = $('.drag-shadow.board-bug');
                    for(var status in statusMap['bug'])
                    {
                        $dargShadow.removeClass('board-bug-' + status);
                    }
                    $dargShadow.addClass('board-bug-' + e.target.data('id'));
                }
            },
            drop: function(e)
            {
                if(e.isNew && e.element.closest('tr').data('id') == e.target.closest('tr').data('id'))
                {
                    var result = dropTo(e.element.data('id'), e.element.closest('td').data('id'), e.target.data('id'), 'bug');
                    if(result !== false)
                    {
                        for(var status in statusMap['bug'])
                        {
                            e.element.removeClass('board-bug-' + status);
                        }
                        e.element.addClass('board-bug-' + e.target.data('id')).insertBefore(e.target.find('.board-shadow'));
                    }
                }
            },
            finish: function(e)
            {
                $kanban.removeClass('dragging drop-in');
                $kanbanWrapper.find('tr.dragging').removeClass('dragging').find('.drop-in, .drag-from').removeClass('drop-in drag-from');
            }
        });
    }

    function refresh()
    {
        var selfClose = $.cookie('selfClose');
        $.cookie('selfClose', 0, {expires:config.cookieLife, path:config.webRoot});
        if(selfClose == 1)
        {
            $('#kanbanWrapper').wrap("<div id='tempDIV'></div>");
            $('#tempDIV').load(location.href + ' #kanbanWrapper', function()
            {
                $('#kanbanWrapper').unwrap();
                initBoards()
                $(".kanbanFrame").modalTrigger({type: 'iframe', width: '80%', afterShow:function(){ $('#ajaxModal').data('cancel-reload', true)}, afterHidden: function(){refresh()}});
            });
        }
    }

    var fixH = $("#kanbanHeader").offset().top;
    $(window).scroll(function()
    {
        var scroH = $(this).scrollTop();
        if(scroH>=fixH)
        {
            $("#kanbanHeader").addClass('affix');
            $("#kanbanHeader").width($('#kanbanWrapper').width());
        }
        else if(scroH<fixH)
        {
            $("#kanbanHeader").removeClass('affix');
            $("#kanbanHeader").css('width', '100%');
        }
    });

    $('#kanban').on('click', '.btn-info-toggle', function()
    {
          $btn = $(this);
          $btn.find('i').toggleClass('icon-angle-down').toggleClass('icon-angle-up');
          $btn.parents('.board').toggleClass('show-info');
    });
});
