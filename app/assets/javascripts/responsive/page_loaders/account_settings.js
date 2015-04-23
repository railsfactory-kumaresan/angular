function limit_restriction()
{
  limit = jQuery('#maximum_limit').val();
  selected_items = jQuery('#client_setting_language_ids_ :selected').size();
        if(selected_items > limit)
        {
          msg = "Maximum limit exceeds.You can select " + limit + " language(s) only"
          jQuery('select#client_setting_language_ids_ option').removeAttr("selected");
          alert(msg);
        }
};