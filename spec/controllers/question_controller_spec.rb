require 'spec_helper'

describe QuestionController do
  before(:each){
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user,:default_biz_user, :business_type_id => 2)
    sign_in :user, @user
    @pricing_plan = FactoryGirl.create(:pricing_plan, :test_pricing_plan)
    @client_settings = FactoryGirl.create(:client_setting, :client_feature_settings,pricing_plan_id: @pricing_plan.id,user_id: @user.id)    
    @question = FactoryGirl.create(:questions, :user_id => @user.id, :expired_at => Time.now + 4.days, :expiration_id => "1 Month")
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_role_level_permissions).and_return(true)
  }

  it "should upload logo" do
   post :upload_logo,{:id=>@question.id,:image => "image.png", :authentication_token => @user.authentication_token },:format => :html
   response.should redirect_to("/question/#{@question.slug}/preview")
 end

 describe "#index" do
  it "should return status 200" do
    get :index
    expect(response).to be_success
    expect(response.status).to eq(200)
  end

  it "should set right instance variables" do
    category_type = CategoryType.find(@question.category_type_id)
    params = {
      category_type_id: category_type.id.to_i,
      status: @question.status,
      page: 1
    }
    get :index, params
    assigns(:business_type).should eq(@user.business_type_id)
    #~ assigns(:questions).should eq([@question])
  end

