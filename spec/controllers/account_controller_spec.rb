require 'spec_helper'

describe AccountController do
  # include Devise::TestHelpers
  before(:each){
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:authenticate_user_web_api).and_return(true)
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_role_level_permissions).and_return(true)
    controller.stub(:catch_exceptions).and_yield
  }

  describe "#change_plan" do
    before(:each){
      @user = FactoryGirl.create(:user, :default_biz_user, :business_type_id => 2)
      sign_in @user
    }
		it "return current plan" do
			params = {new_plan_id: 2}
      get :change_plan, params
		 expect(JSON.parse(response.body)["plan_action"]).to eq("current_plan")
	 end
		it "return upgrade plan" do
			params = {new_plan_id: 3}
      get :change_plan, params      
		 expect(JSON.parse(response.body)["plan_action"]).to eq("upgrade")
	 end
	 		it "return downgrade plan" do
			params = {new_plan_id: 1}
      get :change_plan, params        
		 expect(JSON.parse(response.body)["plan_action"]).to eq("downgrade")
		end
  end
  
  describe "#change_plan2" do
    before(:each){
      @user = FactoryGirl.create(:user, :default_biz_user, :business_type_id => 2, subscribe: true, exp_date: Time.now+8.days)
      sign_in @user
    }
		it "return current plan" do
			params = {new_plan_id: 2}
      get :change_plan, params
		 expect(JSON.parse(response.body)["message"]).to eq("You have to choose a new plan")
	 end
		it "return upgrade plan" do
			params = {new_plan_id: 3}
      get :change_plan, params      
		 expect(JSON.parse(response.body)["message"]).to eq("allow to pay")
	 end
	 		it "return downgrade plan" do
			params = {new_plan_id: 1}
      get :change_plan, params        
		 expect(JSON.parse(response.body)["message"]).not_to be_blank
		end
  end  
  #~ describe "User click upgrade link" do
    #~ context "When user click upgrade button with business user" do
      #~ subscribed_user
      #~ it "should redirect back and display the flash message" do
        #~ request.env["HTTP_REFERER"] = "account/upgrade"
        #~ get 'upgrade',{:authentication_token => @user.authentication_token }
        #~ flash[:non_fade_notice].should eql("You are already a business user,if you need you can DownGrade you account by next billing cycle")
        #~ response.should redirect_to "account/upgrade"
      #~ end
    #~ end

    #~ context "When user click upgrade button with individual user" do
      #~ individual_user
      #~ it "should redirect to payment planning page" do
        #~ get 'upgrade',{:authentication_token => @user.authentication_token }
        #~ response.should redirect_to '/payments/merchant_test'
      #~ end
    #~ end
  #~ end

  #~ describe "User click Downgrade link" do
    #~ before(:each){
      #~ controller.stub(:check_admin_user).and_return(true)
    #~ }
    #~ context "When user click Downgrade button with business user" do
      #~ subscribed_user
      #~ it "should redirect to dash board" do
        #~ request.env["HTTP_REFERER"] = "account/downgrade"
        #~ get 'downgrade',{:authentication_token => @user.authentication_token }
        #~ response.should redirect_to "account/downgrade"
      #~ end
    #~ end

    #~ context "When user click Downgrade button with individual user" do
      #~ subscribe_false_user
      #~ it "should redirect to payment planning page" do
        #~ get 'downgrade',{:authentication_token => @user.authentication_token }
        #~ response.should redirect_to '/payments/merchant_test'
      #~ end
    #~ end
  #~ end

  describe "User update their account logo" do
    context "when user update new logo for their account" do
      business_user
      it "should update with valid parameters" do
        request.env["HTTP_REFERER"] = "/"
        image=fixture_file_upload("/1.jpg")
        attachment = {:image=> image, account_id: @user.id}
        post :account_attachment, attachment
        flash[:notice].should eql("Company logo uploaded successfully")
        response.should redirect_to '/'
      end
    end

    context "when user update new logo for their without account id" do
      business_user
      it "should update with valid parameters" do
        request.env["HTTP_REFERER"] = "/"
        image=fixture_file_upload("/1.jpg")
        attachment = {:image=> image, account_id: ""}
        post :account_attachment, attachment
        flash[:notice].should eql("Invalid account info")
        response.should redirect_to '/'
      end
    end
  end

  #~ describe "#manageuser" do
  #~ it "must allow business user inside" do
  #~ User.delete_all
  #~ @user = FactoryGirl.create(:user,:default_biz_user, :authentication_token => "5666666666666666663940340394")
  #~ get :manageuser, :authentication_token => @user.authentication_token
  #~ expect(assigns[:user]).to eq @user
  #~ expect(assigns[:mangeuser]).to be_empty
  #~ end

  #~ it "must redirect to /account when user is non business user" do
  #~ User.delete_all
  #~ # move this to another spec and see
  #~ @user = FactoryGirl.create(:user,:default_user, :authentication_token => "5666666666666666663940340394")
  #~ get :manageuser, :authentication_token => @user.authentication_token
  #~ flash[:notice].should eql "You have no access to manage user"
  #~ response.should redirect_to "/account"
  #~ end
  #~ end

  describe "#company_settings" do
    business_user
    it "it should return user status,user business id" do
      get :company_settings
      expect(request.session[:referrer]).to eq "/account/company_settings"
      status_hash =  {:fb=>nil, :twitter=>nil, :linkedin=>nil}
      expect(assigns[:status]).to eq status_hash
      expect(assigns[:user_business_id]).to eq @user.business_type_id
      expect(assigns[:subscribe]).to eq @user.subscribe
    end
    it "it should return user status,user business id" do
      @user.company_name = nil
      @user.save(:validate => false)
      get :company_settings
      expect(request.session[:referrer]).to eq "/account/company_settings"
      response.should redirect_to "/users/edit"
    end    
  end

  #~ describe "#update_company_info" do
    #~ business_user
    #~ context "" do
      #~ it "it should update company names" do
        #~ put :update_company_info, {:authentication_token => @user.authentication_token, :company_name => "ABC test company"}
        #~ #flash[:notice].should eq("Company name updated successfully.")
        #~ #response.should redirect_to "/account/company_settings"
	      #~ response.status.should == 200
      #~ end
    #~ end
    #~ context "" do
      #~ it "it should throw errors" do
        #~ User.delete_all
        #~ @user = FactoryGirl.create(:user,:default_biz_user, :authentication_token => "56666666666666666639403sds40394")
        #~ put :update_company_info, {:authentication_token => @user.authentication_token, :company_name => ""}
      #~ end
    #~ end
  #~ end

  #~ describe "#transaction_history" do
    #~ it "it should return business type" do
      #~ User.delete_all
      #~ @user = FactoryGirl.create(:user,:default_biz_user, :authentication_token => "5666666666666666663940340394")
      #~ get :transaction_history, :authentication_token => @user.authentication_token
      #~ expect(assigns[:business_type]).to eq @user.business_type_id
      #~ expect(assigns[:trasactionhistory]).to be_blank
    #~ end
  #~ end

  describe "#user_accounty" do
    context "when user update new logo for their account" do
      business_user
      it "it should return business type" do
        get :user_account, :authentication_token => @user.authentication_token
        expect(assigns[:user]).to eq @user
      end
    end
  end

  describe "#get_customer_info" do
    it "it should return customer info" do
      User.delete_all
      @user = FactoryGirl.create(:user,:default_biz_user, :authentication_token => "5666666666666666663940340394")
      FactoryGirl.create(:business_customer_info, :user_id => @user.id )
      get :get_customer_info, :authentication_token => @user.authentication_token
  # expect(assigns[:customer_info_details]).to be_empty
