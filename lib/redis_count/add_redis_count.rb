module RedisCount
class AddRedisCount
 include ActionController::Helpers::ClassMethods

##
# The *args the the following values
#
# args[0] - Question id
#
# args[1] - Provider
#
# args[2] - User id
#
# args[3] - Age
#
# args[5] - uuid
#
# args[6] - Created Date
#
# args[7] - Category
#
# args[8] - Cookie Token id
def initialize(*args)
  @question_id = args[0]
  @provider= args[1]
  @user_id = args[2]
  @age = args[3]
  @gender = args[4]
  @uuid = args[5]
  @created_date = args[6]
  @category = args[7]
  @cookie_token_id =  args[8]
  @is_redis_connected,@redis = RedisCount::ConnectRedis.connect_redis_server
end

##
#
def increase_question_view_count
@country,@age,@gender = check_user_country_age if @uuid
#check_user_age if @uuid
#RedisCount::IncrementViewCount.new(@question_id,@provider,@user_id,nil,nil,@uuid,nil,@created_date,@category).increase_unknown_view_count if @country.blank?
RedisCount::IncrementViewCount.new(@question_id,@provider,@user_id,nil,nil,@uuid,nil,@created_date,@category,@cookie_token_id).increase_view_count
RedisCount::IncrementViewCount.new(@question_id,@provider,@user_id,@age,@gender,@uuid,nil,@created_date,@category,@cookie_token_id).increase_age_wise_view_count if @age && @gender
RedisCount::IncrementViewCount.new(@question_id,@provider,@user_id,@age,@gender,@uuid,@country,@created_date,@category,@cookie_token_id).increase_country_wise_view_count unless @country.blank?
end

def check_user_country_age
  @country,@age,@gender = ResponseCookieInfo.check_country_and_age(@uuid)
  @gender = @gender.to_s.capitalize
  return @country,@age,@gender
end

def check_user_age
  @age,@gender = ResponseCookieInfo.find_user_age_gender(@uuid)
end

def increase_question_response_count
@country,@age,@gender = check_user_country_age if @uuid
#check_user_age if @uuid
	RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,nil,nil,nil,@uuid,@created_date,@category,@cookie_token_id).increase_response_count
	#RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,nil,nil,@uuid,nil,@created_date,@category).increase_unknown_response_count if @country.blank?
 RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,@age,@gender,nil,@uuid,@created_date,@category,@cookie_token_id).increase_age_wise_response_count if @age && @gender
#  RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,@age,@gender,@uuid,@country,@created_date,@category,@cookie_token_id).increase_country_wise_response_count unless @country.blank?
end

def increase_age_wise_count
  RedisCount::IncrementViewCount.new(@question_id,@provider,@user_id,@age,@gender,nil,nil,@created_date,@category).increase_age_wise_view_count  if (!@gender.blank? && !@age.blank?)
  RedisCount::IncrementResponseCount.new(@question_id,@provider,@user_id,@age,@gender,nil,nil,@created_date,@category).increase_age_wise_response_count if (!@gender.blank? && !@age.blank?)
end


end
end