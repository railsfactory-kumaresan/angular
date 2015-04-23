module UserValidation
  extend ActiveSupport::Concern
  included do
    scope :find_user, lambda { |id| where('id=?', id) }
    scope :fetch_trial_expire_user, lambda { where('subscribe=? AND exp_date < ? AND is_active = ? ', false,Time.now.utc,true) }
    scope :fetch_subscribed_expire_user, lambda { where('subscribe=? AND exp_date < ? AND is_active = ? ', true,Time.now.utc,true) }
    scope :tenant_name, lambda { |t_id| Tenant.where(id: t_id).first.name }
    scope :role_name, lambda { |r_id| Role.where(id: r_id).first.name }
    scope :get_all_users, lambda { |user| user.parent_id == 0 ? where(parent_id: user.id) : where(parent_id: user.parent_id)}
    scope :plan_name, lambda { |user| user.business_type_id ? PricingPlan.where(id: user.business_type_id).first.plan_name : "" }

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :token_authenticatable, :omniauthable, :confirmable, :lockable #:validatable,


    #attr_protected
    #attr_accessible :attachments_attributes
    #relationships
    has_many :questions
    has_many :share_questions
    has_many :transaction_details
    has_many :business_customer_infos
    has_one :attachment, as: :attachable, dependent: :destroy
    has_one :listener
    has_one :client_setting
    has_one :pricing_plan
    has_one :share_detail
    has_many :share_summaries
    belongs_to :role
    has_one :tenant
    has_many :corporate_user, class_name: "User",foreign_key: "parent_id"
    has_many :executive_tenant_mappings

    has_one :billing_info_detail
    accepts_nested_attributes_for :attachment, :allow_destroy => true

    #validations
    validates_confirmation_of :password, :message => "Your passwords should match."

    validates :company_name, :presence => {:message => "Please enter company name."}, :format => {:with => /\A[A-Za-z0-9 .&_-]*\z/, :message => "Symbols are not allowed except this(- _)."}
    validates :company_name, :presence => {:message => "Please enter company name."}, :format => {:with => /[a-zA-Z]/, :message => "Company Name should have atleast one alphabet"}

    validates :company_name, :length => {:within => 2..50, :too_short => 'Company name should be min 2 and max 50 characters.', :too_long => 'Company name should be min 2 and max 50 characters.'}

    validates :first_name, :presence => {:message => " Please enter first name."}, :format => {:with => /[a-zA-Z]/, :message => "First Name should have atleast one alphabet"}
    validates :last_name, :presence => {:message => "Please enter last name."}, :format => {:with => /[a-zA-Z]/, :message => "Last Name should have atleast one alphabet"}
    validates_format_of :first_name,:with => /\A[A-Za-z0-9 .&]*\z/, :message => "First Name should not have special characters"
    validates_format_of :last_name, :with => /\A[A-Za-z0-9 .&]*\z/, :message => "Last Name should not have special characters"

    validates :email, :presence => {:message => "Please enter your email address."}
    validates :email, :uniqueness => {:message => "Email address already exists."}
    validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]{2,3}+\.){1,2}[A-Za-z]{2,4}\Z/, :message => "Please enter a valid email address.",:if => Proc.new { |at| at.step != "4"}

    validates :password, :presence => {:message => "Please enter Password"}, if: :validate_proc_method?

    #privious reg exp for password /^(?=.*\d)(?=.*([A-Z]))(?=.*([a-z]))([\x20-\x7E]){8,20}$/
    validates_format_of :password,:with => /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&+<>{})(=*_-`~:;]).{8,16}\z/, message: "Password length should be 8-16 characters and must contain at least 1 number, 1 small letter, 1 capital letter and 1 special character.", if: :validate_proc_method?
    validates :password_confirmation, :presence => {:message => "Please enter confirm password."}, if: :validate_proc_method?
    validates :current_password, :presence => {:message => "Please enter current password."}, :if => Proc.new { |at| at.step == "password_enabled" }

    validates :first_name, :length => {:within => 2..20, :too_short => 'First name should be min 2 and max 20 characters.", :too_long => "First name should be min 2 and max 20 characters.'}
    validates :last_name, :length => {:within => 2..20, :too_short => 'Last name should be min 2 and max 20 characters.", :too_long => "Last name should be min 2 and max 20 characters.'}
    validates :business_type_id, :presence => {:message => "Select a pricing plan."}#, :if => Proc.new { |at| at.step != "1" && at.step != "2" }
    #plan_ids = PricingPlan.get_all_plans.pluck(:id) if PricingPlan.table_exists?
   # validates_inclusion_of :business_type_id, :in => plan_ids,:message =>"Please select a valid plan", :if => Proc.new { |at| at.step != "1" && at.step != "2" } if plan_ids.present?
    validates :role_id, :presence => {:message => "Select a Role Name."}, :if => Proc.new { |at| at.step == "Multitenant"}
    validates :tenant_id, :presence => {:message => "Select a Tenant Name."}, :if => Proc.new { |at| at.step == "Multitenant"}
   # validates_format_of  :redirect_url, :with => /\A^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$\z/, message:"Please enter valid url."


        def self.user_status_result(pres,resource_params,current_user,params,resource)
      if pres
        result = resource.update_with_password(resource_params)
      elsif (!pres && params[:hidden_pass] == "password_enabled")
        result = resource.update_without_password(resource_params.merge(:step => "2"))
      elsif !['facebook', 'linkedin', 'twitter', 'google_oauth2'].include? current_user[:provider]
        result = resource.update_with_password(resource_params.merge(:step => "provider"))
      else
        result = resource.update_without_password(resource_params.merge(:step => "3"))
      end
      return result
    end

  end

  def validate_proc_method?
    # (!self.step.blank? && self.step.to_s != "2" && self.step != "4" && self.step !="3" || self.step == "password_enabled")
     return true if self.step.to_i == 5 || self.step.to_s == "provider" || self.step.blank?
     return false if self.step.to_i  == 2
    #Proc.new { |at| !at.step.blank? && at.step.to_s != "2" && at.step != "4" && at.step !="3" || at.step == "password_enabled" }
  end


end