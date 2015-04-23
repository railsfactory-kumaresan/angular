function click_ind() {
  $("#ind-select").removeClass("plan-selected");
  $("#bus-select").addClass("plan-selected");
  $("#individual").addClass("individual-plan");
  $("#individual").removeClass("business-plan");
  $("#bussiness").removeClass("individual-plan");
  $("#plan_id").val("ind");
  $(".billingInfo-plan-name").html("Individual Plan");
  $('#billingInfo').modal('show');
}

function click_bus(plan_id, plan_name,billStatus) {
      jQuery.ajax({
        type: 'GET',
        url: '/account/change_plan?new_plan_id='+plan_id,
        success: function(data){
            if(data.message == "allow to pay")
            {
              //~ $("#bus-select").removeClass("plan-selected");
              //~ $("#ind-select").addClass("plan-selected");
              //~ $("#individual").addClass("business-plan");
              //~ $("#individual").removeClass("individual-plan");
              //~ $("#bussiness").addClass("individual-plan");
              //~ $("#bussiness").removeClass("business-plan");
              jQuery("#plan_id").val(plan_id);
              jQuery("#plan_action").val(data.plan_action);
              jQuery(".billingInfo-plan-name").html("Billing Details: " + plan_name);
              jQuery('#billingInfo').modal('show');
              if (billStatus == 'true'){jQuery(".disab").prop('readonly', true);}
              else{jQuery(".disab").prop('readonly', false);}
            }
            else
            {
           //alert(data.message);
            $(".plan_message").text(data.message);
            $('#alert_msg').modal('show');
            }
        }
    });
}

function validate_phone(phone)
{
  if ((phone.length < 10) || (phone.length >11))
  {
    jQuery('#buyerPhoneNumber').val('');
  }
}

function validate_pin(pin)
{
  if (pin.length < 6)
  {
    new Messi('Pin Code must be six character', {
      title : null,
      autoclose : 1700,
      buttons: false
    }, {
      center : true,
      viewport : {
        top : '760px',
        left : '0px'
      }
    });
    jQuery('#buyerPincode').val('');
  }
}

function validate_pin(pin)
{
  if (pin.length < 6)
  {
    new Messi('Pin Code must be six character', {
      title : null,
      autoclose : 1700,
      buttons: false
    }, {
      center : true,
      viewport : {
        top : '760px',
        left : '0px'
      }
    });
    jQuery('#buyerPincode').val('');
  }
}

 //~ function validate_payment()
  //~ {
    //~ if (($.trim($("#billing_email").val()) == "" || $.trim($("#billing_address").val()) == "" || $.trim($("#billing_city").val()) == "" || $.trim($("#billing_state").val()) == "" || $.trim($("#billing_country").val()) == "" || $.trim($("#billing_zip").val()) == "" || $.trim($("#billing_tel").val()) == "") && ($.trim($('#plan_id').val())==""))
    //~ {
      //~ $("#payment_error").css("display", "block");
      //~ $("#business_select").css("display", "block");
      //~ return false;
    //~ }
    //~ else if ($.trim($("#billing_email").val()) == "" || $.trim($("#billing_address").val()) == "" || $.trim($("#billing_city").val()) == "" || $.trim($("#billing_state").val()) == "" || $.trim($("#billing_country").val()) == "" || $.trim($("#billing_zip").val()) == "" || $.trim($("#billing_tel").val()) == "")
    //~ {
      //~ $("#payment_error").css("display", "block");
      //~ $("#business_select").css("display", "none");
      //~ return false;
    //~ }
    //~ else if ($('#plan_id').val()=="")
    //~ {
      //~ $("#payment_error").css("display", "none");
      //~ $("#business_select").css("display", "block");
      //~ return false;
    //~ }
    //~ else
    //~ {
      //~ $("#business_select").css("display", "none");
      //~ $("#payment_error").css("display", "none");
      //~ return true;
    //~ }
//~ } 

