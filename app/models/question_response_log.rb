class QuestionResponseLog < ActiveRecord::Base

  belongs_to :cookie_token
  belongs_to :question
  belongs_to :business_customer_info
  validates :question_id, :uniqueness => {:scope => [:business_customer_info_id, :provider]}, unless: Proc.new { |b| b.business_customer_info_id.nil? }

  #~ def customer_info
    #~ customer_infos = CookieToken.find_customer_informations(cookie_token_id)
    #~ return customer_infos
  #~ end

  #~ def get_question
    #~ Question.find_category_type_id(question_id)
  #~ end

  # searchable do
  #   integer :question_id, :stored =>true, :multiple => true
  #   string :provider, :stored =>true
  #   string :cookie_token_id,:stored=>true
  #   string :user_id,:stored=>true
  #   time :created_at,:stored=>true
  #   string :customer_country, :stored =>true do
  #     customer_info.country rescue nil
  #   end
  #   integer :customer_age, :stored =>true do
  #     customer_info.age rescue nil
  #   end
  #   string :customer_name, :stored =>true do
  #     customer_info.customer_name rescue nil
  #   end
  #   string :customer_email, :stored =>true do
  #     customer_info.email rescue nil
  #   end
  #   string :customer_gender, :stored =>true do
  #     customer_info.gender rescue nil
  #   end
  #   string :customer_mobile, :stored =>true do
  #     customer_info.mobile rescue nil
  #   end
  #   integer :question_category_type_id, :stored => true do
  #     get_question.category_type_id rescue nil
  #   end

  # end
  # handle_asynchronously :solr_index!, queue: 'indexing', priority: 50

  def self.create_new_record(question,provider,cookie_token_id, biz_cus_id=nil)
    response_log = self.create(:question_id=>question.id,:provider=>provider,:user_id=>question.user_id,:cookie_token_id =>cookie_token_id, :business_customer_info_id => biz_cus_id)
    if response_log.valid?
     response_count = question.response_count + 1
     question.update_attribute("response_count",response_count)
     return response_log.id if response_log.business_customer_info_id.nil?
    end
  end

  def self.change_process_status(uuid,question_id, biz_cus_id)
    response_log = QuestionResponseLog.where(:cookie_token_id=>uuid,:question_id=>question_id)[0]
    response_log.update_attributes(is_processed: false, business_customer_info_id: biz_cus_id) if response_log
    view_log = QuestionViewLog.where(:cookie_token_id=>uuid,:question_id=>question_id)[0]
    view_log.update_attributes(is_processed: false, business_customer_info_id: biz_cus_id) if view_log
  end

  #def self.update_biz_details(cookie_id, question)
  #  res_log = where(cookie_token_id: cookie_id, question_id: question.id).first
  #  view_log = QuestionViewLog.where(cookie_token_id: cookie_id, question_id: question.id).first
  #  update_biz_customer_id(cookie_id,question.user_id, res_log)  if res_log.business_customer_info_id.nil?
  #  update_biz_customer_id(cookie_id,question.user_id, view_log)  if view_log.business_customer_info_id.nil?
  #end
  #
  #def self.update_biz_customer_id(cookie_id,user_id, klass)
  #  biz_user = BusinessCustomerInfo.where(cookie_token_id: cookie_id, user_id: user_id).first
  #  klass.update_attribute("business_customer_info_id", biz_user.id) if biz_user
  #end

  def self.update_biz_cus_id(res_id,cus_id)
    res_log = where(id: res_id).first
    if res_log
      res_log.business_customer_info_id =  cus_id
      res_log.is_processed = false
      res_log.save
      res_log.destroy unless res_log.errors.messages.blank?
      return res_log.errors.messages
    end
  end
end
