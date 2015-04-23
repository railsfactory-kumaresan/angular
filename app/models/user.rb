class User < ActiveRecord::Base
  attr_accessor :step, :password_enabled, :current_password
    include UserValidation
    include UserMultitenant
    include SocialService
    include UserPrivilege
  before_create :assign_role
  before_update :update_role
  scope :share_detail, lambda { |user| ShareDetail.where('user_id = ?', user.id) }

  #Method for Facebook auth
  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where("uid =?", auth.uid).first
    unless user
      key = SecureRandom.hex(13)
      confirmed_at = Time.now
      user = User.new(fb_params_hash(auth,key,confirmed_at))
      user.save(:validate => false)
      user.ensure_authentication_token!
    end
    user
  end

  #Method for Twitter auth
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where("twitter_oauth_token=?", auth['credentials']['token']).first
    unless user
      user = User.new(twitter_params_hash(auth))
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  def self.user_status(pres,resource_params,current_user,params,resource)
    result =  user_status_result(pres,resource_params,current_user,params,resource)
    return result
  end

  #Method for google auth
  def self.find_for_google_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(email: "#{data["email"]}").first
    user = User.where(email: "#{data["email"]}_#{data["email"]}").first if user.blank?
    unless user
      user = User.new(email:"#{data["email"]}_#{data["email"]}", password: Devise.friendly_token[0, 20],
                      authentication_token: Devise.friendly_token, first_name: data["first_name"],
                      last_name: data["last_name"], provider: access_token.provider, business_type_id: "1",
                      confirmed_at: Time.now, is_active: true, exp_date: Time.now + 14.days,subscribe: false)
      user.save(:validate => false)
    end
    user
  end

  #Method for linkedin auth
  def self.find_for_linkedin_oauth(access_token, signed_in_resource=nil)
    user = User.where("linkedin_token=?", access_token["credentials"]["token"]).first
    unless user
      key = SecureRandom.hex(13)
      user = User.new(linkedin_params_hash(access_token,key))
      user.skip_confirmation!
      user.save(:validate => false)
    end
    user
  end

  def share_my_question(question_url,params=nil)
    @question = Question.where(slug: question_url).last
    @attachment=(@question.attachment.blank?? self.attachment : @question.attachment) if @question
    face_book_shares(@question,@attachment,params)
    twitter_shares(@question,@attachment,params)
    linked_in_shares(@question,@attachment,params)
    return @fb_failure_user, @twitter_failure_user, @linkedin_failure_user, @fb_acc_count, @twitter_acc_count, @linkedin_acc_count
  end

  def face_book_shares(ques,attach,params)
    facebook_credentials = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "facebook").joins(:user).where('users.id = ? and fb_status = ?', self.id, "true")
    @fb_acc_count = facebook_credentials.count
    share_my_question_fb(@fb_acc_count,ques,facebook_credentials,attach,self,params)
  end

  def facebook_distr_share(params)
    facebook_credentials = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "facebook").joins(:user).where('users.id = ? and fb_status = ?', self.id, "true")
    msg =""
    if facebook_credentials.count > 0
      @fb_failure_user = []
      facebook_credentials.each do |credential|
        page = FbGraph::User.me(credential.social_token)
        begin
          # Create Album and post the image
          album_id = ""
          all_albums = page.albums
          all_albums.each do |album|
            album_id =   album.identifier if album.raw_attributes[:name] == "Inquirly-Distribute"
          end
          unless params[:url].blank?
           if album_id == ""
             page.album!(:name => "Inquirly-Distribute")
             page.albums.first.photo!(
              :access_token => credential.social_token,
              :url => "#{params[:url]}",
              :message => params[:message]
             )
          else
             album = FbGraph::Album.fetch(album_id, :access_token => credential.social_token)
             album.photo!(
                :access_token => credential.social_token,
                :url => "#{params[:url]}",
                :message => params[:message]
             )
          end
          else
            page.feed!(:message => params[:message])
          end
          msg = {:status => "success", :msg => "Successfully shared."}
        rescue => e
          msg = {:status => "error", :msg => "Ihis not authorized application" }
          #@fb_failure_user = User.social_error_messages(e,msg,credential.social_id)
        end
      end
    end
    return msg
  end

  def twitter_shares(ques,attach,params)
    twitter_credentials = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "twitter").joins(:user).where('users.id = ? and twitter_status = ?', self.id, "true")
    @twitter_acc_count = twitter_credentials.count
    share_my_question_tw(@twitter_acc_count,ques,twitter_credentials,attach,params)
  end

  def linked_in_shares(ques,attach,params)
    linkedin_credentials = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "linkedin").joins(:user).where('users.id = ? and linkedin_status = ?', self.id, "true")
    @linkedin_acc_count = linkedin_credentials.count
    share_my_question_lin(@linkedin_acc_count,ques,linkedin_credentials,attach,params)
  end
  def self.social_error_messages(e,msg,s_id)
    logger.info "Error: #{ e.message }"
    @failure_user = []
    if msg.include?("#{e.message}") || msg.find { |e| /The user has not authorized application/ =~ e } != nil
      user = ShareQuestion.find_by_social_id(s_id)
       @failure_user << user.email_address
       user.destroy
       return @failure_user
    end
  end

  def self.question_expiry
    monthly_questions=Question.joins(:user).where('questions.expiration_id = ? and users.id = questions.user_id and questions.status = ?', "1 Month","Active")
    yearly_questions=Question.joins(:user).where('questions.expiration_id = ? and users.id= questions.user_id and questions.status = ?', "1 Year","Active")
    return monthly_questions, yearly_questions
  end

