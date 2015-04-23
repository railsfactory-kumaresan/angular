require "spec_helper"

describe SurveysController do
  before(:each){
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    @user = FactoryGirl.create(:user,:default_biz_user)
  }
  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code for show" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      get :show, id: question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
      response.should render_template(:layout => "layouts/question_response")
    end
  end

  describe "#show_question" do
    it "responds with status 200 for Ajax" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :show_question, id: @question.id, provider: "Twitter"
      assigns(:question).should eq(@question)
      assigns(:thanks_msg).should eq(@question.thanks_response)
      assigns(:provider).should eq("Twitter")
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    # it "responds eith question not found to show_question" do
    #   @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
    #   post :show_question,:id => @question.id
    #   flash[:notice].should eq("Question not found")
    #   response.should redirect_to "/"
    # end
  end

  describe "#create_user_info" do
    it "should return success and set up right class attributes" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      FactoryGirl.create(:question_response_log, question_id: question.id)
      xhr :post, :create_user_info, id: question.id, country: "IN"
      assigns(:question).should eq(question)
      assigns(:user_id).should eq(@user.id)
      assigns(:customer).class.should eq(BusinessCustomerInfo)
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
    it "should return errors" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      FactoryGirl.create(:question_response_log, question_id: question.id)
      business_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id)
      xhr :post, :create_user_info, id: question.id, country: "IN", email: business_customer_info.email
      expect(response).to be_success
      expect(response.status).to eq(200)
    end    
  end

  describe "#states" do
    it "should get states" do
      xhr :get, :states, keywords: "in"
      assigns(:states).should eq(Country["in"].states)
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  #~ describe "#answer" do
  	#~ business_user
    #~ it "must return status 200" do
      #~ question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      #~ get :answers
      #~ expect(response).to be_success
      #~ expect(response.status).to eq(200)
    #~ end

    #~ it "must return status 200 for ajax" do
      #~ question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      #~ xhr :get, :answers
      #~ expect(response).to be_success
      #~ expect(response.status).to eq(200)
    #~ end
  #~ end

  describe "#embed_survey" do
    it "must return status 200 and set up right class attributes" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :get, :embed_survey, id: question.id
      assigns(:company_name).first.company_name.should eq(@user.company_name) # There could be an issue with data structure
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
  
  it "update embed status" do
    question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
    sign_in @user
    get :update_embed_status, q_id: question.id
    expect(response).to be_success
  end
  
  describe "#show_embed_survey" do
    it "must return status 200 and must set right class attributes" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :show_embed_survey, provider: "embed", id: question.id
      assigns(:question).should eq(question)
      response.body.should eq("{\"provider\":\"embed\",\"question_id\":#{question.id}}")
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#response_save" do
    # since this is a big thing, it will be tested in parts
    it "must return status 200" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      customer = FactoryGirl.create(:business_customer_info, user: @user)
      cookie_cus_id = Base64.encode64( ActiveSupport::JSON.encode(customer.id))
      xhr :post, :response_save, id: question.id, cid: cookie_cus_id, provider: "Twitter"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must return status 200 and set up right class attributes" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      customer = FactoryGirl.create(:business_customer_info, user: @user)
      cookie_cus_id = Base64.encode64( ActiveSupport::JSON.encode(customer.id))
      xhr :post, :response_save, id: question.id, cid: cookie_cus_id, provider: "Twitter"
      # assigns(:uuid_id).should eq(cookie_token.uuid)
      # assigns(:customer).should eq(business_customer_info)
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#save_embed_response" do
    it "must return ststs 200, and must set right class variables" do
      question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :save_embed_response, id: question.id
      assigns(:question).should eq(question)
      assigns(:thanks_msg).should eq(question.thanks_response)
      assigns(:response).should eq(200)
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#response_email_verify" do
    it "must return status 200" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :save_embed_response, id: @question.id, email: "abc@def.ghi"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

 describe "Get email from users and redirect to user info page" do
    it "must redirect to user info page" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :response_email_verify, id: @question.id, email: "john@gmail.com"
      expect(response).to be_success
      expect(response.status).to eq(200)
      assigns(:response).should eq("new")
      #expect(cookies.signed["question_#{@question.id}"]).to eq(['viewed', 'answered']) refactor this
    end
  end

   describe "Known customer gives emailid" do
    it "should not ask user information" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      customer = FactoryGirl.create(:business_customer_info, :user_id => @user.id )
      xhr :post, :response_email_verify, id: @question.id, email: "ramanujam@gmail.com"
      expect(response).to be_success
      expect(response.status).to eq(200)
      assigns(:customer).customer_name.should eq(customer.customer_name)
      assigns(:response).should eq("Success")
      #expect(cookies.signed["question_#{@question.id}"]).to eq(['viewed', 'answered']) refactor this
    end
  end

  describe "User enters invalid email id" do
    it "should be in the same page and should set result as false" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      xhr :post, :response_email_verify, id: @question.id, email: "john@g"
      assigns(:cookie_result).should eq(false)
    end
  end


  describe "show the question for already known business user" do
    it "should save the successful response" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      customer = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      cookie_cus_id = Base64.encode64( ActiveSupport::JSON.encode(customer.id))
      FactoryGirl.create(:answer,:customers_info_id => customer.id,:question_id => @question.id)
      FactoryGirl.create(:question_option, question_id: @question.id, option: "Nassau")
      xhr :post, :response_save, id: @question.id, cid: cookie_cus_id ,:answer_option => "Nassau", :provider => "Twitter"
      expect(response.status).to eq(200)
    end

    #it "should throw error response if already answered"
  end

  describe "user clicks the bitly link with cid " do
    it "should set the get email from user as false" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user)
      customer = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      xhr :post, :show_question, id: @question.id,provider: "QR",cid: Base64.encode64( ActiveSupport::JSON.encode(customer.id))
      assigns(:get_email).should eq(false)
    end
    
    it "should set the get email from user as false when QR" do
      @question = FactoryGirl.create(:question, :year_wise_expire, user: @user, status: "Inactive")
      customer = FactoryGirl.create(:business_customer_info, :user_id => @user.id)
      xhr :post, :show_question, id: @question.id,provider: "QR",cid: Base64.encode64( ActiveSupport::JSON.encode(customer.id))
      assigns(:get_email).should eq(false)
    end    
  end

end