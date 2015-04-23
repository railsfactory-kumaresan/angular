jQuery(function () {
    jQuery('#myTabs a:first').tab('show')
})
function locationcount() {
    jQuery(".loading").show();
    var cust_url = jQuery(this).attr('href');
    jQuery.ajax({
        type: "GET",
        url: cust_url,
        success: function(data) {
        }
    });
    return false;
}

function demographcount() {
    var cust_url = jQuery(this).attr('href');
    jQuery.ajax({
        type: "GET",
        url: cust_url,
        success: function(data) {
        }
    });
    return false;
}
jQuery(document).ready(function() {
    //~ jQuery(".location-view-response-count").on("click",jQuery(this).attr('href'),locationcount);
    jQuery(".demograph-count").on("click",jQuery(this).attr('href'),demographcount);


/*Show page "view all kaywords" and "View comments" */
    jQuery("#keywords_list_id").click(function() {
        jQuery("#sentimental_report_modal").modal('show');
        jQuery("#modal-content-display").css("display","none");
        jQuery("#sentimental_comments_list").css("display","none");
        jQuery("#modal-title").html("Keywords List");
        jQuery("#sentimental_keywords_list").css("display","block");
        return false;
    });

    jQuery("#comment_view").click(function(){
        jQuery("#sentimental_report_modal").modal('show');
        jQuery("#modal-content-display").css("display","none");
        jQuery("#sentimental_keywords_list").css("display","none");
        jQuery("#modal-title").html("Comments");
        jQuery("#sentimental_comments_list").css("display","block");
        return false;
    });

});


function GetURLParameter(sParam)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam)
        {
            return sParameterName[1];
        }
    }
}
//Ajax for dashboard recent activity tab navigations
function recent_activity_ajax(category_id,from_date,to_date,request) {
    jQuery(".loading").show();
    jQuery.ajax({
        type: "GET",
        url: "/dashboard",
        data: {
            category_id: category_id,
            from_date: from_date,
            to_date: to_date,
            request: request,
            status: "tab_ajax"
        },
        success: function() {
            jQuery(".loading").hide();

        }
    });
    return false;
}

//Ajax for dashboard recent activity preview and next
function trigger_question_list(offset,limit,category_type_id,count)
{
    status = "tab_ajax";
    jQuery(".loading").show();
    jQuery.ajax({
        type: 'GET',
        dataType: 'script',
        url: '/dashboard',
        data: {
            category_id: category_type_id,
            from_date: jQuery('#from_date').val(),
            to_date: jQuery('#to_date').val(),
            status: status,
            offset: offset,
            limit: limit,
            count: count
        },
        success: function(){
            jQuery(".loading").hide();
        }
    });
}

//Sentimental analysis script for user dashboard page and show page
function sentiment_analysis(question_id,from_date,to_date,category_id,count){
      var url = '/question/sentiment_analyze?id='+question_id
    jQuery(".loading").show();
    jQuery.ajax({
        type: 'GET',
        url: url,
        data: {
            from_date: from_date,
            to_date: to_date,
            category_id: category_id,
            count: count
        },
        success: function(data){
            jQuery(".loading").hide();
            var positive=data.Positive;
            var negative=data.Negative;
           // var very_positive = data.Very_Positive;
            var neutral = data.Neutral;
            //var very_negative = data.Very_Negative
            jQuery("#sentimental_report_modal").modal('show');
            jQuery("#sentimental_comments_list").css("display","none");
            jQuery("#sentimental_keywords_list").css("display","none");
            jQuery("#modal-content-display").css("display","block");
            jQuery("#modal-title").html("Sentimental Analysis");
            jQuery("#modal-content-display").html("<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width: "+positive+"%;'></div></div>")
            //jQuery('#modal-content-display').append("<div class='percent-value'><strong>"+very_positive+"%</strong>Very Positive"+"</div>");
            //jQuery("#modal-content-display").append("<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width: "+positive+"%;'></div></div>")
            jQuery('#modal-content-display').append("<div class='percent-value'><strong>"+positive+"%</strong> Positive"+"</div>");
            jQuery("#modal-content-display").append("<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width: "+neutral+"%;'></div></div>")
            jQuery('#modal-content-display').append("<div class='percent-value'><strong>"+neutral+"%</strong> Neutral"+"</div>");
            jQuery("#modal-content-display").append("<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width: "+negative+"%;'></div></div>")
            jQuery('#modal-content-display').append("<div class='percent-value'><strong>"+negative+"%</strong> Negative"+"</div>");
            //jQuery("#modal-content-display").append("<div class='progress'><div class='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width: "+very_negative+"%;'></div></div>")
            //jQuery('#modal-content-display').append("<div class='percent-value'><strong>"+very_negative+"%</strong> Very Negative"+"</div>");
        }
    });
}

    jQuery("#question_list_filter").click(function(){
        var category_id = jQuery('#category_question_list').val();
        var status = jQuery('#question_status_list').val();
        var tenant = jQuery('#tenant_question_list').val();
        jQuery(".loading").show();
        jQuery.ajax({
            type: 'GET',
            url: '/question',
            data: {
                category_type_id: category_id,
                status: status,
                tenant_id: tenant,
                ajax: true
            },
            success: function(data){
                jQuery(".loading").hide();
            }
        });
    });
 jQuery('.pagination a').attr('data-remote', 'true');

   jQuery(".upgrade-close").click(function () {
    jQuery(".upgrade").fadeTo('slow',0.0);
  });

  function validate() {
    var mesg = document.feedbackForm.message.value;
    if (mesg == '') {
      $('#feedbackForm_CommentsEmpty').show();
      return false;
    }
    $('#feedbackForm_CommentsEmpty').hide();
    return true;
  }

  jQuery(document).keyup(function(e) {
    if (e.keyCode == 27) {jQuery("#lbCloseLink").trigger("click");}   // esc
  });

   //$(".datepicker").datepicker({
     //   showOn : "button",
      //  buttonImage : "/assets/responsive/calendar.png",
        //buttonImageOnly : true
      //});

    jQuery(document).ready(function() {
	jQuery(".isloading-wrapper").hide();
	jQuery('#success_msg1').show();
    thanks_msg = '<%=escape_javascript(@thanks_msg.gsub("\r\n","!-!-!-!"))%>';
    jQuery("#sucess_new").html(thanks_msg.replace(/(!-!-!-!)/gm,'<br/>'));
});

 jQuery(document).ready(function(){
    jQuery(".next_page").attr("title","Next");
    jQuery(".previous_page").attr("title","Privious");
 });
