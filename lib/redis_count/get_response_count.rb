# module RedisCount
#  class GetResponseCount

#    def initialize(*args)
#      @question_id = args[0]
#      @provider= args[1]
#      @user_id = args[2]
#      @age = args[3]
#      @gender = args[4]
#      @uuid = args[5]
#      @from_date = args[6]
#      @to_date = args[7]
#      @category = args[8]
#      @format = args[9]
#      @original_from_date = args[10]
#      @original_to_date = args[11]
#      @is_redis_connected,@redis = RedisCount::ConnectRedis.connect_redis_server
#    end

#    def find_filter_question
#      if @category.to_i != 0
#        @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ? AND category_type_id = ?",@from_date,@to_date,@user_id,@category.to_i)
#      else
#        @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ?",@from_date,@to_date,@user_id)
#      end
#      @question_ids = @question.pluck(:id) if @question.present?
#    end

#    def question_response_count
#      if @from_date.blank?
#        count = @redis.get("question_response_#{@question_id}")
#      else
#        count = rediskey_generate("question_response_#{@question_id}_")
#      end
#      return count
#    end
#    def get_chart_response_count
#     response_counts =  RedisCount::ChartCount.new(@question_id,@user_id,@from_date,@to_date,@category,@format,@original_from_date,@original_to_date,"response").chart_details
#     return response_counts
#    end


#    def get_total_chart_response_count
#     response_counts =  RedisCount::ChartCount.new(@question_id,@user_id,@from_date,@to_date,@category,@format,@original_from_date,@original_to_date,"response").chart_details
#     return response_counts
#    end

#    def rediskey_generate(key)
#      question_dates = (Date.parse(@from_date)..Date.parse(@to_date)).to_a
#      count_keys = question_dates.map{|d|
#        if !@category.blank? && @category.to_i != 0
#          "#{key}#{d.to_date.strftime('%Y/%m/%d')}_#{@category}"
#        else
#          "#{key}#{d.to_date.strftime('%Y/%m/%d')}"
#        end
#      }
#      count_keys
#      return @redis.mget(count_keys).reduce(0){|a,b| a.to_i+b.to_i}
#    end
#    def get_response_count_provider
#      providers = ["Facebook","Twitter","Linkedin","Sms","Email","Call","QR","embed"]
#      provider_count = {}
#      providers.each do |provider|
#        #~ begin
#          if !@from_date.blank? && !@to_date.blank?
#            provider_count[provider] = rediskey_generate("question_response_#{@question_id}_#{provider}_")
#          else
#            provider_count[provider] = @redis.get("question_response_#{@question_id}_#{provider}" )
#          end
#        #~ rescue
#          #~ provider_count[provider] = QuestionResponseLog.find_response_count_provider(@question_id,provider)
#        #~ end
#      end
#      return provider_count
#    end
#    def get_monthly_response_count
#      question_dates = (Date.parse(@from_date)..Date.parse(@to_date)).to_a
#      key = "question_total_response_#{@user_id}_"
#      count_keys = question_dates.map{|d|
#        "#{key}#{d.to_date.strftime('%Y/%m')}"
#      }
#      count_keys = count_keys.uniq
#      return @redis.mget(count_keys)

#    end
#    def get_total_response_count_provider
#      providers = ["Facebook","Twitter","Linkedin","Sms","Email","Call","QR","embed"]
#      provider_count = {}
#      providers.each do |provider|
#        if !@from_date.blank? && !@to_date.blank?
#          find_filter_question
#          if @question_ids.present?
#            provider_count[provider] = 0
#            @question_ids.each do |qst_id|
#              provider_count[provider] += rediskey_generate("question_response_#{qst_id}_#{provider}_")
#            end
#          else
#            provider_count[provider] = 0
#          end
#        else
#          provider_count[provider] = @category.present? ? @redis.get("question_total_response_#{@user_id}_#{provider}_#{@category}") : @redis.get("question_total_response_#{@user_id}_#{provider}")
#        end
#      end
#      return provider_count
#    end

#    def get_response_count_by_age
#      form_count_gender_hash(@question_id,'show')
#    end
#    def get_total_response_count_by_age
#      form_count_gender_hash(@user_id,'dashboard')
#    end

#    def form_count_gender_hash(id,page)
#      genders = ["Male","Female"]
#      count_with_gender={}
#      @redis = Redis.current
#      genders.each do |gender|
#        if !@from_date.blank? && !@to_date.blank?
#         find_filter_question
#         if @question_ids.present?
#          count = 0
#          @question_ids.each do | qst_id|
#           count += rediskey_generate("question_response_#{qst_id}_#{@age}_#{gender}_") if page == "dashboard"
#         end
#       else
#        count = 0
#      end
#      count = rediskey_generate("question_response_#{id}_#{@age}_#{gender}_") if page == "show"
#    else
#      count = @redis.get("question_response_#{id}_#{@age}_#{gender}") if page == "show"
#      count = @category.present? ? @redis.get("question_total_response_#{id}_#{@age}_#{gender}_#{@category}") : @redis.get("question_total_response_#{id}_#{@age}_#{gender}") if page == "dashboard"
#    end
#    count_with_gender["male"]= count ? count.to_i : 0 if gender == "Male"
#    count_with_gender["female"]= count ? count.to_i : 0  if gender == "Female"
#  end
#  count_with_gender
# end

# def get_total_unknown_response_count
#  find_filter_question
#  count = 0
#  @question_ids.each do | qst_id |
#    if @category.present?
#      count += @redis.get("unknown_response_#{qst_id}_#{@category}")
#    else
#      count += @redis.get("unknown_response_#{qst_id}")
#    end
#  end
#  return count
# end

# def get_total_response_count
#  if !@from_date.blank? && !@to_date.blank?
#   find_filter_question
#   if @question_ids.present?
#    count = 0
#    @question_ids.each do | qst_id |
#      count += rediskey_generate("question_response_#{qst_id}_")
#    end
#  else
#    count = 0
#  end
# else
#  count = @category.present? ? @redis.get("question_total_response_#{@user_id}_#{@category}") : @redis.get("question_total_response_#{@user_id}")
# end
# return count
# end
# end
# end