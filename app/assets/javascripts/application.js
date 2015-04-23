// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require responsive/jquery
//= require responsive/jquery-ui
//= require responsive/bootstrap.min
//= require responsive/rails
//= require responsive/html5shiv
//= require responsive/respond.min
//= require responsive/tooltip
//= require responsive/page_loaders/home
//= require responsive/page_loaders/questions
//= require responsive/jquery.placeholder
//= require responsive/iphone-switch
//= require responsive/messi
//= require responsive/kendoui/kendo.web.min
//= require ckeditor/init
//= require responsive/question_script
//= require responsive/easyResponsiveTabs
//= require responsive/client_side_validation
//= require responsive/page_loaders/listener
//= require responsive/payment
//= require remove_social_account


/*jQuery("a[data-toggle='modal']").click(function(){
  console.log("modal window clickec");
  return false;
});*/

jQuery(document).ready(function(){

    // make a call presence validation checking

    jQuery("body").delegate("#make_call_frm","submit", function(){
      var phone_number = jQuery("#phone_number").val();
      if (phone_number  == "Click to add mobile numbers" || phone_number.length < 10)
      {
      jQuery(".make_call_error").show();
      jQuery(".make_call_error").fadeOut(5000);
      return false;
      }
      else
      {
    jQuery(".make_call_error").hide();
      return true;
      }
    });

     var el=  jQuery('form:first :input:visible:enabled:first');
    if ($('#question_style_background')!=null && $('#question_style_background').length==0)
    {
     el.focus();
     tmpStr= el.val();
     el.val('');
     el.val(tmpStr);
    }

    jQuery('#qrcode_id').click(function(){
     update_qrcode();
    });

  jQuery("a[data-toggle='modal']").click(function(){
    jQuery("button[data-dismiss='modal']:visible").click();
  });

  //~ dashboard filter validation
jQuery('.search-date-range-valid').click(function(){
    var start_date = new Date(jQuery(".fliter-from-date").val());
    var end_date = new Date(jQuery(".fliter-end-date").val());
    if (start_date <= end_date )
    {
    jQuery(".date-range-start-end").hide();
    return true;
    }
    else
    {
    jQuery(".date-range-start-end").show();
    return false;
    }
})

//tooltip for demo graphics
 jQuery(".female_view_percentage").tooltip({
        placement : 'top'
    });
    jQuery(".male_view_percentage").tooltip({
        placement : 'bottom'
    });
    jQuery(".male_response_percentage").tooltip({
        placement : 'bottom'
    });
    jQuery(".female_response_percentage").tooltip({
        placement : 'top'
    });



});
function message_display(msg)
{
    jQuery("#msg_container").html(msg).delay(1000);
}
function sign_up_button()
{
    window.location.href="/users/register";
}

/* Invite user edit */
    function Edit(id)
    {
    jQuery.ajax({
        type: 'GET',
        url: '/account/'+id+'/edit',
        data: {id: id},
        success: function(data){
            if(data.status == 200)
            {
                jQuery('a#Edit_user').addClass("osx")
                SM = new SimpleModal();
            }
            else
            {

            }
        }
    });
    }

//function loading_img()
//{
  //jQuery(".loading").css('display','block');
//}

