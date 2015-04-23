module ShareSocial
  extend ActiveSupport::Concern
  included do

    def question_user_info_list(params)
      @question = Question.get_question(params[:id])
      @custom_url= @question.short_url
      session[:question_id] = params[:question_id]
      @user_info_lists= current_user.business_customer_infos if current_user && current_user.business_customer_infos
    end

    def failure_count(params)
      @fb_failure_user, @twitter_failure_user, @linkedin_failure_user, @fb_acc_count, @twitter_acc_count, @linkedin_acc_count = current_user.share_my_question(params[:question_id],params)
      @fb_failure_user = [] if @fb_failure_user.nil?
      @twitter_failure_user = [] if @twitter_failure_user.nil?
      @linkedin_failure_user= [] if @linkedin_failure_user.nil?
      @failured_count = @fb_failure_user.count + @twitter_failure_user.count + @linkedin_failure_user.count
      @acc_count = @fb_acc_count + @twitter_acc_count + @linkedin_acc_count
    end

    def failure_count_details(params,current_user)
      failure_count(params)
      failured_count, acc_count = @failured_count, @acc_count
      if failured_count > 0
        InviteUser.social_acc_exp(@fb_failure_user, @twitter_failure_user, @linkedin_failure_user, current_user.email, current_user.first_name).deliver
        @flash = "Some of the social account(s) have been deleted  because of invalid access token and mailed to your email address. Please reconnect the social account to share the question."
        if ((acc_count) > (failured_count))
          update_status
        end
      else
        @flash = "Question shared successfully."
        update_status
      end
    end

    def qr_code_url_without_current_user(user_current,question)
      if user_current.nil? || !user_current.present?
        render json: {error: 'invalid token', status: 1005}
      elsif question.blank?
        render :json => {:error => "Please activate current question", :status_code => "400"}
      else
        @common_url = question.custom_url("qr", nil, user_current.id)
        render json: {status: "200", url: @common_url, expire: question.expiration_id, status_text: "Successfully Qr Code Url was generated"}
      end
    end

    def qr_code_url_blank_question(question,current_user_question)
      if question.blank?
        @error = "Please activate the Current Question"
        redirect_to "/surveys/#{current_user_question.slug}?provider=QR"
      else
        question.update_status_with_expired_at if question.status.include?("Inactive")
        redirect_to "/surveys/#{question.slug}?provider=QR"
      end
    end

    def show_valid_email(params,cu)
      mail_content = cu.email_content
      session[:referrer] = nil
      user_social_setting
      @question, @custom_url, @common_url, @user_info_lists, @voice_msg = current_user.question_share_url_userlist(params[:id])
      @email_content = mail_content.present? ? mail_content.gsub('"',"'") : ""
      session[:question_id] = params[:id]
      question_details
    end

    def share_call_response_json_question(question,ph,content,uc)
      if question.nil?
        render json: failure({errors: "Invalid Question id"})
      elsif question.user_id == uc.id
        Question.update_inactive_status(question, ph, content)
        render json: success({message: "Successfully Call was Initiated"})
      else
        render json: failure({errors: "Access denied."})
      end
    end
    def question_details
      @expiration_time = @question.find_expiration_time
      @remaining_days = @question.find_remaining_days if @question.status == "Active"
      @valid_days = @question.find_expiration_time
    end
    def share_call_json_response(params, question, phone_number, content)
      auth = params[:authentication_token]
      user_current = User.find_by_authentication_token(auth)
      if user_current.nil? || !user_current.present?
        render json: failure({errors: "Invalid token"})
      else
        share_call_response_json_question(question,phone_number,content,user_current)
      end
    end

    def user_social_setting
      date = (Time.now - current_user.created_at).to_i / 1.days if current_user
      @created_date = 31 - date
      @status = current_user.social_setting_info
      @user_business_id = current_user.business_type_id
      @share_info = ShareQuestion.user_social_setting_info(current_user)
    end

    def update_status
      @question.update_status_with_expired_at if @question.status.include?("Inactive")
    end

    def get_all_categories
      all_categories
      #bitly_url
      category.unshift(["All Questions", "All Questions"])
      cat_id, stat, pag, u_id = params[:category_type_id], params[:status], params[:page], current_user.id
      per_page = Question.where("user_id=?", u_id).count
      active_questions = Question.where(status: "Active", user_id: current_user.id)
      current_question = Question.where(slug: params[:id])
      qr_code_activated_question = Question.where("qrcode_status=? and user_id=?", "Active" ,current_user.id)
      @all_questions = (qr_code_activated_question + current_question + active_questions).uniq
    end

  end

end