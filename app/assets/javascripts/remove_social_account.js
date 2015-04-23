jQuery(document).ready(function(){
         jQuery('.remove-social').click(function(){
             jQuery(this).addClass('selected');
             jQuery('#remove_social_account').modal('show');
         });
         jQuery('#yes-remove').click(function(){
             var id = jQuery(".remove-social.selected").attr('value');
             jQuery.ajax({
                 type: 'POST',
                 url: '/customers/remove_social_account',
                 data: {id: id},
                 dataType: "JSON",
                 success: function(data){
                     if(data.status == 200){
                         var current_account = jQuery('#div_'+id);
                         var parent = current_account.parent().attr("id");
                         switch(parent) {
                             case "facebook_account":
                                 if (jQuery("#facebook_account li").length == 1){
                                     jQuery("#facebook_account").parent().parent().remove();
                                 }else{
                                     current_account.remove();
                                 }
                                 break;
                             case "twitter_account":
                                 if (jQuery("#twitter_account li").length == 1){
                                     jQuery("#twitter_account").parent().parent().remove();
                                 }else{
                                     current_account.remove();
                                 }
                                 break;
                             case "linkedin_account":
                                 if (jQuery("#linkedin_account li").length == 1){
                                     jQuery("#linkedin_account").parent().parent().remove();
                                 }else{
                                     current_account.remove();
                                 }
                                 break;

                         }
                         jQuery(".remove-social").each(function(){
                             jQuery(this).removeClass('selected');
                         });
                         jQuery('#remove_social_account').modal('hide');
                     }
                 }
             });
             return true;
         });
         jQuery('#no-remove, .social-removal').click(function(){
           jQuery(".remove-social").each(function(){
               jQuery(this).removeClass('selected');
           });
         });
 });