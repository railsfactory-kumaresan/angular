module QuestionCreateAndPreview
  extend ActiveSupport::Concern
  included do
  def preview_questions(params)
    @user_company=current_user.company_name
    @question = Question.get_question(params[:question_id])
    @question_options = QuestionOption.options_without_other(@question.id)
    @custom_url = @question.short_url #question_url(@question.slug)
    attachment = @question.attachment
    @image_url = attachment.image(:thumb) if attachment
    @image_file_name = File.basename(attachment.image_file_name, File.extname(attachment.image_file_name)) if attachment
    @question_style = @question.question_style if @question
  end

    def upload_image(params)
      question_id = params[:id] || params[:question_id]
      question_attachment = Attachment.find_by_attachable_id(question_id)
      #~ ShareDetail.update_share_count(current_user,1,'video_photo_count') if !question_attachment && current_user.check_action_privilege('video_photo_count')
      question_attachment.destroy if question_attachment
      @question = Question.get_question(question_id)
      @attachment= Attachment.create_file_attachment(params, @question)
      upload_logos(current_user,params,@attachment,@question)
      upload_logo_respons(@error, @question, @attachment)
    end
  end

  def create_new_question(params,req,cu)
    video_url = params[:question]["upload_video_url"]
    response = (video_url.present? && params["question_video_upload"].present? && current_user.check_action_privilege('video_photo_count') && params["copy_video_url"] == "")  ? transloadit(video_url) : params["copy_video_url"]
    prepare_create(params, response)
    params[:question][:video_url] = response if response && req
      res = (current_user.restrict_question_privilege ? false : true)
      check_user_question_count = req ? res : true
      create_questions_count(check_user_question_count,params,cu)
    return @hash_val,@question
  end
  def question_new(params)
    if valid_email?(current_user.email)
      @user_business_type = current_user.business_type_id
      @user_role = current_user.role
      @monthly_question_count = Question.get_monthly_count(current_user.id)
      question_expiration_pre(@user_business_type, @monthly_question_count, @user_role)
    else
      flash[:non_fade_notice] = "Please update or confirm the email address to access this feature." if !current_user.company_name.blank? && !current_user.unconfirmed_email.blank?
      flash[:non_fade_notice] =  "Please enter company name and email address." if current_user.company_name.blank?
      redirect_to "/users/edit"
    end
  end


 def question_expiration_pre(business_type_id,monthly_question_count,rol)
      if current_user.restrict_question_privilege
        #business_type_id == 1 && monthly_question_count >= 10
        flash[:notice] = "#{APP_MSG["authorization"]["limit"]}"
        redirect_to "/question"
      end
      @ans_err = []
      render "question/restrict" if rol == "view"
      @question = Question.new
      @category_types = CategoryType.get_categories(current_user).uniq { |x| x.category_name }.sort
      @expiration = Question::EXPIRATION
    end


  def show_questions(params)
    all_categories
    get_tenant_list
    bitly_url
    get_index_question_list(request.format.json?, params, @current_user)
    respond_to do |format|
      format.js if request.xhr?
      format.json { render json: build_response_question_list(@questions) }
      format.html
    end
  end
end