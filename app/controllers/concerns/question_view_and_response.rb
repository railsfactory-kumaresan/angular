module QuestionViewAndResponse
  extend ActiveSupport::Concern
  included do
    # def get_chart_view_response_count(params)
    #   #chart_response = (!@question.expired_at.nil? && @question.is_expired?) ? (get_question_view_count_params(@question)) : ((params[:from_date].present? && params[:to_date].present?) ? get_chart_view_res_count_filter(@question,params[:from_date],params[:to_date],params[:category],"question") : get_chart_view_res_count(@question,"question"))
    #   chart_response = (params[:from_date].present? && params[:to_date].present?) ? get_chart_view_res_count_filter(@question,params[:from_date],params[:to_date],params[:category],"question") : get_chart_view_res_count(@question,"question")
    #   view_count_response_count(chart_response)
    #   Question.delete_item_from_hash(@view_count,@response_count,@yaxis)
    # end

    def qrcode_active_inactive
      @questions = @current_user.questions.where("status=? or status=?", "Active", "Inactive") if @current_user
    end

    def check_option_uniqueness(array_items)
      count, result=[],[];
      count = Question.array_items_split(array_items)
      count.uniq.each{|e|(result<< "more then one times")if e[1] >1}
      @ans_uni_err = []
      @ans_uni_err << "Answer must be unique" if result.include?("more then one times")
    end

    def prepare_create(params,response)
      assign_params(params,response)
      question_params
    end

    def assign_embed_url(param_name,ques)
      para = param_name
      (para.blank? && para == "") ? (ques.embed_url.present? ? ques.embed_url : nil) : para
    end

    def assign_params(params,response)
      params[:question][:include_other]= (params[:question][:include_other]== "on" || params[:question][:include_other] == "1") ? 1 : 0
      params[:question][:include_text]= (params[:question][:include_text] == "on" || params[:question][:include_text] == "1") ? 1 : 0
      if response && params[:copy_video_url].present?
        params[:question][:video_url] = params[:copy_video_url]
      elsif response.class == Transloadit::Response
        params[:question][:video_url] = (!response["results"]["extracted_thumbs"].blank? ? response["results"]["iphone"].first["ssl_url"] : response["results"][":original"].first["ssl_url"])
      elsif response.class == Attachment
        params[:question][:video_url] = response.image(:large)
      else
        params[:question][:video_url] = ""
      end
      #~ params[:question][:video_url] =  response && params[:copy_video_url].present? ? params[:copy_video_url] : response.class == Transloadit::Response ? (!response["results"]["extracted_thumbs"].blank? ? response["results"]["iphone"].first["ssl_url"] : response["results"][":original"].first["ssl_url"]) : ""
      params[:question][:video_url_thumb] = (response && !params[:copy_video_url].blank?)  ? params[:copy_video_url]  :  response.class == Transloadit::Response ? (response &&  !response["results"]["extracted_thumbs"].blank? && params[:copy_video_url] == "" ?  response["results"]["extracted_thumbs"].first["ssl_url"]  : "" ) : ""
    end

    def show_method_partial(params)
      case params[:fetch_type]
        when "show"
          #ques_res_count = RedisCount::GetResponseCount.new(params[:id],nil,nil,nil,nil,nil,nil,nil,nil).question_response_count
          #ques_view_count = RedisCount::GetViewCount.new(params[:id],nil,nil,nil,nil,nil,nil,nil,nil).question_view_count
          expire_within = Question.get_question_expiration(@question)
          render json: success({view_count: nil, response_count: nil,
                                question_status:  @question.status, bitly_url: @custom_url , expire_within: expire_within,
                                question_name: @question.question, category_type: @question.category_type_id,question_type: @question.question_type_id})
        when "gender"
          get_gender_wise_count(status = "show", @question.id)
          render json: success({views: @age_wise_view_count, responses: @age_wise_response_count})
        when "chart"
          chart_response =  get_chart_view_res_count(@question,"question")
          view_count_response_count(chart_response)
        else
          render json: failure({ errors: "Invalid params" })
      end
    end

    def build_response_count(answer,ques,cu,frm,to_d,params)
      total_known_view_count,total_known_response_count ,build_response,countries=0,0, [], []
      answer.each do |ans|
        if countries.index(ans.value).nil?
          view_response = {}
          total_view_count = find_location_view_count(ans.value,ques.id,cu.id,ques.category_type_id,frm,to_d)
          total_response_count = get_location_based_response_count(ans.value,ques.id,cu.id,params,'show')
          view_response["question"] = {"country"=>ans.value,"view_count" => total_view_count, "response_count" => total_response_count }
          total_known_view_count += total_view_count.to_i
          total_known_response_count += total_response_count.to_i
          build_response << view_response
        end
      end
      return total_known_view_count,total_known_response_count,build_response
    end
  end
end