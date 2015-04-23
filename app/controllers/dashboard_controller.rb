class DashboardController < PrivilegeController
  require 'rubygems'
  require 'twilio-ruby'
  require 'will_paginate/array'
  include ApplicationHelper
  include DashboardHelper
  before_filter :authenticate_user_web_api, :check_acc_exp , :except => [:shift_to_trial_period]
  #before_filter :current_user_email_format,:only => [:index]
  #before_filter :check_role_level_permissions, :only => ["index"]
  skip_before_filter :check_admin_user, :only => [:index, :get_response_wordcloud]
  #include DashboardViewsAndResponses
  include ViewsAndResponses
  include Wordcloud
  include Chart

  def index
    if current_user.admin
       redirect_to "/admin/pricing_plans"
    else
      get_recent_activity_qs_list(current_user,params)
      @billing_info = BillingInfoDetail.find_user_billing_info(current_user) if current_user.is_trail_in_period?
      if request.xhr? && params[:status] == "tab_ajax"
        respond_to do |format|
          format.js
        end
      else
        get_show_privileges
        questions,question_ids = Question.get_question_ids(current_user,params)
        get_views_responses_count(params,question_ids,'dashboard')
      end
    end
  end

  # def get_response_wordcloud
  #   #response= current_user.get_response_words(params, current_user)
  #   #render :json => {:response => response[0], :option_ids => response[1]}
  # end

#  def location
#    if current_user.present?
##      @countries, @response = current_user.get_location_wise_count(params)
#      respond_to do |format|
#        #format.html { redirect_to '/'}
#        format.js
#      end
#    end
#  end

  def share_active
    @share_question = ShareQuestion.find_by_id(params[:id])
    if params['active'] == 'on'
      @share_question.update_attributes(:active => true)
      render :text => "Success"
    else
      @share_question.update_attributes(:active => false)
      render :text => "Success"
    end
  end

  #~ def total_gender_view_response
    #~ get_gender_wise_count(status = "dashboard", nil)
    #~ render json: success({Views: @age_wise_view_count, responses: @age_wise_response_count})
  #~ end

  def shift_to_trial_period
    plan_id = PricingPlan.find_by_plan_name("Trial")
    current_user.account_cancel(plan_id)
    User.change_role(current_user)
    render json: success({view:"success"})
  end

  # def get_customers_by_location
  #   find_filter_question
  #   countries = []
  #   answer, response = @current_user.get_location_wise_count(params)
  #   build_response,total_known_view_count,total_known_response_count = get_customers_location(answer,@current_user)
  #   unknown_view= get_total_unknown_view_count(total_known_view_count)
  #   unknown_response =get_total_unknown_response_count(total_known_response_count)
  #   render json: success({location: build_response, unknown_views: unknown_view, unknown_response: unknown_response})
  # end


  #Pagination for recent responses
  # def display_recent_responses(responses_length, category_type_id)
  #   activity_limit=3
  #   activity_offset=params[:page] ? params[:page].to_i-1 : 0
  #   activity_offset=activity_limit*activity_offset
  #   display_recent_page(responses_length, category_type_id,activity_limit,activity_offset)
  #   return @no_of_pages, @current_page, @previous_page, @next_page, @recent_activity
  # end

    # API datewise question analytics

  #~ def datewise_question_analytics
    #~ if params[:start_date].nil? && params[:end_date].nil?
      #~ render json: failure({errors: "Invalid Parameters"})
    #~ else
     #~ date_wise_views_response_month(params)
      #~ render json: success({total_view_count: @views, total_response_count: @responses, date_month: @date_month.uniq})
    #~ end
  #~ end

  #~ def date_wise_views_response_month(params)
    #~ s_date ,e_date , user_id = params[:start_date],params[:end_date],@current_user.id
    #~ #@views = RedisCount::GetViewCount.new(nil, nil,user_id , nil, nil, nil, nil,s_date,e_date).get_monthly_view_count
    #~ #@responses = RedisCount::GetResponseCount.new(nil, nil, user_id, nil, nil, nil,s_date,e_date).get_monthly_response_count
    #~ @date_month = []
    #~ question_dates = (Date.parse(s_date)..Date.parse(e_date)).to_a
    #~ question_dates.map { |d|
      #~ @date_month.push(d.to_date.strftime('%Y/%m'))
    #~ }
  #~ end

  private

  #~ def get_categories(params)
    #~ category = params["category"].present? ? params["category"] : params["category_id"]
    #~ @question_categories = CategoryType.get_categories(current_user)
    #~ @categories = (params["status"] == "tab_ajax" || params["request"] == "Filter" && category.to_i != 0) ? CategoryType.find_by_id(category) : CategoryType.first
    #~ @category_types = (category.present? && category.to_i != 0) ? CategoryType.where(:id => category) :  @question_categories
  #~ end


  #~ def get_chart_count(params)
    #~ chart_count = (params[:from_date].present? && params[:to_date].present? && @categories.present?) ? get_chart_view_res_count_filter(current_user, params[:from_date], params[:to_date], params[:category], "dashboard") : get_chart_view_res_count(current_user, "dashboard")
    #~ @total_view_count = chart_count[0]
    #~ @total_response_count = chart_count[1]
    #~ @yaxis = chart_count[2]
    #~ @x_axis_label = chart_count[3]
    #~ delete_item_from_hash
  #~ end

  #~ def delete_item_from_hash
    #~ Question.delete_item_from_hash(@total_view_count,@total_response_count,@yaxis)
  #~ end

  # def get_recent_questions(params, categories = nil)
  #   limit = params["limit"] || 0
  #   offset = params["offset"]  || 0
  #   from_date = params["from_date"] || nil
  #   to_date =  params["to_date"] || nil
  #   request =  params["request"] || nil
  #   @category = Hash.new
  #   recent_activity_count = Question.recent_activity_count(current_user,categories.id,from_date,to_date)
  #   @category = {:recent_activity =>[{"recent_activity_#{ categories.category_name }" => Question.recent_activity(current_user,categories.id,from_date,to_date,request,offset,limit),
  #                      "limit" => limit,"offset" => offset,"count" => recent_activity_count}]}
  # end
end
