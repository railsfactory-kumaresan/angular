require "spec_helper"

describe PrivilegeHelper do
	
  describe "Load tab details" do
    it "To load tab details" do
      result = helper.load_tab_details('disable','','')
      result.should eql "this.href ='';alert('#{APP_MSG["authorization"]["limit"]}');return false;"
    end
    it "To load tab details when email" do
      result = helper.load_tab_details('','','email')
      result.should eql "email_body_append_editor('');"
    end		
    it "To load tab details when sms" do
      result = helper.load_tab_details('','','sms')
      result.should eql "share_sms_div_load('');"
    end
    it "To load tab details when call" do
      result = helper.load_tab_details('','','call')
      result.should eql "share_make_call_div_load('');"
    end		
  end
	
end