//颜色标签
function setColor(obj) {
		if(!$(obj).hasClass('empty')){
			$("a.cp-tile.active").removeClass("active");
			$(obj).addClass("active");
//			$('#colorBtn').css = ({"color":"white","borler-color":obj.style.background,"background-color":obj.style.background});
			$('#colorBtn').css("color","white");
			$('#colorBtn').css("borler-color",obj.style.background);
			$('#colorBtn').css("background-color",obj.style.background);
			$('#name').css("color",obj.style.background);
			$('#title').css("color",obj.style.background);
			$("#color").val(obj.getAttribute("data-color"));
		} else {
//			$('#colorBtn').css = ({"color":"","borler-color":"","background-color":""});
			$('#colorBtn').css("color","");
			$('#colorBtn').css("borler-color","");
			$('#colorBtn').css("background-color","");
			$('#name').css("color","");	
			$('#title').css("color","");
			
		}
	}

function setColori(obj,i) {
	if(!$(obj).hasClass('empty')){
		$("a.cp-tile.active").removeClass("active");
		$(obj).addClass("active");
		//$('#colorBtn').css = {"color":"white","borler-color":obj.style.background,"background-color":obj.style.background};
		$('#colorBtn[i]').css("color","white");
		$('#colorBtn[i]').css("borler-color",obj.style.background);
		$('#colorBtn[i]').css("background-color",obj.style.background);
		$('#name[i]').css("color",obj.style.background);
		$('#title[i]').css("color",obj.style.background);
		$("#color[i]").val(obj.getAttribute("data-color"));
	} else {
		$('#colorBtn[i]').css("color","");
		$('#colorBtn[i]').css("borler-color","");
		$('#colorBtn[i]').css("background-color","");
		$('#name[i]').css("color","");	
		$('#title[i]').css("color","");
		
	}
}
//优先级
function setPri(obj) {
	$("#priSpan").attr("class",$(obj).find("span").attr("class"));
	$("#priSpan").text($(obj).find("span").text());
	$(obj).parent().addClass("active");
	$(obj).parent().siblings().removeClass("active");
	$("#pri").find("option[value!='" + $(obj).find("span").text() + "']").removeAttr("selected");
	$("#pri").find("option[value='" + $(obj).find("span").text() + "']").attr("selected",true);
}
//富文本框
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea', {
           width:'100%',
		resizeType : 1,
		urlType:'relative',
		afterBlur: function(){this.sync();},
		allowFileManager : true,
		items : [ 'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic','underline', '|', 
		          'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', '|',
		          'emoticons', 'image', 'code', 'link', '|', 'removeformat','undo', 'redo', 'fullscreen', 'source', 'about']
	});
});
//设置白名单
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

////显示时间
//$(function(){
//	$(".form-date").datetimepicker(
//	{
//	    language:  "zh-CN",
//	    weekStart: 1,
//	    todayBtn:  1,
//	    autoclose: 1,
//	    todayHighlight: 1,
//	    startView: 2,
//	    minView: 2,
//	    forceParse: 0,
//	    format: "yyyy-mm-dd"
//	});
//})
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
    dateString = dateString[1] + '/' + dateString[2] + '/' + dateString[0];
     
     return Date.parse(dateString);
 }
/**
 * Compute the end date for productplan.
 * 计算可用工作日
 * @param  int    $delta 
 * @access public
 * @return void
 */
 function computeEndDate(delta)
 {
     beginDate = $('#begin').val();
     if(!beginDate) return;

     endDate = addDays(convertStringToDate(beginDate),parseInt(delta));
     year = endDate.getFullYear();
     month = endDate.getMonth() < 9 ? "0" + (endDate.getMonth() + 1) : (endDate.getMonth() + 1);
     day = endDate.getDate() < 10 ? "0" + endDate.getDate() : endDate.getDate();
     endDate = year + "-" + month + "-" + day;
     $('#end').val(endDate);
     var s1 = beginDate.getTime(),s2 = endDate.getTime();
     var total = (s2 - s1)/1000;
     var days = parseInt(total / (24*60*60));//计算整数天数
     $('#days').val(days);
 }
 function addDays(date, days) {
     var result = new Date(date);
     result.setDate(result.getDate() + days);
     return result;
 }
 
 
 /**
  * 关联产品
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
 
 