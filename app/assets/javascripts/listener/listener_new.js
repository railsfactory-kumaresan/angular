function add_tab(current_tab,options,book_mark) {
    if($("#link" + current_tab).length > 0)
    {
        $( "#link"+ current_tab+"").remove();
        $( ".link"+ current_tab+"").remove();
    }
    options = options || "inactive";
   var user_id = jQuery("#"+current_tab+"").attr("class").split(" ")[0]
    var keyword = jQuery("#"+current_tab).text();
    if(options != "inactive"){jQuery(".message-card-container").remove();}
    jQuery(".search_new_keyword").val("");
    if($(".tab-pane").hasClass("" + current_tab + "") == true){var id_c_1 = jQuery("#link"+current_tab+"").children()[1];
        close_tab(id_c_1)}
    if ($(".tab-pane").hasClass("" + current_tab + "") == false || options == "active"  || book_mark == "1") {
        var id = current_tab;
        jQuery(".show_filter").show();
        jQuery(".remove_keyword").hide();
        jQuery(".bookmark_keyword").hide();
        jQuery("."+current_tab+"_class").show();
        jQuery("."+current_tab+"_book").show();
        jQuery(".slot-container").css({"background-color":""})
        jQuery("#"+current_tab+"").parent().parent().parent().css({"background-color":"dimgrey"});
        jQuery(".advance_search").attr("id",current_tab)
        jQuery(".advance_search").attr("onClick",'add_tab(this.id,false,0);')
        var tent_id = id.split("_")[1];
            var sources = [];
            $('.filter-source:checked').each(function(i){
            sources[i] = $(this).val();
            });
        $.ajax(
            {
                url: "/admin/listeners/list_keywords",
                type: "get",
                data: {id: id.replace("tab",'').split("_")[0],tenant_id: tent_id,user_id: user_id, book_mark: book_mark,filter_source: sources, keyword: keyword},
                dataType: "JSON",
                success: function (data) {
                    jQuery(".tab-pane").removeClass("active in");
                    var nextTab = jQuery("#" + current_tab + "").text();
                    if ( options != "active")
                    {
                    $('<li style ="width:128px;" id="link'+current_tab+'"><a href="#' + current_tab + '" role="tab" data-toggle="tab" style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;" class="idchange" onclick = "add_remove_class(this)">' + nextTab + '</a><span title ="Close menu" class="glyphicon glyphicon-remove close-btn" onclick="close_tab(this)"></span></li>').appendTo('#tabs');
                    $('<div class="tab-pane fade active in canchange ' + current_tab + '  link'+current_tab+'" id="' + current_tab + 'i"></div>').appendTo('.tab-content');
                    }
                    else
                    {
                    $(".tab-pane").html("");
                    $(".tab-pane").addClass("active in");
                    }
                    console.log(data['list'])
                    $.each(data['list'], function (k, v) {
                        //$.each(this, function (k, v) {
                        try {
                            if(data['list'] != '' && data['list'][k] != ''){
                                var book_mark_class = ""
                                if(data['list'][k]['bookmark']){var book_mark_class ="fa-bookmark"; var bookma ="delete_bookmark";var title = "Un Bookmark"}else{var book_mark_class ="fa-bookmark-o";var bookma = "";var title = "Bookmark"}
                                var icon_name = get_icon(data['list'][k]["source"])
                                var sentiment_yellow_circle ='';var sentiment_green_circle ='';var sentiment_red_circle =''
                                var color_chan  = ''
                                if(data['list'][k]['sentiment'] >= 2 && data['list'][k]['sentiment'] < 3 ){color_chan = 'message-card-yellow'; sentiment_yellow_circle = "fa-check-circle"; sentiment_green_circle = "fa-circle";sentiment_red_circle = "fa-circle";}
                                else if(data['list'][k]['sentiment'] >= 1 && data['list'][k]['sentiment'] < 2 ){color_chan = 'message-card-red';sentiment_yellow_circle = "fa-circle"; sentiment_green_circle = "fa-circle";sentiment_red_circle = "fa-check-circle";}
                                else if(data['list'][k]['sentiment'] >= 3 ){color_chan = 'message-card-green';sentiment_yellow_circle = "fa-circle"; sentiment_green_circle = "fa-check-circle";sentiment_red_circle = "fa-circle";}
                                else{}
                                var d = new Date(data['list'][k]["published"]);
                                var published_date = d.getDate() + '-' + (d.getMonth()+1) + '-' + d.getFullYear()
                                var tweet_id = data['list'][k]['url'].split("/")
                                var messages = "<div class='message-card-container'>";
                                messages += "<div class='title_listener "+k+"_"+current_tab+"_share' style='display:none'>" + data['list'][k]['title'] + "|" + data['list'][k]['url'] + "|" + data['list'][k]['content'] + "</div>"
                                if (data['list'][k]['source'] == "Twitter") {
                                    messages += "<div class='message-card container-fluid "+color_chan+"'><div class='message-title row'><div class='source-info-left col-lg-6 col-md-6'><div class='source-icon twitter-icon'><i class='fa fa-twitter'></i></div><div class='source-text'><!--twitter.com /  " + data['list'][k]['url'].split("/")[3] + "--></div><div class='source-share-options'><a href='#' onclick=window.open('https://twitter.com/intent/tweet?in_reply_to="+tweet_id[tweet_id.length-1]+"&original_referer=http://listener.inquirly2.railsfactory.com/index.php','replywindow','width=600,height=500,top=400,left=500')><span title ='Reply' class='glyphicon glyphicon-share-alt'></span></a><a title ='Retweet' href='#'  onclick =window.open('https://twitter.com/intent/retweet?tweet_id="+tweet_id[tweet_id.length-1]+"&original_referer=http://listener.inquirly2.railsfactory.com/index.php','retweetwindow','width=600,height=500,top=400,left=500')><i class='fa fa-retweet'></i></a><a href='#' onclick=window.open('https://twitter.com/intent/favorite?tweet_id="+tweet_id[tweet_id.length-1]+"','Favouritewindow','width=600,height=500,top=400,left=500')><span title='Favourite' class='glyphicon glyphicon-star'></span></a></div></div><div class='source-info-right col-lg-6 col-md-6'><div class='message-options'><a title='View' href=" + data['list'][k]["url"] + " target='_blank'><i class='fa fa-eye'></i></a><a title='"+title+"' href='#' class='book_mark "+bookma+"' id="+tent_id+'_2_'+data['list'][k]['id']+'_'+user_id+'_'+id.replace("tab",'').split("_")[0]+"><i class='fa "+book_mark_class+"'></i></a><a title='share'href= '#' class='shr-dtls-modal modal_click "+k+"_"+current_tab+"' data-toggle='modal' data-target='#share_detaill'><i class='fa fa-share-alt'></i></a></div>"
                                    messages += "<div class='message-date'>"+published_date+"</div><div class='message-rating'><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_2_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_yellow_circle+" yellow circle_"+data['list'][k]['id']+"'></i></a><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_3_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_green_circle+" green circle_"+data['list'][k]['id']+"'></i></a><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_1_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_red_circle+" red circle_"+data['list'][k]['id']+"'></i></a></div></div></div><div class='message-text row'>" + data['list'][k]['content'] + "</div>"
                                    if (data['list'][k]['influence'] > 0) {
                                        messages += "<div class='message-fotter row'><span class='influence-value'>" + data['list'][k]['influence'] + "</span><span class='influence-label'>influence</span> </div> <div style='width:" + data['list'][k]['influence'] + "%;' class='sentiment-bar'></div>"
                                    }
                                }
                                else {
                                    messages += "<div class='message-card container-fluid "+color_chan+"'><div class='message-title row'><div class='source-info-left col-lg-6 col-md-6'><div class='source-icon "+icon_name.split("|")[0]+"'> <i class='fa "+icon_name.split("|")[1]+"'></i></div><div class='source-text'><!--" + data['list'][k]['url'].split("/")[2] + " --></div><div class='source-share-options'></div></div><div class='source-info-right col-lg-6 col-md-6'><div class='message-options'> <a title='View' href=" + data['list'][k]["url"] + " target='_blank'><i class='fa fa-eye'></i></a><a title='"+title+"' href='#' class='book_mark "+bookma+"' id="+tent_id+'_2_'+data['list'][k]['id']+'_'+user_id+'_'+id.replace("tab",'').split("_")[0]+"><i class='fa "+book_mark_class+"'></i></a><a title='Share' href='#' class='shr-dtls-modal modal_click "+ k +"_" +current_tab+"' data-toggle='modal' data-target='#share_detaill'><i class='fa fa-share-alt'></i></a></div><div class='message-date'>"+published_date+"</div><div class='message-rating'><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_2_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_yellow_circle+" yellow circle_"+data['list'][k]['id']+"'></i></a><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_3_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_green_circle+" green circle_"+data['list'][k]['id']+"'></i></a><a title='Sentiment' href='javascript:void(0)' class ='sentiment_score' id="+tent_id+'_1_'+data['list'][k]['id']+'_'+user_id+" ><i class='fa "+sentiment_red_circle+" red circle_"+data['list'][k]['id']+"'></i></a></div></div></div>"
                                    messages += "<div class='message-text row'> " + data['list'][k]['content'] + "</div><div class='message-fotter row'>"
                                    if (data['list'][k]['influence'] > 0) {
                                        messages += "<span class='influence-value'>" + data['list'][k]['influence'] + "</span><span class='influence-label'>influence</span></div><div style='width:" + data['list'][k]['influence'] + "%;' class='sentiment-bar'></div>"
                                    }
                                }
                                messages += "</div>"
                                $("#" + current_tab + "i").append(messages);
                            }}
                        catch(err){
                            console.log(data["list"]);
                            console.log(err.message)
                        }
                        // });
                    });
                    $('#tabs a:last').tab('show');
                    move_tab(current_tab);
                    //jQuery(".loading").css('display', 'block');
                }

            });
    }
    else {
        console.log("Already Opened");
    }
    wcFetch(current_tab);
};

