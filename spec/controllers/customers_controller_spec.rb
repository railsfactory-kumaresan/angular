require 'spec_helper'

describe CustomersController do
  before(:each){
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    # controller.stub(:authenticate_user_web_api).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
  }
  describe "#index" do
    business_user
    it "must respond with customer information without sort and filter, customer_records_count type specified" do
      params = {:share_type => 'customer_records_count', :sort => nil, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last == @biz_customer_info
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and filter, email_count type specified" do
      params = {:share_type => 'email_count', :sort => nil, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last.email == @biz_customer_info.email
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and filter, call_count or sms_count type specified" do
      params = {:share_type => 'sms_count', :sort => nil, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last.mobile == @biz_customer_info.mobile
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and without filter, customer_records_count type selected" do
      params = {:share_type => "customer_records_count", :sort => {:column=>"email", :by=>"asc"}, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and without filter, customer_records_count type selected" do
      params = {:share_type => "email_count", :sort => {:column=>"email", :by=>"asc"}, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and without filter, customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => {:column=>"email", :by=>"asc"}, :filter => nil,:logic => nil,:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      BusinessCustomerInfo.last == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, customer_records_count type selected" do
      params = {:share_type => "customer_records_count", :sort => nil, :filter => {"0"=>{"field"=>"email", "operator"=>"contains", "value"=>"ramanujam@gmail.com"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_1
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, customer_records_count type selected" do
      params = {:share_type => "email_count", :sort => nil, :filter => {"0"=>{"field"=>"email", "operator"=>"contains", "value"=>"Atest@gmail.com"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => nil, :filter => {"0"=>{"field"=>"mobile", "operator"=>"contains", "value"=>"+91 12345678"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_1
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and with filter, customer_records_count type selected" do
      params = {:share_type => "customer_records_count", :sort => {"column"=>"email", "by"=>"asc"}, :filter => {"0"=>{"field"=>"email", "operator"=>"contains", "value"=>"ramanujam@gmail.com"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_1
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, customer_records_count type selected" do
      params = {:share_type => "email_count", :sort => {"column"=>"email", "by"=>"asc"}, :filter => {"0"=>{"field"=>"email", "operator"=>"contains", "value"=>"Atest@gmail.com"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => {"column"=>"mobile", "by"=>"asc"}, :filter => {"0"=>{"field"=>"mobile", "operator"=>"contains", "value"=>"+91 12345678"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and with filter, all selection operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => {"column"=>"country", "by"=>"asc"}, :filter => {"0"=>{"logic"=>"or", "filters"=>{"0"=>{"field"=>"age", "operator"=>"gte", "value"=>"23"}, "1"=>{"field"=>"age", "operator"=>"lte", "value"=>"25"}}}, "1"=>{"field"=>"country", "operator"=>"eq", "value"=>"India"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and with filter, starts with operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => {"column"=>"country", "by"=>"asc"}, :filter => {"0"=>{"field"=>"customer_name", "operator"=>"startswith", "value"=>"Srinivasa"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_1
      expect(response.status).to eq(200)
    end
    it "must respond with customer information with sort and with filter, ends with operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => {"column"=>"country", "by"=>"asc"}, :filter => {"0"=>{"field"=>"customer_name", "operator"=>"endswith", "value"=>"Abtest"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, doesnotcontain operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => nil, :filter => {"0"=>{"field"=>"gender", "operator"=>"doesnotcontain", "value"=>"Male"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", gender: "", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, not equal operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => nil, :filter => {"0"=>{"field"=>"state", "operator"=>"neq", "value"=>"TN"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", gender: "", state: "kerala", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, is greater than operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => nil, :filter => {"0"=>{"field"=>"age", "operator"=>"gt", "value"=>"19"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", gender: "", state: "kerala", age: "18", user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_1
      expect(response.status).to eq(200)
    end
    it "must respond with customer information without sort and with filter, is less than operator , customer_records_count type selected" do
      params = {:share_type => "sms_count", :sort => nil, :filter => {"0"=>{"field"=>"age", "operator"=>"lt", "value"=>"19"}},:logic => "and",:top => "20", :authentication_token => @user.authentication_token}
      @biz_customer_info_1 = FactoryGirl.create(:business_customer_info, user_id: @user.id, status: nil, is_deleted: nil)
      @biz_customer_info_2 = FactoryGirl.create(:business_customer_info, email: "Atest@gmail.com", customer_name: "Abtest", gender: "", state: "kerala", age: "17",user_id: @user.id, status: nil, is_deleted: nil)
      get :index, params
      assigns[:business_customer_infos].first.should == @biz_customer_info_2
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    business_user
    it "must respond with status 200" do
      params = {}
      params[:models] = {:mobile=> "123456789",:email => "abc@def.ghi",:country=>  "IN",:gender=> "male"}
      params[:authentication_token] = @user.authentication_token
      xhr :post, :create, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#show" do
    business_user
     it "must respond with status 200 xhr request" do
      xhr :get, :show, authentication_token: @user.authentication_token, status: "dashboard",:id => @user.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must respond with status 200" do
      get :show, authentication_token: @user.authentication_token,:id => @user.id,:view_info => "true"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#update" do
    business_user
    it "must respond with status 200" do
      @business_customer_info = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      # params = {}
      # params[:customer][:mobile] =
      # params[:authentication_token] = @user.authentication_token
      # params[:id] = @business_customer_info.id
      put :update, :customer => {:mobile=> "1234567890",:country=>"IN", :email => "ramanujam@gmail.com"},:authentication_token => @user.authentication_token,:id => @business_customer_info.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#delete_selected" do
    business_user
    it "must respond with status 200" do
      @business_customer_info = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      post :delete_selected, id: @business_customer_info.id, authentication_token: @user.authentication_token, bulk_delete: "yes", email: @business_customer_info.email
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
  
  describe "#get_customer_email" do
    business_user
    it "must respond with status 200" do
      get :get_customer_email, authentication_token: @user.authentication_token
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
  
  describe "#email_duplication_check" do
    business_user
    it "email duplication check no mobile and email params" do
      @business_customer_info = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      get :email_duplication_check, id: @business_customer_info.id
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end
    it "email duplication check email params exists" do
      @business_customer_info = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "919629000000", :user_id => @user.id)
      get :email_duplication_check, id: @business_customer_info.id, email: customer_info.email
      expect(JSON.parse(response.body)["result"]).to eq(true)
      expect(response).to be_success
    end   
    it "email duplication check email params exists without id" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "919629000000", :user_id => @user.id)
      get :email_duplication_check, email: customer_info.email
      expect(JSON.parse(response.body)["result"]).to eq(true)
      expect(response).to be_success
    end
    it "email duplication check email params exists without id" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "919629000000", :user_id => @user.id)
      get :email_duplication_check, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(true)
      expect(response).to be_success
    end    
  end  
  
  describe "#mobile_duplication_check" do
    business_user
    it "mobile duplication check no mobile and email params" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "9629000000", :user_id => @user.id)
      get :mobile_duplication_check, id: customer_info.id, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end
    it "mobile duplication check mobile params exists" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "9629000000", :user_id => @user.id)
      get :mobile_duplication_check, id: customer_info.id, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end    
    it "mobile duplication check email params exists" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "9629000000", :user_id => @user.id)
      get :mobile_duplication_check, id: customer_info.id, email: customer_info.email, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end   
    it "mobile duplication check email params exists without id" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "9629000000", :user_id => @user.id)
      get :mobile_duplication_check, email: customer_info.email, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end
    it "mobile duplication check mobile params exists without id" do
      customer_info = FactoryGirl.create(:business_customer_info, email: "test@gmail.com", mobile: "9629000000", :user_id => @user.id)
      get :mobile_duplication_check, mobile: customer_info.mobile
      expect(JSON.parse(response.body)["result"]).to eq(false)
      expect(response).to be_success
    end    
  end  
  
  describe "remove social account" do
    business_user
    it "delete the social account" do
      share_question = FactoryGirl.create(:share_question, user_id: @user.id)
      post :remove_social_account, id: share_question.id
      expect(JSON.parse(response.body)["status"]).to eq(200)
    end
    it "delete the social account if record not found" do
      post :remove_social_account, id: nil
      expect(JSON.parse(response.body)["status"]).to eq(403)
    end    
  end

end