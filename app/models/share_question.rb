class ShareQuestion < ActiveRecord::Base
  belongs_to :user
  include CampaignProcess
  include ErpCampaign

  def self.find_user_email(user_id ,social_id ,provider,user_email)
    share_question = self.where("user_id =? AND social_id =? AND provider =? ", user_id,social_id, provider)
    share_question.each do |share|
      if share.email_address == user_email
        return true
      end
    end
  end

def self.shared_users_count(user,provider)
  user.share_questions.where('provider=?',provider).count
end

# create share question from api request
def self.api_share_question_create(params)
  self.create(:email_address => params[:email], :provider => params[:provider], :social_id => params[:social_id], :social_token => params[:social_token], :user_id => params[:user_id], :active => true, :user_name => params[:user_name], :user_profile_image => params[:profile_image])
end

def self.share_message(ph, msg)
  begin
   client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
   account = client.account
   account.sms.messages.create({:from => "#{ENV["SMS_NUM"]}", :to => "+#{ph}", :body => "#{msg}"})
  rescue => e
    TWILIO_LOGGER.info("Error(sms): #{e}")
  end
end

def self.share_via_call(params,question, user, content, filter,logic,sort)
  question.update_status_with_expired_at if question.status.include?("Inactive")
  params[:sso] ? call_campaign(params,user,question,content) : voice_campaign_process(params,question,user,content, filter,logic,sort)
end

def self.user_social_setting_info(user)
   share_info = {}
   share_details = where("user_id =? and provider in (?)",user.id,DEFAULTS["social_providers"])
   share_details.each_with_index do |share_detail,index|
    profile_image = share_detail.user_profile_image
    share_info["#{share_detail.provider}"] = {} if share_info["#{share_detail.provider}"].blank?
    share_info["#{share_detail.provider}"].merge!("#{share_detail.provider}_#{index}" => {"id"=> share_detail.id,"user_name"=>share_detail.user_name,"profile_image"=> (profile_image.present? ? profile_image : 'no_image.jpg'),"is_active" => share_detail.active})
   end
  return share_info
end

def self.voice_call(phone_number,question_id,content,is_demo_call)
  question = Question.where(id: question_id).first
  current_users = User.where(id:question.user_id).first
  from_number= current_users.from_number.blank?? ENV["CALL_NUM"] : current_users.from_number if current_users.parent_id.to_i == 0 || current_users.parent_id.blank?
  tenant = Tenant.where(id:current_users.tenant_id).first if current_users.parent_id.to_i != 0
  from_number = tenant.from_number.blank?? ENV["CALL_NUM"] : tenant.from_number if current_users.parent_id.to_i != 0
  account_sid = ""
  auth_token = ""
  begin
    @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    if("+#{from_number.to_s.gsub("+","")}" != ENV["CALL_NUM"].to_s)
    @client.accounts.list({:friendly_name => twillo_friendly_name(current_users)}).each do |account|
      account_sid = account.sid
      auth_token = account.auth_token
    end
    @client = Twilio::REST::Client.new account_sid, auth_token
    end
    @client.account.calls.create(:url => "#{Bitly_url["url"]}/share/call_handle.xml?question_id=#{question_id}&content=#{content}&is_demo=#{is_demo_call.to_s}",:to => "#{phone_number}",:from => from_number)
  rescue => e
    TWILIO_LOGGER.info("Error(voice): #{e}")
  end
end

def self.share_via_email(params,user,filter,logic,sort)
  question = Question.get_question(params["id"])
  question.update_status_with_expired_at if question.status.include?("Inactive")
  self.update_email_content(params,user)
  params[:sso] ? email_campaign(params,user,question) : email_campaign_process(params,user,filter,logic,sort,question)
end

def self.update_email_content(params,user)
  unless params[:is_html]
    params[:message] = params[:message].gsub('&nbsp;','').squish
    params[:message] = params[:message].gsub(/\n+/, '')
    user.update_attribute('email_content',params[:message])
  end
end

def self.share_via_sms(params,user,filter,logic,sort)
  user.sms_content = params[:message]
  user.save!(:validate => false)
  question = Question.get_question(params[:id])
  custom_url = question.custom_url("sms",nil,user.id)
  check_msg = params[:message].include?("<survey link>")
  params[:message] = check_msg == true  ? params[:message].gsub("<survey link>", " #{custom_url} ").strip : params[:message] +" "+ custom_url
  question.update_status_with_expired_at if question.status.include?("Inactive")
  if !params[:phone_number_sms].blank?
    params[:sso] ? sms_campaign(params,user) : sms_campaign_process(params,user,filter,logic,sort)
    response_message = true if question
  else
    response_message = false
  end
  self.status_code_and_response(response_message)
end

def self.status_code_and_response(msg)
  if msg
    response_message = "Message successfully shared through sms"
    status_code = 200
  else
    response_message = "No customer Details are uploaded"
    status_code = 400
  end
  return response_message, status_code
