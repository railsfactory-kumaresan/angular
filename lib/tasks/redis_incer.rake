# desc "Creating a sample data's"

# task :insert_keys => [:environment] do
# puts Benchmark.measure {increment_redis}
#   end

# def increment_redis
# answers= Answer.find(:all,:conditions=>"id >= 1 and id <= 1304")
# answers.sort.each do |answer|
# question = answer.question
# @question_id = question.id
# @provider = answer.provider
# @user_id = User.find(2).id
# @uuid = answer.uuid
# @created_date = answer.created_at
# @category = question.category_type_id
# @age = answer.customer_info.age
# @gender = answer.customer_info.gender
# @country = answer.customer_info.country
# keys = []
#        keys << ["question_view_#{@question_id}","question_view_#{@question_id}_#{@provider}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y')}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_view_#{@question_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_view_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}","question_total_view_#{@user_id}_#{@category}","question_total_view_#{@user_id}_#{@provider}","question_total_view_#{@user_id}_#{@provider}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y')}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_total_view_#{@user_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_total_view_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"]

#    keys << ["question_response_#{@question_id}","question_response_#{@question_id}_#{@provider}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y')}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_response_#{@question_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_response_#{@question_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_response_#{@user_id}","question_total_response_#{@user_id}_#{@category}","question_total_response_#{@user_id}_#{@provider}","question_total_response_#{@user_id}_#{@provider}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y')}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y/%m')}_#{@category}","question_total_response_#{@user_id}_#{@created_date.to_date.strftime('%Y')}_#{@category}","question_total_response_#{@user_id}_#{@provider}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"]

#   keys << ["question_view_#{@question_id}_#{@country}","question_total_view_#{@user_id}_#{@country}","question_total_view_#{@user_id}_#{@country}_#{@category}","question_view_#{@question_id}_#{@country}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}","question_total_view_#{@user_id}_#{@country}_#{@created_date.to_date.strftime('%Y/%m/%d')}_#{@category}"]

# #   RedisCount::RedisKeyIncrement.new(keys.flatten).increment_keys
#   increase_response_count_by_age
# print "done with #{answer.id}.............\r"

# end
# end

#   def increase_response_count_by_age
#     case @age.to_i
#       when 0..17
#        increase_age_count(@question_id,@user_id,"0_to_17",@gender,@created_date,@category)
#       when 18..25
#        increase_age_count(@question_id,@user_id,"18_to_25",@gender,@created_date,@category)
#       when 26..30
#        increase_age_count(@question_id,@user_id,"26_to_30",@gender,@created_date,@category)
#        when 31..35
#        increase_age_count(@question_id,@user_id,"31_to_35",@gender,@created_date,@category)
#        when 36..40
#        increase_age_count(@question_id,@user_id,"36_to_40",@gender,@created_date,@category)
#        when 41..45
#        increase_age_count(@question_id,@user_id,"41_to_45",@gender,@created_date,@category)
#       when 46..50
#         increase_age_count(@question_id,@user_id,"46_to_50",@gender,@created_date,@category)
#         when 51..300
#        increase_age_count(@question_id,@user_id,"51_to_300",@gender,@created_date,@category)
#        end
# end

#  def increase_age_count(question_id,user_id,age_limit,gender,created_date=nil,category=nil)
#    keys = ["question_response_#{question_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{category}","question_response_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_response_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_total_response_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}"]
#  # RedisCount::RedisKeyIncrement.new(keys).increment_keys #if @sample_question_view_date.blank?
#    keys = ["question_view_#{question_id}_#{age_limit}_#{gender}","question_total_view_#{user_id}_#{age_limit}_#{gender}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{category}","question_view_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_view_#{question_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}","question_total_view_#{user_id}_#{age_limit}_#{gender}_#{created_date.to_date.strftime('%Y/%m/%d')}_#{category}"]

#  #  RedisCount::RedisKeyIncrement.new(keys).increment_keys
#       #return keys
# end
