require 'spec_helper'

describe ShareController do
  include Devise::TestHelpers
  before(:each){
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user,:default_biz_user)
    controller.stub(:current_user){@user}
    sign_in :user, @user
    @question = FactoryGirl.create(:question, :user_id => @user.id, :expired_at => Time.now + 4.days, :expiration_id => "1 Month")
    controller.stub(:check_admin_user).and_return(@user)
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_current_user_share_access).and_return(true)
    controller.stub(:authenticate_user_web_api).and_return(true)
    controller.stub(:check_role_level_permissions).and_return(true)
    controller.stub(:check_current_user_question).and_return(true)
    controller.stub(:set_maximum_limit).and_return(true)
  }
  describe "GET show" do
    context "" do
      it "should validate the current user can access this share page" do
        get :show,  {:id => @question.id, :question_id => @question.slug}, :format => 'html'
        response.status.should eq(200)
      end
    end
    context "" do
      it "should redirect to user edit page if not authorized to share" do
        @user.email = "test@sfd"
        @user.save
        get :show, {:id => @question.slug, :question_id => @question.slug}, :format => 'html'
        response.should redirect_to "/users/edit"
      end
    end
  end
  describe "GET social_status_change" do
    it "should set the status true for facebook if status is on" do
      get :social_status_change, {:status => "on", :provider => "fb" }, :format => "json"
      user = User.find(@user.id)
      user.fb_status.should == "true"
    end
    it "should set the status false for facebook if status is off" do
      get :social_status_change, {:status => "off", :provider => "fb" }, :format => "json"
      user = User.find(@user.id)
      user.fb_status.should == "false"
    end
    it "should set the status true for twitter if status is on" do
      get :social_status_change, {:status => "on", :provider => "twitter" }, :format => "json"
      user = User.find(@user.id)
      user.twitter_status.should == "true"
    end
    it "should set the status true for twitter if status is off" do
      get :social_status_change, {:status => "off", :provider => "twitter" }, :format => "json"
      user = User.find(@user.id)
      user.twitter_status.should == "false"
    end
    it "should set the status true for linkedin if status is on" do
      get :social_status_change, {:status => "on", :provider => "linkedin" }, :format => "json"
      user = User.find(@user.id)
      user.linkedin_status.should == "true"
    end
    it "should set the status false for twitter if status is off" do
      get :social_status_change, {:status => "off", :provider => "linkedin" }, :format => "json"
      user = User.find(@user.id)
      user.linkedin_status.should == "false"
    end
  end

  describe "share sms to users" do
   it "should share SMS" do
    post :share_sms,{ message: "<survey link> #{@question.question}",:id => @question.id, :question_id => @question.slug,:phone_number_sms => "+91 9994587002",:format => "js"}
   end
  end

  describe "show sms" do
   it "should show SMS page" do
    xhr :get,:show_sms,{:id => @question.id,:format => "js"}
    response.status.should eq(200)
   end
  end

  describe "share call to customers" do
   it "should share call to selected users" do
    post :share_call,{ call_default_content: "#{@question.question}",:id => @question.slug, :question_id => @question.slug,:phone_number => "91 9994587002",authentication_token: "#{@user.authentication_token}",:format => "html"}
    expect(response.status).to eq(200)
   end

   it "should share call to selected users - request should be json - api request" do
    post :share_call,{ call_default_content: "#{@question.question}",:id => @question.slug, :question_id => @question.slug,:phone_number => ["91 9994587002", "91 9715621817"],authentication_token: "#{@user.authentication_token}",:format => "json"}
   end
  end


  describe "share call to customers" do
   it "should share call to selected users" do
    post :make_demo_call,{ demo_content: "#{@question.question}",:id => @question.slug,:phone_number => "91 9994587002",:format => "js"}
    expect(response.status).to eq(200)
   end
   it "should share call to selected users - api josn request" do
    post :make_demo_call,{ demo_content: "#{@question.question}",:id => @question.slug,:phone_number => "91 9994587002",authentication_token: "#{@user.authentication_token}",:format => "json"}
    expect(response.status).to eq(200)
   end
  end


  describe "share question via social network(Twitter)" do
   it "should share question to users through social network" do
    @twitter_user = FactoryGirl.create(:user,:twitter_user, :twitter_oauth_token => "1234567899")
    controller.stub(:current_user){@twitter_user}
    sign_in :user, @twitter_user
    existing_user = FactoryGirl.create(:existing_social_user,:user_id =>@twitter_user.id)
    Rack::Test::UploadedFile.new('spec/fixtures/1.jpg', 'image/jpg')
    FactoryGirl.create(:attachment,:user_image,:image_file_name => "1.jpg",:attachable_type => "Question",:attachable_id => @question.id)
    post :share_to_social_nw,{:id => @question.slug,:question_id => @question.slug ,:message => "This is testing"}
  #  expect(response.status).to eq(200)
   end
  end

  describe "share question via social network(linkedin))" do
    it "should share question to users through social network" do
      @linkedin_user = FactoryGirl.create(:user,:linkedin_user, :linkedin_token => "1234567899")
      controller.stub(:current_user){@linkedin_user}
      sign_in :user, @linkedin_user
      existing_user = FactoryGirl.create(:existing_social_user_linkedin,:user_id => @linkedin_user.id)
      post :share_to_social_nw,{:id => @question.slug,:question_id => @question.slug ,:message => "This is testing"}
      # expect(response.status).to eq(200)
    end
  end

  describe "share question via social network(Facebook)" do
    it "should share question to users through social network" do
      @fb_user = FactoryGirl.create(:user,:facebook_user, :uid => "1234" ,:authentication_token => "xyese2134343434",:confirmed_at => Time.now)
      controller.stub(:current_user){@fb_user}
      sign_in :user, @fb_user
      existing_user = FactoryGirl.create(:existing_social_user_fb,:user_id => @fb_user.id)
      post :share_to_social_nw,{:id => @question.slug,:question_id => @question.slug ,:message => "This is testing"}
      #expect(response.status).to eq(200)
    end
  end

  describe " Download qrcode" do
   it "should download qrcode" do
    post :qrdownload,{:url => @question.qrcode_short_url}
    expect(response.status).to eq(200)
   end
  end

  describe "customer data grid count" do
    it "should set the maximum limit" do
      xhr :get, :customers_data_grid, :share => "customer_records_count", format: :js
    end
  end

  describe "Mandrill Email activity report" do
    it 'should get the latest mandrill report based on the date' do
      params = {"email"=>"kumareshc10@gmail.com", "from_date"=>"2015/02/27", "to_date"=>"2015/02/28"}
      xhr :post, :mandril_report, params, format: :json
      JSON.parse(response.body)["status"] == 200
      JSON.parse(response.body)["message"] == "Email report will be sent to '#{@user.email}' email address shortly."
    end
  end
  describe "Twilio call activity report" do
    it 'should get the voice call report based on the date' do
      params = {"email"=>"kumareshc10@gmail.com", "start_date"=>"2015/02/27", "end_date"=>"2015/02/28"}
      xhr :post, :twillo_call_report, params, format: :json
      JSON.parse(response.body)["status"] == 200
      JSON.parse(response.body)["message"] == "No result found"
    end
  end
end