def social_setting_info
  status = {}
  status[:fb]= self.fb_status
  status[:twitter] = self.twitter_status
  status[:linkedin] = self.linkedin_status
  return status
end

def dashboard_details
  return self.transaction_detail,self.active_questions
end

# def get_location_wise_count(params)
#   countries = Answer.collection_of_countries(self.id, status = "dashboard",params)
#   responses = Answer.collection_of_responses(self,nil,params).uniq
#   return countries,responses
# end

# def get_response_words(params,user)
#   a,option_ids = Answer.collection_of_responses_wordcloud(user,params)
#   responses = Hash[a.uniq.map{ |i| [i, a.count(i)] }]
#   return responses,option_ids.uniq
# end

  #current user transaction details
  def transaction_detail
    self.transaction_details.last
  end

#current user's questions
def user_question
  self.questions
end


def active_questions
  # Active Questions for Multitenant
  #self.questions.where('questions.status <> ?', "Inactive")
  tenant_ids = ExecutiveTenantMapping.get_tenant_ids(self.id)
  t_ids = Tenant.where(id: tenant_ids, is_active: true).map(&:id)
  questions = Question.where("tenant_id IN (?) AND status <> ?", t_ids,"Inactive") + Question.where("user_id IN (?) AND status <> ?", self.id,"Inactive")
  return questions.uniq
end

#user share question customs url and user info list
def question_share_url_userlist(question_id)
  question = Question.get_question(question_id)
  custom_url = question.short_url
  common_url = question.custom_url("qr",nil,question.user_id)
  user_info_lists = self.business_customer_infos.where("email != ''") if self.business_customer_infos
  voice_msg = Question.play_demo(question_id)
  return question, custom_url, common_url, user_info_lists, voice_msg
end

def social_nw_share_question
  fb_acc = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "facebook").joins(:user).where('users.id = ? and fb_status = ?', self.id, "true")
  linkedin_acc = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "linkedin").joins(:user).where('users.id = ? and linkedin_status = ?', self.id, "true")
  twitter_acc = ShareQuestion.where('share_questions.provider = ? and share_questions.active is true', "twitter").joins(:user).where('users.id = ? and twitter_status = ?', self.id, "true")
  return fb_acc, linkedin_acc, twitter_acc
end

def check_subscribe_user?(user)
  user.present? && user.subscribe == false && user.parent_id.blank? && user.is_active == true
end

def update_qr_status
  qr_questions=Question.update_all(:qrcode_status => "")
  return qr_questions
end

def self.check_user_auth_confirmed(authentication_token)
  User.where("authentication_token=? and confirmed_at is not null",authentication_token).first if !authentication_token.blank?
end

def self.save_default_content(user,content)
  user.call_content = content
  user.save(:validate => false)
  return user.call_content
end

 def get_mail_date
   if self.email != "admin@inquirly.com"
     mail_day = self.exp_date - 7.day
     return self.exp_date,mail_day
   end
 end

 def self.social_network_status_change(user,provider,status)
   usr = User.find_user(user.id)[0]
   stattus = (status == "on") ? "true" : "false"
   case provider
     when "fb"
       usr.fb_status = stattus
     when "twitter"
       usr.twitter_status = stattus
     when "linkedin"
       usr.linkedin_status = stattus
   end
   usr.save(:validate => false)
 end

  def self.hash_result_for_social_login(u_res)
    hash_res = {:auth_token => u_res.authentication_token, :email => u_res.email,
                :first_name => u_res.first_name, :last_name => u_res.last_name, :business_role => u_res.business_type_id,
                :role =>u_res.role, :company_name => u_res.company_name}
  end

