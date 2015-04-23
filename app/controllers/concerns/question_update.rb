module QuestionUpdate
  extend ActiveSupport::Concern
  included do
  def create_questions_count(check_user_question_count,params,cu)
    ans_err,ans_uni_err,error_two_option,array_items = ""
    @current_user = cu
    if check_user_question_count
      @question,ans_err,ans_uni_err,error_two_option,array_items = Question.build_question(params, @current_user, "create")
      @question_last = @question.valid? ? Question.where("user_id =? and status != ?",@current_user.id,"Closed").last : nil
      if @question.save
        @hash_val= respond_format_new(@question,params,array_items,@current_user)
      end
    end
    return @hash_val,@question
  end
    def respond_format_new(question,params,array_items,cu)
      id ,other = question.id, params[:question][:include_other]
      QuestionOption.add_question_options(array_items,id,0,false)
      max_order = QuestionOption.find_max_option_order(id) if other &&  other == '1'
      @question.question_latest_style_apply(current_user,@question_last)
      short_url = Question.question_url(question.slug).short_url
      opt = question.question_options
      hash_val = {question: question, question_id: id, company_name: cu.company_name,bitly_url: short_url,question_options: opt}
      return hash_val
    end

    def question_update_status(question)
      if question.status == "Inactive"
        get_expiration_date(question.expiration_id)
        question.update_attributes(:status => "Active", :expired_at => expired_at)
        render json: success({success: 'Successfully updated question status'})
      else question.status == 'Closed'
      render json: failure({errors: 'Question may be Closed/Activated already'})
      end
    end

    def get_expiration_date(exp)
      case exp
        when "1 Week"
          expired_at = Time.now + 1.week
        when "1 Month"
          expired_at = Time.now + 1.month
        when "1 Year"
          expired_at = Time.now + 1.year
        when "1 Day"
          expired_at = Time.now + 1.day
      end
      return expired_at
    end

    def update_question_params(params,ques)
      @expiration = Question::EXPIRATION
      para = params[:question][:question_type_id]
      if (para != 1) || (para != 2)
        array_items = array_item_value(params)
        check_option_uniqueness(array_items)
      end
      QuestionOption.update_options(array_items,ques.id,params[:question][:include_other])
    end

  def array_item_value(params)
    array_items = []
    params[:ans] && params[:ans].each_with_index do |(k, v),i|
      array_items <<  params[:ans][i.to_s] if !v.blank?
    end
    return array_items
  end

    def upload_logos(cu,params,attach,q)
      @user_company= cu.company_name
      @custom_url = q.short_url#question_url(@question.slug)
      attachment = q.attachment
      @image_url = attachment.image(:thumb) if attachment
      que = params[:question]
      @errors= que && que[:image].present? && attach.errors.present? ?  attach.errors : ''
    end

    def upload_logo_respons(error,q,attach)
      s_msg = "Question logo was not uploaded. Please try again."
      f_msg = "Question logo uploaded successfully."
      respond_to do |format|
        unless error.blank?
          format.json { render json: failure({ errors: attach.errors })}
          format.html {render 'preview' ,  flash: { non_fade_notice: s_msg}}
        else
          format.json {render json: success({ message:f_msg})}
          format.html {redirect_to question_preview_path(q.slug) ,  flash: { notice: f_msg } }
        end
      end
    end

  def upload_question_logo(params)
    question_attachment = Attachment.find_by_attachable_id(@question.id)
    #~ ShareDetail.update_share_count(@question.user,1,'video_photo_count') if !question_attachment && current_user.check_action_privilege('video_photo_count')
    question_attachment.destroy if question_attachment
    attachment = Attachment.create(:image => params[:logo_image], :attachable_id => @question.id,:attachable_type => "Question")  if params[:logo_image].present? #&& current_user.check_action_privilege('video_photo_count')
    @error_meg = "Question Logo was not uploaded.Please try again" if attachment && attachment.errors.present?
  end

  def prepare_update(params,response)
    assign_params(params,response)
    if params[:question]["upload_video_url"].present? && params[:copy_video_url].blank?
      #params[:question][:embed_url] = assign_embed_url(params[:question][:embed_url],@question)
      params[:question][:video_url] = assign_embed_url(params[:question][:video_url],@question)
      params[:question][:embed_url] = ""
    elsif params[:question][:embed_url].present? && params["question_video_upload"].present? && params[:copy_embed_url].blank?
      params[:question][:embed_url] = (params[:question][:embed_url].blank? && params[:question][:embed_url] == "") ? (@question.embed_url.present? ? @question.embed_url : nil) : params[:question][:embed_url]
      params[:question][:video_url] = ""
    else
      params[:question][:video_url] = !params[:copy_video_url].blank? ? params[:copy_video_url] : ""
      params[:question][:embed_url] = !params[:copy_embed_url].blank? ? params[:copy_embed_url] : ""
    end
    question_params
  end

    def build_response_list(questions)
      build_response = []
      questions.each  do |q|
        question_view_response = {}
        ans_co = question_response_count(q.id)? question_response_count(q.id) : 0
        view_co = view_count(q.id)? view_count(q.id) : 0
        vew_per  = get_view_percentage(ans_co.to_f, view_co.to_f)
        question_view_response = {"id"=> q.id ,"question"=> q.question,"status"=> q.status,"category_type_id"=> q.category_type_id,
                                  "created_at"=> q.created_at,"updated_at"=> q.updated_at, "answer_count"=> (ans_co) ,
                                  "view_count"=> (view_co),"response_percentage"=>(vew_per)
        }
        build_response << question_view_response
      end
      return build_response
    end

  end
end