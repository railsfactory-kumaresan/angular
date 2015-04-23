module SurveyResponse
  extend ActiveSupport::Concern
  included do

    def save_response(params)
      create_question_response_cookie(@question.id,params[:provider])
      @provider = params[:provider] unless params[:provider].blank?
      cid_present(params)
      res_id = QuestionResponseLog.create_new_record(@question,params[:provider],@uuid_id, @customer.try(:id))
      session[:q_r_id] = res_id unless res_id.nil?
      params[:answer_option] = @question.question_type_id == 2 ?  params[:multiple_answers] : (params[:answer_option] == "others" ? params[:other_answer_option] : params[:answer_option])
      other_option_id = QuestionOption.create_new_other_option(params[:other_answer_option],@question.id)  unless params[:other_answer_option].blank?
      customer_id = @customer.blank? ? nil : @customer.id
      unless params[:include_text].blank?
         ans = Answer.create_free_text(params,@question.question_type_id,customer_id,nil,true)
         session[:ans_ids].blank? ? session[:ans_ids] = [ans.id] : session[:ans_ids] << ans.id if ans.customers_info_id.nil? || ans.customers_info_id == 0
      end
      check_only_if_ans_option(params,other_option_id,customer_id,true)
      @thanks_msg = @question.thanks_response
    end


    def response_email_verify_check(params,q,c_uuid,errors,is_answered)
      q_attach = q.attachment
      if !params[:email].blank?
        q_att_res = q_attach.image(:thumb) if q.present? && q_attach.present?
        @attachment = q_att_res && q_attach.image.present? && q_attach.image.url.present?
        unless_response_email_verify_errors(errors,params)
      elsif is_answered
        @response = "Error"
      else
        @response = "Success"
      end
    end

    def check_only_if_ans_option(params,o_id,cus_id,is_business_user)
      q_id = @question.question_type_id
      unless params[:answer_option].blank?
        if q_id == 2
          answer = Answer.multiple_responses(params,o_id,@question,cus_id,nil,is_business_user)
        else
          answer = Answer.single_responses(params,o_id,@question,cus_id,nil,is_business_user)
        end
        session[:ans_ids].blank? ? session[:ans_ids] = [answer] : session[:ans_ids] << answer unless answer.blank? || answer.nil? || answer == 0
      end
    end

    def embed_response_save_if_not_answered(is_answered,question)
      opt,oth_opt = params[:answer_option],params[:other_answer_option]
      unless is_answered
        question.question_type_id == 2 ? params[:answer_option] = params[:multiple_answers] : params[:answer_option] = params[:other_answer_option] if params[:answer_option] == "others"
        params[:question_id] = @question.id
        other_option_id = QuestionOption.create_new_other_option(oth_opt,question.id)  unless oth_opt.blank?
        unless params[:include_text].blank?
          ans = Answer.create_free_text(params,@question.question_type_id,nil,nil,false)
          session[:ans_ids].blank? ? session[:ans_ids] = [ans.id] : session[:ans_ids] << ans.id if ans.customers_info_id.nil? || ans.customers_info_id == 0
        end
        embed_response_if_answer_option(params,other_option_id,question)
        res_log_id = QuestionResponseLog.create_new_record(@question,params[:provider],nil)
        session[:q_r_id] = res_log_id unless res_log_id.nil?
      end
    end

    def embed_response_if_answer_option(params,other_option_id,question)
      q_id = question.question_type_id
      unless params[:answer_option].blank?
        if q_id == 2
          answer = Answer.multiple_responses(params,other_option_id,question,false,nil)
        else
          answer = Answer.single_responses(params,other_option_id,question,false,nil)
        end
         session[:ans_ids].blank? ? session[:ans_ids] = [answer] : session[:ans_ids] << answer unless answer.blank? || answer.nil? || answer == 0
      end
    end

    def unless_response_email_verify_errors(errors,params)
      if errors.blank?
        @customer,@is_business_user_value = Question.business_response_user_checking(@email,@question.user_id)
        @customer_cookie_detail = @customer  if @customer
        update_customer_id_in_logs(@customer) if @customer
        @response = "new"
        if @customer.present?
          @response = "Success"
        else
          @response = "new"
        end
      else
        @response = "Success"
        @cookie_result = false
      end
    end

    def create_info_geo_location_is_active(params,cookie_token_id,user_id)
      mobile_num = params[:mobile].present? ? BusinessCustomerInfo.add_country_code(params[:mobile],params[:country]) : ""
      @customer = ResponseCustomerInfo.create_customer(params,mobile_num,cookie_token_id, user_id)
    end

    def update_customer_id_in_logs(customer)
       @view_log_error = QuestionViewLog.update_biz_cus_id(session[:q_v_id],customer.id)
       @res_log_error = QuestionResponseLog.update_biz_cus_id(session[:q_r_id],customer.id)
       answers= Answer.where(id: session[:ans_ids])
       answers.update_all(:customers_info_id => customer.id) if answers
       session[:q_v_id], session[:q_r_id], session[:ans_ids] = nil
       cookies.permanent.signed[:customer_details] = Base64.encode64( ActiveSupport::JSON.encode(customer.id)) if cookies.signed[:customer_details].nil?
    end
  end
end