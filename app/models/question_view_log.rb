class QuestionViewLog < ActiveRecord::Base

  belongs_to :cookie_token
  belongs_to :question
  belongs_to :business_customer_info
  has_many :response_cookie_infos, :primary_key => :cookie_token_id, :foreign_key => :cookie_token_id
  validates :question_id, :uniqueness => {:scope => [:business_customer_info_id, :provider]}, unless: Proc.new { |b| b.business_customer_info_id.nil? }

  #~ def get_user_info
    #~ customer_infos = CookieToken.find_customer_informations(cookie_token_id)
    #~ return customer_infos
  #~ end

  #~ def get_question
    #~ Question.find_category_type_id(question_id)
  #~ end

  # searchable do
  #    integer :question_id, :stored =>true, :multiple => true
  #   string :provider, :stored =>true
  #   string :cookie_token_id,:stored=>true
  #   string :user_id,:stored=>true
  #   time :created_at,:stored=>true

  #   string :customer_country, :stored =>true do
  #     get_user_info.country rescue nil
  #   end
  #   integer :customer_age, :stored =>true do
  #     get_user_info.age rescue nil
  #   end
  #   string :customer_name, :stored =>true do
  #     get_user_info.customer_name rescue nil
  #   end
  #   string :customer_email, :stored =>true do
  #     get_user_info.email rescue nil
  #   end
  #   string :customer_gender, :stored =>true do
  #     get_user_info.gender rescue nil
  #   end
  #   string :customer_mobile, :stored =>true do
  #     get_user_info.mobile rescue nil
  #   end
  #   integer :question_category_type_id, :stored => true do
  #     get_question.category_type_id rescue nil
  #   end

  # end
  # handle_asynchronously :solr_index!, queue: 'indexing', priority: 50

  def self.create_new_record(question,provider,biz_cus_id=nil)
    view_log = self.create(:question_id=>question.id,:provider=>provider,:user_id=>question.user_id,:business_customer_info_id => biz_cus_id)
    if view_log.valid?
     view_count = question.view_count + 1
     question.update_attribute("view_count",view_count)
     return view_log.id if view_log.business_customer_info_id.nil?
    end
  end

  def self.update_biz_cus_id(view_id, cus_id)
    view_log = where(id: view_id).first
    if view_log
      view_log.business_customer_info_id =  cus_id
      view_log.is_processed = false
      view_log.save
      view_log.destroy unless view_log.errors.messages.blank?
      return view_log.errors.messages
    end
  end
 #used for sample records
  # def self.create_new_record_for_sample(question_id,provider,user_id,cookie_token_id,created_at)
  #   view_log = self.create(:question_id=>question_id,:provider=>provider,:user_id=>user_id,:cookie_token_id =>cookie_token_id,:created_at=>created_at)
  # end

  # def self.get_viewed_customer_info(question_ids,current_user,params)

  # end

  # def self.index_question_view_log(uuid,question_id)
  #   views = QuestionViewLog.where(:cookie_token_id=>uuid,:question_id=>question_id)
  #   views.each do |view|
	 #   view.index!
  #   end
  # end

end
