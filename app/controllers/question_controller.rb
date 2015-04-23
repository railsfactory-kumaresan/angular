require 'aws/s3'
require 'will_paginate/array'
require 'tts'
require 'open-uri'
class QuestionController < PrivilegeController
  include QuestionHelper
  include DashboardHelper
  include ApplicationHelper
  include QuestionVideoUploadService
  include Transloadit::Rails::ParamsDecoder
  include QuestionCreateAndPreview
  include QuestionViewAndResponse
  include QuestionUpdate
  include QuestionShow
  include QuestionCustomUpdate
  include ViewsAndResponses
  include SentimentalAnalyze
  include Wordcloud
  include Chart

  protect_from_forgery :except => [:question_video_upload, :create]
  before_filter :authenticate_user_web_api, :except => [:response_embed, :view_count_update, :play_demo, :preview, :question_video_upload]
  before_filter :check_role_level_permissions, :only => ["show", "new", "edit", "upload_logo", "deactivate"]
  before_filter :check_admin_user
  before_filter :check_current_user_question, :only => [:edit, :update, :preview, :upload_logo, :customize, :deactivate]
  before_filter :check_current_user_privilege, :only => [:show]
  before_filter :close_question_access_redirect, :only => [:edit]
  before_filter ->(param='qr_share') { check_current_user_share_access param }, only: %w{qrcode_active_inactive}
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_privileges, :only => [:new,:edit,:preview]


  def index
    show_questions(params)
  end

  def new
    question_new(params)
  end

#question creation for both html and json requests
  def create
    hash_val,question = create_new_question(params,request.format.json?,current_user)
    respond_to do |format|
    format.json { render json: success(hash_val)}
    format.html { redirect_to question_preview_path(question.slug) }
    end
  end

  def edit
    unless @question.status == "Active" || @question.status == "Closed"
      @user_business_type = current_user.business_type_id
      @category_type = CategoryType.get_categories(current_user).uniq { |x| x.category_name }.sort
      @expiration = Question::EXPIRATION
      @custom_url = @question.question_short_url
    end
  end

  def show
    @question = Question.get_question(params[:id])
    @custom_url = @question.question_short_url
    get_show_privileges
    unless request.format.json?
      question_ids = [@question.id]
      get_views_responses_count(params,question_ids,'question')
      answer_option = AnswerOption.get_answer_option(@question.id)
      @keywords = answer_option.present? ? answer_option[0].options : []
      @comments = Answer.find_comments_free_text(@question)
      get_valid_expire_days(params, @question, current_user)
    else
      show_method_partial(params)
    end
  end

  def update
    para = params[:question]["upload_video_url"]
    response = para.present? && params["question_video_upload"].present? && params["copy_video_url"] == "" ? transloadit(para) : params["copy_video_url"]
    @question = Question.get_question(params[:id])
    question_updates(params,response,@question)
  end

  def preview
    preview_questions(params)
  end

  def upload_logo
    upload_image(params)
  end

  def search
    @question = Question.question_suggestion(params[:keywords], params[:question_type], @current_user)
    respond_to do |format|
      format.js
      format.json { render json: success({suggestion_questions: @question}) }
    end
  end

  def fill_sugg_qst
    @question, @question_options, @category_type_id = Question.get_qst_with_option(params[:qst_id])
    respond_to do |format|
      format.js
    end
  end

  def customize
    st = params[:question_style]
    if params[:reset_image] == "true"
      question_style_params = params.require(:question_style).permit!
      reset_image(st[:question_id],question_style_params)
    else
    respond_to do |format|

     customize_new(params)
      req = request.format.json?
     question_customization(params,req,@question,@error_meg,format)
        end
    end
  end

  def customize_new(params)
    st = params[:question_style]
    @question = Question.get_question(st[:question_id])
    params[:question_style][:font_style] = "" if st[:font_style].include?("Select")
    question_style_params = params.require(:question_style).permit!
    @question.question_style ? @question.question_style.update_attributes(question_style_params) : QuestionStyle.create(question_style_params)
  end

  def reset_image(id,question_style_params)
    question = Question.get_question(params[:id])
    question_attachment = Attachment.find_by_attachable_id_and_attachable_type(question.id, "Question")
    question_attachment.destroy if question_attachment
    question.create_attachment(:image=> URI.parse(current_user.attachment.image(:thumb))) if current_user.attachment
    question.question_style.update_attributes(question_style_params) if question.question_style
    flash[:notice] =  "Customization applied to the Question"
    return redirect_to question_preview_path(:question_id => question.slug)
  end


  #def default_settings
  #  question = Question.get_question(params[:id])
  #  question_attachment = Attachment.find_by_attachable_id_and_attachable_type(question.id, "Question")
  #  question_attachment.destroy if question_attachment
  #  question.question_style.update_attributes("background" => "#fefefe", "page_header" => "#858585",
  #                                            "submit_button" => "#d5d5d7", "question_text" => "#30A4AC", "button_text" => "#FFFFFF",
  #                                            "answers" => "#636363", "font_style" => nil) if question.question_style
  #  redirect_to question_preview_path(:question_id => question.slug)
  #end

