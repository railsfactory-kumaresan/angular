# module RedisCount
#   class ChartCount

#    def initialize(*args)
#      @question_id = args[0]
#      @user_id = args[1]
#      @from_date = args[2]
#      @to_date = args[3]
#      @category = args[4]
#      @format = args[5]
#      @original_from_date = args[6]
#      @original_to_date = args[7]
#      @status =args[8]
#    end


#    def chart_details
#      if @category.to_i != 0
#        @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ? AND category_type_id = ?",@original_from_date,@original_to_date,@user_id,@category.to_i)
#      else
#        @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ?",@original_from_date,@original_to_date,@user_id)
#      end
#      @question_ids = @question_id.present? ? [@question_id] : @question.pluck(:id) if @question.present?
#      @keys=[]
#      if @question_ids.present?
#        count = 0
#        @question_ids.each do |qst_id|
#          @keys << "question_#{@status}_#{qst_id}_"
#        end
#      else
#        @keys << "not_generated_keys_"
#      end
#      if @format =="day"
#        @format = "%Y/%m/%d"
#      elsif @format == "month"
#        @format = "%Y/%m/%d"
#        month_keys = true
#        question_dates = (Date.parse(@from_date)..Date.parse(@to_date).end_of_month).to_a
#      else
#        @format = "%Y/%m/%d"
#        @format_year = true
#        @from_date = @original_from_date.to_date.strftime(@format)
#        @to_date = @original_to_date.to_date.strftime(@format)
#        month_keys = true
#        question_dates = (Date.parse(@from_date)..Date.parse(@to_date).end_of_month).to_a
#      end
#      question_dates = (Date.parse(@from_date)..Date.parse(@to_date)).to_a unless month_keys
#      count_keys = question_dates.map{|d|
#        if @category && @category.to_i != 0
#          @keys.map{|key| "#{key}#{d.to_date.strftime(@format)}_#{@category}" }
#        else
#          @keys.map{|key| "#{key}#{d.to_date.strftime(@format)}"}
#        end
#      }
#      count_keys1 = []
#      if month_keys == true
#        count_keys1 = get_month_based_keys(count_keys.flatten.uniq)
#      else
#        count_keys.each do |a|
#          count_keys1 <<  $redis.mget(a).reduce(0){|a,b| a.to_i+b.to_i}
#        end
#      end

#      return count_keys1
#    end

#    def get_month_based_keys(keys)
#      years = @original_from_date.year.upto(@original_to_date.year).map{|y| y }
#      @key_collection ={}
#      keys.each do |key|
#        years.each_with_index do |year,i|
#          month= key.split("/")[1].to_i
#          key_year = key.split("/")[0].split("_").last.to_i
#          if key_year == year
#            check_date = check_start_end_date(key,year)
#            if @key_collection["#{year}"] && @key_collection["#{year}"][month] && check_date
#              @key_collection["#{year}"][month].push(key)
#            elsif check_date
#              @key_collection["#{year}"] = [] if @key_collection["#{year}"].nil?
#              @key_collection["#{year}"][month] = [key]
#            end
#          end
#        end
#      end
#      count = []
#      years.each do |year|
#        if @format_year
#          keys = @key_collection["#{year}"].flatten
#          count << $redis.mget(keys.compact).reduce(0){|a,b| a.to_i+b.to_i}  unless keys.nil?
#        else
#          @key_collection["#{year}"] && @key_collection["#{year}"].each do |key|
#            count << $redis.mget(key.compact).reduce(0){|a,b| a.to_i+b.to_i}  unless key.nil?
#          end
#        end
#      end
#      return count
#    end

#    def check_start_end_date(key,year)
#      month = key.split("/")[1].to_i
#      if year == @original_from_date.year && month == @original_from_date.month
#        key.split("/")[2].to_i >= @original_from_date.day ? true : false
#      elsif year == @original_to_date.year && month == @original_to_date.month
#        key.split("/")[2].to_i <= @original_to_date.day ? true : false
#      else
#        true
#      end
#    end
#   end
# end