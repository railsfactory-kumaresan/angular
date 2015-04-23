require "spec_helper"

describe ApplicationHelper do
  include Devise::TestHelpers
  describe "#check_role_level_permissions_js" do
    it "returns true" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      helper.check_role_level_permissions_js('corporate_users', 'change_user_status').should eql(false)
    end
  end
  
  describe "#qustion_created" do
    it "returns true" do
      time_now = Time.now
      helper.qustion_created(time_now).should eql(time_now.to_date.strftime("%b %d, %Y"))
    end
  end

  describe "#countries" do
    it "must return all countries" do
      helper.countries.should eql(Country.all)
    end
  end

  describe "#find_country" do
    it "should return right country name if alpha 2 value is given" do
      alpha2 = "in"
      helper.find_country(alpha2).should eql("India")
    end

    it "should return alpha 2 if wrong alpha 2 value is given" do
      alpha2 = "ZD" # hopefully wrong value
      helper.find_country(alpha2).should eql(alpha2)
    end
  end

  describe "#question_expire" do
    it "should return 1 when expiray date is 1 day" do
      helper.question_expire("1 Day", Time.now + 1.day).should eql(0)
    end

    it "should return 7 when expiray date is 1 Week" do
      helper.question_expire("1 Week", DateTime.now + 7.day).should eql(6)
    end

    it "should return 30 when expiray date is around 1 Month" do
      helper.question_expire("1 Month", DateTime.now + 30.day).should eql(29)
    end

    it "should return 365 when the expiry is around 1 year" do
      helper.question_expire("1 Year", DateTime.now + 365.day).should eql(364)
    end
  end

  describe "#find_date_response_count" do
    it "should return date response count" do
      answers = [FactoryGirl.create(:answer, :uuid => 4), FactoryGirl.create(:answer, :uuid => 4), FactoryGirl.create(:answer, :uuid => 5)]
      helper.find_date_response_count(answers).should eql(2)
    end
  end
  
  describe "#calculate_unknown_count" do
    it "should return calculate unknown count" do
      helper.calculate_unknown_count(5, 2).should eql(3)
    end
  end  
  
  describe "#country_load_all" do
    it "should return country load all" do
      result = helper.country_load_all
      result.class.should eql(Array)
      result.count.should eql(247)
    end
  end    
  
  describe "#enable_listen_menu" do
    it "should enable listen menu" do
      result = enable_listen_menu("anjan@inquirly.com")
      result.should eql("anjan")
    end
    it "should enable listen menu" do
      result = enable_listen_menu("manimaransudha@gmail.com")
      result.should eql("sudha")
    end
    it "should enable listen menu" do
      result = enable_listen_menu("amarkanand@yahoo.com")
      result.should eql("amar")
    end    
  end  
  
  describe "#image_file_format_check" do
    it "should image file format check" do
      helper.image_file_format_check("fixtures/img.jpg").should eql(true)
    end
    it "should image file format check" do
      helper.image_file_format_check("fixtures/img.apk").should eql(false)
    end    
  end
  
  describe "#wicked_pdf_image_tag_for_public" do
    it "multiple image wicked_pdf_image_tag_for_public" do
      helper.wicked_pdf_image_tag_for_public("fixtures/img.jpg")
    end    
  end  
  
  describe "#wicked_pdf_image_tag" do
    it "multiple image wicked_pdf_image_tag" do
      helper.wicked_pdf_image_tag("fixtures/img.jpg")
    end    
  end

  describe "#qr_code" do
    it "get qr code url" do
      helper.qr_code("sjdfdsj").should eql("https://chart.googleapis.com/chart?cht=qr&chs=300x300&chl=sjdfdsj")
    end    
  end
  
  describe "#facebook_sharing_url" do
    it "get facebook_sharing_url" do
      user = FactoryGirl.create(:user, :default_biz_user)
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id)      
      params = {:id => question.slug, :action => 'show', :controller => 'surveys'}
      helper.stub(:params).and_return(params)
      helper.facebook_sharing_url.should eql(user.company_name)
    end    
  end  
  
  describe "#qr_code active url" do
    it "get the active qr code url" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id)        
      helper.qr_code_active_url(question).should eql(question.qrcode_short_url)
    end    
  end  
  
  describe "#qr_code active question" do
    it "get the active qr code question" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id, :qrcode_status => "Active")        
      helper.qr_code_active_question.should eql(question.id)
    end    
  end   
  
  describe "#embed_code active question" do
    it "get the active embed code question" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id, :embed_status => true)        
      helper.embed_active_question.should eql(question.id)
    end    
  end    
  
  describe "#low_value_plan" do
    it "get the low_value_plan" do      
      helper.low_value_plan.plan_name.should eql("Trial")
    end    
  end   
  
  describe "#high_value_plan" do
    it "get the high_value_plan" do      
      helper.high_value_plan.plan_name.should eql("Enterprise")
    end    
  end    
  
  describe "#feature_column_list" do
    it "get the feature_column_list" do      
      helper.feature_column_list.should eql(COLUMN_NAME["column_settings"].except("business_type_id","amount"))
    end    
  end    

  describe "#feature_column_list_new" do
    it "get the feature_column_list_new" do      
      helper.feature_column_list_new.should eql(COLUMN_NAME["column_resetting"])
    end    
  end
  
  describe "#get_plan_name" do
    it "get the plan_name" do
      plan = PricingPlan.find_by_plan_name("Solo")
      helper.get_plan_name(plan.id).should eql(plan.plan_name)
    end    
  end
  
  describe "#assign_parent_id" do
    it "assign parent id to the user" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user      
      helper.assign_parent_id.should eql(user.id)
    end   
  end    
  
  describe "#get_transaction_detail" do
    it "get the transaction detail" do
      tdetail = FactoryGirl.create(:transaction_detail)
      helper.get_transaction_detail(tdetail.order_id).amount.should eql(tdetail.amount)
    end   
  end  
  
  describe "#get_tenant_count" do
    it "get the tenant count detail" do
      user = FactoryGirl.create(:user, :default_biz_user)
      #helper.get_tenant_count(user)
    end   
  end    
  
  describe "#billing_info_country" do
    it "get the billing info country" do
      result = helper.billing_info_country
      result.class.should eql(Array)
      result.count.should eql(Country.all.count)
    end   
  end     
  
  describe "#valid_email" do
    it "check valid email" do
      helper.valid_email?("abcd@gmail.com").should eql(true)
    end  
    it "check invalid email" do
      helper.valid_email?("ab.cd@gma.il.com").should eql(true)
    end    
  end   

  describe "#user_plan_billinginfo" do
    it "get the user plan billinginfo" do
      user = FactoryGirl.create(:user, :default_biz_user)
      billing_info_detail = FactoryGirl.create(:billing_info_detail, :user_id => user.id)
      sign_in user
      billing_info, plan_name = helper.user_plan_billinginfo(user)
      billing_info.billing_name.should eql(billing_info_detail.billing_name)
      plan_name.should eql("Business")
    end   
  end 
  
  describe "#check_pricing_plan_access" do
    it "To check the pricing plan access" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      helper.check_pricing_plan_access(user).should eql(true)
    end   
  end   
  
  describe "#user_redirect_url" do
    it "To check the user_redirect_url" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id)  
      params = {:id => question.slug}
      helper.stub(:params).and_return(params)      
      helper.user_redirect_url.should eql(ENV["DEFAULT_REDIRECT_URL"])
    end   
  end    
  
  describe "#check_listener_permisson" do
    it "To check the listener permisson" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      helper.check_listener_permisson.should eql(false)
    end   
  end  
  
  describe "#default_url_phone_user" do
    it "To check the default url phone_user" do
      user = FactoryGirl.create(:user, :default_biz_user)
      sign_in user
      helper.default_url_phone_user.should eql(ENV["CALL_NUM"])
    end   
  end    
  
  describe "#check_customer_info" do
    it "To check the check customer info" do
      user = FactoryGirl.create(:user, :default_biz_user)
      FactoryGirl.create(:business_customer_info, :user_id => user.id)
      sign_in user
      helper.check_customer_info.should eql(true)
    end   
  end    
  # describe "#inactive_question_expire" do
  #   it "should return 1 expiration_id is 1 Day" do
  #     question = FactoryGirl.create(:question, :without_expired_at, expiration_id: "1 Day")
  #     helper.inactive_question_expire(question).should eql(1)
  #   end

  #   it "should return 7 expiration_id is 1 Week" do
  #     question = FactoryGirl.create(:question, :without_expired_at, expiration_id: "1 Week")
  #     helper.inactive_question_expire(question).should eql(7)
  #   end

  #   it "should return 30 expiration_id is 1 Month" do
  #     question = FactoryGirl.create(:question, :without_expired_at, expiration_id: "1 Month")
  #     helper.inactive_question_expire(question).should eql(30)
  #   end

  #   it "should return 365 when expiration_id is 1 Year" do
  #     question = FactoryGirl.create(:question, :without_expired_at, expiration_id: "1 Year")
  #     helper.inactive_question_expire(question).should eql(365)
  #   end

  #   it "should return 365 if expired at is set to 365 days from now" do
  #     question = FactoryGirl.create(:question, :expired_at_set_to_365_days)
  #     helper.inactive_question_expire(question).should eql(365)
  #   end

  #   it "should return 0 when expired_at is in the past" do
  #     question = FactoryGirl.create(:question, :expired_at_in_past)
  #     helper.inactive_question_expire(question).should eql(0)
  #   end
  # end

  # describe "copy_url" do
    # it "should return a url when question is given to copy_url" do
    #   question = FactoryGirl.create(:question, expiration_id: "1 Year")
    #   helper.copy_url(question.id).should match(/http:\/\//)
    # end

    # it "should return a url when question is given to embed_url" do
    #   question = FactoryGirl.create(:question, expiration_id: "1 Year")
    #   helper.embed_url(question.id).should match(/http:\/\//)
    # end
  # end

  #~ describe "#account_subscription" do
    #~ it "must return downgrade for business user" do
      #~ current_user = FactoryGirl.create(:user, :default_biz_user, is_active: true, subscribe: true)
      #~ result = helper.account_subscription current_user
      #~ expect(result).to eq( ["Downgrade", "/account/downgrade"])
    #~ end

    #~ it "must return upgrade for normal user" do
      #~ current_user = FactoryGirl.create(:user, :default_user, is_active: true, subscribe: true)
      #~ result = helper.account_subscription current_user
      #~ expect(result).to eq( ["Upgrade", "/account/upgrade"])
    #~ end
  #~ end




end