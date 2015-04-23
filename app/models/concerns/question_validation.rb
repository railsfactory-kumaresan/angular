module QuestionValidation
  extend ActiveSupport::Concern
  included do
    scope :fetch_question, lambda { |id| where('slug=?', id) }
    #scope :fetch_users_question, lambda { |id| where('user_id=?', id) unless id.nil? }


    attr_accessor :step, :upload_video_url
    #attr_protected

    #relationship
    belongs_to :user
    delegate :company_name, :to => :user, :prefix => true
    has_one :attachment, :as => :attachable, :dependent => :destroy
    has_one :question_style
    has_many :answers, -> { where is_deactivated: false }, :dependent => :destroy
    has_many :question_view_counts, :dependent => :destroy
    has_many :question_view_logs, :dependent => :destroy
    has_many :question_response_logs, :dependent => :destroy
    has_many :email_activities, :dependent => :destroy
    belongs_to :category_type
    delegate :category_name, :to => :category_type, :prefix => true
    has_many :question_options, -> { where is_deactivated: false }, :dependent => :destroy
    has_many :answer_analyses
    has_many :answer_options
    belongs_to :tenant
    validates :question, :presence => {:with => true, :message => "Please enter the question."}
    #validates :expiration_id, :presence => {:with => true, :message => "Please enter the Expiration"}
    #validates :question_type_id, :presence => {:with => true, :message => "Please enter the question type"}
    #validates :category_type_id, :presence => {:with => true, :message => "Please enter the category type"}

    EXPIRATION=[["1 Day"], ["1 Week"], ["1 Month"], ["1 Year"]]
    ANSWER=[["Single Answer"], ["Multiple Answer"], ["Yes/no"], ["Comments"]]

    # searchable do
    #   integer :id,:stored => true
    #   string :question,:stored => true
    #   integer :category_type_id,:stored => true
    #   integer :question_type_id,:stored => true
    #   string :expiration_id,:stored => true
    #   boolean :include_other,:stored => true
    #   boolean :include_text,:stored => true
    #   boolean :include_comment,:stored => true
    #   string :qrcode_status,:stored => true
    #   string :embed_url, :stored => true
    #   string :video_url, :stored => true
    #   integer :user_id,:stored => true
    #   time :created_at,:stored => true
    #   string :status,:stored => true
    #   integer :video_type,:stored => true
    #   time :updated_at,:stored => true
    # end
  end
end