def assign_role
  #TODO[User sing-up form by default have parent_id and role_id is nil]. Changed for multitenant
  plan = PricingPlan.find_pricing_plan(self.business_type_id).first
  individual_role_id = Role.where(name: DEFAULTS['signup_role_individual']).first.id
  if self.role_id.nil? && self.parent_id.nil?
      self.role_id = plan.blank? ?  nil : (plan.plan_name.include?("#{DEFAULTS['signup_plan_individual']}") || plan.tenant_count <= 0) ? individual_role_id : Role.where(name: DEFAULTS['signup_role_other']).first.id
      self.parent_id = plan.blank? ? nil : (plan.plan_name.include?("#{DEFAULTS['signup_plan_individual']}") || plan.tenant_count <= 0) ? nil : 0
  end
end

def update_role
  assign_role if self.role_id.nil? && self.parent_id.nil? && self.provider == "facebook" || self.provider == "twitter" || self.provider == "google_oauth2"
end

# User Subscription update. changing for one plan to another plan.
# Counters all reset.
  def account_subscribe(business_type_id, exp_date=nil)
    pricing_plan = PricingPlan.find_by_id(business_type_id)
    self.update_columns(:subscribe => true,:business_type_id => business_type_id, :exp_date => exp_date.present? ? exp_date : Time.now + 1.year, :parent_id => (pricing_plan.tenant_count > 0 ? 0 : nil), :is_active => true,:role_id => pricing_plan.tenant_count <= 0 ? Role.where(name: DEFAULTS['signup_role_individual']).first.id : Role.where(name: DEFAULTS['signup_role_other']).first.id)
    #Plan Upgrade, update the all multitenant users.
    self.fetch_tenant_users.update_all(:subscribe => true,:business_type_id => business_type_id, :exp_date => exp_date.present? ? exp_date : Time.now + 1.year, :is_active => true)
    self.client_setting.update_attributes(:pricing_plan_id => pricing_plan.id, :tenant_count => pricing_plan.tenant_count,:customer_records_count => pricing_plan.customer_records_count, :language_count => pricing_plan.language_count,:business_type_id => pricing_plan.id)
  self.share_detail ?  self.share_detail.update_attributes(:customer_records_count => 0, :questions_count => 0, :video_photo_count => 0, :sms_count => 0, :call_count => 0, :email_count => 0) : ''
  self.client_setting && self.client_setting.client_languages ? self.client_setting.client_languages.delete_all : ''
  end

  def account_cancel(business_type_id)
    pricing_plan = PricingPlan.find_by_id(business_type_id)
    self.update_columns(:business_type_id => business_type_id, :exp_date => Time.now + 14.days, :parent_id => (pricing_plan.tenant_count > 0 ? 0 : nil) ,:is_active => true)
    #Plan Upgrade, update the all multitenant users.
    self.client_setting.update_attributes(:pricing_plan_id => pricing_plan.id, :tenant_count => pricing_plan.tenant_count,:customer_records_count => pricing_plan.customer_records_count, :language_count => pricing_plan.language_count,:business_type_id => pricing_plan.id)
  end

#this mehtod will return the current user, present status, if user in trail period or subscribed the plan,
  def is_trail_in_period?
    (!self.parent_id || self.parent_id == 0 ) && (self.subscribe == false && self.is_active == true) && is_valid_email(self.email) ? true : false
  end

  def is_valid_email(email)
    reg = /\A[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]{2,3}+\.){1,2}[A-Za-z]{2,4}\Z/
    return (reg.match(email))? true : false
  end

  def self.change_role(current_user)
    role = current_user
    role.role_id = Role.find_by_name("Individual").id
    role.save(:validate=> false)
  end

  def self.users_list(email)
    where("email LIKE ? AND email NOT IN (?) AND (parent_id is NULL OR parent_id =(?))", "%#{email}%",DEFAULTS["internal_emails"], 0).map(&:email)
  end

  def update_csv_process(status)
    update_columns(:is_csv_processed => status)
  end
end
