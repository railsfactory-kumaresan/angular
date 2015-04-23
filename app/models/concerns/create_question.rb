module CreateQuestion
  extend ActiveSupport::Concern
  included do

    def self.build_questions(params, current_user, state)
      #user_business_type = current_user.business_type_id
      category_type = CategoryType.get_categories(current_user).uniq { |x| x.category_name }
      expiration = Question::EXPIRATION
      array_items = params[:ans].values.reject { |e| e.empty? } if params[:ans].present?
      count, result=[], [];
      count = Question.array_items_split(array_items)
      count.uniq.each { |e| (result<< "more then one times") if e[1] >1 }
      step = "1" if params[:question][:question_type_id] == "4"
      #user_business_type == 1 ? category_type_id = 1 : category_type_id = params[:question][:category_type_id]
      category_type_id = params[:question][:category_type_id]
      create_state(state, params, category_type_id, step, current_user)
      questions = @questions
      ans_err = ""
      ans_uni_err = []
      ans_count_count = params[:ans] && params[:ans].values.reject { |e| e.present? }.count ||= 0
      ans_err = "Please enter the answer" if ans_count_count && ans_count_count > 0
      ans_uni_err << "Answer should be unique" if result.include?("more then one times")
      error_two_option = questions.question_type_id == 4 ? "" : (params[:ans].length < 2 ? "Question should have two options" : "")
      return questions, ans_err, ans_uni_err, error_two_option, array_items
    end

    def self.create_state(state, params, cat, step, current_user)
      if state == "create"
        questions = Question.new
        para_q = params[:question]
        embed_url = embed_video_url(params[:question][:embed_url])
        video_url = embed_video_url(params[:question][:video_url])
        thx_res = para_q[:thanks_response].blank? ? "Thanks for responding!" : para_q[:thanks_response]
        associate_params = {:step => step, :thanks_response => thx_res, :category_type_id => cat, :question_type_id => para_q[:question_type_id],
                            :embed_url => embed_url, :video_url => video_url, :tenant_id => current_user.tenant_id}
        questions = current_user.questions.build(para_q.merge!(associate_params))
      else
        questions = Question.find_by_slug(params[:id])
        QuestionOption.update_options(array_items, questions.id, params[:question][:include_other])
      end
      @questions = questions
    end

    def self.embed_video_url(para)
      return (para.blank? && para == "") ? nil : para
    end

  end
end