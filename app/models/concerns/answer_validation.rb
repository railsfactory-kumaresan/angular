module AnswerValidation
  extend ActiveSupport::Concern
  included do
    belongs_to :question
    belongs_to :response_customer_info , -> { where is_business_user: false }, :foreign_key => "customers_info_id"
    belongs_to :business_customer_info, -> { where is_business_user: true }, :foreign_key => "customers_info_id"
    before_create :answer_datetime_split
    #validates :question_id, :uniqueness => {:scope => [:customers_info_id, :provider]}
#Sunspot search to define attributes
    # searchable(:includes => [:response_customer_info, :business_customer_info]) do
    #   integer :id, :stored => true
    #   time :created_at, :stored =>true
    #   string :option, :stored =>true
    #   integer :question_id, :stored =>true, :multiple => true
    #   integer :customers_info_id, :stored =>true
    #   integer :question_type_id, :stored =>true
    #   string :provider, :stored =>true
    #   text :comments, :stored =>true
    #   integer :question_option_id, :stored =>true
    #   boolean :is_business_user, :stored =>true
    #   boolean :is_deactivated, :stored =>true
    #   string :comments,:stored => true
    #   string :free_text, :stored => true
    #   string :uuid,:stored=>true

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

    #   string :question_owner_id, :stored => true do
    #     question_owner.user_id rescue nil
    #   end

    #   integer :question_category_type_id, :stored => true do
    #     question_owner.category_type_id rescue nil
    #   end

    #   string :current_user_question, :stored => true do
    #     question_owner.question
    #   end

    #   time :question_created_at, :stored => true do
    #     question_owner.created_at
    #   end

    #   string :attachment, :stored => true do
    #     question_attachment.image rescue nil
    #   end
    # end

    # handle_asynchronously :solr_index!, queue: 'indexing', priority: 50

    #~ def  customer_info
      #~ return ResponseCustomerInfo.find(customers_info_id) unless is_business_user
      #~ BusinessCustomerInfo.find(customers_info_id) if is_business_user
    #~ end

    #~ def question_owner
      #~ return Question.find_question_owner(question_id) if question_id
      #~ return Question.find_by_question_id(question_id) if category_type_id
    #~ end

    #~ def question_attachment
      #~ return Question.find(question_id).attachment if question_id
    #~ end

    #After create callback for answer_datetime_split
    def answer_datetime_split
      self.date =  Time.now.day
      self.month = Time.now.month
      self.year =  Time.now.year
      self.hour =  Time.now.hour
    end

  end
end