# desc "Creating a Redis Keys"
# task :add_redis_keys => [:environment] do
#   add_redis_keys
# end
# def add_redis_keys
# 	question_view_keys = QuestionViewLog.all
# 	@view_keys = []
# 	@response_keys = []
# 	question_view_keys.each do |view|
# 		@question_id = view.question_id
# 		@provider  = view.provider
# 		@created_date = view.created_at
# 		@category = Question.where(id: view.question_id).first.category_type_id
# 		@user_id = view.user_id
# 		p "-------------user_id--------------"
# 		p @user_id
# 	        cookie_tokn = CookieToken.where(id: view.cookie_token_id).first
# 		p "----------------- CookieToken --------"
# 		p cookie_tokn
# 	        cus_info  =  ResponseCustomerInfo.where(cookie_token_id: cookie_tokn.id) if !cookie_tokn.blank?
# 		p "---------------- ResponseCustomer -----------"
# 		p cus_info
# 	        cus_info  =  BusinessCustomerInfo.where(cookie_token_id: cookie_tokn.id) if cus_info.blank? && !cookie_tokn.blank?
# 		p "---------------- BusinessCustomer -----------"
# 		p cus_info
# 		@age =  @provider != 'embed' &&  !cus_info.blank?  ? cus_info.first.age :  ""
# 	        @gender =  @provider != 'embed' &&  !cus_info.blank? ?  cus_info.first.gender : ""
# 	        @country = @provider != 'embed' &&  !cus_info.blank? ? cus_info.first.country  :  ""
# 		p "---------Country----------------"
# 		p @country
# 	        @created_time = @created_date.utc
#                 @date_y_m_d = @created_time.strftime('%Y/%m/%d')
# 		@view_keys <<  ["question_view_#{@question_id}","question_view_#{@question_id}_#{@provider}","question_view_#{@question_id}_#{@date_y_m_d}","question_view_#{@question_id}_#{@provider}_#{@date_y_m_d}","question_view_#{@question_id}_#{@created_time.strftime('%Y/%m')}","question_view_#{@question_id}_#{@created_time.strftime('%Y')}","question_view_#{@question_id}_#{@date_y_m_d}_#{@category}","question_view_#{@question_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_view_#{@question_id}_#{@created_time.strftime('%Y')}_#{@category}","question_view_#{@question_id}_#{@provider}_#{@date_y_m_d}_#{@category}","question_total_view_#{@user_id}","question_total_view_#{@user_id}_#{@category}","question_total_view_#{@user_id}_#{@provider}","question_total_view_#{@user_id}_#{@provider}_#{@category}","question_total_view_#{@user_id}_#{@date_y_m_d}","question_total_view_#{@user_id}_#{@created_time.strftime('%Y/%m')}","question_total_view_#{@user_id}_#{@created_time.strftime('%Y')}","question_total_view_#{@user_id}_#{@date_y_m_d}_#{@category}","question_total_view_#{@user_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_total_view_#{@user_id}_#{@created_time.strftime('%Y')}_#{@category}","question_total_view_#{@user_id}_#{@provider}_#{@date_y_m_d}","question_total_view_#{@user_id}_#{@provider}_#{@date_y_m_d}_#{@category}"]

# 		 @view_keys << ["question_view_#{@question_id}_#{@country}_#{@date_y_m_d}","question_view_#{@question_id}_#{@country}","question_total_view_#{@user_id}_#{@country}","question_view_#{@question_id}_#{@country}_#{@date_y_m_d}_#{@category}","question_total_view_#{@user_id}_#{@country}_#{@date_y_m_d}_#{@category}","question_total_view_#{@user_id}_#{@country}_#{@category}"] if @provider != 'embed'

# 	    increase_response_count_by_age if @provider != "embed" && !@age.blank? && !@gender.blank?
# 	 end