#API for get question customize value
  def get_style
    question = Question.get_question(params[:id])
    question && question.question_style.present? ? (render json: success({question_style: question.question_style})) : (render json: failure({errors: "Question has no style"}))
  end

#API for get question details
  def get_detail
    question_array = []
    @question = Question.get_question(params[:id])
    @company_logo = @question.attachment.image.url if @question.attachment.present?
  end

#API Question logo fetch
  def get_image
    @question = Question.get_question(params[:id])
    get_logo_image(@question,current_user)
  end

  def deactivate
    @question = Question.get_question(params[:question_id])
    status = @question.status
    respond_to do |format|
      if status != "Closed" && status != "Inactive"
        deactivation_not_deactivated(@question,format)
      else
        deactivation_already_deactvated(format)
      end
    end
  end

#API social network Based bitly url generation
  def generate_bity_url
    if params[:id].present?
      question = Question.get_question(params[:id])
      generate_bitly_url_for_social(question, params)
    else
      render json: failure({errors: "Question not found."})
    end
  end

  #~ def get_question_by_user
    #~ @question= current_user.questions.where("status=? or status=?", "Active", "Inactive") if current_user
    #~ @ques_count = @question.length
    #~ @question = @question.paginate(:page => params[:page], :per_page => 9)
    #~ respond_to do |format|
      #~ format.html { render :layout => false }
      #~ format.js
    #~ end
  #~ end

  # This method will redirect the user to index page, if the user comes with the closed question.
  def close_question_access_redirect
    @question = Question.get_question(params[:id])
    if @question.status == "Closed"
      flash[:notice] = "Access denied for closed question."
      redirect_to "/question"
    end
  end

  def question_status_change
    @question = Question.fetch_question(params[:question_id])[0]
    if @question.status.include?("Inactive")
      @question.update_status_with_expired_at
      render json: {status: 'Success', status_code: 200}
    else
      render json: {status: 'error', status_code: 500}
    end
  end

  def single_question
    render_question("single_question", params)
  end

  def multiple_question
    render_question("multiple_question", params)
  end

  def render_question(name, params)
    if params[:question_id].present?
      @question= Question.get_question(params[:question_id])
      @question_option = @question.question_options.where('is_deactivated is FALSE and is_other is FALSE').order("question_options.order ASC") if (@question.question_type_id == 2 || @question.question_type_id == 1)
    end
    render :partial => "#{name}", :locals => {:question_option => @question_option, :question => @question}
  end

  def yes_no_question
    @question = Question.get_question(params[:question_id]) if params[:question_id].present?
    render :partial => "yes_no_question", :locals => {:question => @question}
  end

  def comment_question
    render :partial => "comment_question"
  end


  def redirect_based_on_validation(params)
   # params[:question][:video_url]   =  @question.video_url  if params[:question]["upload_video_url"].blank? &&  params[:question]["embed_url"] .blank?
    @question.share_count_update(params)
    ques = params[:question]
    @valid_question = ques[:question_type_id] == "4" ? @question.update_attributes(ques.merge!({:step => "1"})) : @question.update_attributes(ques)
    respond_to do |format|
      redirect_based_on_validation_update(@valid_question,@current_user,@question,format)
    end
  end

  def update_question_status
    question = Question.find_by_id(params['id'])
    if params['share_status'] == 'success' && question.present?
      question_update_status(question)
    else
      render json: failure({errors: 'Invalid Parameters'})
    end
  end

#API get Social network question sharing status
  def view_response_by_provider
    question = Question.get_question(params[:id])
    views, responses = question.provider_wise_count(params)
    prov = params[:provider]
    render json: success({view: (views[prov] ? views[prov] : 0), response: (responses[prov] ? responses[prov] : 0)})
  end

#API get view and response count based on the location
  def view_response_by_location
    @question = Question.get_question(params[:id])
    from_date = params["from_date"].present? ? params["from_date"] : ''
    to_date = params["to_date"].present? ? params["to_date"] : ''
    build_response,unknown_view,unknown_response = view_unknown_response_by_location(params,@question,current_user,from_date,to_date)
    render json: success({location: build_response, unknown_views_show: unknown_view, unknown_response_show: unknown_response})
  end

#API Build response for question list based categroy and status
  def build_response_question_list(questions)
    if questions.present?
      build_response = build_response_list(questions)
      success(all_question: build_response)
    else
      failure({errors: "No Question found"})
    end
  end

  private

  def check_current_user_privilege
    question = params[:id] || params[:question_id]
    @question = Question.get_question(question)
    check_question_show_privilege(@question,@current_user)
  end

  def question_params
    params.require(:question).permit!
  end

#Restrict the type of user to create the number of questions
  # def check_num_of_question
  #   (@current_user.business_type_id == 1 && Question.get_monthly_count(@current_user.id) >= 10) ? true : false
  # end

  # view and response count
  def view_count_response_count(chart_response)
    @view_count, @response_count, @yaxis, @x_axis_label = chart_response[0], chart_response[1], chart_response[2], chart_response[3]
  end


end
