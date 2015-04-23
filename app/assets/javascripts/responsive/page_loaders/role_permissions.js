

jQuery( document ).ready(function() {
jQuery(".parent-select").each(function() {
id = this.id
id  = id.split("_")[1]
child_id = "#sub_feature_index_" + id;
parent_id = "#feature_" + id + "_access_level"

        if(jQuery(child_id).children().length == jQuery(child_id).find('input[type=checkbox]:checked').length) {
              jQuery(parent_id).prop('checked', true);

        } else {
                 jQuery(parent_id).prop('checked', false);
        }

});


jQuery(".parent-select").click(function () {

id = this.id
id  = id.split("_")[1]
child_id = "#sub_feature_index_" + id;
parent_id = "#feature_" + id + "_access_level"
 var is_checked = jQuery(parent_id).is(':checked');
 if(is_checked)
 {
   jQuery(child_id).find('input[type=checkbox]').each(function() {
    this.checked = true;
    });
 }
 else
 {
   jQuery(child_id).find('input[type=checkbox]').each(function() {

    this.checked = false;
    });
 }

   });

    jQuery(".sub_case").click(function(){

      id = this.id
id  = id.split("_")[2]
child_id = "#sub_feature_index_" + id;
          parent_id = "#feature_" + id + "_access_level"
        if(jQuery(child_id).children().length == jQuery(child_id).find('input[type=checkbox]:checked').length) {
              jQuery(parent_id).prop('checked', true);

        } else {
                 jQuery(parent_id).prop('checked', false);
        }

    });

});
