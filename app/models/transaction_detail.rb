class TransactionDetail < ActiveRecord::Base

  #attr_accessible :amount, :business_type_id, :profile_id, :transaction_id, :user_id, :expiry_date, :order_id, :active, :action, :payment_status, :zaakpay_response, :response_dec, :response_code
 # belongs_to :user

  # block commented because code is unused
   # def self.call_post_to_zaakpay(params, current_user, random_token)
  	#   TransactionDetail.create(:user_id => current_user.id, :business_type_id => current_user.business_type_id, :order_id => random_token, :payment_status => "incomplete")
   #    params[:bus_type] == "ind" ? amount = 1000 : amount= 2000
   #    pay=Hash.new
   #    pay["merchantIdentifier"] =  "#{ENV["MERCHANT_IDENTIFIER"]}"
   #    pay["orderId"] = random_token
   #    pay["buyerFirstName"] = current_user.first_name
   #    pay["buyerLastName"] = current_user.last_name
   #    pay["txnType"] = "1"
   #    pay["zpPayOption"] = "1"
   #    pay["mode"] = 0
   #    pay["currency"] = "INR"
   #    pay["amount"]= amount
   #    pay["merchantIpAddress"]= current_user.current_sign_in_ip
   #    pay["purpose"]= "1"
   #    pay["productDescription"] = "test product"
   #    pay["txnDate"]= Date.today
   #    pay.update({"buyerEmail" => params[:buyerEmail],
   #      "buyerAddress" => params[:buyerAddress],
   #      "buyerCity" => params[:buyerCity], "buyerState" => params[:buyerState],
   #      "buyerCountry" => params[:buyerCountry],
   #      "buyerPincode" => params[:buyerPincode],
   #      "buyerPhoneNumber" => params[:buyerPhoneNumber]})
   #    return pay
   # end


=begin
  # commented out because I am quiet suspicious about its working
  # Can a model have falsh[:notice] in it ?
  # can a model have redirect_to in it ?
   def call_z_response
   	  flash[:notice] = "The transaction was completed successfully."
      InviteUser.payment_success(current_user.email).deliver
      exp_date = Time.now + 1.month
      @zaakpay_post['amount'] == '2000' ? modified_bussiness_type = 2 : modified_bussiness_type = 1
      user_detail = User.find_by_id(current_user.id)
      if modified_bussiness_type == user_detail.business_type_id
        @action ="Renewed"
      elsif modified_bussiness_type == 2
        @action ="Upgraded"
      elsif modified_bussiness_type == 1
        @action = "Downgraded"
      end
      user_detail.subscribe = true
      user_detail.business_type_id = modified_bussiness_type
      user_detail.exp_date = exp_date
      user_detail.is_active = true
      user_detail.save(:validate => false)
      transactiondetail.update_attributes(:user_id => current_user.id, :amount => @zaakpay_post["amount"], :business_type_id => modified_bussiness_type, :transaction_id => @zaakpay_post["checksum"], :order_id => @zaakpay_post["orderId"], :expiry_date => exp_date, :active => 1, :action => @action, :payment_status => "completed", :response_code => @zaakpay_post['responseCode'], :response_dec => @zaakpay_post['responseDescription'], :zaakpay_response => @zaakpay_post)
      #TransactionDetail.create
      flash[:notice] = "Thanks.Payment successfully completed"
      redirect_to "/"
   end
=end

# decrypt the data and build hash
 def self.crypto_key_split(encResponse)
   workingKey = ENV["CCAVENUE_WOKING_KEY"]
   crypto = Crypto.new 
   decResp=crypto.decrypt(encResponse,workingKey)
   decResponse = decResp.split("&")
   build_hash = {}
    decResponse.each do |key|
     build_hash[key.from(0).to(key.index("=")-1)] = key.from(key.index("=")+1).to(-1)
    end
   transactiondetail = self.find_transaction(build_hash["order_id"])
   return build_hash, transactiondetail
 end

#find transaction by order ID
def self.find_transaction(order_id)
  self.where("order_id = ? AND payment_status =?",order_id, "Incomplete").first
end

# Create TransactionDetail
def self.create_transaction(current_user,params)
   self.create(:user_id => current_user.id, :business_type_id => current_user.business_type_id, :order_id => params["order_id"], :payment_status => "Incomplete",:request_plan_id => params["plan_id"],:action => params["plan_action"],:amount=>params["amount"])
end

#update ccavenue details
def update_transaction_details(plan_id,decrypt_response,exp_date = nil)
 self.update_attributes(:business_type_id => plan_id, :amount => decrypt_response["amount"].to_f , :payment_status =>decrypt_response["order_status"] , :tracking_id => decrypt_response["tracking_id"].to_i, :bank_ref_no => decrypt_response["bank_ref_no"], :failure_message => decrypt_response["failure_message"], :payment_mode => decrypt_response["payment_mode"], :card_name => decrypt_response["card_name"],:status_code => decrypt_response["status_code"],:status_message=>decrypt_response["status_message"] ,:currency => decrypt_response["currency"],:expiry_date => exp_date)
end

end