function validate_payment()
{
   var return_status = true;
    if (jQuery('#billing_email').val() === ""){
        jQuery('#billing_email').next().text("Please enter the email address.");
        jQuery('#billing_email').next().show();
        return_status = false;
    }
    else if (validateEmail(jQuery('#billing_email').val()))
    {
      jQuery('#billing_email').next().text("Please enter the valid email address.");
        jQuery('#billing_email').next().show();
        return_status = false;
    }
    else { jQuery('#billing_email').next().hide();}
    
    if (jQuery('#billing_address').val() === ""){
        jQuery('#billing_address').next().text("Please enter your address.");
        jQuery('#billing_address').next().show();
        return_status = false;
    }
  else { jQuery('#billing_address').next().hide();}
    
    if (jQuery('#billing_name').val().length < 3 || jQuery('#billing_name').val().length >30)
    {
        jQuery('#billing_name').next().text("Billing Name field should have minimum 3 and maximum 30 letters.");
        jQuery('#billing_name').next().show();
        return_status = false;
    }
    else if (!jQuery('#billing_name').val().match(/^[ A-Za-z0-9_-]*$/))
    {
        jQuery('#billing_name').next().text("Billing Name field should have only alphabets and blank space");
        jQuery('#billing_name').next().show();
        return_status = false;
    }
    else { jQuery('#billing_name').next().hide(); }
    
    if (jQuery('#billing_city').val().length < 3 || jQuery('#billing_city').val().length >30)
    {
        jQuery('#billing_city').next().text("City field should have minimum 3 and maximum 30 letters.");
        jQuery('#billing_city').next().show();
        return_status = false;
    }
    else if (jQuery('#billing_city').val().match(/[^a-zA-Z\ ]/))
    {
        jQuery('#billing_city').next().text("City field should have only alphabets and blank space");
        jQuery('#billing_city').next().show();
        return_status = false;
    }
    else { jQuery('#billing_city').next().hide(); }
    
    if (jQuery('#billing_state').val().length < 2 || jQuery('#billing_state').val().length >30)
    {
        jQuery('#billing_state').next().text("Stat field should have minimum 2 and maximum 30 letters.");
        jQuery('#billing_state').next().show();
        return_status = false;
    }
    else if (jQuery('#billing_state').val().match(/[^a-zA-Z\ ]/))
    {
        jQuery('#billing_state').next().text("State field should have only alphabets and blank space");
        jQuery('#billing_state').next().show();
        return_status = false;
    }
    else { jQuery('#billing_state').next().hide(); }
    
    if (jQuery('#billing_country').val().length < 1 || jQuery('#billing_country').val().length >50)
    {
        jQuery('#billing_country').next().text("Please select your Country");
        jQuery('#billing_country').next().show();
        return_status = false;
    }
    else if (jQuery('#billing_country').val().match(/[^a-zA-Z\ ]/))
    {
        jQuery('#billing_country').next().text("Country field should have only alphabets and blank space");
        jQuery('#billing_country').next().show();
        return_status = false;
    }
    else { jQuery('#billing_country').next().hide(); }
    
    if (jQuery('#billing_zip').val() === ""){
        jQuery('#billing_zip').next().text("Please enter the zip code.");
        jQuery('#billing_zip').next().show();
        return_status = false;
    }
  else { jQuery('#billing_zip').next().hide(); }
  
  if (jQuery('#billing_tel').val() === ""){
        jQuery('#billing_tel').next().text("Please enter the Phone number.");
        jQuery('#billing_tel').next().show();
        return_status = false;
    }
  else { jQuery('#billing_tel').next().hide(); }
if(return_status == true){
    jQuery(".disab").prop('readonly', false);
return true;

}else{ return false; }
}

 function validateEmail($email) {
  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  if( !emailReg.test( $email ) ) {
    return true;
  } else {
    return false;
  }
}
jQuery(document).ready(function() 
{
    jQuery(".edit_billing_details").click(function(){jQuery(".edit_billing_details").hide();jQuery(".update_billing").show();jQuery(".edit_billing_details").attr("id","update_billing");jQuery(".edit_billing_details_leave").show();jQuery(".disab").prop('readonly', false);return false;})
    jQuery(".update_billing").click(function(){
        jQuery.ajax({
            type:'POST',
            data: jQuery(".form-horizontal").serialize(),
            url:'/payments/update_billing',
            dataType :"script",
            success:function(data) {
                jQuery( ".form-horizontal" ).append(data);
                jQuery("#success").html("Billing details updated successfully.").show(0).delay(1500).hide(0);
                jQuery(".disab").prop('readonly', true);
                jQuery(".update_billing").hide();
                jQuery(".edit_billing_details_leave").hide();
                jQuery(".edit_billing_details").show();
                return false;
            }
        });
        return false;
    })

    jQuery(".edit_billing_details_leave").click(function(){
        jQuery(".update_billing").hide();
        jQuery(".edit_billing_details_leave").hide();
        jQuery(".edit_billing_details").show();
        jQuery(".disab").prop('readonly', true);
            })
	jQuery("body").delegate("#billing_zip,#billing_tel","keypress",function(e) {
			var a = [8,46,0];
			var k = e.which;
			for (i = 48; i < 58; i++)
					a.push(i);
			if (!(a.indexOf(k)>=0))
					e.preventDefault();
	});
  //~ $('#payment_error').hide();
  //~ bussiness_type = <%= @bussiness_type %>
  //~ if (bussiness_type == 1)
  //~ {
    //~ $("#bus-select").addClass("plan-selected");
    //~ $("#individual").addClass("individual-plan");
    //~ $("#bus_type").val("ind");
  //~ }
  //~ else
  //~ {
    //~ $("#ind-select").addClass("plan-selected");
    //~ $("#bussiness").addClass("individual-plan");
    //~ $("#bus_type").val("bus");
  //~ }
});