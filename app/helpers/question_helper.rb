module QuestionHelper

  # def get_question_view_count_params(question)
  #   filter_type = question.expiration_id
  #   case filter_type
  #   when "1 Day"
  #     view_count_filter_by_day(question,"question")
  #   when "1 Week"
  #     view_count_filter_by_day(question,"question")
  #   when "1 Month"
  #     view_count_filter_by_month(question,"question")
  #   when "1 Year"
  #     view_count_filter_by_year(question,"question")
  #   end
  # end

#*******************************************************Without filter *********************************************************#

# def get_chart_view_res_count(obj,status)
#  from_date = obj.created_at
#  to_date = Time.now.to_date
#  days = calculate_num_of_days(obj.created_at)
#  case days
#  when 0..31
#   view_count_filter(from_date,to_date,status,obj,'day',nil)
#  when 32..365
#   view_count_filter(from_date,to_date,status,obj,'month',nil)
#  when 366..(1.0/0.0)
#   view_count_filter(from_date,to_date,status,obj,'year',nil)
#  end
# end

# def view_count_filter(from_date,to_date,data,obj,status,category)
#   original_from_date = from_date.to_date
#   original_to_date = to_date.to_date
#   from_date,to_date,format = get_from_date_to_date(from_date,to_date,data,obj,status)
#   views,responses = view_and_response_count(from_date,to_date,format,data,obj,status,category,original_from_date,original_to_date)
# if status != "year"
#   yaxis = (Date.parse(from_date)..Date.parse(to_date)).to_a
#   yaxis = yaxis.map{|d| "#{d.to_date.strftime(format)}" }
#   yaxis = yaxis .uniq
# end
# if status == "day"
#   view_counts,response_counts,dates = get_xaxis_yaxis_values(views,responses,yaxis)
#   # to_date nil class error handled using the below code
#   #return view_counts.map! { |x| x || 0 }, response_counts.map! { |x| x || 0 }, dates.map! { |x| x.blank? ? "" :  x.to_date.strftime(format)}.sort, "Views vs Responses by Date"
#   return view_counts.map! { |x| x || 0 }, response_counts.map! { |x| x || 0 }, dates.map! { |x| x.to_date.strftime(format)}.sort, "Views vs Responses by Date"
# elsif status == "month"
#  return views.map! { |x| x || 0 }, responses.map! { |x| x || 0 }, yaxis.sort, "Views vs Responses by Month"
# elsif status == "year"
#    from_year = from_date
#    to_year = to_date.present? ? to_date : Time.now.year.to_i
#    yaxis =   (to_year.to_i).downto(from_year.to_i).to_a
#    yaxis = yaxis .uniq
#    return views.map! { |x| x || 0 }, responses.map! { |x| x || 0 }, yaxis.sort, "Views vs Responses by Year"
# end
# end

# def view_and_response_count(from_date,to_date,format,data,obj,status,category,original_from_date,original_to_date)
#   if data=="dashboard"
#     views =  RedisCount::GetViewCount.new(nil,nil,obj.id,nil,nil,nil,category,from_date,to_date,status,original_from_date,original_to_date).get_total_chart_view_count
#     responses =  RedisCount::GetResponseCount.new(nil,nil,obj.id,nil,nil,nil,from_date,to_date,category,status,original_from_date,original_to_date).get_total_chart_response_count
#   else
#     views =  RedisCount::GetViewCount.new(obj.id,nil,obj.user_id,nil,nil,nil,category,from_date,to_date,status,original_from_date,original_to_date).get_chart_view_count
#     responses =  RedisCount::GetResponseCount.new(obj.id,nil,obj.user_id,nil,nil,nil,from_date,to_date,category,status,original_from_date,original_to_date).get_chart_response_count
#   end
#   return views,responses
# end

# def get_from_date_to_date(from_date,to_date,data,obj,status)
#   case status
#   when "day"
#    format = "%Y/%m/%d"
#   when "month"
#    format = "%Y/%m"
#   when "year"
#    format = "%Y"
#   end
#    from_date = from_date.to_date.strftime(format)
#    to_date = to_date.to_date.strftime(format)
#   return from_date,to_date,format
# end

# def get_xaxis_yaxis_values(ques_view_cnt,ans,yaxis)
# view_counts,response_counts,dates = [],[],[]
# i = 0
# yaxis = yaxis.sort
# ques_view_cnt.each do |view_count|
#  view_counts << view_count if(!view_count.nil? || !ans[i].nil?)
#  response_counts << ans[i] if(!view_count.nil? || !ans[i].nil?)
#  dates << yaxis[i] if(!view_count.nil? || !ans[i].nil?)
#  i += 1
# end
# return view_counts,response_counts,dates
# end

