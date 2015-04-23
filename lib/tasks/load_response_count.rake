desc :load_response_count
task :increment_response_count => [:environment]  do

cron_log = CronLog.where("log_type=?","QuestionResponseLog").first
last_run_id = cron_log.last_run_id.nil? ? 0 : cron_log.last_run_id
log_records = QuestionResponseLog.where("id > ?",last_run_id).order('id')
unless log_records.empty?
log_records.each do |question_log|
vrtype = "response"
process_response(question_log,vrtype) #if question_log.is_processed?
@question_log_id = question_log.id
end
cron_log.update_attribute("last_run_id",@question_log_id)
end
end

private
def process_response(question_log,vrtype)
  #question = Question.find(question_log.question_id)
  norm_date = (Date.parse(question_log.created_at.strftime("%d/%m/%Y")) - Date.parse("#{DEFAULTS['norm_date']}")).to_i + 1
  biz_customer_id = question_log.business_customer_info_id
  if biz_customer_id.present?
    customer = BusinessCustomerInfo.where(id: biz_customer_id).first
    gender = customer.gender.to_s.capitalize unless customer.gender.blank?
    country = customer.country.to_s.upcase unless customer.country.blank?
    age = customer.age.to_i unless customer.age.blank?
 end
  if (!country.blank? && !question_log.is_processed?) || (question_log.is_processed?)

  provider = question_log.provider
  question_log.update_attribute("is_processed",true) unless(country.blank? && question_log.is_processed?)
  c = CountsStore.find_for_increment(question_log.question_id,  vrtype, country, norm_date)
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
end