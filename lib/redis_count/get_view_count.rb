# module RedisCount
#   class GetViewCount

#    def initialize(*args)
#      @question_id = args[0]
#      @provider= args[1]
#      @user_id = args[2]
#      @age = args[3]
#      @gender = args[4]
#      @country = args[5]
#      @category = args[6]
#      @from_date = args[7]
#      @to_date = args[8]
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

#    def question_view_count
#      if @from_date.blank?
#        count = @redis.get("question_view_#{@question_id}")
#      else
#        count = rediskey_generate("question_view_#{@question_id}_")
#      end
#      return count
#    end
#    def get_chart_view_count
#     view_counts = RedisCount::ChartCount.new(@question_id,@user_id,@from_date,@to_date,@category,@format,@original_from_date,@original_to_date,"view").chart_details
#     return view_counts
#    end
#    def get_view_count_provider
#      providers = ["Facebook","Twitter","Linkedin","Sms","Email","Call","QR","embed"]
#      provider_count = {}
#      providers.each do |provider|
#        if !@from_date.blank? && !@to_date.blank?
#          provider_count[provider] = rediskey_generate("question_view_#{@question_id}_#{provider}_")
#        else
#          provider_count[provider] = @category.present? ?  @redis.get("question_view_#{@question_id}_#{provider}_#{@category}" ) : @redis.get("question_view_#{@question_id}_#{provider}" )
#        end
#      end
#      return provider_count
#    end
#    def get_monthly_view_count
#      @date_month = []
#      question_dates = (Date.parse(@from_date)..Date.parse(@to_date)).to_a
#      key = "question_total_view_#{@user_id}_"
#      count_keys = question_dates.map{|d|
#        "#{key}#{d.to_date.strftime('%Y/%m')}"
#        @date_month.push(d.to_date.strftime('%Y/%m'))
#      }
#      count_keys = count_keys.uniq
#      return @redis.mget(count_keys)
#    end

#    def get_total_chart_view_count
#     view_counts = RedisCount::ChartCount.new(@question_id,@user_id,@from_date,@to_date,@category,@format,@original_from_date,@original_to_date,"view").chart_details
#     return view_counts
#    end

#    def get_total_view_count_provider
#      providers = ["Facebook","Twitter","Linkedin","Sms","Email","Call","QR","embed"]
#      provider_count = {}
#      providers.each do |provider|
#        if !@from_date.blank? && !@to_date.blank?
#          find_filter_question
#          if @question_ids.present?
#            provider_count[provider] = 0
#            @question_ids.each do |qst_id|
#              provider_count[provider] += rediskey_generate("question_view_#{qst_id}_#{provider}_")
#            end
#          else
#            provider_count[provider] = 0
#          end
#        else
#          provider_count[provider] = @category.present? ? @redis.get("question_total_view_#{@user_id}_#{provider}_#{@category}" ) : @redis.get("question_total_view_#{@user_id}_#{provider}" )
#        end
#      end
#      return provider_count
#    end

#    def rediskey_generate(key)
#      question_dates = (Date.parse(@from_date)..Date.parse(@to_date)).to_a
#      count_keys = question_dates.map{|d|
#        if @category && @category.to_i != 0
#          "#{key}#{d.to_date.strftime('%Y/%m/%d')}_#{@category}"
#        else
#          "#{key}#{d.to_date.strftime('%Y/%m/%d')}"
#        end
#      }
#      return @redis.mget(count_keys).reduce(0){|a,b| a.to_i+b.to_i}
#    end

#    def get_view_count_by_age
#      form_count_gender_hash(@question_id,"show")
#    end

#    def get_total_view_count_by_age
#      form_count_gender_hash(@user_id,"dashboard")
#    end

#    def form_count_gender_hash(id,page)
#      genders = ["Male","Female"]
#      count_with_gender={}
#      genders.each do |gender|
#        if !@from_date.blank? && !@to_date.blank?
#          find_filter_question
#          if @question_ids.present?
#            count = 0
#            @question_ids.each do | qst_id|
#              count += rediskey_generate("question_view_#{qst_id}_#{@age}_#{gender}_") if page == "dashboard"
#            end
#          else
#            count = 0
#          end
#          count = rediskey_generate("question_view_#{id}_#{@age}_#{gender}_") if page == "show"
#        else
#          count = @category.present? ? @redis.get("question_total_view_#{id}_#{@age}_#{gender}_#{@category}") : @redis.get("question_total_view_#{id}_#{@age}_#{gender}") if page == "dashboard"
#          count = @redis.get("question_view_#{id}_#{@age}_#{gender}") if page == "show"
#        end
#        count_with_gender["male"]= count ? count.to_i : 0 if gender == "Male"
#        count_with_gender["female"]= count ? count.to_i : 0  if gender == "Female"
#      end
#      count_with_gender
#    end

#    def get_unknown_view_count
#      count = @redis.get("unknown_view_#{@question_id}")
#    end

#    def get_total_unknown_view_count
#      find_filter_question
#      count = 0
#      @question_ids.each do |qst_id|
#        if @category.present?
#          count +=  @redis.get("unknown_view_#{qst_id}_#{@category}")
#        else
#          count += @redis.get("unknown_view_#{@qst_id}")
#        end
#      end
#      return count
#    end

#    def get_total_view_count_country
#      if !@from_date.present? && !@to_date.present?
#        count = @category.present? ? @redis.get("question_total_view_#{@user_id}_#{@country}_#{@category}") : @redis.get("question_total_view_#{@user_id}_#{@country}")
#      else
#        find_filter_question
#        if @question_ids.present?
#          count = 0
#          @question_ids.each do |qst_id|
#            count += rediskey_generate("question_view_#{qst_id}_#{@country}_")
#          end
#        else
#          count = 0
#        end
#      end
#      return count
#    end

#    def get_view_count_country
#      if @category && @category.to_i != 0 && !@from_date.blank?
#        count = rediskey_generate("question_view_#{@question_id}_#{@country}_")
#      else
#        count = @redis.get("question_view_#{@question_id}_#{@country}")
#        return count
#      end
#    end

#    def get_total_view_count
#      if @from_date.present? && @to_date.present?
#        find_filter_question
#        if @question_ids.present?
#          count = 0
#          @question_ids.each do | qst_id |
#            count += rediskey_generate("question_view_#{qst_id}_")
#          end
#        else
#          count = 0
#        end
#      else
#        count = @category.present? ? @redis.get("question_total_view_#{@user_id}_#{@category}") : @redis.get("question_total_view_#{@user_id}")
#      end
#      return count
#    end
#   end
# end