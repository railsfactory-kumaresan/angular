   /* Date Selection for Email and Call report */
    $("#from_date").datepicker({
        showOn : "button",
        buttonImage : "/assets/responsive/calendar.png",
        buttonImageOnly : true,
        dateFormat : 'yy/mm/dd',
        minDate:"-90D",
        maxDate: new Date()
    });
    $("#to_date").datepicker({
        showOn : "button",
        buttonImage : "/assets/responsive/calendar.png",
        buttonImageOnly : true,
        dateFormat : 'yy/mm/dd',
        minDate:"-90D",
        maxDate: new Date()
    });

  jQuery(document).ready(function(){
      /* HTML container code Mirror */
      var myTextArea = document.getElementById('html_content');
      var editor = CodeMirror.fromTextArea(myTextArea, {mode: 'htmlmixed',
          indentUnit: 4,
          lineNumbers: true,
          lineWrapping: true,
          styleActiveLine: true,
          matchBrackets: true
      });
      editor.setOption("theme", "default");
      jQuery("#email_report").click(function(){
	
     /* Mandrill Activity Report */ 
      var start_date = new Date(jQuery(".fliter-from-date").val());
      var end_date = new Date(jQuery(".fliter-end-date").val());
      if (start_date <= end_date )
       {
	      jQuery(".date-range-start-end").hide();
	      jQuery(".loading").css('display','block');
	      jQuery.ajax({
	      type: 'POST',
	      url: '/share/mandril_report',
	      data: jQuery(".mail-report").serialize(),
	      dataType: "json",
	      success: function(data){
		      jQuery(".loading").css('display','none');
		      jQuery("#report_model").modal("hide");
		      jQuery("#success").show()
		      jQuery(".notice").html(data.message)
		      jQuery("#success").css("display","block");
		      jQuery("#success").delay(15000).hide("slow");
		  }
	      });
	}else
	{
              jQuery(".date-range-start-end").show();
              return false;
	}
      });

      jQuery("#email-field").click(function(){
          jQuery("#user_info_list").dialog({modal: false});
      });

      jQuery("#add-emails").click(function(){
          jQuery("#customer_list_email").modal();
      });

      jQuery('#success').hide();
      jQuery(".close_flash").click(function(){
         jQuery("#success").css("display","none");
      });
      /* Submit Email Share */
      jQuery(".question_send_email_share_submit").click(function () {
        var email_body_content;
        var is_html;

        /* SSO share data */
        var selectedCustomers = jQuery("#selected_customers").val();
        var unselectedCustomers = jQuery("#unselected_customers").val();
        var is_select_all = jQuery("#select-all").val();

        if(jQuery("#text-email-action").is(':visible')){
            email_body_content = CKEDITOR.instances['email_text_area'].getData();
            is_html = false;
        }
        else if(jQuery("#html-email-action").is(':visible')){
            email_body_content =  editor.getValue();
            is_html = true;
        }
       var email = jQuery("#email_value").val();
       var id = jQuery("#question_id").val();
       if (email !== "" && email !== "Click to add email address") {  // If something was entered
        if (!isValidEmailAddress(email)) {
          jQuery(".email_value_error_message").show(); //error message
          return false;
        } else {
          jQuery("#create_email").prop('disabled', true).css("cursor","not-allowed");
          jQuery(".email_value_error_message").hide();
          jQuery("#error_email").hide();
          jQuery(".spinner").show();
          jQuery.ajax({
            type: 'POST',
            url: '/share/'+id+'/share_email',
            data :{
		    to:  jQuery("#email_value").val(),
		    subject: jQuery.trim(jQuery('#email_subject').val()),
		    message: email_body_content,
		    is_html: is_html,
		    customer_ids: jQuery("#biz_cus_ids").val(),
		    unchecked_ids: jQuery("#unchecked_ids").val(),
            selected_customers: selectedCustomers,
            unselected_customers: unselectedCustomers,
            is_select_all: is_select_all
            },
	  beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', jQuery('meta[name="csrf-token"]').attr('content'))},
	  success: function(data){
              jQuery(".spinner").hide();
              jQuery('.flash_message').show();
              jQuery(".link-add-email").focus();
              jQuery("#email_value").val('');
              jQuery('#email_subject').val('');
              jQuery("#status_ques").html('Status: Active');
              jQuery(".notice").html("Your email has been shared successfully")
              jQuery("#success").css("display","block");
              jQuery("#success").delay(5000).hide("slow");
              jQuery("#create_email").prop('disabled', false).css("cursor","pointer");
            }
          });
          return false;
        }
      } else {
        jQuery(".email_value_error_message").show();
        return false;
      }
    });
    
    function isValidEmailAddress(emailAddress) {
      var email_array = emailAddress.split(',')
      var pattern = new RegExp(/^(("[\w-+\s]+")|([\w-+]+(?:\.[\w-+]+)*)|("[\w-+\s]+")([\w-+]+(?:\.[\w-+]+)*))(@((?:[\w-+]+\.)*\w[\w-+]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][\d]\.|1[\d]{2}\.|[\d]{1,2}\.))((25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\.){2}(25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\]?$)/i);
      for (i = 0; i < email_array.length; ++i) {
        return pattern.test(email_array[i]);
      }
    };
    
    /* Email Preview */
     jQuery("#email_preview").click(function(){
      var text_area_value = CKEDITOR.instances['email_text_area'].getData();
      text_area_value = text_area_value != "" ? (text_area_value.indexOf('&lt;survey link inserted here automatically&gt;') > -1 ? text_area_value.replace('&lt;survey link inserted here automatically&gt;','Click here to respond'): text_area_value +'Click here to respond'): 'Click here to respond'
      jQuery("#preview").css("display","block");
      jQuery("#mail_content").html(text_area_value);
      jQuery("#preview").modal();
    });
     jQuery("#text-email").addClass('active');
     jQuery("#html-email-action").hide();
     jQuery('body').on('click', '.btn-group button', function (e) {
          jQuery(this).addClass('active');
          jQuery(this).siblings().removeClass('active');
      });
      
     jQuery('#text-email').click(function(){
          jQuery("#custom-template").hide();
          jQuery("#html-email-action").hide();
          jQuery("#text-email-action").show();
          jQuery("#cke_email_text_area").show();
      });
      
     jQuery('#html-email').click(function(){
          jQuery("#cke_email_text_area").hide();
          jQuery("#text-email-action").hide();
          jQuery("#html-email-action").show();
          jQuery("#custom-template").show();
      });

      jQuery("#html_email_preview").click(function(){
          jQuery("#preview").modal('hide');
          jQuery("#html-email-container").modal();
          return false;
      });
      var delay;
      editor.on("change", function() {
          clearTimeout(delay);
          delay = setTimeout(updatePreview(editor), 300);
      });
      setTimeout(updatePreview(editor), 300);
  });

   function updatePreview(editor) {
       var previewFrame = document.getElementById('html-preview');
       var preview =  previewFrame.contentDocument ||  previewFrame.contentWindow.document;
       var survey_path = "/surveys/"+ document.getElementById('question_id').value;
       var htmlContent = editor.getValue();
       var surveyPattern = /<survey_link>/gi;
       htmlContent = htmlContent.replace(surveyPattern,survey_path);
       preview.open();
       preview.write(htmlContent);
       preview.close();
   }