function get_icon(source)
{ var icon_name = "";
if(source == "Media"){icon_name = ' media-icon|fa-rss'}else if(source == "facebook-icon|Delicious"){icon_name =="facebook-icon|fa-delicious"}else if(source=="Forums"){icon_name = "facebook-icon|fa-comments-o"}
else if(source=="GooglePlus"){icon_name = 'google_icon|fa-google-plus-square'}else if(source == "Reddit"){icon_name='facebook-icon|fa-reddit'}else if(source == "News"){icon_name='news-icon|fa-bullhorn'}else if(source == "Facebook"){icon_name='facebook-icon|fa-facebook'}
return icon_name
}

function add_remove_class(current_id) {
    jQuery("#myTabContent").parent().find('div').removeClass("active in");
    var s = jQuery(current_id).attr("href");
    if(s.split("#")[1] == "live_listen"){jQuery(".show_filter").hide();}else{jQuery(".show_filter").show();}
    jQuery(".advance_search").attr("id",s.split("#")[1])
    jQuery(".advance_search").attr("onClick",'add_tab(this.id,false,0);')
    wcFetch(s.split("#")[1]);
    jQuery("" + s + "i").addClass("active in");
    jQuery(".remove_keyword").hide();
    jQuery(".bookmark_keyword").hide();
    jQuery(".slot-container").css({"background-color":""})
    if(s.split("#")[1] !="live_listen"){
    jQuery("#"+s.split("#")[1]+"").parent().parent().parent().css({"background-color":"dimgrey"});
    jQuery("."+s.split("#")[1]+"_class").show();
        jQuery("."+s.split("#")[1]+"_book").show();
    }else{}
};

