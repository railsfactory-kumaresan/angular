class ResponseCustomerInfo < ActiveRecord::Base
  #attr_protected
  #attr_accessible :mobile, :customer_name,   :email,  :response_status,    :view_status,    :gender,    :question_id,    :provider,    :date_of_birth,    :age,    :country,    :state,      :city,   :area
  has_many :answers, -> { where is_business_user: false }, :foreign_key => "customers_info_id"
  has_many :response_cookie_info, :as => :response_token

  # searchable do
  #   string :mobile, :customer_name, :email, :gender, :stored => true
  #   integer :age, :stored => true
  # end
  # handle_asynchronously :solr_index, queue: 'indexing', priority: 50
  before_save :email_downcase

  def create_response_user_info(params, cookie_uuid,question_id)
    #update_age = ResponseCustomerInfo.where("id = #{self.id}").select("age(date_of_birth) as new_age")
    uuid_id = CookieToken.find_cookie_token_id(cookie_uuid)
    self.response_cookie_info.create(:cookie_token_id => uuid_id)
    self.cookie_token_id = uuid_id
    self.save
    Answer.update_customer_info(self.id,uuid_id,false,question_id)
  end

  def create_response_cookie_info(cookie_uuid,question_id)
    uuid_id = CookieToken.find_cookie_token_id(cookie_uuid)
    customer_cookie_info = self.response_cookie_info.create(:cookie_token_id => uuid_id)
		return customer_cookie_info
  end

  def self.find_response_customer_info(email)
    where("email ILIKE (?)","%#{email.strip}%").first
  end

	def change_cookie_token_id(id)
		self.update_attribute("cookie_token_id",id)
  end

  def self.create_customer(params,mob,cookie_token_id,user_id=nil)
    name,gen,cou,dob,email = params[:name],params[:gender],params[:country],params[:date_of_birth],params[:email]
    age,stat,city,area = params[:age],params[:states],params[:text_city],params[:area]
    BusinessCustomerInfo.create(customer_name: name, mobile: mob,gender: gen, country: cou, date_of_birth: dob,
                                email: email, age: age, state: stat,city: city, area: area,cookie_token_id: cookie_token_id, user_id: user_id)
  end


 #~ def self.get_reponsed_customers(word,question_id)
   #~ customers = self.find_by_sql("select * from answer_option_details where question_id = #{question_id} and option = '#{word}' and name is not null")
 #~ end

 #~ def self.get_customers_list(question_ids,params)
  #~ type = params[:view_info] == "true" ? 'viewed_norm_date' : 'responded_norm_date'
  #~ qry = CountsStore.get_conditions(question_ids,params,type)
  #~ customers = self.find_by_sql("select * from customer_details where #{qry} and country = '#{params[:location]}'").uniq(&:customer_id)
 #~ end

 def email_downcase
   self.email.downcase! if self.email
 end
end

