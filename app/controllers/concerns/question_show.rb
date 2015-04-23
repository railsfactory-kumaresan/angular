module QuestionShow
  extend ActiveSupport::Concern
  included do

    def get_question_view_and_response(params, question, current_user)
      get_chart_view_response_count(params)
      get_gender_wise_count(status = "show", question.id)
      @answer = Answer.collection_of_countries(question.id, status = "show", params)
      @views, @responses = question.provider_wise_count(params)
      #@response = Answer.collection_of_responses(current_user,question.id,params).uniq
    end

    def get_valid_expire_days(params, question, current_user)
      #@options, @option_ids = Answer.collection_of_options(current_user, question.id, params).uniq
      #@response = @options
     # @comments = Answer.find_free_text(question.id, question.question_type_id, current_user.id, params)
   #   answers = Answer.find_all_responses(question.id, params)
     # @keywords=answers.nil? ? 0 : answers
      @expiration_time = question.question_expire_status
      @remaining_days = question.find_remaining_days if question.status == "Active"
      @valid_days = question.find_expiration_time
    end

    def generate_bitly_url_for_social(question, params)
      if question.status != "Closed"
        bitly = Bitly.client
        case params['provider']
          when 'facebook'
            url = "#{Bitly_url["url"]}/surveys/#{params[:id]}?provider=Facebook&status=true"
          when 'twitter'
            url = "#{Bitly_url["url"]}/surveys/#{params[:id]}?provider=Twitter"
          when 'linkedin'
            url = "#{Bitly_url["url"]}/surveys/#{params[:id]}?provider=Linkedin"
        end
        generate_bitly_url_response(url, question)
      else
        render json: failure({errors: "Question Closed already"})
      end
    end

    def generate_bitly_url_response(url, question)
      if url
        custom_url = question.short_url
        qst_image_url = question.attachment.image.url if question.attachment
        render json: success({bitly_url: custom_url, question_image_url: qst_image_url})
      else
        render json: failure({errors: "Invalid Parameter"})
      end
    end

    def get_index_question_list(req, params, cu)
      if req
        category_type = CategoryType.where("category_name =?", params[:category])
        params[:category_type_id] = category_type.last.id if category_type.present?
      end
      @business_type = cu.business_type_id if cu
      per_page = 5
      page = params[:page] ? params[:page] : 1
      questions  = Question.find_question_list(params[:category_type_id], params[:status], cu.id, params[:tenant_id])
      question_ids = questions.map{|q| q.id}
      @questions = get_question_vr_details(question_ids,params,questions,nil)
      @questions = WillPaginate::Collection.create(page, per_page, @questions.count) do |pager|
        question = @questions.to_a.slice(pager.offset, pager.per_page)
        pager.replace(question)
      end
    end

    def deactivation_not_deactivated(q,format)
      q.status ="Closed"
      q.save(:validate => false)
      format.json { render json: success({success_text: 'Question has been deactivated successfully.'}) }
      if params["request_type"]
        format.html { redirect_to question_index_path, flash: {notice: "Question has been deactivated successfully."} }
      else
        format.html { redirect_to question_path(q.slug), flash: {notice: "Question has been deactivated successfully."} }
      end
    end

    def deactivation_already_deactvated(format)
      success_msg= status == "Closed" ? "Already question has been deactivated" : "Already question has been inactive"
      format.json { render json: failure({errors: success_msg}) }
      format.html { redirect_to '/', flash: {notice: success_msg} }
    end

    def view_unknown_response_by_location(params,ques,cu,frm,to_d)
      answer = Answer.collection_of_countries(params[:id], status = "show", params)
      t_count, t_k_count, b_res = build_response_count(answer, ques, cu, frm, to_d, params)
      uk_view= get_unknown_view_count(t_count, ques.id)
      un_response =get_unknown_response_count(t_k_count, ques.id)
      return b_res,uk_view,un_response
    end

    def check_question_show_privilege(q,cu)
      # Multitenant Changes
      tenant_id = ExecutiveTenantMapping.get_tenant_ids(cu.id)
       if q.user_id != cu.id
        if  q.nil? || !tenant_id.include?(q.tenant_id)
          respond_to do |format|
            flash[:notice] = "#{APP_MSG['authorization']['failure']}"
            format.json { render json: failure({error: "Access Denied."}) }
            format.html { redirect_to "/question" }
          end
        end
       end
    end

  end
end