//~ get word colud data via API
function wcFetch(current_tab) {
    var keywordID = current_tab.split("tab")[0];
    var user_id = jQuery("#"+current_tab+"").attr("class").split(" ")[0]
    jQuery.get("/admin/listeners/wordcloud", { id: keywordID,tenant_id : current_tab.split("_")[1],user_id:user_id });
    jQuery(".loading").css('display', 'block');
}

function validateEmail(sEmail) {
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (filter.test(sEmail)) {
        return true;
    }
    else {
        return false;
    }
}

function close_tab(id_c){
    if(jQuery("#tabs").children().size() == 5 || jQuery("#tabs").children().size() >=5  ){
        var prevu_tab = jQuery("#tabs").children('li:hidden')[0];
        jQuery("#"+prevu_tab.id+"").css("display","block");
     }
    var active_tab = jQuery("ul#tabs").find(".active")
    if(!$("#"+active_tab[0].id+"").prev().is(':visible'))
    {
        jQuery("#"+active_tab[0].id+"").prev().css("display","block")
        jQuery("#"+prevu_tab.id+"").css("display","none");
    }
    if(jQuery("#tabs").children().size() == 5){visible_prev();visible_next();}
   var id_new = jQuery(id_c).parent().attr("id")
    var prevu = jQuery("#"+id_new+"").prev().attr("id")
    var next_tab =jQuery("#"+id_new+"").next().attr("id")
   jQuery("#"+id_new+"").remove();
   jQuery("."+id_new+"").remove();
    if(prevu == "live_listen"){jQuery(".show_filter").hide();}else{jQuery(".show_filter").show();}
    jQuery(".remove_keyword").hide();
    jQuery(".bookmark_keyword").hide();
    jQuery(".slot-container").css({"background-color":""})
   if(jQuery(".idchange").parent().hasClass("active")){jQuery("#"+next_tab.replace("link",'')+"").parent().parent().parent().css({"background-color":"dimgrey"});
       jQuery("."+next_tab.replace("link",'')+"_class").show();jQuery("."+next_tab.replace("link",'')+"_book").show()}else{jQuery("#"+prevu+"").addClass("active");
       jQuery("."+prevu+"").addClass("active in");
       if(prevu!="live_listen"){jQuery("#"+prevu.replace("link",'')+"").parent().parent().parent().css({"background-color":"dimgrey"});
       jQuery("."+prevu.replace("link",'')+"_class").show();jQuery("."+prevu.replace("link",'')+"_book").show();}}
    try{if(next_tab.length == 0){jQuery(".show_filter").hide();}else{jQuery(".show_filter").show();}}catch(e){}
}

