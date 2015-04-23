module ViewsAndResponses
  extend ActiveSupport::Concern
  included do

    def get_recent_activity_qs_list(current_user,params)
      if current_user
        @user = current_user
        @is_listener_activated = Listener.fetch_listener(current_user.id)
        @created_date = distance_of_time_in_words(@user.exp_date - DateTime.now)
        @created_at= @user.created_at
        @transaction_details, @question_details = current_user.dashboard_details
      end
      @offset = params["offset"].present? ? params["offset"] : 0
      @count = params[:count].present? ? params[:count].to_i : 1
      category = params["category"].present? ? params["category"] : params["category_id"]
    @question_categories = CategoryType.get_categories(current_user)
    @categories = (params["status"] == "tab_ajax" || params["request"] == "Filter" && category.to_i != 0) ? CategoryType.find_by_id(category) : CategoryType.first
    @category_types = (category.present? && category.to_i != 0) ? CategoryType.where(:id => category) :  @question_categories
    get_recent_questions(params, @categories)
    end

 def get_views_responses_count(params,question_ids,type)
      @view_res_details = CountsStore.get_counts([question_ids],params,nil) if type == "question"
      get_view_response_collection
      @total_views_count = provider_count_sum(@views)
      @total_responses_count = provider_count_sum(@responses)
      @total_opens_count,@total_clicks_count = total_email_open_clicks(question_ids)
      question_id_collection = type == "question" ? [question_ids] : question_ids
      chart_collection = CountsStore.get_counts_static_chart(question_id_collection,params,nil)
      get_chart_collection(chart_collection,current_user)
      get_gender_wise_count
      @location_count = CountsStore.get_counts_static_location(question_ids,params,nil)
 end


def get_view_response_collection
  @views = {}
  @responses = {}
  @view_res_details.each do |detail|
   DEFAULTS['count_keys'].each do |key|
    value = detail.send("#{key}_count")
    if detail.vrtype == 'view'
      @views["#{key}_count"] = 0 if @views["#{key}_count"].nil?
      @views["#{key}_count"] += value ? value : 0
    else
      @responses["#{key}_count"] = 0 if @responses["#{key}_count"].nil?
      @responses["#{key}_count"] += value ? value : 0
    end
   end
  end
end

def get_gender_wise_count
    @age_limits = DEFAULTS['age_limits']
    @total_count,@age_wise_view_count,@age_wise_response_count = {},{},{}
    get_total_age_wise_count
    DEFAULTS['types'].each do |type|
    	@age_limits.each_with_index do |age_limit, index|
   		 @count_with_gender={}
     		DEFAULTS['genders'].each do |gender|
       			count = type == 'view' ? @views["a#{gender}#{age_limit}_count"] : @responses["a#{gender}#{age_limit}_count"]
       			@count_with_gender["male"]= count ? count.to_i : 0 if gender == "m"
       			@count_with_gender["female"]= count ? count.to_i : 0  if gender == "f"
       			@count_with_gender["#{gender}percentage"] = get_age_wise_percentage(gender,count)
     		end
     	count_hash = @count_with_gender
     	type == 'view' ?  @age_wise_view_count[index] =  count_hash :  @age_wise_response_count[index] =  count_hash
    	end
  	end
end

  def get_recent_questions(params,categories = nil)
    limit = params["limit"] || 0
    offset = params["offset"]  || 0
    from_date = params["from_date"] || nil
    to_date =  params["to_date"] || nil
    request =  params["request"] || nil
    @category = Hash.new
    cat_id = params[:category_id] ? params[:category_id] : params[:category]
    @total_questions,@limit_questions,limit_count = Question.recent_activity_questions(current_user,cat_id,from_date,to_date,request,offset,limit,params[:status])
    question_ids = @total_questions.map{|qus| qus.id}
    get_question_vr_details(question_ids,params,@limit_questions,nil)
    @category = {:recent_activity =>[{"recent_activity_#{ categories.category_name }" =>@ques_details,"limit" => limit,"offset" => offset,"count" => limit_count}]}
  end


  def get_question_vr_details(question_ids,params,questions,vrtype)
    @view_res_details = CountsStore.get_counts(question_ids,params,vrtype)
    form_question_hash(@view_res_details,questions)
  end


private

def form_question_hash(view_res_details,questions)
 @ques_details = {}
  questions.each do |question|
    tenant_name =  !question.tenant_id.nil? ?  User.tenant_name(question.tenant_id) : ""
    view_res_details.blank? ? get_qs_vr_count(nil,question,tenant_name) : view_res_details.map{|detail| get_qs_vr_count(detail,question,tenant_name)}
    end
return @ques_details
end


def provider_count_sum(detail)
  provider_sum = 0
  unless detail.blank?
  DEFAULTS['providers'].each do |provider|
    provider_name = provider + "_count"
    provider_sum += detail[provider_name] unless detail[provider_name].nil?
  end
  end
  return provider_sum
end


def get_qs_vr_count(detail,question,tenant_name=nil)
@ques_details["#{question.id}"] = {} if @ques_details["#{question.id}"].nil?
  if detail && detail.question_id.to_i == question.id.to_i
    total = provider_count_sum(detail)
    @ques_details["#{question.id}"].merge!({"#{detail.vrtype}"=>"#{total}","slug"=>"#{question.slug}","question"=>"#{question.question}", "status"=>"#{question.status}", "category_name"=>"#{question.category_type.category_name}", "tenant_name" => "#{tenant_name}"})
  else
   @ques_details["#{question.id}"].merge!({"created_at" => "#{question.created_at.strftime("%B %d, %Y") }","status"=>"#{question.status}","category_name"=>"#{question.category_type.category_name}", "slug"=>"#{question.slug}","question"=>"#{question.question}", "tenant_name" => "#{tenant_name}"})
  end
end


def get_total_age_wise_count
    	@total_count["total_f_view_count"] = @views["f_count"]
    	@total_count["total_f_response_count"] = @responses["f_count"]
    	@total_count["total_m_view_count"] = @views["m_count"]
    	@total_count["total_m_response_count"] = @responses["m_count"]
end

def get_age_wise_percentage(gender,count)
 	percentage = count * 100 / (@total_count["total_#{gender}_view_count"]) if @total_count["total_#{gender}_view_count"] && count && (@total_count["total_#{gender}_view_count"]  > 0 && count > 0)
	percentage.nil? ? 0 : (percentage  <= 5 ? 5 : percentage)
end

def total_email_open_clicks(question_id)
 email_activity = EmailActivity.where(question_id:question_id)
 if email_activity.present?
   total_opens = EmailActivity.where(question_id: question_id).sum(:opens)
   total_clicks = EmailActivity.where(question_id: question_id).sum(:clicks)
 else
   total_opens = "NA"
   total_clicks = "NA"
 end
  [total_opens,total_clicks]
end

end
end