end
end
describe "#check_trial_user_account_status" do
  business_user
  it "it should return user expire status" do
    account = AccountController.new
		account.check_trial_user_account_status
end
end

describe "#valid_email" do
  before(:each){
    controller.stub(:check_admin_user).and_return(true)
  }
  context "When user have valid email" do
    business_user
    it "it should return valid email" do
      post :valid_email, {:authentication_token => @user.authentication_token}
      parsed_body = JSON.parse(response.body)
      parsed_body["body"]["success"].should == "true"
      parsed_body["header"]["status"].should == 200
    end
  end

  context "When user have invalid email" do
    invalid_email_user
    it "should return invalid email error" do
      post :valid_email, :authentication_token => @user.authentication_token
      parsed_body = JSON.parse(response.body)
      parsed_body["body"]["errors"].should == "please update your email"
      parsed_body["header"]["status"].should == 400
    end
  end

  context "When no authentication_token present" do
    invalid_email_user
    it "should return paramter error" do
      post :valid_email
      parsed_body = JSON.parse(response.body)
      parsed_body["body"]["errors"].should == "Invalid token"
      parsed_body["header"]["status"].should == 1005
    end
  end

  context "When user not exist" do
    business_user
    it "should return failure authentication error" do
      post :valid_email, :authentication_token => "sss"
      parsed_body = JSON.parse(response.body)
      parsed_body["body"]["errors"].should == "Invalid token"
      parsed_body["header"]["status"].should == 1005
    end
  end