function move_tab(current_tab)
{
    if(jQuery("#tabs").children('li:visible').size() > 4)
    {
        var remove_tab = jQuery("#tabs").children('li:visible')[1]
        jQuery("#"+remove_tab.id+"").css("display","none");
        jQuery(".move_left").show();
        jQuery(".move-prev").show();
        var last_tab = "#"+jQuery("#tabs").children('li:visible').last()[0].id+""
        if(last_tab.split("link")[1] != current_tab){jQuery(".move-next").show();}else{jQuery(".move-next").hide()}

    }
}

function visible_prev()
{
    var prevuu_tab = jQuery("#tabs").children('li:visible')[1]
    var check_first = jQuery("#"+prevuu_tab.id+"").prev('li:hidden')
    if(check_first && check_first.length > 0){jQuery(".move-prev").show()}else{jQuery(".move-prev").hide()}
}
function visible_next()
{   var lastu_tab = jQuery("#tabs").children('li:visible').last().attr("id")
    var check_last = jQuery("#"+lastu_tab+"").next('li:hidden')
    if(check_last && check_last.length > 0){jQuery(".move-next").show()}else{jQuery(".move-next").hide()}
}

function prev_tab()
{
    var prevu_tab = jQuery("#tabs").children('li:visible')[1]
    var last_tab = jQuery("#tabs").children('li:visible').last().attr("id")
    var active_tab = jQuery("ul#tabs").find(".active")
    jQuery(".tab-pane").removeClass("active in");
    jQuery("ul#tabs>li.active").removeClass("active");
    jQuery("#"+prevu_tab.id+"").prev().css("display","block");
    jQuery("#"+last_tab+"").css("display","none");
    if(!$("#"+active_tab[0].id+"").prev().is(':visible'))
    {
        jQuery("#"+active_tab[0].id+"").prev().css("display","block")
        jQuery("#"+prevu_tab.id+"").css("display","none");
    }
    jQuery("#"+active_tab[0].id+"").prev().addClass("active");
    jQuery("."+active_tab[0].id+"").prev().addClass("active in")
    jQuery(".move-next").show();
    visible_prev();
    background_color_change((jQuery("#"+active_tab[0].id+"").prev()[0].id).replace("link",''))
}

function background_color_change(s){
    jQuery(".remove_keyword").hide();
    jQuery(".bookmark_keyword").hide();
    jQuery(".slot-container").css({"background-color":""})
    if(s !="live_listen"){
        jQuery("#"+s+"").parent().parent().parent().css({"background-color":"dimgrey"});
        jQuery("."+s+"_class").show();
        jQuery("."+s+"_book").show();

    }else{}
}

