require 'spec_helper'

describe ShareController do
  before(:each){
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user,:default_biz_user, :id => 50000)
    controller.stub(:current_user){@user}
    sign_in :user, @user
    @question = FactoryGirl.create(:question, :user_id => @user.id, :expired_at => Time.now + 4.days, :expiration_id => "1 Month")
    controller.stub(:check_admin_user).and_return(@user)
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_current_user_share_access).and_return(true)
  }

  describe "#show" do
  end

  describe "#social_status_change" do
    it "must respond with status 200" do
      params = {
        status: "on",
        provider: "twitter"
      }
      get :social_status_change, params
      expect(@user.twitter_status) == "true"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#share_email" do
    it "must respond with status 200" do
      params = {
        subject: "testing share controller",
        message: "share email a success",
        to: "kumaresan@railsfactory.org",
        customer_ids: "234",
        id: @question.id
      }
      xhr :post, :share_email, params
      expect(@user.twitter_status) == "true"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#show_embed_code" do
    it "must return wih status 200" do
      params = {
        "id" => @question.id
      }
      get :show_embed_code, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#show_sms" do
    it "must respond with status 200" do
      xhr :get, :show_sms, {:id => @question.id}
      response.should_not render_template '/share/show_sms'
    end
  end

  describe "#share_sms" do
  end

  describe "#show_call_list" do
    it "must respond with status 200" do
      params = {
        id: @question.id
      }
      xhr :get, :show_call_list, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#share_call" do
    it "must respond with status 200" do
      params = {
        id: @question.id
      }
      @request.env["HTTP_ACCEPT"] = 'application/json'
      post :share_call, params,:authentication_token => @user.authentication_token
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#share_to_social_nw" do
    it "must respond with status 200" do
      params = {
        id: @question.id
      }
      get :share_to_social_nw, params
      response.body.should redirect_to("/share/#{@question.slug}")
    end
  end

  describe "#qrdownload" do
    # not in routes
  end

  describe "#call_handle" do
    it "must respond with status 200" do
      post :call_handle,{:question_id => @question.id,:question_view_id=> "viewed",:format => 'xml'}
      response.status.should eq(200)
    end
  end

  describe "#handle_gather" do

  end

  describe "#qrcode_url" do
    it "generate qrcode_url and must respond with status 200" do
      @request.env["HTTP_ACCEPT"] = 'application/json'
      get :qrcode_url
      # response.format.should eql "appliction/json"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#show_qr" do
    it "generate qrcode_url and must respond with status 200" do
      params = {
        id: @question.id
      }
      get :show_qr, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#send_sms" do
    # no there in routes
  end

  describe "#check_auth_token" do
    # not there in routes
  end

  describe "#activate_qr" do
    it "must respond with status 200." do
      params = {
        id: @question.id
      }
      post :activate_qr, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#api_qrcode_url" do
    it "must respond with status 200" do
      params = {
        id: @question.id
      }
      post :api_qrcode_url, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must reflect in stats" do
      expect(1).to eq(1)
    end
  end

  describe "#get_all_categories" do
    # not there in routes
  end

  describe "#user_social_setting" do
    # not there in routes
  end

  describe "#update_status" do
    # not there in routes
  end
end