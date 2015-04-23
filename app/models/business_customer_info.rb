class BusinessCustomerInfo < ActiveRecord::Base
  include KendoFilter
  include CsvImport
  include MandrillApi
  include CsvProcess
  include ValidateCsv

=begin
  attr_accessible :mobile,
    :customer_name,
    :email,
    :user_id,
    :response_status,
    :view_status,
    :gender,
    :question_id,
    :provider,
    :date_of_birth,
    :age,
    :country,
    :state,
    :city,
    :area,
    :cookie_token_id,
    :country_code,
    :state_code
=end
  attr_accessor :country_code, :state_code

 #user based validation check
  #validates :email, :presence => true
  validates :email, :uniqueness => {:scope => :user_id}
  #validates :mobile, :presence => true
  #validates :mobile, :uniqueness => {:scope => :user_id, :message => "This phone number already exist", :allow_blank => true}

  belongs_to :user
  has_many :answers, -> { where is_business_user: true }, :foreign_key => "customers_info_id"
  has_many :response_cookie_info, as: :response_token
	belongs_to :cookie_token
  after_create :update_share_detail
  before_save :email_downcase
  # Solr
  # searchable do
  #   string :mobile, :stored => true
  #   string :customer_name, :stored => true
  #   string :email, :stored => true
  #   string :gender, :stored => true
  #   integer :age, :stored => true
  #   integer :id, :stored => true
  #   integer :user_id, :stored => true
  # end
  # handle_asynchronously :solr_index, queue: 'indexing', priority: 50

  CUSTOMER_INFO = ["BusinessCustomerInfo"]


  # To check the if business user information is exist or not
  def self.check_user_already_exist(email,customer_name,user_id)
    user = where("customer_name=? and email =? and user_id=?",customer_name,email,user_id)
    user.blank? ? false : true
  end

  def self.find_business_customer_info(email,user_id,mobile=nil)
    if email.present? && !mobile.present?
      where("email=(?) and user_id=?",email.strip,user_id).first
    elsif !email.present? && mobile.present?
      where("mobile=(?) and user_id=?",mobile,user_id).first
    elsif email.present? && mobile.present?
      where("email=(?) and mobile=(?) and user_id=?",email.strip,mobile,user_id).first
    end
  end
  
	def self.create_survey_customers(customers)
		result = customers.is_a?(Array) ? self.insert_multiple_customers(customers) : self.insert_single_customers(customers)
	end
	
	def self.insert_multiple_customers(customers)
    result = []
    customers.each do |customer|
      business_customer = BusinessCustomerInfo.create(self.form_customer_infos(customer))
      result << (!business_customer.id.blank? ? {:customer => business_customer} : {:errors => business_customer.errors.messages })
    end
    result
	end
	
	def self.insert_single_customers(customer)
		business_customer = BusinessCustomerInfo.create(self.form_customer_infos(customer))
    !business_customer.id.blank? ? {:customer => business_customer} : {:errors => business_customer.errors.messages }
	end

  def self.form_customer_infos(customer)
    {mobile: customer["mobile"], customer_name: customer["customer_name"], email: customer["email"], gender: customer["gender"], age: customer["age"], user_id: customer["user_id"], country: customer["country"], state: customer["state"], city: customer["city"], area: customer["area"]}
  end
  
  def create_response_cookie_info(cookie_uuid,question_id)
    uuid_id = CookieToken.find_cookie_token_id(cookie_uuid)
    customer_cookie_info =  self.response_cookie_info.create(:cookie_token_id => uuid_id)
		return customer_cookie_info
  end

	def self.get_customer_info(id)
	  where("id=?",ActiveSupport::JSON.decode( Base64.decode64(id))).first unless id.blank?
  end

  # To generate the cookie token before create the records
	def change_cookie_token_id(id)
		self.update_attribute("cookie_token_id",id)
  end

  # CSV file data inserting in the database
  # Maximum limit per user to upload the record is 5000
  # If current user have reached maximun limit, user cannot able to upload record
  # After success/faliure to intimate to user through mail with attachment
  def self.insert_customer_info(file,user)
    csv_insert(file,user)
  end

  # TO export csv file
  def self.create_csv_to_export(error_hash_value, user)
    all_data = error_hash_value
    tmp_file_path = "/tmp/customer_info_#{ user.id }.csv"
    CSV.open(tmp_file_path, "wb") do |csv|
      csv << all_data.first.keys # adds the attributes name on the first line
      all_data.each do |hash|
        csv << hash.values
      end
    end
  end

  # def self.get_customer_list_and_count(params ,user)
  # end

  def self.build_business_customer_json(business_customers,client_id,biz_count,params)
    business_customer_infos = {}
    business_customer_infos["value"] = []
    business_customers.each do |info|
      json = {}
      json['email'] = info.email
      json['id'] = info.id
      json['customer_name'] = info.customer_name
      json['mobile'] = info.mobile
      json['area'] = info.area
      json['city'] = info.city
      json['age'] = info.age
      json['state'] = info.state
      country = info.country ? Country.find_country_by_alpha2(info.country) : ""
      country_alpha = country.present? ? country.alpha2 : ""
      json['country_code'] = {"code" => country_alpha, "name" => country.present? ? country.name : ""}
      json['country'] = info.country
      json['gender'] =info.gender
      json['custom_field'] = info.custom_field
      json['status'] = info.status
      business_customer_infos["value"] << json
    end
    business_customer_infos["odata.count"] = total_records_count(client_id,params[:share_type],params[:filter],params[:logic])
    return business_customer_infos
  end

  def self.insert_new_business_customer(user_data,user)
    user_data["mobile"] = self.add_country_code(user_data["mobile"],user_data["country"])
    customer = BusinessCustomerInfo.find_business_customer_info(user_data["email"],user.id) if user_data["email"]
    if customer.blank?
      customer = user.business_customer_infos.create(user_data)
      #cookie_token = CookieToken.create_new_record(SecureRandom.hex(10))
      #customer.cookie_token_id = cookie_token.id
      #customer.save
      #ResponseCookieInfo.create_new_record(customer.id,cookie_token.id) if customer
    else
      customer.assign_attributes(user_data.merge!({:is_deleted => nil, :id => customer.id, :city => user_data["city"], :area => user_data["area"], :custom_field => user_data["custom_field"] }))
      customer.save(:validate => false)
    end
    return customer
  end

  def self.add_country_code(mobile,country,is_csv = nil)
     c_code = is_csv  ? Country.find_country_by_name(country).country_code : Country.find_country_by_alpha2(country).country_code
     mobile_number = "#{c_code}#{mobile}"
     return mobile_number
  end

  def self.update_country_code(params,country,mobile_num)
    unless country.nil?
      existing_c_code = Country.find_country_by_alpha2(country).country_code
      m_number = (params["customer"]["mobile"] == mobile_num) ? mobile_num.remove(existing_c_code) : params["customer"]["mobile"]
    else
      m_number = params["customer"]["mobile"]
    end
    self.add_country_code(m_number,params["customer"]["country"])
  end

  def self.check_email_and_mobile_duplication(params,user)
    business_customer = BusinessCustomerInfo.where(id: params["id"], user_id: user.id, is_deleted: nil).first
    if params["mobile"]
      business_customer.update_attributes(:mobile=> params["mobile"],:user_id => user.id)
    elsif params["email"]
      business_customer.update_attributes(:email=> params["email"],:user_id => user.id)
    end
    return business_customer
  end

  def self.mobile_and_email_check_if_id_nil(params,user)
    if params["mobile"]
      business_customer = BusinessCustomerInfo.where("mobile =? and user_id = ? and is_deleted is NULL",params["mobile"].downcase, user.id).first
    elsif params["email"]
      business_customer = BusinessCustomerInfo.where("email =? and user_id = ? and is_deleted is NULL",params["email"], user.id).first
    end
    return business_customer
  end

 def self.collection_of_business_users(current_user_id)
    where(user_id: current_user_id)
 end

  def self.to_csv
    CSV.generate do |csv|
      column_names = ["customer_name", "email", "age", "gender", "mobile", "country", "state", "city", "area", "custom_field"]
      csv << column_names
      all.each do |customer|
        csv << customer.attributes.values_at(*column_names)
      end
    end
  end

  def self.email_reject_list
    email_reject_calls
  end

  def self.sub_account_create(user)
    create_mandrill_sub_account(user)
  end

  #def self.sub_account_list
  #  list_sub_account
  #end

  private
  def self.current_user_total_records(user)
    # Current user's csv file uploaded total records in business customer info table
    #user_count = BusinessCustomerInfo.where(:user_id => user.id).count
    #remaining_records = ClientSetting.get_column_value("customer_records_count",user) - user_count
    #return remaining_records
    if user.parent_id != 0 && user.parent_id != nil
      user_ids = User.where(parent_id: user.parent_id).map(&:id)
      user_count = where(user_id: user_ids, is_deleted: nil).count +  where(user_id: user.parent_id, is_deleted: nil).count
      user = User.where(id: user.parent_id).first
    elsif user.parent_id == 0 && user.parent_id != nil
      user_ids = User.where(parent_id: user.id).map(&:id)
      user_count = where(user_id: user_ids, is_deleted: nil).count + where(user_id: user.id, is_deleted: nil).count
    else
      user_count = where(user_id: user.id, is_deleted: nil).count
    end
      remaining_records = ClientSetting.where(user_id: (user.parent_id == 0 || user.parent_id == nil) ? user.id : user.parent_id).first.customer_records_count - user_count
    return remaining_records
  end

  def update_share_detail
     ShareDetail.update_share_count(self.user,1,'customer_records_count')
  end

  def email_downcase
    self.email.downcase! if self.email
    self.gender.downcase! if self.gender
  end

end