function next_tab()
{
    var prevu_tab = jQuery("#tabs").children('li:visible')[1]
    var last_tab = jQuery("#tabs").children('li:visible').last().attr("id")
    var active_tab = jQuery("ul#tabs").find(".active")
    jQuery(".tab-pane").removeClass("active in");
    jQuery("ul#tabs>li.active").removeClass("active");
    jQuery("#"+prevu_tab.id+"").css("display","none");
    if(!$("#"+active_tab[0].id+"").next().is(':visible'))
    {
        jQuery("#"+active_tab[0].id+"").next().css("display","block")
        jQuery("#"+prevu_tab.id+"").css("display","none");
    }else{jQuery("#"+last_tab+"").next().css("display","block");}
    jQuery("#"+active_tab[0].id+"").next().addClass("active");
    jQuery("."+active_tab[0].id+"").next().addClass("active in")
    background_color_change((jQuery("#"+active_tab[0].id+"").next()[0].id).replace("link",''))
    visible_prev();
    visible_next();
}

$(document).ready( function() {
    jQuery('.search_new_keyword').keypress(function (e) {
        var key = e.which;
        if(key == 13)  // the enter key code
        {
            jQuery('.search_new_keyword_butt').click();
        }
    });



//$('.scroll_saved').enscroll().bind('enscroll', function(e, pos){
//    alert(23)
//});
     $("#sent_email").click(function () {
        var sEmail = jQuery('#share_email').val();
        var subject = jQuery("#share_subject").val()
        var message = jQuery("#share_message").val()
        if ($.trim(sEmail).length == 0 && $.trim(subject).length == 0 && $.trim(message).length == 0) {
            jQuery("#error_email").html('Please enter valid email address');
            jQuery("#error_subject").html('Please enter subject');
            jQuery("#error_message").html('Please enter Message');
            return false;
        } else if ($.trim(sEmail).length == 0 && $.trim(subject).length == 0) {
            jQuery("#error_email").html('Please enter valid email address');
            jQuery("#error_subject").html('Please enter subject');
            jQuery("#error_message").hide();
            return false
        } else if ($.trim(sEmail).length == 0 && $.trim(message).length == 0) {
            jQuery("#error_email").html('Please enter valid email address');
            jQuery("#error_subject").hide();
            jQuery("#error_message").html('Please enter Message');
            return false
        } else if ($.trim(subject).length == 0 && $.trim(message).length == 0) {
            jQuery("#error_email").hide();
            jQuery("#error_subject").html('Please enter subject');
            jQuery("#error_message").html('Please enter Message');
            return false
        }
        else if ($.trim(subject).length == 0) {
            jQuery("#error_email").hide();
            jQuery("#error_message").hide();
            jQuery("#error_subject").html('Please enter subject');
            return false;
        }
        else if ($.trim(message).length == 0) {
            jQuery("#error_email").hide();
            jQuery("#error_subject").hide();
            jQuery("#error_message").html('Please enter Message');
            return false;
        }
        else if ($.trim(sEmail).length == 0) {
            jQuery("#error_message").hide();
            jQuery("#error_subject").hide();
            jQuery("#error_email").html('Please enter valid email address');
            return false;
        }
        else {

        }
        if (validateEmail(sEmail)) {
        } else {
            jQuery("#error_message").hide();
            jQuery("#error_subject").hide();
            jQuery("#error_email").html('Please enter valid email address');
            return false;
        }
        var id_name = jQuery(this).attr("class")
        $.ajax(
            {
                url: "/admin/listeners/share_listener",
                type: "get",
                data: $("#send_email").serialize(),
                dataType: "script",
                success: function (data) {
                    $('#share_detaill').modal("hide");
                    $('#send_email')[0].reset();
                    jQuery("#error_email").hide();
                    jQuery("#error_subject").hide();
                    jQuery("#error_message").hide();
                    //data: return data from server
                }
            });
    });
//~ Sentiment score
$('body').on('click', '.sentiment_score', function () {
var sentiScore = this.id;
    var sentiScore_old =
//~ var tenant = jQuery(".sentiment_score").parent().parent().parent().parent().parent().parent().attr("id");
$.ajax(
    {
        url: "/admin/listeners/save_sentiment_score",
        type: "post",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {tenant_id: sentiScore.split('_')[0], senti_score: sentiScore.split('_')[1], message_id: sentiScore.split('_')[2], user_id:sentiScore.split('_')[3] },
        dataType: "json",
        success:function(data)
        {
            //alert(data.message);
            var color_chan = "";
               if(sentiScore.split('_')[1]  >= 2 && sentiScore.split('_')[1]  < 3 ){color_chan = 'message-card container-fluid message-card-yellow'}
                else if(sentiScore.split('_')[1]  >= 1 && sentiScore.split('_')[1]  < 2 ){color_chan = 'message-card container-fluid message-card-red'}
                else if(sentiScore.split('_')[1]  >= 3 ){color_chan = 'message-card container-fluid message-card-green'}
                else{}
            jQuery("#"+sentiScore+"").parent().parent().parent().parent().removeClass();
            jQuery("#"+sentiScore+"").parent().parent().parent().parent().addClass(color_chan);
            jQuery(".circle_"+sentiScore.split("_")[2]+"").removeClass("fa-check-circle").addClass("fa-circle")
            jQuery("#"+sentiScore+"").children().addClass("fa-check-circle").removeClass("fa-circle");

        }
    });
});

    $(".add-slot-btn").click( function() {
        $('#send_email')[0].reset();
        $(".modal-title").text("Keyword Request Count");
        $("#type_of_email").val("keywords_email");
        $("#share_email").val("help@inquirly.com");
        $('#share_email').attr('readonly', true);
        $("#share_subject").val("Request for keyword count");
        $('#share_subject').attr('readonly', true);

    });
    $('body').on('click', '.shr-dtls-modal', function () {
        $('#send_email')[0].reset();
        $(".modal-title").text("Share Article");
        $("#type_of_email").val("share_email");
        $("#share_email").val("");
       $('#share_email').attr('readonly', false);
        $("#share_subject").val("");
        $('#share_subject').attr('readonly', false);

    });
});

