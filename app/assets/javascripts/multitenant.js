$(document).ready(function(){
        $("#update_user_roles").click(function(){
              var user_ids = []
             jQuery(".user_id:checked").each(function() { user_ids.push($(this).val());});
            var role_id = jQuery("#user_role_id").val();
            if(role_id == ""){
                $("#error_role_id").text("Please Choose any Role").show();
                return false;
            }else if(role_id != "" && user_ids.length < 1){
                $("#error_role_id").text("Please select atleast one user").show();
                return false;
            }
            else{
                $("#error_role_id").hide();
                return true;
            }
        });

//      $("#update_user_roles").click(function(){
//          var user_ids = []
//          jQuery(".user_id:checked").each(function() { user_ids.push($(this).val());});
//           var role_id = jQuery("#user_role_id").val();
//           if(role_id == ""){
//               $("#error_role_id").text("Please Choose any Role");
//           }else{
//               $("#error_role_id").hide();
//               jQuery.ajax({
//                   type: "POST",
//                   url: "/corporate_users/update_user_roles",
//                   data:  {user_ids: user_ids, role_id: role_id},
//                   dataType: "json",
//                   success: function(data){
//                        window.location.reload();
//                   }
//               });
//           }
//      });

        jQuery("body").delegate("#role_id","change", function(){
            var role_id = $("#role_id").val();
            if (role_id != ""){ $("#error_role_id").hide();}
        });

    /* Checkbox Select */
        $('.user_ids').click(function () {
            if($(".user_ids").is(':checked')){
                $('.user_id').prop('checked', true);
            }else{
                $('.user_id').prop('checked', false);
            }
        });
        $('.user_id').click(function () {
         if ($('.user_id').length == $('.user_id:checked').length){
               $(".user_ids").prop('checked', true);
          }else{
               $(".user_ids").prop('checked', false);
          }
        });

    /* Auto Complete for Tenant Name */
    jQuery("#InputTenantName").autocomplete({
        source: "/corporate_users/search_tenant_name",
        minLength:1,
        delay:100,
        select: function(event, ui) {
            jQuery("#InputTenantName").val(ui.item.label);
        },
        messages: {
            noResults: '',
            results: function() {}
        }
     });

    /* Create Org Details Validation */
    $("#InputMobileNumber,#InputPhoneNumber, #InputPinCode").keypress(function (e) {
        //if the letter is not digit then display error and don't type anything
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });
    jQuery("body").delegate("#org_country","change", function(){
        var country = $("#org_country").val();
        if (country != ""){ $("#error_country").hide();}
        jQuery.ajax({
            url: "/surveys/states?keywords="+ country,
            type: 'GET',
            success: function(data){
            }
        });
    });
    jQuery("body").delegate("#org_state","change", function(){
        var state = $("#org_state").val();
        if (state != ""){ $("#error_state").hide();}
    });


    /* Create Organization Details */

    jQuery("#org_details_submit").click(function(){
        var params = jQuery( "#org-details" ).serialize();
        jQuery.ajax({
            type: "POST",
            url: "/account/create_org_details",
            data:   params,
            dataType: "json",
            success: function(data){
                if (data.status == 400)
                {
                    var errors = data.errors
                    $(".error").hide();
                    for (x in errors)
                        $('#error_'+x).html(errors[x][0]).show();
                }else if(data.status == 200){
                    window.location.reload();
                    $("#flash-message").append('<div id="flash_message" class="flash-message"><div class="alert alert-warning fade in"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">x</button><strong><span id="msg_container">'+ data.message +'</span></strong></div></div>');
                }
            }
        });
        return false;
    });

    /* Update Organization Details */
    jQuery("#update_org_details_submit").click(function(){
        var params = jQuery( "#org-details-edit" ).serialize();
        jQuery.ajax({
            type: "PUT",
            url: "/account/update_org_details",
            data:   params,
            dataType: "json",
            success: function(data){
                if (data.status == 400)
                {
                    var errors = data.errors
                    $(".error").hide();
                    for (x in errors)
                        $('#error_'+x).html(errors[x][0]).show();
                }else if(data.status == 200){
                    window.location.reload();
                    $("#flash-message").append('<div id="flash_message" class="flash-message"><div class="alert alert-warning fade in"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">x</button><strong><span id="msg_container">'+ data.message +'</span></strong></div></div>');
                }
            }
        });
        return false;
    });

    });

/* Reset Password function */
function reset_password(id){
    jQuery.ajax({
        type: "POST",
        url: "/corporate_users/reset_password",
        data:  {user_id: id},
        dataType: "json",
        success: function(data){
            $("#flash_message").remove();
            $("#flash-message").append('<div id="flash_message" class="flash-message"><div class="alert alert-warning fade in"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">x</button><strong><span id="msg_container">'+ data.message +'</span></strong></div></div>').show();
            setTimeout(function() { $("#flash-message").hide(); }, 5000);
        }
    });
}

/* Active and De activate - User*/
function make_active(id, status){
    jQuery.ajax({
        type: "POST",
        url: "/corporate_users/change_user_status",
        data:  {user_id: id, is_active: status},
        dataType: "json",
        success: function(data){
            if (data.status == 200 ){
                var span_text = data.is_active == true ? "Deactivate" : "Activate";
                var span = jQuery("change_status_"+id+"").selector
                var method = "change_user_status("+id+","+ data.is_active +");"
                jQuery("#"+span).attr('onclick', method);
                jQuery("#"+span).text(span_text);
                jQuery("#"+span).attr('Title', span_text);

            }
        }
    });
}

/* Active and De activate - Tenant*/
function make_tenant_active(id, status, value){
    jQuery.ajax({
        type: "POST",
        url: "/tenants/change_tenant_status",
        data:  {tenant_id: id, is_active: status},
        dataType: "json",
        success: function(data){
            if (data.status == 200 ){
                var span_text = data.is_active == true ? "Deactivate" : "Activate";
                var span = jQuery("change_status_"+id+"").selector
                var method = "change_tenant_status("+id+","+ data.is_active +");"
                jQuery("#"+span).attr('onclick', method);
                jQuery("#"+span).text(span_text);
                jQuery("#"+span).attr('Title', span_text);
            }
        }
    });
}