end

  describe "#new" do
    it "must set a new question for biz user and must return status 200" do
      @user
      sign_in :user, @user
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    it "must create a question" do
      Question.delete_all
      params = {
        question:{
          status: "Active",
          qrcode_status: false,
          language: "English",
          question_type_id: QuestionType.pluck(:id).first,
          category_type_id: CategoryType.pluck(:id).first,
          thanks_response: "Testing Response",
          question: "Whats the capital of bahamas?",
          slug: "19b4ace056d9e04d6ae7c52a3f70a448",
          expiration_id: "1 Year"
          },
          ans:{"0"=>"one", "1"=>"two", "2"=>"three"}
        }
        post :create, params
        expect(Question.count).to eq(1)
      end
    end

    describe "#edit" do
      it "must redirect to question_index_path when question is active" do
        @question.status = "Active"
        @question.save
        get :edit, id: @question.id
        response.status.should eq(200)
      end

      it "must set attribute varables properly when question is inactive" do
        @question.status = "Inactive"
        @question.save
        get :edit, id: @question.id
        assigns(:user_business_type).should eq(@user.business_type_id)
        assigns(:custom_url).should_not be_nil
      end
      
      it "access denied when question is closed" do
        @question.status = "Closed"
        @question.save
        get :edit, id: @question.id
        response.should redirect_to "/question"
      end      
    end

    describe "#GET show" do
      it "must set right question to the given id" do
        params = {
          id: @question.id
        }
        get :show, params
        assigns(:question).should eq(@question)
        assigns(:custom_url).should_not be_nil
        assigns(:keywords).should eq([])
    end

    it "must return right JSON response when fetch_type is show" do
      params = {
        id: @question.slug,
        fetch_type: "show"
      }
      @request.env["HTTP_ACCEPT"] = 'application/json'
      xhr :get, :show, params
      assigns(:question).should eq(@question)
      assigns(:custom_url).should_not be_nil
      JSON.parse(response.body)["header"]["status"].should eq(200)
    end

    #~ it "must return right JSON response when fetch_type is gender" do
      #~ params = {
        #~ id: @question.slug,
        #~ fetch_type: "gender"
      #~ }
      #~ @request.env["HTTP_ACCEPT"] = 'application/json'
      #~ xhr :get, :show, params
      #~ assigns(:question).should eq(@question)
      #~ assigns(:custom_url).should_not be_nil
      #~ JSON.parse(response.body)["header"]["status"].should eq(200)
    #~ end

    #~ it "must return right JSON response when fetch_type is chart" do
        #~ params = {
        #~ id: @question.slug,
        #~ fetch_type: "chart"
      #~ }
      #~ @request.env["HTTP_ACCEPT"] = 'application/json'
      #~ xhr :get, :show, params
      #~ expect(response).to be_success
    #~ end
  end

  describe "#preview" do
    it "should set the right attributes when question_id is given" do
      question_style = FactoryGirl.create(:question_style, question_id: @question.id)
      get :preview, question_id: @question.id
      assigns(:custom_url).should_not be_nil
      assigns(:question).should eq(@question)
      assigns(:question_style).should eq(question_style)
    end
  end

  describe "#upload_logo" do
    it "must repond to call by returning ststus 200" do
      image = fixture_file_upload("/1.jpg")
      post :upload_logo, :question => {:image => image},id: @question.id
      response.body.should redirect_to("/question/#{@question.slug}/preview")
    end
  end

  describe "#fill_sugg_qst" do
    it "must repond to call by returning ststus 200" do
      xhr :get, :fill_sugg_qst, qst_id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#customize" do
    it "should respond to HTML request" do
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.slug,
          font_style: "Verdana"
        }
      }
      post :customize, params
      response.body.should redirect_to("/question/#{@question.slug}/preview")
    end
    it "should respond to HTML request with reset image as true" do
      params = {
        id: @question.id,
        reset_image: "true",
        question_style: {
          question_id: @question.slug,
          font_style: "Verdana"
        }
      }
      post :customize, params
      response.body.should redirect_to("/question/#{@question.slug}/preview")
    end
    it "should respond to JSON request" do
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.id,
          font_style: "Select",
          # logo_image: fixture_file_upload("/1.jpg")
        }
      }
      @request.env["HTTP_ACCEPT"] = 'application/json'
      post :customize, params
      expect(response).to be_success
      expect(response.status).to eq(200)
      JSON.parse(response.body)["header"]["status"].should eq(200)
    end

    it "should create a question style if the question does not have one (JSON request)" do
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.id,
          font_style: "Select",
          background: "#171717",
          page_header: "#858585",
          submit_button: "#d5d5d7",
          question_text:  "#30A4AC",
          button_text:  "#FFFFFF",
          answers:  "#636363",
          font_style: "sans"
        }
      }
      QuestionStyle.delete_all
      @request.env["HTTP_ACCEPT"] = 'application/json'
      post :customize, params
      expect(response).to be_success
      expect(response.status).to eq(200)
      JSON.parse(response.body)["header"]["status"].should eq(200)
      expect(QuestionStyle.first.question_id).to eq(@question.id)
    end

    it "should create a question style if the question does not have one (HTTP request)" do
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.id,
          font_style: "Select",
          background: "#171717",
          page_header: "#858585",
          submit_button: "#d5d5d7",
          question_text:  "#30A4AC",
          button_text:  "#FFFFFF",
          answers:  "#636363",
          font_style: "sans"
        }
      }
      QuestionStyle.delete_all
      @request.env["HTTP_ACCEPT"] = 'application/json'
      post :customize, params
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(QuestionStyle.first.question_id).to eq(@question.id)
    end

    it "should update a question style if the question does have one (JSON request)" do
      # change the background and check for updation
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.id,
          font_style: "Select",
          background: "#171819",
          page_header: "#858585",
          submit_button: "#d5d5d7",
          question_text:  "#30A4AC",
          button_text:  "#FFFFFF",
          answers:  "#636363",
          font_style: "times"
        }
      }
      question_style = FactoryGirl.create(:question_style, question_id: @question.id)
      previous_background = question_style.background
      @request.env["HTTP_ACCEPT"] = 'application/json'
      post :customize, params
      expect(response).to be_success
      expect(response.status).to eq(200)
      # got: {"header"=>{"status"=>200}, "body"=>{"question_style"=>{"question_style"=>{"answers"=>nil, "background"=>nil, "button_text"=>nil, "created_at"=>"2014-02-21T05:34:23Z", "font_style"=>"", "id"=>68, "page_header"=>nil, "question_id"=>3493, "question_text"=>nil, "submit_button"=>nil, "updated_at"=>"2014-02-21T05:34:23Z"}}}}
      JSON.parse(response.body)["header"]["status"].should eq(200)
      expect(@question.question_style.background).to eq(params[:question_style][:background])
      expect(@question.question_style.background).not_to eq(previous_background)
    end

    it "should update a question style if the question does have one (HTTP request)" do
      # change the background and check for updation
      params = {
        id: @question.id,
        question_style: {
          question_id: @question.id,
          font_style: "Select",
          background: "#171819",
          page_header: "#858585",
          submit_button: "#d5d5d7",
          question_text:  "#30A4AC",
          button_text:  "#FFFFFF",
          answers:  "#636363",
          font_style: "times"
        }
      }
      question_style = FactoryGirl.create(:question_style, question_id: @question.id)
      previous_background = question_style.background
      post :customize, params
      response.body.should redirect_to("/question/#{@question.slug}/preview") #"Already question has been deactivated"
    end
  end



  describe "#get_style" do
    it "must repond to call by returning ststus 200" do
      get :get_style, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#get_detail" do
    it "must repond to call by returning ststus 200" do
      get :get_detail, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#get_image" do
    it "must repond to call by returning ststus 200" do
      get :get_image, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#deactivate" do
    it "must repond to call by returning ststus 200" do
      get :deactivate, question_id: @question.id
      # expect(response).to be_success
      # expect(response.status).to eq(200)
      # response.should redirect_to "/"
      flash[:notice].should eql "Question has been deactivated successfully."
    end

    it "must say question is already deactivated if question is closed" do
      @question.status = "Closed"
      @question.save
      get :deactivate, question_id: @question.slug
      response.body.should redirect_to("/question") #"Already question has been deactivated"
    end

    it "must say question is inactive if question is inactive" do
      @question.status = "Inactive"
      @question.save
      get :deactivate, question_id: @question.slug
      flash[:notice].should eql "Already question has been inactive"
    end
  end

  describe "#generate_bity_url" do
    it "must repond to call by returning ststus 200" do
      get :generate_bity_url, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must repond to call by returning ststus 200 for facebook provider" do
      get :generate_bity_url, id: @question.id, provider: "facebook"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must repond to call by returning ststus 200 for twitter provider" do
      get :generate_bity_url, id: @question.id, provider: "twitter"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must repond to call by returning ststus 200 for facebook provider" do
      get :generate_bity_url, id: @question.id, provider: "linkedin"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  # describe "#user_info_list" do
  #   it "must repond to call by returning ststus 200" do
  #     get :user_info_list, id: @question.id
  #     expect(response).to be_success
  #     expect(response.status).to eq(200)
  #   end
  # end

  #~ describe "#get_question_by_user" do
     #~ it "must repond to call by returning ststus 200" do
       #~ xhr :get, :get_question_by_user, id: @question.id
       #~ expect(response).to be_success
       #~ expect(response.status).to eq(200)
     #~ end
   #~ end

  #~ describe "#close_question_access_redirect" do
     #~ it "must repond to call by returning ststus 200" do
       #~ get :close_question_access_redirect, id: @question.id
       #~ expect(response).to be_success
       #~ expect(response.status).to eq(200)
     #~ end    
  #~ end

  describe "#question_status_change" do
    it "must repond to call by returning ststus 200" do
      post :question_status_change, question_id: @question.slug,:status => "Inactive"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#single_question" do
    it "must repond to call by returning status 200" do
      question_option = FactoryGirl.create(:question_option, question: @question)
      get :single_question, question_id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#multiple_question" do
    it "must repond to call by returning status 200" do
      question_option = FactoryGirl.create(:question_option, question: @question)
      get :multiple_question, question_id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#yes_no_question" do
    it "must repond to call by returning ststus 200" do
      get :yes_no_question, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#comment_question" do
    it "must repond to call by returning ststus 200" do
      get :comment_question, id: @question.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#define_parameters" do

  end

  describe "#check_option_uniqueness" do
  end

  describe "#redirect_based_on_validation" do
  end

  describe "#get_chart_view_response_count" do
  end

  describe "#qrcode_active_inactive" do
  end

  describe "#update_question_status" do
    it "must return invalid parameters if parameters are not provided" do
      xhr :post, :update_question_status, id: @question.id
      JSON.parse(response.body)["body"]["errors"].should eql 'Invalid Parameters'
    end

    it "must say question is not aviable if wrong id is given" do
      xhr :post, :update_question_status, id: "#{Random.rand(114444444)}", provider: 'twitter',:share_status => "success"
      JSON.parse(response.body)["body"]["errors"].should eql "Invalid Parameters"
    end

    it "must say question is closed" do
      @question.status = "Closed"
      @question.save
      xhr :post, :update_question_status, id: @question.id, provider: 'twitter',:share_status => "success"
      JSON.parse(response.body)["body"]["errors"].should eql "Question may be Closed/Activated already"
    end
  end

  #~ describe "#view_response_by_provider" do
  #~ # this is making all tests collapse
  #~ it "must send valid json response" do
    #~ get :view_response_by_provider, id: @question.id
    #~ response_hash = JSON.parse(response.body)
    #~ response_hash["header"]["status"].should eq(200)
      #~ # "{\"header\":{\"status\":200},\"body\":{\"view\":0,\"response\":0}}"
      #~ # check for other fields
    #~ end
  #~ end

  #~ describe "#view_response_by_location" do
    #~ it "must respond to ping with status 200" do
      #~ xhr :get, :view_response_by_location, id: @question.id
      #~ expect(response).to be_success
      #~ expect(response.status).to eq(200)
    #~ end
  #~ end

  describe "#build_response_question_list" do
  end

  describe "#check_status_delayed_job" do
  end

  describe "#search" do
    it "must respond with ststus 200" do
      params = {
        keywords: "who what",
        question_type: @question.category_type_id
      }
      xhr :get, :search, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "must respond properly for json request" do
      params = {
        keywords: @question.question.split.first,
        question_type: @question.category_type_id
      }
      @request.env["HTTP_ACCEPT"] = 'application/json'
      get :search, params
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe "#update" do
    it "must update question" do
      @question.status = "Inactive"
      @question.save
      params = {
        question:{
          status: "Inactive",
          qrcode_status: false,
          language: "English",
          question_type_id: QuestionType.pluck(:id).first,
          category_type_id: CategoryType.pluck(:id).first,
          thanks_response: "Testing Response",
          question: "Whats the capital of India?",
          slug: "19b4ace056d9e04d6ae7c52a3f70a448",
          }, id: @question.id
        }
        post :update, params
        response.body.should redirect_to("/question/19b4ace056d9e04d6ae7c52a3f70a448/preview")
      end
    end

    #~ describe "#default_settings" do
      #~ it "must respond to status 200 for default settings" do
        #~ question_style = FactoryGirl.create(:question_style, question_id: @question.id)
        #~ get :default_settings, slug: @question.slug
      #~ # question_preview_path(:question_id => question.slug)
      #~ response.should redirect_to "/question/#{@question.slug}/preview"
    #~ end
  #~ end

  describe "MARCH_CR_WEEK_1#self_upload" do
    context "when video/photo upload" do
      it "it must take video file with extension *.3gp,*.mpeg,*.mp4,*.mov,*.avi,*.jpg,*.jpeg,*.png" do
        video_file = fixture_file_upload('/7Up Uphill.mp4')
        @request.env["HTTP_ACCEPT"] = 'application/json'
        post :question_video_upload, { Filename: '7Up Uphill.mp4', Filedata: video_file,user_id: @user.id }
        response_hash = JSON.parse(response.body)
        response_hash["status"].should eq(200)
        response_hash["preview_image"].should eq("/data/7Up Uphill.#{ @user.id }_.mp4")
      end

      it "it must take video file with extension *.3gp,*.mpeg,*.mp4,*.mov,*.avi,*.jpg,*.jpeg,*.png" do
        video_file = fixture_file_upload('/img.jpg')
        @request.env["HTTP_ACCEPT"] = 'application/json'
        post :question_video_upload, { Filename: 'img.jpg', Filedata: video_file,user_id: @user.id }
        response_hash = JSON.parse(response.body)
        response_hash["status"].should eq(200)
        response_hash["preview_image"].should eq("/data/img.#{ @user.id }_.jpg")
      end
    end
  end

  describe "MARCH_CR_WEEK_1#create_question_self_upload_video" do
    context "when self_upload_video" do
      it "it must create a question with video" do
        post :create, { :question => { question: "Which city do you like?", category_type_id: 1, expiration_id: "1 Day", language: "English", private_access: 0, upload_video_url: "http://localhost:3000/data/7Up Uphill.#{ User.last.id }_.mp4", video_type: 2, question_type_id: 3, thanks_response: "Thanks for response", slug: "19b4ace056d9e04d6ae7c52a3f70a558"},:ans => { "0"=> "Yes", "1"=>"No" } }
        response.should redirect_to "/question/#{Question.last.slug}/preview"
      end
      it "it must create a question with image" do
        post :create, { :question => { question: "Which city do you like?", category_type_id: 1, expiration_id: "1 Day", language: "English", private_access: 0, upload_video_url: "http://localhost:3000/data/img.#{ User.last.id }_.jpg", video_type: 2, question_type_id: 3, thanks_response: "Thanks for response", slug: "19b4ace056d9e04d6ae7c52a3f70a558"},:ans => { "0"=> "Yes", "1"=>"No" } }
        response.should redirect_to "/question/#{Question.last.slug}/preview"
      end
    end

    context "when youtube_upload_video" do
      it "it must create a question with youtube video" do
        post :create, { :question => { question: "Which city do you like?", category_type_id: 1, expiration_id: "1 Day", language: "English", private_access: 0, embed_url: "http://www.youtube.com/watch?v=aTbCrOiwsEc", video_type: 2, question_type_id: 3, thanks_response: "Thanks for response", slug: "19b4ace056d9e04d6ae7c52a3f70a558"},:ans => { "0"=> "Yes", "1"=>"No" } }
        response.should redirect_to "/question/#{Question.last.slug}/preview"
      end
    end
  end
  
  describe "#sentiment_analyze" do
    it "get the result as per sentiment analyze" do
      answer = FactoryGirl.create(:answer, question_id: @question.id)
      FactoryGirl.create(:answer_analysis, question_id: @question.id, answer_id: answer.id)
      get :sentiment_analyze, id: @question.id
      expect(JSON.parse(response.body)["Positive"]).to eq("0.00")
      expect(JSON.parse(response.body)["Neutral"]).to eq("100.00")
      expect(JSON.parse(response.body)["Negative"]).to eq("0.00")
    end
  end
  
  describe "#show_question_wordcloud" do
    it "show the question wordcloud" do
      answer_option = FactoryGirl.create(:answer_option, question_id: @question.id)
      get :show_question_wordcloud, slug: @question.slug
      expect(JSON.parse(response.body)["response"]).to eq(answer_option.options)
    end
  end  
end