end

  def self.check_outgoing_caller_ids(from_number,current_user)
    begin
    account_sid = ""
    auth_token = ""
    @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    if("+#{from_number.to_s}" != ENV["CALL_NUM"].to_s)
    @client.accounts.list({:friendly_name => twillo_friendly_name(current_user)}).each do |account|
      account_sid = account.sid
      auth_token = account.auth_token
    end
    @client = Twilio::REST::Client.new account_sid, auth_token
    end
    caller_id = @client.account.outgoing_caller_ids.create({:phone_number => from_number,})
    return caller_id.validation_code
    rescue Exception => e
     return e.message
    end
  end

  def self.create_sub_account(current_user)
    @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    account = @client.accounts.create(:friendly_name => twillo_friendly_name(current_user))
    puts account.sid
  end

  def self.twillo_friendly_name(current_user)
    return "#{current_user.company_name}_#{current_user.parent_id.to_i == 0 || current_user.parent_id.blank? ? current_user.id : current_user.parent_id}".strip #if current_user.parent_id == 0 || current_user.parent_id.blank?
    #tenant = Tenant.where(id:current_users.tenant_id).first if current_user.parent_id != 0
    #return "#{tenant.company_name}_#{tenant.client_id}"  if current_user.parent_id != 0
  end

  def self.check_verified_caller_ids(current_user,params)
    begin
      account_sid = ""
      auth_token = ""
      phone_number_list = []
      @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
      if("+#{params[:from_number].to_s}" != ENV["CALL_NUM"].to_s)
      @client.accounts.list({:friendly_name => twillo_friendly_name(current_user)}).each do |account|
        account_sid = account.sid
        auth_token = account.auth_token
      end
      @client = Twilio::REST::Client.new account_sid, auth_token
      end
      callerId = @client.account.outgoing_caller_ids.list({  }).each do |callerId|
        phone_number_list << callerId.phone_number
      end
     if phone_number_list.include?("+#{params[:from_number]}")
       if(params[:tenant != "true"])
       user = User.find(current_user.id)
       user.from_number = params[:from_number]
       user.save(:validate => false)
       end
       return  APP_MSG["account"]["verification_success"]
     else
       return APP_MSG["account"]["verification_failed"]
     end
    rescue Exception => e
      puts e.message
    end
  end

  def self.update_sub_account_friendly_name(current_company,prev_company)
    begin
      account_sid = ""
      auth_token = ""
      @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
      @client.accounts.list({:friendly_name => prev_company}).each do |account|
        account_sid = account.sid
        auth_token = account.auth_token
      end
      @client.accounts.get(account_sid).update({:friendly_name => current_company,})
    rescue Exception => e
      puts e.message
    end
  end

  def self.mandrill_emails_report(current_user,params)
    begin
      mandrill = Mandrill::API.new "#{ENV["MANDRILL_API_KEY"]}"
      query = "sender:#{params[:email]}"
      #query = "sender:sada.shetti@gmail.com	OR full_email:sada.shetti@gmail.com"
      date_from = "#{params[:from_date].gsub("/","-")}"
      date_to = "#{params[:to_date].gsub("/","-")}"
      result = mandrill.messages.search query, date_from, date_to #, tags, senders, api_keys, limit
      if !result.blank?
      CSV.open("/tmp/report_#{current_user.id}.csv", "wb") do |csv|
        csv << ["Date/Time","From Email","To Email","Subject", "State","Open","Click"]
        result.each do |i|
          csv << [(i["ts"].blank? ? "" : Time.at(i["ts"]).strftime('%a, %d %b %Y %H:%M')),i["sender"],i["email"],i["subject"],i["state"],i["opens"],i["clicks"]]
        end
      end
    end
    InviteUser.delay.mandrill_email_report(current_user, !result.blank?)
    rescue Mandrill::Error => e
      MANDRILL_LOGGER.info("A mandrill error occurred(report): #{e.class} - #{e.message}")
    end
  end


  def self.twillo_report(current_user,params)
    @client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    account_sid = ""
    auth_token = ""
    array_record = []
    if(!current_user.from_number.blank?  && ("+#{current_user.from_number.to_s}" != ENV["CALL_NUM"].to_s))
    @client.accounts.list({:friendly_name => twillo_friendly_name(current_user)}).each do |account|
        account_sid = account.sid
        auth_token = account.auth_token
      end
      @client = Twilio::REST::Client.new account_sid, auth_token if !account_sid.blank?
    end
      @client.account.calls.list({:startTime => "#{params[:start_date].gsub("/","-")}", }).each do |call|
       array_record << {:to =>call.to,:from => call.from, :start_time => call.start_time,:end_time => call.end_time,:duration => call.duration,:status => call.status}
      end
    if !array_record.blank?
    CSV.open("/tmp/CallReport_#{current_user.id}.csv", "wb") do |csv|
      csv << ["FROM","TO","START TIME","END TIME","DURATION", "STATUS"]
      array_record.each do |i|
        csv << [i[:from],i[:to],i[:start_time],i[:end_time],i[:duration],i[:status]]
      end
    end
    InviteUser.delay.twillo_calls_report(current_user)
    else
      return "No data"
    end
  end
end