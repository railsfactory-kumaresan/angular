# module RedisCount
# class IncrementResponseCount
#  def initialize(*args)
#    @question_id = args[0]
#    @provider= args[1]
#    @user_id = args[2]
#    @age = args[3]
#    @gender = args[4].blank? ? args[4] : args[4].to_s.capitalize
#    @country = args[5]
#    @uuid = args[6]
#    @created_date = args[7]
#    @category = args[8]
#    @cookie_token_id =  args[9]
#    @sample_question_response_date = args[10]
# 	  @redis = Redis.current
#    @created_time = @created_date.utc
#    @date_y_m_d = @created_time.strftime('%Y/%m/%d')
#  end

#  def increase_response_count
#    keys =["question_response_#{@question_id}","question_response_#{@question_id}_#{@provider}","question_response_#{@question_id}_#{@date_y_m_d}","question_response_#{@question_id}_#{@provider}_#{@date_y_m_d}","question_response_#{@question_id}_#{@created_time.strftime('%Y/%m')}","question_response_#{@question_id}_#{@created_time.strftime('%Y')}","question_response_#{@question_id}_#{@date_y_m_d}_#{@category}","question_response_#{@question_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_response_#{@question_id}_#{@created_time.strftime('%Y')}_#{@category}","question_response_#{@question_id}_#{@provider}_#{@date_y_m_d}_#{@category}","question_total_response_#{@user_id}","question_total_response_#{@user_id}_#{@category}","question_total_response_#{@user_id}_#{@provider}","question_total_response_#{@user_id}_#{@provider}_#{@category}","question_total_response_#{@user_id}_#{@date_y_m_d}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y/%m')}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y')}","question_total_response_#{@user_id}_#{@date_y_m_d}_#{@category}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y/%m')}_#{@category}","question_total_response_#{@user_id}_#{@created_time.strftime('%Y')}_#{@category}","question_total_response_#{@user_id}_#{@provider}_#{@date_y_m_d}","question_total_response_#{@user_id}_#{@provider}_#{@date_y_m_d}_#{@category}"]
#      @sample_question_response_date.blank? ? QuestionResponseLog.create_new_record(@question_id,@provider,@user_id,@cookie_token_id) : ""
#  RedisCount::RedisKeyIncrement.new(keys).increment_keys if @sample_question_response_date.blank?
#     return keys
# end

#  def increase_response_count_by_age
#    case @age.to_i
#      when 0..17
#       increase_age_count(@question_id,@user_id,"0_to_17",@gender,@category)
#      when 18..25
#       increase_age_count(@question_id,@user_id,"18_to_25",@gender,@category)
#      when 26..30
#       increase_age_count(@question_id,@user_id,"26_to_30",@gender,@category)
#       when 31..35
#       increase_age_count(@question_id,@user_id,"31_to_35",@gender,@category)
#       when 36..40
#       increase_age_count(@question_id,@user_id,"36_to_40",@gender,@category)
#       when 41..45
#       increase_age_count(@question_id,@user_id,"41_to_45",@gender,@category)
#      when 46..50
#        increase_age_count(@question_id,@user_id,"46_to_50",@gender,@category)
#        when 51..300
#       increase_age_count(@question_id,@user_id,"51_to_300",@gender,@category)
#       end
# end

# def increase_age_count(question_id,user_id,age_limit,gender,category=nil)
#   keys = ["question_response_#{question_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{category}","question_response_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_response_#{question_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{@date_y_m_d}_#{category}"]
#   RedisCount::RedisKeyIncrement.new(keys).increment_keys if @sample_question_view_date.blank?
#      return keys
# end

# def increase_age_wise_response_count
#  RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,@age,@gender,nil,nil,@created_date,@category).increase_response_count_by_age if(!@age.blank? && !@gender.blank?)
# end

# end
# end