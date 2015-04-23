require 'spec_helper'
describe DashboardController do
  # let(:valid_session) { {} }
  before(:each){
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:authenticate_user_web_api).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
  }
  describe "GET index" do
    business_user
    context "if user login present" do
      it "should redirect to dashboard page if current user present and format html" do
        params = {:category => "1", :from_date => "2014/02/17",:to_date => "2014/02/18"}
        get :index, params #, { :format => :html }
        expect(response.status).to eq(200)
      end
    end
    context "" do
      it "should redirect to dashboard page if current user present and format json" do
        params = {:status => "tab_ajax", :category => 1 }
        xhr :get, :index, params
      end
    end
    it "admin should redirect to listener page" do
      user = FactoryGirl.create(:user,:default_biz_user, :business_type_id => 2, :admin => true, :email => "admininq@inquirly.com", :authentication_token => "45327374456384674834")
      sign_in user
      get :index
      response.should redirect_to "/admin/pricing_plans"
    end
  end
  
  describe "#show_dashboard_wordcloud" do
    it "show the dashboard wordcloud" do
      user = FactoryGirl.create(:user,:default_biz_user, :business_type_id => 2)
      sign_in user
      pricing_plan = FactoryGirl.create(:pricing_plan, :test_pricing_plan)
      client_settings = FactoryGirl.create(:client_setting, :client_feature_settings,pricing_plan_id: pricing_plan.id,user_id: user.id)    
      question = FactoryGirl.create(:questions, :user_id => user.id, :expired_at => Time.now + 4.days, :expiration_id => "1 Month")      
      counts_store = FactoryGirl.create(:counts_store, question_id: question.id)
      params = {action: "index", controller: "dashboard"}
      post :show_dashboard_wordcloud, params
      expect(JSON.parse(response.body)["response"]).not_to be_blank
    end
  end   
  
  describe "GET share_active" do
    business_user
      it "update active status as true for share question" do
        share_question = FactoryGirl.create(:share_question)
        params = {id: share_question.id, active: 'on'}
        get :share_active, params
        expect(response.body).to eq("Success")
      end
      it "update active status as false for share question" do
        share_question = FactoryGirl.create(:share_question)
        params = {id: share_question.id, active: 'off'}
        get :share_active, params
        expect(response.body).to eq("Success")
      end
    end  
    
  describe "#shift_to_trial_period" do
    business_user
    it "shift_to_trial_period" do 
      FactoryGirl.create(:client_setting, :client_feature_settings, user_id: @user.id, pricing_plan_id: PricingPlan.first.id)
      get :shift_to_trial_period
      expect(JSON.parse(response.body)["body"]["view"]).to eq("success")
    end
  end
  
end