# def view_count_filter_by_month(user,data)
#  if data=="dashboard"
#   ques_view_cnt =  RedisCount::GetViewCount.new(nil,nil,user.id,nil,nil,nil,nil,user.created_at.to_date.strftime("%Y/%m"),Time.now.to_date.strftime("%Y/%m"),"month").get_total_chart_view_count
#   ans =  RedisCount::GetResponseCount.new(nil,nil,user.id,nil,nil,nil,user.created_at.to_date.strftime("%Y/%m"),Time.now.to_date.strftime("%Y/%m"),nil,"month").get_total_chart_response_count
# else
#   ques_view_cnt =  RedisCount::GetViewCount.new(user.id,nil,user.user_id,nil,nil,nil,nil,user.created_at.to_date.strftime("%Y/%m"),Time.now.to_date.strftime("%Y/%m"),"month").get_chart_view_count
#   ans =  RedisCount::GetResponseCount.new(user.id,nil,user.user_id,nil,nil,nil,user.created_at.to_date.strftime("%Y/%m"),Time.now.to_date.strftime("%Y/%m"),nil,"month").get_chart_response_count
# end
# yaxis = (Date.parse(user.created_at.to_date.strftime("%Y/%m"))..Date.parse(Time.now.to_date.strftime("%Y/%m"))).to_a

# yaxis = yaxis.map{|d| "#{d.to_date.strftime("%Y/%m")}" }
# yaxis = yaxis .uniq
# return ques_view_cnt.map! { |x| x || 0 }, ans.map! { |x| x || 0 }, yaxis.sort, "View vs Response by Month"
# end

# def view_count_filter_by_year(user,data)
#   if data=="dashboard"
#     ques_view_cnt =  RedisCount::GetViewCount.new(nil,nil,user.id,nil,nil,nil,nil,user.created_at.to_date.strftime("%Y"),Time.now.to_date.strftime("%Y"),"year").get_total_chart_view_count
#     ans =  RedisCount::GetResponseCount.new(nil,nil,user.id,nil,nil,nil,user.created_at.to_date.strftime("%Y"),Time.now.to_date.strftime("%Y"),nil,"year").get_total_chart_response_count
#   else
#     ques_view_cnt =  RedisCount::GetViewCount.new(user.id,nil,user.user_id,nil,nil,nil,nil,user.created_at.to_date.strftime("%Y-%m-%d"),Time.now.to_date.strftime("%Y-%m-%d"),"year").get_chart_view_count
#     ans =  RedisCount::GetResponseCount.new(user.id,nil,user.user_id,nil,nil,nil,user.created_at.to_date.strftime("%Y-%m-%d"),Time.now.to_date.strftime("%Y-%m-%d"),nil,"year").get_chart_response_count
#   end
#    from_date = user.created_at.to_date.strftime("%Y-%m-%d")
#    to_date = Time.now.to_date.strftime("%Y-%m-%d")
#    from_year = user.created_at.to_date.strftime("%Y")
#    yaxis =   (Time.now.year.to_i).downto(from_year.to_i).to_a
#    yaxis = yaxis .uniq
#    return ques_view_cnt.map! { |x| x || 0 }, ans.map! { |x| x || 0 }, yaxis.sort, "View vs Response by Month"
# end



  #*******************************************************With filter  question*********************************************************#

# def get_chart_view_res_count_filter(obj,from_date,to_date,category,status)
#   days = calculate_date(from_date,to_date)
#  case days.abs
#   when 0..31
#   view_count_filter(from_date,to_date,status,obj,'day',category)
#  when 32..365
#   view_count_filter(from_date,to_date,status,obj,'month',category)
#  when 366..(1.0/0.0)
#   view_count_filter(from_date,to_date,status,obj,'year',category)
#  end

# end


# def view_count_filter_by_day_date(question,from_date,date,category,data)
#  if data=="question"
#    ques_view_cnt =  RedisCount::GetViewCount.new(question.id,nil,question.user_id,nil,nil,nil,category,from_date.to_date.strftime("%Y/%m/%d"),date.to_date.strftime("%Y/%m/%d"),"day").get_chart_view_count
#    ans =  RedisCount::GetResponseCount.new(question.id,nil,question.user_id,nil,nil,nil,from_date.to_date.strftime("%Y/%m/%d"),date.to_date.strftime("%Y/%m/%d"),category,"day").get_chart_response_count
#  else
#   ques_view_cnt =  RedisCount::GetViewCount.new(nil,nil,current_user.id,nil,nil,nil,category,from_date.to_date.strftime("%Y/%m/%d"),date.to_date.strftime("%Y/%m/%d"),"day").get_total_chart_view_count
#   ans =  RedisCount::GetResponseCount.new(nil,nil,current_user.id,nil,nil,nil,from_date.to_date.strftime("%Y/%m/%d"),date.to_date.strftime("%Y/%m/%d"),category,"day").get_total_chart_response_count
# end
# yaxis = (Date.parse(from_date.to_date.strftime("%Y/%m/%d"))..Date.parse(date.to_date.strftime("%Y/%m/%d"))).to_a
# return ques_view_cnt.map! { |x| x || 0 }, ans.map! { |x| x || 0 }, yaxis.map! { |x| x.to_date.strftime("%Y/%m/%d")}, "View vs Response by Date"
# end

