module DashboardHelper
  def get_view_percentage(total_response, total_view)
    if total_response.present? && total_view.present? && total_response != 0 && total_view != 0
      total_percentage = ((total_response.to_f / total_view.to_f) * 100)
    else
      total_percentage = 0
    end
    return total_percentage.round
  end

  def male_female_percentage(view,response,gender)
  if gender == "male"
     if view["male"].to_i != 0 || response["male"].to_i != 0
      male_count =  view["male"].to_i + response["male"].to_i
      female_count = view["female"].to_i + response["female"].to_i
      #male_per = (male_count.to_f/(female_count+male_count).to_f*100)
     else
       male_count = 0
     end
     return male_count
   end
  if gender == "female"
     if view["female"].to_i != 0 || response["female"].to_i != 0
      male_count =  view["male"].to_i + response["male"].to_i
      female_count = view["female"].to_i + response["female"].to_i
      #female_per = (female_count.to_f/(female_count+male_count).to_f*100)
     else
       female_count = 0
     end
     return female_count
  end
  end

  # def get_location_based_view_count(country,user_id,params,status)
	 #  count = RedisCount::GetViewCount.new(nil,nil,user_id,nil,nil,country,params[:category],params[:from_date],params[:to_date],status).get_total_view_count_country
  #   count = count ? count : 0
  # end
  # def find_location_view_count(country,question_id,user_id,category_type_id,from_date,to_date)
	 #  count = RedisCount::GetViewCount.new(question_id,nil,user_id,nil,nil,country,category_type_id,from_date,to_date).get_view_count_country
  #   count = count ? count : 0
  # end

  # def get_location_view_count_percentage(view_count,response_count)
  #   view_count= view_count ? view_count.to_i : 0
  #   response_count= response_count ? response_count.to_i : 0
  #   percentage = view_count/(view_count+response_count)*100
  #   return sprintf "%.2f", percentage
  # end

 #~ def get_location_based_response_count(country,question_id,user_id,params,status)
   #~ Answer.get_country_based_res_count(country,question_id,user_id,params,status)
 #~ end

 # def gender_percentage(male_count,female_count,gender,total_female_view,total_female_response,total_male_view,total_male_response)
 #    total = total_female_view + total_female_response + total_male_view + total_male_response
 #    if male_count.to_f == total || female_count.to_f == total
 #      total = total + 1
 #   end
 #    percentage = ((male_count.to_f)/(total) * 100) if gender == "Male" && total !=0
 #    percentage = ((female_count.to_f)/(total) * 100) if gender == "Female" && total !=0
 #    total == 0 ? 0 : percentage
 # end

  def fetch_slug(question_id)
    question=Question.find(question_id)
    return question.slug if question
  end
  # def demographics_calculation(age_wise_view_count,age_wise_response_count)
  #   demo_graphics = {}
  #   age = ["age0_17","age18_25","age26_30","age31_35","age36_40","age40_45","age46_50","age51-100"]
  #   total_male_view_count  = 0
  #   total_male_response_count = 0
  #   total_female_count  = 0
  #   total_female_view_count =0
  #   total_female_response_count =0
  #   male_count_view = []
  #   female_count_view = []
  #   male_count_response = []
  #   female_count_response = []
  #   age.each_with_index do |x,i|
  #     view = age_wise_view_count[i]
  #     response = age_wise_response_count[i]
  #     male_count_view[i] = view['male'].to_i
  #     male_count_response[i] = response['male'].to_i
  #     female_count_view[i] = view['female'].to_i
  #     female_count_response[i] = response['female'].to_i
  #     total_male_view_count = total_male_view_count + view['male'].to_i
  #     total_male_response_count = total_male_response_count + response['male'].to_i
  #     total_female_view_count = total_female_view_count + view['female'].to_i
  #     total_female_response_count = total_female_response_count + response['female'].to_i
  #   end
  #   demo_graphics = {"male_count_view"=> male_count_view, "male_count_response" => male_count_response,"female_count_response" => female_count_response,"female_count_view" => female_count_view,"total_male_view_count" => total_male_view_count,"total_male_response_count" => total_male_response_count,"total_female_view_count" => total_female_view_count, "total_female_response_count" => total_female_response_count,"age" => age}
  #   return demo_graphics
  # end
  def previous_count(count)
      count_pre = count - 1
      if((count_pre % 3) == 0)
        prev_count = (count_pre - (count_pre % 3)) - 5
      else
        prev_count = (count_pre - (count_pre % 3)) - 2
      end
      return prev_count
  end

  def get_plan_category_types(user)
     plan = PricingPlan.where(business_type_id: user.business_type_id).first
     return plan.category_types.map(&:category_name).first if plan
  end

end