# 	 question_response_keys = QuestionResponseLog.all
# 	 question_response_keys.each do |response|
# 		@question_id = response.question_id
# 		@provider  = response.provider
# 		@created_date = response.created_at
# 		@category = Question.where(id: response.question_id).first.category_type_id
# 		@user_id = response.user_id
# 		p "-------------user_id--------------"
# 		p @user_id
# 	        cookie_tokn = CookieToken.where(id: response.cookie_token_id).first
# 		p "----------------- CookieToken --------"
# 		p cookie_tokn
# 	        cus_info  =  ResponseCustomerInfo.where(cookie_token_id: cookie_tokn.id) if !cookie_tokn.blank?
# 		p "---------------- ResponseCustomer -----------"
# 		p cus_info
# 	        cus_info  =  BusinessCustomerInfo.where(cookie_token_id: cookie_tokn.id) if cus_info.blank? && !cookie_tokn.blank?
# 		p "---------------- BusinessCustomer -----------"
# 		p cus_info
# 		@age =  @provider != 'embed' &&  !cus_info.blank?  ? cus_info.first.age :  ""
# 	        @gender =  @provider != 'embed' &&  !cus_info.blank? ?  cus_info.first.gender : ""
# 	        @country = @provider != 'embed' &&  !cus_info.blank? ? cus_info.first.country  :  ""
# 		p "---------Country----------------"
# 		p @country
# 	        @created_time = @created_date.utc
#                 @date_y_m_d = @created_time.strftime('%Y/%m/%d')
# 		@response_keys <<  ["question_response_#{@question_id}","question_response_#{@question_id}_#{@provider}","question_response_#{@question_id}_#{@date_y_m_d}","question_response_#{@question_id}_#{@provider}_#{@date_y_m_d}","question_response_#{@question_id}_#{@created_time.strftime('%Y/%m')}","question_response_#{@question_id}_#{@created_time.strftime('%Y')}","question_response_#{@question_id}_#{@date_y_m_d}_#{@category}","question_response_#{@question_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_response_#{@question_id}_#{@created_time.strftime('%Y')}_#{@category}","question_response_#{@question_id}_#{@provider}_#{@date_y_m_d}_#{@category}","question_total_response_#{@user_id}","question_total_response_#{@user_id}_#{@category}","question_total_response_#{@user_id}_#{@provider}","question_total_response_#{@user_id}_#{@provider}_#{@category}","question_total_response_#{@user_id}_#{@date_y_m_d}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y/%m')}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y')}","question_total_response_#{@user_id}_#{@date_y_m_d}_#{@category}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y')}_#{@category}","question_total_response_#{@user_id}_#{@provider}_#{@date_y_m_d}","question_total_response_#{@user_id}_#{@provider}_#{@date_y_m_d}_#{@category}"]

# 	    increase_response_count_by_age if @provider != "embed" && !@age.blank? && !@gender.blank?
#     end
#      keys = @response_keys + @view_keys
#     RedisCount::RedisKeyIncrement.new(keys.flatten).increment_keys
# end

# def increase_response_count_by_age
#   case @age.to_i
#   when 0..17
#     increase_age_count(@question_id,@user_id,"0_to_17",@gender,@created_date,@category)
#   when 18..25
#     increase_age_count(@question_id,@user_id,"18_to_25",@gender,@created_date,@category)
#   when 26..30
#     increase_age_count(@question_id,@user_id,"26_to_30",@gender,@created_date,@category)
#   when 31..35
#     increase_age_count(@question_id,@user_id,"31_to_35",@gender,@created_date,@category)
#   when 36..40
#     increase_age_count(@question_id,@user_id,"36_to_40",@gender,@created_date,@category)
#   when 41..45
#     increase_age_count(@question_id,@user_id,"41_to_45",@gender,@created_date,@category)
#   when 46..50
#     increase_age_count(@question_id,@user_id,"46_to_50",@gender,@created_date,@category)
#   when 51..300
#     increase_age_count(@question_id,@user_id,"51_to_300",@gender,@created_date,@category)
#   end
# end


# #~ def increase_unknown_view_count
#   #~ key = ["unknown_view_#{@question_id}","unknown_total_view_#{@user_id}","unknown_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","unknown_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","unknown_total_view_#{@user_id}_#{@category}"]
#   #~ RedisCount::RedisKeyIncrement.new(key).increment_keys if @provider == 'embed'
# #~ end


# def increase_age_count(question_id,user_id,age_limit,gender,created_date=nil,category=nil)
#   keys = ["question_response_#{question_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{category}","question_response_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_response_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}"]
#   RedisCount::RedisKeyIncrement.new(keys).increment_keys #if @sample_question_view_date.blank?
#   keys = ["question_view_#{question_id}_#{age_limit}_#{gender}","question_total_view_#{user_id}_#{age_limit}_#{gender}","question_view_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_view_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{category}"]
#   RedisCount::RedisKeyIncrement.new(keys).increment_keys #if @sample_question_view_date.blank?
#   #return keys
# end