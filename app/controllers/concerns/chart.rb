module Chart
  extend ActiveSupport::Concern
  included do

def get_chart_collection(vr_collection,obj)
@chart_view_type = get_chart_type(params,obj)
@chart_type,@xaxis_label  = get_chart_detail
@date_collection,@chart_date_collection,@chart_view_counts,@chart_response_counts = {},[],[],[]
vr_collection.each do |vr|
  date_type_based_collection(vr)
end
@date_collection.each_pair do |key,value|
  @chart_date_collection << key
  @chart_view_counts << value["view"]
  @chart_response_counts << value["response"]
end
end

def date_type_based_collection(vr)
  vr_date =   (Date.parse("#{DEFAULTS['norm_date']}")) - 1 + vr.norm_date
  if @chart_type == "day"
  @date_collection["#{vr_date}"] = {} if @date_collection["#{vr_date}"].nil?
  @date_collection["#{vr_date}"].merge!("response" => "0") if vr.vrtype != 'response' &&  @date_collection["#{vr_date}"]["response"].blank?
  @date_collection["#{vr_date}"].merge!("#{vr.vrtype}" => "#{vr.total_count}")
 else
  str_date = vr_date.strftime("%Y-%m-%d")
  vr_date = @chart_type == "month" ?  str_date.first(7) : str_date.first(4)
  @date_collection["#{vr_date}"] = {} if @date_collection["#{vr_date}"].nil?
  count =  @date_collection["#{vr_date}"]["#{vr.vrtype}"] ?  @date_collection["#{vr_date}"]["#{vr.vrtype}"].to_i : 0
  @date_collection["#{vr_date}"].merge!("#{vr.vrtype}" => "#{count + vr.total_count}")
 end
end

def calculate_num_of_days(from_date,to_date)
  (to_date.to_date - from_date.to_date).to_i
end

def get_chart_type(params,obj)
  @days = params && params[:from_date].present? ? calculate_num_of_days(params[:from_date],params[:to_date]) : calculate_num_of_days(obj.created_at,Date.today)
  chart_type = @days.abs <= 7 ? "bar_chart" : "line_chart"
end

def get_chart_detail
 case @days.abs
  when 0..31
  return 'day', "Views vs Responses by Day"
 when 32..365
  return 'month',"Views vs Responses by Month"
 when 366..(1.0/0.0)
  return 'year',"Views vs Responses by Year"
 end
end


end
end