end

describe "company_settings" do
  # before(:each) do
  #   @request.env["HTTP_REFERER"] = "/account/company_settings"
  # end
  context "When user request company details" do
    business_user
    it "it should return valid email" do
      get :company_settings, :authentication_token => @user.authentication_token
      response.status.should == 200
      # response.should redirect_to "/account/company_settings"
      # parsed_body = JSON.parse(response.body)
      # parsed_body["body"]["success"].should == "true"
      # parsed_body["header"]["status"].should == 200
    end
  end

    # context "When user have invalid email" do
    #   invalid_email_user
    #   it "should return invalid email error" do
    #     post :valid_email, :authentication_token => @user.authentication_token
    #     parsed_body = JSON.parse(response.body)
    #     parsed_body["body"]["errors"].should == "please update your email"
    #     parsed_body["header"]["status"].should == 400
    #   end
    # end

    # context "When no authentication_token present" do
    #   invalid_email_user
    #   it "should return paramter error" do
    #     post :valid_email
    #     parsed_body = JSON.parse(response.body)
    #     parsed_body["body"]["errors"].should == "Invalid parameters"
    #     parsed_body["header"]["status"].should == 400
    #   end
    # end

    # context "When user not exist" do
    #   it "should return failure authentication error" do
    #     post :valid_email, :authentication_token => "ssss"
    #     parsed_body = JSON.parse(response.body)
    #     parsed_body["body"]["errors"].should == "Invalid token"
    #     parsed_body["header"]["status"].should == 1005
    #   end
    # end
  end

  describe "#social_login" do
    context "Social Login" do
      business_user
      it "must return error json when no parameters are given" do
        xhr :post, :social_login
        JSON.parse(response.body)["body"]["errors"].should eql('Invalid Parameters')
      end
    end
    context "User create" do
      it "must create a user if right parameters are present" do
        User.delete_all # delete all users
        params = {first_name: "Someone",
          last_name: "no name",
          uid: "mnasdfbadf8923her0fb",
          provider: "twitter",
          email: "abcdef@ghi.com"
        }
        xhr :post, :social_login, params
        expect(User.count).to eq(1)
        result_hash = JSON.parse(response.body)
        result_hash["body"]["first_name"].should eql(params[:first_name])
        result_hash["body"]["last_name"].should eql(params[:last_name])
      end
    end
    context "User create" do
      User.delete_all # delete all users
      business_user
      it "must register user for authentication token if the user is present" do
        @user.uid = "mnasdfbadf8923her0fb"
        @user.save
        params = {
          first_name: @user.first_name,
          last_name: @user.last_name,
          uid: @user.uid,
          provider: "twitter"
        }
        xhr :post, :social_login, params
        expect(User.count).to eq(1)
        result_hash = JSON.parse(response.body)
        result_hash["body"]["first_name"].should eql(params[:first_name])
        result_hash["body"]["last_name"].should eql(params[:last_name])
        result_hash["body"]["email"].should eql @user.email
      end
    end
  end

  describe "#add_social_account" do
    context "" do
      business_user
      it "must return json with Please enter valid details" do
        xhr :post, :add_social_account
        result_hash = JSON.parse(response.body)
        result_hash["status_text"].should eql('Please enter the valid details')
      end
    end
    context "Existing user added" do
      business_user
       it "must return 'Already user account added'" do
         share_question = FactoryGirl.create(:share_question, user_id: @user.id)
          params = {
            email: share_question.email_address,
            provider: "Twitter",
            user_id: @user.id
          }
         xhr :post, :add_social_account, params
         result_hash = JSON.parse(response.body)
         result_hash["error"].should eql("Already user account added")
         result_hash["status"].should eql(200)
       end
     end

    it "profile header" do
      get :profile_header
      expect(response).to be_success
    end
    
    context "" do
      business_user
      it "send success json response" do
        params = {
          email: "kumaresan@railsfactory.org",
          provider: "Twitter",
          user_id: @user.id
        }
        xhr :post, :add_social_account, params
        result_hash = JSON.parse(response.body)
        result_hash["success"].should eql("Success")
      end
    end
  end
  
  describe "#transaction_history" do
    before(:each){
      @user = FactoryGirl.create(:user, :default_biz_user, :business_type_id => 2)
      sign_in @user
    }
    it "transaction history" do
      transaction_detail = FactoryGirl.create(:transaction_detail, :user_id => @user.id)
      get :transaction_history
      expect(assigns[:trasactionhistory].last).to eq(transaction_detail)
    end
  end
end