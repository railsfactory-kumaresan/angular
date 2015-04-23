class ResponseCookieInfo < ActiveRecord::Base
  #attr_protected
   #attr_accessible :cookie_token_id,:response_token_type,:response_token_id
  belongs_to :response_token, :polymorphic => true
  has_many :business_customer_infos, :primary_key => :response_token_id, :foreign_key => :id

  def self.find_user_info(id)
    self.find(id).response_token
  end

  def self.check_country_and_age(uuid)
   user =  CookieToken.find_cookie_customer_info(uuid)
   country = user && user.country ? user.country : nil
   age =user && user.age ? user.age : nil
   gender = user && user.gender ? user.gender : nil
   return country,age,gender
  end

  def self.find_user_age_gender(uuid)
    user =  CookieToken.find_cookie_customer_info(uuid)
    if user
	   return user.age,user.gender
    end
   end

 def self.create_new_record(customer_id,cookie_token_id)
   self.create(response_token_id: customer_id,response_token_type: "BusinessCustomerInfo",cookie_token_id: cookie_token_id)
 end
 end
