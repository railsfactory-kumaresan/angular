# module DashboardViewsAndResponses
#   extend ActiveSupport::Concern
#   included do

#     # def get_recent_activity_qs_list(current_user,params)
#     #   if current_user
#     #     @user = current_user
#     #     @is_listener_activated = Listener.fetch_listener(current_user.id)
#     #     @created_date = distance_of_time_in_words(@user.exp_date - DateTime.now)
#     #     @created_at= @user.created_at
#     #     @transaction_details, @question_details = current_user.dashboard_details
#     #   end
#     #   @offset = params["offset"].present? ? params["offset"] : 0
#     #   @count = params[:count].present? ? params[:count].to_i : 1
#     #   category = params["category"].present? ? params["category"] : params["category_id"]
#     # @question_categories = CategoryType.get_categories(current_user)
#     # @categories = (params["status"] == "tab_ajax" || params["request"] == "Filter" && category.to_i != 0) ? CategoryType.find_by_id(category) : CategoryType.first
#     # @category_types = (category.present? && category.to_i != 0) ? CategoryType.where(:id => category) :  @question_categories
#     # get_recent_questions(params, @categories)
#     # end

#     # def get_customers_location(answer,current_user)
#     #   assignment_views_and_response
#     #   get_location_wise_total_count(params,answer,current_user)
#     #   return @build_response,@total_known_view_count,@total_known_response_count
#     # end

#     # def assignment_views_and_response
#     #   @total_known_view_count = 0
#     #   @total_known_response_count = 0
#     #   @build_response = []
#     # end

#     # def get_location_wise_total_count(params,answer,current_user)
#     #   assignment_views_and_response
#     #   answer.each do |ans|
#     #     if countries.index(ans.value).nil?
#     #       total_view_count,total_response_count, view_response= get_total_view_and_response(ans,current_user,params)
#     #       @total_known_view_count += total_view_count.to_i
#     #       @total_known_response_count += total_response_count.to_i
#     #       @build_response << view_response
#     #     end
#     #   end
#     # end
#     # def display_recent_page(responses_length, category_type_id,activity_limit,activity_offset)
#     #   rse = responses_length/activity_limit
#     #   page = params[:page]
#     #   @no_of_pages=responses_length%activity_limit==0 ? rse : rse+1
#     #   @current_page=page.to_i>1 ? page.to_i : 1
#     #   @previous_page= @current_page==1 ? 1 : @current_page-1
#     #   @next_page=@current_page== @no_of_pages ? @no_of_pages : @current_page+1
#     #   @recent_activity= Question.recent_activity(current_user, category_type_id,activity_limit).limit(activity_limit).offset(activity_offset)
#     # end

#     # def get_total_view_and_response(ans,current_user,params)
#     #   view_response = {}
#     #   total_view_count = get_location_based_view_count(ans.value, current_user.id,params,'dashboard')
#     #   total_response_count = get_location_based_response_count(ans.value, ans.question_id,current_user.id, params, 'dashboard')
#     #   view_response["question"] = {"country" => ans.value, "view_count" => total_view_count, "response_count" => total_response_count}
#     #   return total_view_count,total_response_count, view_response
#     # end
#   end
# end