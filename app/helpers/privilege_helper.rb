module PrivilegeHelper

  def load_tab_details(action,js_param,tab)
     if action == "disable"
       "this.href ='';alert('#{APP_MSG["authorization"]["limit"]}');return false;"
     else
       case tab
         when 'email'
          "share_email_div_load('#{js_param}');"
         when 'sms'
          "share_sms_div_load('#{js_param}');"
         when 'call'
          "share_make_call_div_load('#{js_param}');"
         else
          ""
       end
    end
  end
end