/* share page check box */
function Share(id) {
    //~ alert(jQuery('#share_click_'+id).is(":checked"));
    if(jQuery('#share_click_'+id).is(":checked"))
    {
        var value="on";
        jQuery("#div_"+id).addClass("active");
    }
    else
    {
        var value ="off";
        jQuery("#div_"+id).removeClass("active");
    }
        jQuery.ajax({
        type: 'GET',
        url: '/dashboard/share_active',
        data: {id:id, active:value},
        success: function(data){
            if(value == "on")
            {
                jQuery('#div_'+id).addClass('select');
                jQuery('#div_'+id).addClass('active');
                jQuery('.flash_message').show();
                jQuery('.success p').text("Successfully account added");
            }
            else
            {
                jQuery('#div_'+id).removeClass('select');
                jQuery('#div_'+id).removeClass('active');
                jQuery('.flash_message').show();
                jQuery('.success p').text("Successfully account disabled");
            }
        }
    });
    }

  // Protect user to share multiple or comment questions via sms -begin
  function check_question_type(answer_type){
      if (answer_type =="1" || answer_type == "4") {
        jQuery(".sms_wrapper").show();
        jQuery("#sms_media_tab").addClass("active");
        jQuery("#embed_media_tab").removeClass("active");
        jQuery("#email_media_tab").removeClass("active");
        jQuery("#social_media_tab").removeClass("active");
        jQuery(".email_networks_wrapper").hide();
        jQuery(".embed_wrapper").hide();
        jQuery("#facebook").hide();
        jQuery("#twitter").hide();
        jQuery("#linked_in").hide();
      return true;
          }
      else
      {
      new Messi('Sorry! you can not share multiple/comments question through SMS', {	title : null,autoclose : 1500,buttons: false}, {center : true,viewport : {	top : '760px',left : '0px'}});  return false;
      }
      }

    function share_email(id){
    if (jQuery("#email_value").val() == "This is a default subject")
    {
               jQuery("#error_email").html('Please enter email address.');
                return false;
    }
    else
            jQuery("#error_email").hide();
      jQuery(".spinner").show();
      jQuery.ajax({
        type: 'POST',
        url: '/share/'+id+'/share_email',
        data :{
            to:  jQuery("#email_value").val(),
            subject: jQuery.trim(jQuery('#email_subject').val()),
            message: jQuery.trim(jQuery('#email_text_area').val()),
            customer_ids: jQuery("#biz_cus_ids").val(),
            unchecked_ids: jQuery("#unchecked_ids").val()
        },
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', jQuery('meta[name="csrf-token"]').attr('content'))},
        success: function(data){
            jQuery(".spinner").hide();
            jQuery('.flash_message').show();
            jQuery('.success p').text("Successfully email sent");
            jQuery("#email_value").val('');
            jQuery('#email_subject').val('');
            jQuery('#email_text_area').val('');
            jQuery("#status_ques").html('Status: Active');
        }
    });
    return true;
    }

    /*File upload*/
       function change_file(){
        var val1 = jQuery("#new_file").val();
        jQuery("#file_upload").val(val1);
        return false
    }

    /*Response*/

    jQuery(document).ready(function() {
        jQuery('#success_msg').hide();
        jQuery('#failure_msg').hide();
        jQuery("#flash_message").fadeOut(15000).hide("slow");
        //back to top

  // hide #back-top first
	jQuery("#back-top").hide();

	// fade in #back-top
	jQuery(function () {
		jQuery(window).scroll(function () {
			if (jQuery(this).scrollTop() > 100) {
				jQuery('#back-top').fadeIn();
			} else {
				jQuery('#back-top').fadeOut();
			}
		});

		// scroll body to 0px on click
		jQuery('#back-top a').click(function () {
			jQuery('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});
	});


    });
    // to validation answer in question create and update*
    function validateform(){
        var contain =[];
        var flag;
        jQuery("#all_possible_responses input:text").each(function(){
        contain.push(jQuery(this).val());
        });
        //~ alert(contain);
        //~ alert(contain.length);
        if (contain.length > 0)
            {
                for (var i = 0; i < contain.length; i++)
                {
                    //~ alert(contain[i]);
                    if (contain[i]=='')
                        {flag =false;}
                    else
                        {flag=true}
                }
                if (flag == true)
                    {return true;}
                else
                    {
                        //~ alert("error");
                        jQuery('.common_valid').text("Please enter the answer");
                        jQuery(".common_valid").css("color", "#FF0000");
                        return false;
                    }
            }
        else
            {
                //~ alert("return");
                return true;
            }
    }

    function reset_form()
    {
      jQuery("#question_create")[0].reset();
    }

    function fix_flash() {
    // loop through every embed tag on the site
    var embeds = document.getElementsByTagName('embed');
    for (i = 0; i < embeds.length; i++) {
        embed = embeds[i];
        var new_embed;
        // everything but Firefox & Konqueror
        if (embed.outerHTML) {
            var html = embed.outerHTML;
            // replace an existing wmode parameter
            if (html.match(/wmode\s*=\s*('|")[a-zA-Z]+('|")/i))
                new_embed = html.replace(/wmode\s*=\s*('|")window('|")/i, "wmode='transparent'");
            // add a new wmode parameter
            else
                new_embed = html.replace(/<embed\s/i, "<embed wmode='transparent' ");
            // replace the old embed object with the fixed version
            embed.insertAdjacentHTML('beforeBegin', new_embed);
            embed.parentNode.removeChild(embed);
        } else {
            // cloneNode is buggy in some versions of Safari & Opera, but works fine in FF
            new_embed = embed.cloneNode(true);
            if (!new_embed.getAttribute('wmode') || new_embed.getAttribute('wmode').toLowerCase() == 'window')
                new_embed.setAttribute('wmode', 'transparent');
            embed.parentNode.replaceChild(new_embed, embed);
        }
    }
    // loop through every object tag on the site
    var objects = document.getElementsByTagName('object');
    for (i = 0; i < objects.length; i++) {
        object = objects[i];
        var new_object;
        // object is an IE specific tag so we can use outerHTML here
        if (object.outerHTML) {
            var html = object.outerHTML;
            // replace an existing wmode parameter
            if (html.match(/<param\s+name\s*=\s*('|")wmode('|")\s+value\s*=\s*('|")[a-zA-Z]+('|")\s*\/?\>/i))
                new_object = html.replace(/<param\s+name\s*=\s*('|")wmode('|")\s+value\s*=\s*('|")window('|")\s*\/?\>/i, "<param name='wmode' value='transparent' />");
            // add a new wmode parameter
            else
                new_object = html.replace(/<\/object\>/i, "<param name='wmode' value='transparent' />\n</object>");
            // loop through each of the param tags
            var children = object.childNodes;
            for (j = 0; j < children.length; j++) {
                try {
                    if (children[j] != null) {
                        var theName = children[j].getAttribute('name');
                        if (theName != null && theName.match(/flashvars/i)) {
                            new_object = new_object.replace(/<param\s+name\s*=\s*('|")flashvars('|")\s+value\s*=\s*('|")[^'"]*('|")\s*\/?\>/i, "<param name='flashvars' value='" + children[j].getAttribute('value') + "' />");
                        }
                    }
                }
                catch (err) {
                }
            }
            // replace the old embed object with the fixed versiony
            object.insertAdjacentHTML('beforeBegin', new_object);
            object.parentNode.removeChild(object);
        }
    }
}

function active_qr_code_current_question(id)
{
  jQuery.ajax({
        type: 'GET',
        url: '/share/'+id+'/show_qr',
        success: function(data){
 // alert("Successfully Updated");


        }
    });
}

//Recent activity
  jQuery(document).ready(function () {
    jQuery('#horizontalTab').easyResponsiveTabs({
        type: 'default', //Types: default, vertical, accordion
        width: 'auto', //auto or any width like 600px
        fit: true,   // 100% fit in a containdataer
        closed: false, // Start closed if in accordion view
        activate: function(event) { // Callback function if tab is switched
            var $tab = jQuery(this);
            var $info = jQuery('#tabInfo');
            var $name = jQuery('span', $info);

            $name.text($tab.text());

            $info.show();
        }
    });
      jQuery('#select-button').click(function () {
          jQuery("input[type='file']").trigger('click');
      });
      jQuery('#csv-select-button').click(function () {
        jQuery("#upload_csv_element").trigger('click');
    });

      jQuery("input[type='file']").change(function () {
          jQuery('#val').text(this.value.replace(/C:\\fakepath\\/i, ''))
      });
  });



function GetWrapedText(text, maxlength) {
    var resultText = [""];
    var len = text.length;
    if (maxlength >= len) {
        return text;
    }
    else {
        var totalStrCount = parseInt(len / maxlength);
        if (len % maxlength != 0) {
            totalStrCount++
        }

        for (var i = 0; i < totalStrCount; i++) {
            if (i == totalStrCount - 1) {
                resultText.push(text);
            }
            else {
                var strPiece = text.substring(0, maxlength - 1);
                resultText.push(strPiece);
                resultText.push("<br>");
                text = text.substring(maxlength - 1, text.length);
            }
        }
    }
    return resultText.join("");
}

//Jquery fn for question create add video pane toggle.
jQuery(document).ready(function(){
  var checkbox_checked = jQuery("#question_video_upload_checkbox").prop("checked");
  if(checkbox_checked == true) {
    jQuery("#question_upload").show();
  }else {
    jQuery("#question_upload").hide();
  }
  jQuery("#question_video_upload_checkbox").click(function(){
    jQuery("#question_upload").toggle(this.checked);
    jQuery("#video_error").css("display","none");

jQuery("#self-upload_hide").hide();
  jQuery("#embed_url").attr("disabled",true);
  jQuery("#source_video").hide();
  jQuery("#youtube_source_video").hide();
  jQuery("#default_img").show();
  jQuery("#embed_url").val('');
  jQuery("#chk_youtub_upload").prop('checked',false);
  jQuery("#chk_self_upload").prop('checked', false);


  });
});
function deleteCookie(c_name) {
    document.cookie = encodeURIComponent(c_name) + "=deleted; expires=" + new Date(0).toUTCString();
}

jQuery(document).ready(function(){
    jQuery("#verify_caller_edit").click(function(){
        if(jQuery(this).attr("class") == 'edit_from'){jQuery("#InputFromNumber").prop("readonly", false)}
        else{jQuery("#user_from_number").prop("readonly", false);}
        jQuery("#verify_caller_edit").hide()
        jQuery(".verify_caller_id").show();
        return false;
    })
jQuery(".verify_caller_id").click(function(){
    var from_no = jQuery(".from_number").val()
    var tenant = 'true'
    var tenant = jQuery(".verify_caller_id").attr("id")
    jQuery(".loading").css('display', 'block');
    $.ajax(
        {
            url: "/tenants/check_caller_id/",
            type: "get",
            data: {from_number: from_no,tenant: tenant },
            dataType: "json",
            success:function(data)
            {
                jQuery("#verify_caller").click();
                if($.isNumeric(data["code"])){jQuery(".verify_call_message").html("Your Verification Code : "+data["code"]+"")}
                else{jQuery(".verify_call_message").html("Errors : "+data["code"]+"")}
                setTimeout(function(){
                    if($.isNumeric(data["code"]) || tenant != 'false'){
                    $.ajax({
                        type: "get",
                        url: "/tenants/check_verify_caller_ids",
                        data: {from_number :from_no},
                        dataType: "json",
                        success: function(data){
                            console.log("success")
                            jQuery('#verify_caller_model').modal('hide');
                            jQuery("#error_from_number").html(data.message)
                        }
                    });}
                    else
                    {
                        jQuery('#verify_caller_model').modal('hide');
                    }

                }, 40000);
                if(tenant == 'false'){jQuery("#InputFromNumber").prop("readonly", true)}
                else{jQuery("#user_from_number").prop("readonly", true);}
                jQuery("#verify_caller_edit").show()
                jQuery(".verify_caller_id").hide();
                jQuery(".loading").css('display', 'none');
            }
        }); return false;});
jQuery(".update_account_det").click(function(){
    var from_no
    if(jQuery("#user_from_number").length > 0){ from_no = jQuery("#user_from_number").val();}
    else{from_no = jQuery("#InputFromNumber").val();}
    //if(jQuery("#user_from_number").length > 0 || jQuery("#InputFromNumber").length > 0 ){
    if(from_no.length > 0 ){
    jQuery(".loading").css('display', 'block');
    $.ajax({
        type: "get",
        url: "/tenants/check_verify_caller_ids",
        data: {from_number :from_no,tenant: "true"},
        dataType: "json",
        success: function(data){
            if(data.message == "Phone Number Successfully updated.")
            {
               if(jQuery("#edit_user").length > 0 ){
                jQuery("#edit_user").submit();}else{
                jQuery(".new_tenant").submit();}
                jQuery(".loading").css('display', 'none');
            }
                else
                  {
                  jQuery("#error_from_number").html(data.message)
                      setTimeout(function(){jQuery("#error_from_number").html("")}, 8000);
                      jQuery(".loading").css('display', 'none');
                  }
        }
    });
    return false;
    }else{return true;}
})
});
