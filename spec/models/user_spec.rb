require "spec_helper"

describe User do
  #~ include SolrSpecHelper
  #~ before(:all) do
    #~ solr_setup
  #~ end

describe "# Association" do
  it { should have_many(:questions) }
  it { should have_many(:share_questions) }
  it { should have_many(:transaction_details) }
  it { should have_many(:business_customer_infos) }
  it { should have_one(:attachment) }
  it { should have_one(:listener) }

  it { should accept_nested_attributes_for :attachment}
end
  context "validation" do
    it "should have valid factory" do
      User.delete_all
      FactoryGirl.build(:user,:user_all).should be_valid
    end

    it "fails validation with mismatch password confirmation " do
      user = FactoryGirl.build(:user,:mis_match_confirmation,:password_confirmation =>'23456788')
      user.should_not be_valid
      message = "Your passwords should match"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    #  it "fails validation without companyname" do
    #    user = FactoryGirl.build(:user,:without_company_name , :company_name=>'')
    #    user.should_not be_valid
    #    message = "Please enter Company name"
    #    expect {user.errors.messages.include?(message)}.to be_true
    #  end

    #  it "fails validation with minimum length of companyname " do
    #    user = FactoryGirl.build(:user,:without_company_name , :company_name=>'T')
    #    user.should_not be_valid
    #    message = "Company Name should be min 2 and max 50 characters"
    #    expect {user.errors.messages.include?(message)}.to be_true
    #  end

    it "fails validation without firstname " do
      user = FactoryGirl.build(:user,:without_first_name , :first_name=>'')
      user.should_not be_valid
      message = " Please enter First name"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation without lastname " do
      user = FactoryGirl.build(:user,:without_last_name , :last_name=>'')
      user.should_not be_valid
      message = "Please enter Last name"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation without email address " do
      user = FactoryGirl.build(:user,:without_email , :email=>'')
      user.should_not be_valid
      message = "Please enter your Email Adress"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation with wrong email address " do
      user = FactoryGirl.build(:user,:without_email , :email=>'test')
      user.should_not be_valid
      message = "Please enter a valid Email Address"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation without password" do
      user = FactoryGirl.build(:user,:without_password , :password =>'')
      user.should_not be_valid
      message = "Please enter Password"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation with minium length password" do
      user = FactoryGirl.build(:user,:without_password , :password =>'2345')
      user.should_not be_valid
      message = "Password should be 8-16 characters"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation without confirmation password" do
      user = FactoryGirl.build(:user,:without_password_confirmation , :password_confirmation => "")
      user.should_not be_valid
      message = "Please enter Confirm Password"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation without bussiness type" do
      user = FactoryGirl.build(:user,:without_bussiness_type , :business_type_id => "")
      user.should_not be_valid
      message = "Select account type"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation with wrong bussiness type" do
      user = FactoryGirl.build(:user,:without_bussiness_type)
      user.should_not be_valid
    end

    it "fails validation with minimum length firstname " do
      user = FactoryGirl.build(:user,:without_first_name , :first_name=>'a')
      user.should_not be_valid
      message = " Please enter First name"
      expect {user.errors.messages.include?(message)}.to be_true
    end

    it "fails validation with minimum length lastname " do
      user = FactoryGirl.build(:user,:without_last_name , :last_name=>'a')
      user.should_not be_valid
      message = "Please enter Last name"
      expect {user.errors.messages.include?(message)}.to be_true
    end
  end

  describe "find_for_facebook_oauth"  do
    it "it should find facebook user" do
      fb_user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      user = User.find_for_facebook_oauth(fb_user)
      expect(user.id).to eql fb_user.id
      expect(user.uid).to eql fb_user.uid
      expect(user.provider).to eql fb_user.provider
      expect(user.email).to eql fb_user.email
      User.delete_all
    end

    it "it should create new facebook user" do
      User.delete_all
      fb_user = OmniAuth.config.mock_auth[:facebook]
      user = User.find_for_facebook_oauth(fb_user)
      expect(User.count).to eql 1
      expect(User.first.provider).to eq fb_user.provider
      expect(User.first.first_name).to eq fb_user.info.first_name
    end
  end

  describe "find_for_twitter_oauth"  do
    it "it should find twitter user" do
      User.delete_all
      twitter_user = FactoryGirl.create(:user,:twitter_user, :twitter_oauth_token => "1234567899")
      auth = {"credentials" => {"token" => twitter_user.twitter_oauth_token}}
      user = User.find_for_twitter_oauth(auth)
      expect(user.id).to eql twitter_user.id
      expect(user.twitter_oauth_token).to eql twitter_user.twitter_oauth_token
      expect(user.provider).to eql twitter_user.provider
      expect(user.email).to eql twitter_user.email
    end

    it "it should create new twitter user" do
      User.delete_all
      twitter_user = OmniAuth.config.mock_auth[:twitter]
      user = User.find_for_twitter_oauth(twitter_user)
      expect(User.count).to eql 1
      expect(User.first.provider).to eq twitter_user.provider
      expect(User.first.first_name).to eq twitter_user.info.name
    end

  end

  describe "user status"  do
    it "it should update the user status" do
      user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      params = {"hidden_pass" => "password_enabled", "user" => {"first_name" => "Test facebook user"}}
      result = User.user_status(false, params["user"], user, params, user)
      expect(result).to eql true
    end
    it "it should update the user status pres as true" do
      user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      params = {"user" => {"first_name" => "Test facebook user", "password" => "Inquirly@123", "password_confirmation" => "Inquirly@123"}}
      result = User.user_status(true, params["user"], user, params, user)
      expect(result).to eql false
    end    
    it "it should update the user status pres as true" do
      user = FactoryGirl.create(:user,:facebook_user, :uid => "1234", :provider => "testuser")
      params = {"user" => {"first_name" => "Test facebook user", "password" => "Inquirly@123", "password_confirmation" => "Inquirly@123"}}
      result = User.user_status(false, params["user"], user, params, user)
      expect(result).to eql false
    end
    it "it should update the user status pres as true" do
      user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      params = {:hidden_pass => "password_enabled", "user" => {"first_name" => "Test facebook user", "password" => "Inquirly@123", "password_confirmation" => "Inquirly@123"}}
      result = User.user_status(false, params["user"], user, params, user)
      expect(result).to eql true
    end      
  end
  
  describe "find_for_google_oauth"  do
    it "it should create new google user" do
      auth = OmniAuth.config.mock_auth[:google]
      user = User.find_for_google_oauth(auth)
      expect(User.count).to eql 1
      # expect(User.first.provider).to eq auth.provider
      # expect(User.first.first_name).to eq auth.info.first_name
    end
  end

  describe "find_for_linkedin_oauth"  do
    it "it should find twitter user" do
      User.delete_all
      linkedin_user = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      auth = {"credentials" => {"token" => linkedin_user.linkedin_token}}
      user = User.find_for_linkedin_oauth(auth)
      expect(user.id).to eql linkedin_user.id
      expect(user.linkedin_token).to eql linkedin_user.linkedin_token
      expect(user.provider).to eql linkedin_user.provider
      expect(user.email).to eql linkedin_user.email
    end

    it "it should create new linkedin user" do
      User.delete_all
      linkedin_user = OmniAuth.config.mock_auth[:linkedin]
      user = User.find_for_linkedin_oauth(linkedin_user)
      expect(User.count).to eql 1
      expect(User.first.provider).to eq linkedin_user.provider
      expect(User.first.first_name).to eq linkedin_user.info.first_name
    end
  end

  describe "question_expiry" do
    before do
      User.delete_all
      Question.delete_all
      @user = FactoryGirl.create(:user,:user_all)
    end
    it "it should return year wise question detail not to be empty and month wise question detail to be empty" do
      @year_wise_questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      month_question,year_question = User.question_expiry
      expect(month_question).to be_empty
      expect(year_question.first.user_id).to eq @year_wise_questions.user_id
      expect(year_question.first.id).to eq @year_wise_questions.id
      expect(year_question.first.expiration_id).to eq @year_wise_questions.expiration_id
    end

    it "it should return month wise question detail not to be empty and year wise question details to be empty" do
      @month_wise_questions = FactoryGirl.create(:question ,:month_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      month_question,year_question = User.question_expiry
      expect(year_question).to be_empty
      expect(month_question.first.user_id).to eq @month_wise_questions.user_id
      expect(month_question.first.id).to eq @month_wise_questions.id
      expect(month_question.first.expiration_id).to eq @month_wise_questions.expiration_id
    end
  end

  describe "social_setting_info" do
    before do
      User.delete_all
      @fuser = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      @tuser = FactoryGirl.create(:user,:twitter_user, :twitter_oauth_token => "1234567899")
      @luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
    end
    it "facebook social login status should be true " do
      current_user = User.find @fuser.id
      status  = current_user.social_setting_info
      expect(status).not_to be_empty
      expect(status[:fb]).to eq "true"
      expect(status[:twitter]).to be nil
      expect(status[:linkedin]).to be nil
    end

    it "twitter social login status should be true " do
      current_user = User.find @tuser.id
      status  = current_user.social_setting_info
      expect(status).not_to be_empty
      expect(status[:fb]).to be nil
      expect(status[:twitter]).to eq "true"
      expect(status[:linkedin]).to be nil
    end

    it "linkedin social login status should be true " do
      current_user = User.find @luser.id
      status  = current_user.social_setting_info
      expect(status).not_to be_empty
      expect(status[:fb]).to be nil
      expect(status[:twitter]).to be nil
      expect(status[:linkedin]).to eq "true"
    end
  end

  describe "dashboard_details" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
      @questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      @t_detail = FactoryGirl.create(:transaction_detail, :user_id => @user.id)
    end
    it "get transaction detail and active questions" do
      user = User.find @user.id
      result = user.dashboard_details
      expect(result.count).to eq 2
      expect(result[0].id).to eq @t_detail.id
      expect(result[0].user_id).to eq @user.id
      expect(result[1].first.id).to eq @questions.id
      expect(result[1].first.user_id).to eq @user.id
    end
  end

  describe "get_location_wise_count" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
      questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      FactoryGirl.create(:question_view_log, :provider_fb, :question_id => questions.id)
    end
=begin
    it "it should return collection of question logs" do
      user = User.find @user.id
      result = user.get_location_wise_count(params = nil)
    end
=end
  end

  describe "user_question" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
      @questions = FactoryGirl.create_list(:questions,10,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
    end
    it "it should return users Questions" do
      user = User.find @user.id
      result = user.user_question
      expect(result.count).to eql @questions.count
      expect(result.collect{|i|i.id}.sort).to eql @questions.collect{|i|i.id}.sort
    end
  end

  describe "get_mail_date" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
    end
    it "it should return user mailday and expired at" do
      user = User.find @user.id
      result = user.get_mail_date
    end
  end


  describe "check_user_auth_confirmed" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all, :authentication_token => "xyese2134343434",:confirmed_at => Time.now)
    end
    it "it should return confirmed user" do
      user = User.check_user_auth_confirmed(@user.authentication_token)
      expect(user).not_to be_nil
      expect(user.id).to eq @user.id
    end

    it "it should be nil" do
      user = User.check_user_auth_confirmed("7wwekwhjewoeuw")
      expect(user).to be_nil
    end
  end

  describe "update_qr_status" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
      @questions = FactoryGirl.create_list(:questions,10,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
    end
    it "it should update qrcode status as empty" do
      user = User.new.update_qr_status
      expect(user).to eq @questions.count
    end
  end

  describe "check_subscribe_user?" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
    end
    it "it should update qrcode status as empty" do
      user = User.new.check_subscribe_user?(@user)
      expect(user).to eq false
    end
  end

  describe "share_my_question" do
    before do
      User.delete_all
      @fuser = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      @tuser = FactoryGirl.create(:user,:twitter_user, :twitter_oauth_token => "1234567899")
      @luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
    end
    it "Share My question counts it shuould return facebook count" do
      user = User.find @fuser.id
      questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @fuser.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      FactoryGirl.create(:share_question_new, :provider_facebook, :user_id => @fuser.id,:user_name => @fuser.first_name )
      fb_failure_user, twitter_failure_user, linkedin_failure_user, fb_acc_count, twitter_acc_count, linkedin_acc_count = user.share_my_question(questions.slug)
      expect(fb_acc_count).to eq 1
      expect(twitter_acc_count).to eq 0
      expect(linkedin_acc_count).to eq 0
    end

    it "Share My question counts it shuould return twitter count" do
      ShareQuestion.delete_all
      user = User.find @tuser.id
      questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @tuser.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      FactoryGirl.create(:share_question_new, :provider_twitter, :user_id => @tuser.id,:user_name => @tuser.first_name )
      fb_failure_user, twitter_failure_user, linkedin_failure_user, fb_acc_count, twitter_acc_count, linkedin_acc_count = user.share_my_question(questions.slug, {:message => "Test Test"})
      expect(fb_acc_count).to eq 0
      expect(twitter_acc_count).to eq 1
      expect(linkedin_acc_count).to eq 0
    end

    it "Share My question counts it shuould return linkedin count" do
      ShareQuestion.delete_all
      user = User.find @luser.id
      questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @luser.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
      FactoryGirl.create(:share_question_new, :provider_linkedin, :user_id => @luser.id,:user_name => @luser.first_name )
      fb_failure_user, twitter_failure_user, linkedin_failure_user, fb_acc_count, twitter_acc_count, linkedin_acc_count = user.share_my_question(questions.slug)
      expect(fb_acc_count).to eq 0
      expect(twitter_acc_count).to eq 0
      expect(linkedin_acc_count).to eq 1
    end
  end

  describe "facebook_distr_share" do
    it "it should share distribute facebook" do
      fuser = FactoryGirl.create(:user,:facebook_user, :uid => "1234", :fb_status => "true")
      FactoryGirl.create(:share_social_account, :user_id => fuser.id)
      fuser.facebook_distr_share({})
    end
    it "it should share distribute facebook with url" do
      fuser = FactoryGirl.create(:user,:facebook_user, :uid => "1234", :fb_status => "true")
      FactoryGirl.create(:share_social_account, :user_id => fuser.id)
      fuser.facebook_distr_share({:url => "http://incitecloud.com/inquirly/wp-content/uploads/inquirly-logo.png"})
    end    
  end

  describe "question_share_url_userlist" do
    before do
      User.delete_all
      @user = FactoryGirl.create(:user,:user_all)
      @b_user = FactoryGirl.create(:business_customer_info,:user_id => @user.id)
      @questions = FactoryGirl.create(:question ,:year_wise_expire,:user_id => @user.id,:question_type_id => QuestionType.first.id,:category_type_id => CategoryType.first.id)
    end
    it "it should update qrcode status as empty" do
      user = User.find @user.id
      question, custom_url, common_url, user_info_lists, voice_msg = user.question_share_url_userlist(@questions.id)
      expect(question.id).to eq @questions.id
      expect(custom_url).not_to  be nil
      expect(common_url).not_to  be nil
      expect(user_info_lists.first.id).to eq @b_user.id
    end
  end

  describe "social_nw_share_question" do
    before do
      User.delete_all
      @fuser = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
      @tuser = FactoryGirl.create(:user,:twitter_user, :twitter_oauth_token => "1234567899")
      @luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      @share_user  = FactoryGirl.create(:share_question_new, :provider_facebook, :user_id => @fuser.id,:user_name => @fuser.first_name )
    end
    it "it should update qrcode status as empty" do
      user = User.find @fuser.id
      fb_acc, linkedin_acc, twitter_acc = user.social_nw_share_question
      expect(fb_acc.first.id).to eq @share_user.id
      expect(linkedin_acc).to be_empty
      expect(twitter_acc).to be_empty
    end
  end

  describe "save_default_content" do
    it "it should save_default_content" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.save_default_content(luser, "Welcome to New Inquirly ")
      expect(result).to eq "Welcome to New Inquirly "
    end 
  end
  
  describe "Social network status change" do
    it "it should change social network status" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.social_network_status_change(luser, 'fb', 'on')
      expect(result).to eq true
    end 
    it "it should change social network status" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.social_network_status_change(luser, 'twitter', 'on')
      expect(result).to eq true
    end     
    it "it should change social network status" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.social_network_status_change(luser, 'linkedin', 'off')
      expect(result).to eq true
    end      
  end

  describe "hash_result_for_social_login" do
    it "it should get hash_result_for_social_login" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.hash_result_for_social_login(luser)
      expect(result.class).to eq Hash
      expect(result[:email]).to eq luser.email
    end 
  end

  describe "Account Subscribe" do
    it "it should subscribe the account" do
      user = FactoryGirl.create(:user,:default_biz_user)
      csetting = FactoryGirl.create(:client_setting,:client_feature_settings, :user_id => user.id, :pricing_plan_id => 1)
      clanguage = FactoryGirl.create(:client_language,:test_client_language, :client_setting_id => csetting.id, :language_id => 2)
      result = user.account_subscribe(user.business_type_id)
      expect(result).to eq nil
    end 
  end
  
  describe "Account Cancel" do
    it "it should cancel the account" do
      user = FactoryGirl.create(:user,:default_biz_user)
      FactoryGirl.create(:client_setting,:client_feature_settings, :user_id => user.id, :pricing_plan_id => 1)
      result = user.account_cancel(user.business_type_id)
      expect(result).to eq true
    end 
  end
  
  describe "Check is trail peroid" do
    it "it should check the trail peroid of user" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = luser.is_trail_in_period?
      expect(result).to eq true
    end 
  end

  describe "Check valid email" do
    it "it should check correct email id" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = luser.is_valid_email("abcd@gmail.com")
      expect(result).to eq true
    end
    it "it should check wrong email id" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = luser.is_valid_email("abc@d@gmail.com")
      expect(result).to eq false
    end    
  end
  
  describe "Change role" do
    it "it should update the role id" do
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      result = User.change_role(luser)
      expect(result).to eq true
    end
  end

  describe "update_company_name" do
    it "should update company name" do
      user = FactoryGirl.create(:user, :default_biz_user)
      tenant = FactoryGirl.create(:tenant)
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899", parent_id: user.id, role_id: Role.last.id, tenant_id: tenant.id)
      params = {user: {company_name: "Inquirly Test"}}
      result = User.update_company_name(luser, params)
      expect(result.last.company_name).to eq "Inquirly Test"
    end
  end
  
  describe "same_url_update_user" do
    it "should same url update user" do
      user = FactoryGirl.create(:user, :default_biz_user)
      tenant = FactoryGirl.create(:tenant, client_id: user.id)
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899", parent_id: user.id, role_id: Role.last.id, tenant_id: tenant.id)
      tenant_url = Tenant.where("redirect_url is null or redirect_url=?",luser.redirect_url).where(client_id: user.id)
      params = {user: {redirect_url: "http://www.inquirly.com"}}
      result = User.new.same_url_update_user(luser,tenant_url,params)
      expect(result.last).to eq(tenant_url.last)
    end
    it "should same url update user where tenant is zero" do
      user = FactoryGirl.create(:user, :default_biz_user)
      tenant = FactoryGirl.create(:tenant, client_id: user.id)
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899", parent_id: user.id, role_id: Role.last.id, tenant_id: tenant.id)
      tenant_url = Tenant.where("redirect_url is null or redirect_url=?",luser.redirect_url).where(client_id: luser.id)
      params = {user: {redirect_url: "http://www.inquirly.com"}}
      result = User.new.same_url_update_user(luser,tenant_url,params)
      expect(result).to eq([])
    end    
  end

  describe "same_number_update_user" do
    it "should same number update user" do
      user = FactoryGirl.create(:user, :default_biz_user)
      tenant = FactoryGirl.create(:tenant, client_id: user.id)
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899", parent_id: user.id, role_id: Role.last.id, tenant_id: tenant.id)
      tenant_no = Tenant.where("from_number is null or from_number=?",luser.from_number).where(client_id: user.id)
      params = {user: {redirect_url: "http://www.inquirly.com"}}
      result = User.new.same_number_update_user(luser,tenant_no,params)
      expect(result.last).to eq(tenant_no.last)
    end
    it "should same number update user where tenant is zero" do
      user = FactoryGirl.create(:user, :default_biz_user)
      tenant = FactoryGirl.create(:tenant, client_id: user.id)
      luser = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899", parent_id: user.id, role_id: Role.last.id, tenant_id: tenant.id)
      tenant_no = Tenant.where("from_number is null or from_number=?",luser.from_number).where(client_id: luser.id)
      params = {user: {redirect_url: "http://www.inquirly.com"}}
      result = User.new.same_number_update_user(luser,tenant_no,params)
      expect(result).to eq([])
    end    
  end
end