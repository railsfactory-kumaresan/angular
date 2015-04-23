class SurveysController < ApplicationController
  layout 'question_response', :only => :show
  before_filter :find_customer_details,:only => [:show_question,:response_question, :response_save, :update_view_count, :embed, :response_embed, :view_count_update,:response_email_verify,:create_user_info]
  before_filter :get_question, except: [:states, :show_embed_survey]
  skip_before_filter :verify_session, only: [:show, :show_question, :embed_survey, :response_save, :response_email_verify, :show_embed_survey, :save_embed_response]
  layout 'prev_question', :only => [:response_email_verify, :create_user_info]
  include SurveyResponse
  include SurveyQuestion
  include SurveyUserDetails
  # layout false
  def show
    @question_status = @question.check_status if @question
    render :layout => "question_response"
  end

  def show_question
    show_survey_question(params)
  end

  def response_save
    unless check_cookie_already_answered(@question.id, params[:provider])
      save_response(params)
    else
      @response = "Error"
    end
  end

  def save_embed_response
    @question = Question.get_question(params[:id])
    embed_response_save_if_not_answered(false, @question)
    @thanks_msg = @question.thanks_response
    respond_to do |format|
      @response = 200
      format.js if request.xhr?
    end
  end



  def response_email_verify
    @user_id = @question.user_id
    @thanks_msg = @question.thanks_response
    @email = params[:email]
    @errors = Question.validate_email(@email) if @email
    response_email_verify_check(params,@question,@cookie_uuid,@errors,params[:already_answered])
    respond_to do |format|
      format.js
    end
  end


  def create_user_info
    @user_id = @question.user_id
    create_info_geo_location_is_active(params,@cookie_uuid,@user_id)
    if @customer.errors.blank?
      update_customer_id_in_logs(@customer)
    else
      @errors = @customer.errors
    end
    respond_to do |format|
      format.js if request.xhr?
      format.html
    end
  end

  def states
    @country = Country[params[:keywords]]
    @states = @country.states
    respond_to do |format|
      format.js
    end
  end

  def embed_survey
    question = Question.get_question(params[:id])
    active_embed_question = Question.where(user_id: question.user_id, embed_status: true, status: "Active").first
    @question = active_embed_question.blank? ? Question.change_embed_status(question.user_id) : active_embed_question
    @question_style = @question.question_style if @question
    @attachment, @company_name, @question_options = @question.embed_question_share
    render :layout => false
  end

  def update_embed_status
    Question.update_embed_status(params[:q_id], current_user.id)
    render :json => {:status => 200}
  end

  def show_embed_survey
    session[:q_v_id], session[:q_r_id], session[:ans_ids] = nil
    params[:provider] = "embed"
    @question = Question.get_question(params[:id])
    if @question.status !="Closed"
      @category_type = CategoryType.all.uniq{|x| x.category_name}.sort
      view_log_id = QuestionViewLog.create_new_record(@question,params[:provider],nil)
      session[:q_v_id] = view_log_id unless view_log_id.nil?
      render :json => {:provider => params[:provider], :question_id => @question.id}
    end
  end

  private

  # Find user details based on the customer ID
  def find_customer_details
    question_id = Question.get_question(params[:id]).id if params[:id]
    if params[:cid].present? && question_id.present?
      customer_id = ActiveSupport::JSON.decode( Base64.decode64(params[:cid]))
      is_answered_already = Answer.check_already_answered(question_id,customer_id, params["provider"])
      customer_cookie_detail = customer_id && !is_answered_already ? params[:cid] : (cookies.signed[:customer_details].present? ? cookies.signed[:customer_details] : '')
    else
      customer_cookie_detail = cookies.signed[:customer_details].present? ? cookies.signed[:customer_details] : ''
    end
    @cookie_uuid = params["cookie_token_value"].present? ? params["cookie_token_value"] : customer_cookie_detail
    @customer_cookie_detail = !customer_cookie_detail.blank? ? BusinessCustomerInfo.get_customer_info(@cookie_uuid) :  ''
  end

  def get_question
    @question= Question.get_question(params[:id])
  end

end