# def view_count_filter_by_month_date(question,from_date,date,category,data)
#   if data=="question"
#    ques_view_cnt =  RedisCount::GetViewCount.new(question.id,nil,question.user_id,nil,nil,nil,category,from_date.to_date.strftime("%Y/%m"),date.to_date.strftime("%Y/%m"),"month").get_chart_view_count
#    ans =  RedisCount::GetResponseCount.new(question.id,nil,question.user_id,nil,nil,nil,from_date.to_date.strftime("%Y/%m"),date.to_date.strftime("%Y/%m"),category,"month").get_chart_response_count
#  else
#   ques_view_cnt =  RedisCount::GetViewCount.new(nil,nil,current_user.id,nil,nil,nil,category,from_date.to_date.strftime("%Y/%m"),date.to_date.strftime("%Y/%m"),"month").get_total_chart_view_count
#   ans =  RedisCount::GetResponseCount.new(nil,nil,current_user.id,nil,nil,nil,from_date.to_date.strftime("%Y/%m"),date.to_date.strftime("%Y/%m"),category,"month").get_total_chart_response_count
# end
# yaxis = (Date.parse(from_date.to_date.strftime("%Y/%m"))..Date.parse(date.to_date.strftime("%Y/%m"))).to_a
# yaxis = yaxis.map{|d|
#   "#{d.to_date.strftime("%Y/%m")}"
# }
# yaxis = yaxis .uniq
# return ques_view_cnt.map! { |x| x || 0 }, ans.map! { |x| x || 0 }, yaxis, "View vs Response by Week"
# end

# def view_count_filter_by_year_date(question,from_date,date,category,data)
#   if data=="question"
#     ques_view_cnt =  RedisCount::GetViewCount.new(question.id,nil,question.user_id,nil,nil,nil,category,from_date.to_date.strftime("%Y"),date.to_date.strftime("%Y"),"year").get_chart_view_count
#     ans =  RedisCount::GetResponseCount.new(question.id,nil,question.user_id,nil,nil,nil,from_date.to_date.strftime("%Y"),date.to_date.strftime("%Y"),category,"year").get_chart_response_count
#   else
#     ques_view_cnt =  RedisCount::GetViewCount.new(nil,nil,current_user.id,nil,nil,nil,category,from_date.to_date.strftime("%Y"),date.to_date.strftime("%Y"),"year").get_total_chart_view_count
#     ans =  RedisCount::GetResponseCount.new(nil,nil,current_user.id,nil,nil,nil,from_date.to_date.strftime("%Y"),date.to_date.strftime("%Y"),category,"year").get_total_chart_response_count
#   end
#   from_date = from_date.to_date.strftime("%Y-%m-%d")
#   to_date = date.to_date.strftime("%Y-%m-%d")
#   from_year = from_date.to_date.strftime("%Y")
#   yaxis =   (Time.now.year.to_i).downto(from_year.to_i).to_a
#   yaxis = yaxis .uniq
#   return ques_view_cnt.map! { |x| x || 0 }, ans.map! { |x| x || 0 }, yaxis, "View vs Response by Month"
# end

# def calculate_num_of_days(question_date)
#   (Date.today - question_date.to_date).to_i
# end

# def calculate_date(from_date,to_date)
#   (to_date.to_date - from_date.to_date).to_i
# end



def get_question_status_class(status)
  cls_name = ""
  case status
  when "Active"
    cls_name = "active"
  when "Closed"
    cls_name = "closed"
  when "Inactive"
  end
  return cls_name
end

def get_category_based_icon(category)
 DEFAULTS["#{category}"]["class"]
end

#for rails best practise below method is commented - unused method

# def  get_question_view_count_params_age(question)
#   if !question.expired_at.nil? && question.is_expired?
#     view_count, response_count, yaxis, x_axis_label = get_question_view_count_params(question.expiration_id, question)
#   else
#     view_count, response_count, yaxis, x_axis_label = get_question_viewcount_by_age(question)
#   end
# end

def dynamic_icon_category(category)
 DEFAULTS["#{category}"]["icon"]
end


#def email_content_trim(email_content)
#  email_content_trim = email_content.gsub( / *\n+/, "\n" )
#  email_content_trim_new = email_content_trim.include?("survey link inserted here automatically") ? email_content_trim : email_content_trim + "&lt;survey link inserted here automatically&gt;"
#  return email_content_trim_new.gsub("\n", "<br>").html_safe
#end

# def display_question_from_slug(slug)
#   Question.where("slug=?",slug).first.question
# end

end