function filterSourceSearch(type)
{
    var type = ( type == 'exact' ) ? "active" : "inactive" ;
    var activetab = jQuery("li.active > a").attr('href');
    if (activetab)
    {
    add_tab(activetab.split('#')[1],type,0);
    }
    else
    {
    alert('no tabs avialable');
    }
}

$('body').on('click', '.book_mark', function() {
    var sentiScore = this.id;
    if (jQuery("#"+sentiScore+"").hasClass("delete_bookmark")){
       var json_book = {tenant_id: sentiScore.split('_')[0], message_id: sentiScore.split('_')[2], user_id:sentiScore.split('_')[3],id:sentiScore.split('_')[4],book_mark_delete: true}
    }
    else
    {
        var json_book = {tenant_id: sentiScore.split('_')[0], message_id: sentiScore.split('_')[2], user_id:sentiScore.split('_')[3],id:sentiScore.split('_')[4],book_mark_delete: false}
    }
    $.ajax(
        {
            url: "/admin/listeners/book_marks",
            type: "get",
            data: json_book,
            dataType: "JSON",
            success: function(data){
                if(jQuery("#"+sentiScore+"").children().hasClass("fa fa-bookmark-o")){
                    jQuery("#"+sentiScore+"").children().removeClass("fa-bookmark-o");
                    jQuery("#"+sentiScore+"").children().addClass("fa-bookmark");
                    jQuery("#"+sentiScore+"").children().attr("title","Un Bookmark");
                    jQuery("#"+sentiScore+"").addClass("delete_bookmark");}
                else{
                    jQuery("#"+sentiScore+"").children().removeClass("fa-bookmark");
                    jQuery("#"+sentiScore+"").children().attr("title","Bookmark");
                    jQuery("#"+sentiScore+"").removeClass("delete_bookmark");
                    jQuery("#"+sentiScore+"").children().addClass("fa-bookmark-o");
                    }
            }
        });
});



function chart_graph_data_build(keywords,traffic_source,results_velocity,new_results,post_per_day,init_val_tra,init_val_res_vel, init_val_new_res)
{
    post_per_day = JSON.parse(post_per_day.replace(/&quot;/g, '"'));
    $('#traffic_source').html("");
    $('#new_results').html("");
    $('#results_velocity').html("");
    $('#trends_chart').html("");
    $('#trends_keywords').html("");
    var chart1 = new DoughnutChart($('#traffic_source'), traffic_source, init_val_tra);
    var chart2 = new DoughnutChart($('#new_results'), new_results, init_val_new_res);
    var chart3 = new DoughnutChart($('#results_velocity'), results_velocity, init_val_res_vel);
    var t = new TrendsChart($('#trends_chart'), $('#trends_keywords'), keywords, post_per_day);    
}

