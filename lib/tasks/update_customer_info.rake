desc :Update_customer_info
task :process_response_log => [:environment]  do


  view_cron_log = CronLog.where("log_type=?","QuestionViewLog").first
  view_last_run_id = view_cron_log.last_run_id.nil? ? 0 : view_cron_log.last_run_id
  unprocessed_view_records = QuestionViewLog.where("is_processed =? and id <= ?",false,view_last_run_id)
  cron_log = CronLog.where("log_type=?","QuestionResponseLog").first
  last_run_id = cron_log.last_run_id.nil? ? 0 : cron_log.last_run_id
  unprocessed_records = QuestionResponseLog.where("is_processed =? and id <= ?",false,last_run_id)
  unless unprocessed_view_records.empty?
  unprocessed_view_records.each do |question_log|
    vrtype = "view"
    process_stats_update(question_log,vrtype)
  end
end


  unless unprocessed_records.empty?
  unprocessed_records.each do |question_log|
    vrtype = "response"
    process_stats_update(question_log,vrtype)
  end
end
end

private

def process_stats_update(question_log,vrtype)
  norm_date = (Date.parse(question_log.created_at.strftime("%d/%m/%Y")) - Date.parse("#{DEFAULTS['norm_date']}")).to_i + 1
  biz_customer_id = question_log.business_customer_info_id
  country,age,gender = get_user_info(biz_customer_id) if biz_customer_id.present?
  provider = question_log.provider
  incr_decr_count(question_log.question_id,vrtype,norm_date,provider,country,gender,age)
  question_log.update_attribute("is_processed",true)
 end

def get_user_info(biz_customer_id)
  customer = BusinessCustomerInfo.where(id: biz_customer_id).first
  gender = customer.gender.to_s.capitalize unless customer.gender.blank?
  country = customer.country.to_s.upcase unless customer.country.blank?
  age = customer.age.to_i unless customer.age.blank?
  return country,age,gender
end

def incr_decr_count(question_id,vrtype,norm_date,provider,country,gender,age)
  uk_response_log = CountsStore.find_counts_store(question_id,vrtype,nil, norm_date)
  decrement_count(uk_response_log,provider) if uk_response_log.present?
  response = CountsStore.find_for_increment(question_id,vrtype, country, norm_date)
  update_hstore(response,gender,age,country,provider)
end

def decrement_count(uk_log,provider)
uk_log =uk_log.first
 provider_map = {'embed'=>'embed', 'Email'=> 'mail','Twitter' => 'tw','Linkedin'=> 'lk','Sms' => 'sms','Call'=>'call',"QR"=> 'qr',"Facebook"=>"fb"}
 store_provider = provider_map["#{provider}"]
 old_count = uk_log[:counts_key]["#{store_provider}"].to_i
  if !(old_count.blank? && old_count.to_i <= 0)
  count = old_count - 1
  uk_log.update_attribute("#{store_provider}",count) unless (count.to_i < 0)
 end
end


def update_hstore(c,gender,age,country,provider)
	c.tkc = c.tkc.to_i + 1 unless country.blank?
    case age
      when 0..17
        gender == "Male" ? (c.am17 = c.am17.to_i + 1) : (c.af17 = c.af17.to_i + 1)
      when 18..25
        gender == "Male" ? (c.am25 = c.am25.to_i + 1) : (c.af25 = c.af25.to_i + 1)
    when 26..30
        gender == "Male" ? (c.am30 = c.am30.to_i + 1) : (c.af30 = c.af30.to_i + 1)
      when 31..35
        gender == "Male" ? (c.am35 = c.am35.to_i + 1) : (c.af35 = c.af35.to_i + 1)
      when 36..40
        gender == "Male" ? (c.am40 = c.am40.to_i + 1) : (c.af40 = c.af40.to_i + 1)
      when 41..45
        gender == "Male" ? (c.am45 = c.am45.to_i + 1) : (c.af45 = c.af45.to_i + 1)
      when 46..50
        gender == "Male" ? (c.am50 = c.am50.to_i + 1) : (c.af50 = c.af50.to_i + 1)
      else
        gender == "Male" ? (c.am00 = c.am00.to_i + 1) : (c.af00 = c.af00.to_i + 1) if age && age >= 51
    end

    case gender
      when 'Male'
        c.m = c.m.to_i + 1
    when 'Female'
        c.f = c.f.to_i + 1
    end

    case provider
      when 'Facebook'
        c.fb = c.fb.to_i + 1
    when 'Twitter'
        c.tw = c.tw.to_i + 1
      when 'Linkedin'
        c.lk = c.lk.to_i + 1
    when 'QR'
        c.qr = c.qr.to_i + 1
      when 'Email'
        c.mail = c.mail.to_i + 1
    when 'Call'
        c.call = c.call.to_i + 1
      when 'Sms'
        c.sms = c.sms.to_i + 1
    when 'embed'
        c.embed = c.embed.to_i + 1
    end

    c.save
 end