module QuestionCustomUpdate
  extend ActiveSupport::Concern
  included do

    def redirect_based_on_validation_update(valid,cu,q,format)
      if valid
        msg = 'Successfully question has been updated'
        hs = {success:msg ,company_name: cu.company_name, question_id: q.id}
        format.json { render json: success(hs) }
        format.html { redirect_to question_preview_path(q.slug) }
      else
        format.json { render json: failure({errors: q.errors}) }
        format.html { render 'edit' }
      end
    end

    def question_customization(params,req,q,e_meg,format)
      customize_format(req,q,params)
      flash[:notice] = e_meg.present? ? e_meg : "Customization applied to the Question"
      format.html { redirect_to question_preview_path(:question_id => q.slug) }
      q_style = QuestionStyle.find_by_question_id(params[:question_style][:question_id])
      format.json { render json: success({question_style: q_style}) }
    end

    def customize_format(req, ques,params)
      unless req
        @custom_url = ques.short_url
        upload_question_logo(params) if params[:logo_image].present?
        @question_style = ques.question_style if ques
      end
    end

    def question_updates(params,response,q)
      prepare_update(params, response)
      @category_type = CategoryType.get_categories(current_user).uniq { |x| x.category_name }.sort
      update_question_params(params, q)
      redirect_based_on_validation(params)
    end

    def get_logo_image(q,cu)
      if q.nil?
        render json: failure({errors: "Invalid question id"})
      elsif q.user_id == cu.id
        img_path = q.attachment
        img_path.nil? ? (render json: failure({errors: "There is no image for this question"})) : (render json: success({url: img_path.image}))
      else
        render json: failure({errors: "Access denied."})
      end
    end

  end
end