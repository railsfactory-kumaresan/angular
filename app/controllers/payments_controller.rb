class PaymentsController < ApplicationController
  require "zaakpay"
  require "uri"
  require "net/http"
  layout 'admin_layout', :only => [:new]
   before_filter :authenticate_user_web_api
   before_action :plan_details, :only => [:new]
   skip_before_filter :verify_authenticity_token, :only => [:response_handler,:send_cancel_email]
   before_filter :check_role_level_permissions, :only => ["merchant_test", "transaction","handler"]
   #before_action :redirect_to_dashboard, :only =>[:merchant_test]
  #Removing these codes since we moved paymnet in offline
  #protect_from_forgery :except => [:z_response,:post_to_zaakpay]
  #before_filter :check_sbscribe_status_and_invite_user, :only => [:merchant_test]
  #before_filter :check_admin_user, :except => [:merchant_test, :post_to_zaakpay, :z_response]
  #
  # GET /merchant_test
  def merchant_test
    @plans = PricingPlan.where("plan_name != 'Trial'").includes(:category_types).order_by_amount_asc
    @billing_info = BillingInfoDetail.find_user_billing_info(current_user) if current_user
    if valid_email?(current_user.present? ? current_user.email : "" )
      @bussiness_type = current_user.business_type_id if current_user
    else
      flash[:fadeout_notice] = APP_MSG["email"]["email_incorrect"]
      redirect_to "/users/edit"
    end
  end

  def update_payment_details
    if (params[:user][:email].present? && params[:user][:action_name].present? && params[:user][:amount].present?)
      user_detail = User.where(email: params[:user][:email].downcase).first
      if user_detail.parent_id == 0 || user_detail.parent_id == nil
        biz_type_id = params[:user][:plan_name].present? ? params[:user][:plan_name] : user_detail.business_type_id
        user_detail.account_subscribe(biz_type_id,params[:user][:exp_date])
        TransactionDetail.create(:user_id => user_detail.id, :amount => params[:user][:amount], :business_type_id => biz_type_id, :transaction_id => SecureRandom.hex(10), :expiry_date => params[:user][:exp_date], :active => true, :action => params[:user][:action_name], :payment_status => "completed", :order_id => SecureRandom.hex(32))
        InviteUser.payment_success(user_detail.email,user_detail.first_name).deliver
        flash[:notice] = APP_MSG["admin"]["payment_success"]
      else
        flash[:notice] = APP_MSG["admin"]["wrong_user"]
      end
    else
      flash[:notice] = APP_MSG["admin"]["payment_error"]
    end
    redirect_to "/payments/new"
  end

  def get_user_emails
    user = User.users_list(params[:term])
    render :json => user
  end

  def get_user_plan_details
    # If user is in highest plan shouldn't show upgrade option
    # When choose upgrade other than (plan should show other than his plan also it should show the highest plan from his plan )
    # When choose downgrade show only (the lowest plan) other than the highest plan
    highest_plan = PricingPlan.all.sort_by(&:amount).reverse.first.id
    lowest_plan = PricingPlan.all.sort_by(&:amount).first.id
    @user = User.where(email: params[:email]).first
    amount = PricingPlan.where(id: @user.business_type_id).first.amount
    unless  params[:email].present? && params[:pay_action].present?
      @user_action  = (@user.business_type_id == highest_plan) ? ["Downgrade", "Renewal"] : ( (@user.business_type_id == lowest_plan) ? ["Upgrade", "Renewal"] : DEFAULTS["payment_action"] )
      @plans = (@user.business_type_id == highest_plan) ? PricingPlan.order_by_amount.select {|p| p.id != highest_plan} : ((@user.business_type_id == lowest_plan) ? PricingPlan.order_by_amount.select {|p| p.id != lowest_plan} : PricingPlan.order_by_amount)
    else
      if params[:pay_action] == "Upgrade"
        @plans = PricingPlan.order_by_amount.select {|p| p.amount > amount}
      elsif params[:pay_action] == "Downgrade"
        @plans = PricingPlan.order_by_amount.select {|p| p.amount < amount}
      else
        @plans = PricingPlan.order_by_amount.select {|p| p.amount = amount}
      end
    end
    respond_to do |format|
      format.js
    end
  end

  
  #################################################
  # Comment Old Zaakpay code, comments start
  #################################################
    #~ #Create Zaakpay request with merchant id, order id, user details
   #~ #POST /post_to_zaakpay
  #~ def post_to_zaakpay
    #~ generate_orderid
    #~ if ((@token.to_s == "false") && (@random_token.length > 20))
      #~ generate_orderid
    #~ else
      #~ TransactionDetail.create(:user_id => current_user.id, :business_type_id => current_user.business_type_id, :order_id => @random_token, :payment_status => "incomplete")
      #~ params[:bus_type] == "ind" ? amount = 1000 : amount= 2000
      #~ pay=Hash.new
      #~ pay["merchantIdentifier"] = "#{ENV["MERCHANT_IDENTIFIER"]}"
      #~ pay["orderId"] = @random_token
      #~ pay["buyerFirstName"] = current_user.first_name
      #~ pay["buyerLastName"] = current_user.last_name
      #~ pay["txnType"] = "1"
      #~ pay["zpPayOption"] = "1"
      #~ pay["mode"] = 0
      #~ pay["currency"] = "INR"
      #~ pay["amount"]= amount
      #~ pay["merchantIpAddress"]= current_user.current_sign_in_ip
      #~ pay["purpose"]= "1"
      #~ pay["productDescription"] = "test product"
      #~ pay["txnDate"]= Date.today
      #~ pay.update({"buyerEmail" => params[:buyerEmail], "buyerAddress" => params[:buyerAddress], "buyerCity" => params[:buyerCity], "buyerState" => params[:buyerState], "buyerCountry" => params[:buyerCountry], "buyerPincode" => params[:buyerPincode], "buyerPhoneNumber" => params[:buyerPhoneNumber]})
      #~ zr = Zaakpay::Request.new(pay)
      #~ @zaakpay_data = zr.all_params
      #~ render :layout => false
    #~ end
  #~ end
  
   #~ #POST /z_response
  #~ def z_response
    #~ zr_response = Zaakpay::Response.new(request.raw_post)
    #~ @checksum_check = zr_response.valid?
    #~ @zaakpay_post = zr_response.all_params
    #~ order_id = @zaakpay_post["orderId"]
    #~ transactiondetail = TransactionDetail.where("order_id = ? AND payment_status =?", @zaakpay_post["orderId"], "incomplete").first if @zaakpay_post["orderId"] != "Cannot be shown due to security reason."
    #~ if @zaakpay_post['responseCode'] == "100" && (@zaakpay_post["orderId"] != "Cannot be shown due to security reason.") && @checksum_check == true
      #~ flash[:notice] = "The transaction was completed successfully."
      #~ InviteUser.payment_success(current_user.email,current_user.first_name).deliver
      #~ exp_date = Time.now + 1.month
      #~ @zaakpay_post['amount'] == '2000' ? modified_bussiness_type = 2 : modified_bussiness_type = 1
      #~ user_detail = User.find_by_id(current_user.id)
      #~ if modified_bussiness_type == user_detail.business_type_id
        #~ @action ="Renewed"
      #~ elsif modified_bussiness_type == 2
        #~ @action ="Upgraded"
      #~ elsif modified_bussiness_type == 1
        #~ @action = "Downgraded"
      #~ end
      #~ user_detail.subscribe = true
      #~ user_detail.business_type_id = modified_bussiness_type
      #~ user_detail.exp_date = exp_date
      #~ user_detail.is_active = true
      #~ user_detail.save(:validate => false)
      #~ transaction_amount = (@zaakpay_post["amount"].to_i) /100
      #~ transactiondetail.update_attributes(:user_id => current_user.id, :amount => transaction_amount, :business_type_id => modified_bussiness_type, :transaction_id => @zaakpay_post["checksum"], :order_id => @zaakpay_post["orderId"], :expiry_date => exp_date, :active => 1, :action => @action, :payment_status => "completed", :response_code => @zaakpay_post['responseCode'], :response_dec => @zaakpay_post['responseDescription'], :zaakpay_response => @zaakpay_post)
      #~ redirect_to "/"
    #~ else
      #~ transactiondetail.update_attributes(:user_id => current_user.id, :transaction_id => @zaakpay_post["checksum"], :order_id => @zaakpay_post["orderId"], :payment_status => "incomplete", :response_dec => @zaakpay_post['responseDescription'], :response_code => @zaakpay_post['responseCode'], :zaakpay_response => @zaakpay_post)
      #~ render :action => 'z_response'
    #~ end
  #~ end
#############################################################
# Zaakpay code comments end
#############################################################

  #CCavenue request handler
  def handler
    generate_orderid
    if ((@token.to_s == "false") && (@random_token.length > 20))
       generate_orderid
    else
      request_params_builder(params["plan_id"])
      TransactionDetail.create_transaction(current_user, params)
      user_exist = BillingInfoDetail.where(user_id: current_user.id).first
      BillingInfoDetail.create_billing_info_details(current_user, params) if user_exist.blank?
    end
  end

  def update_billing
    BillingInfoDetail.create_billing_info_details(current_user, params)
    respond_to do |format|
      format.js
    end
  end
   
   #CCavenue response handler
  def response_handler
    decrypt_response, transactiondetail = TransactionDetail.crypto_key_split(params[:encResp])
    if decrypt_response["order_status"] == "Success"
      current_user.account_subscribe(transactiondetail.request_plan_id)
      transactiondetail.update_transaction_details(transactiondetail.request_plan_id,decrypt_response,current_user.exp_date)
      # CC Avenue email engine will be used. Inquirly app will not send payment success message
      # InviteUser.payment_success(current_user.email,current_user.first_name).deliver
      $_SESSION[:client_settings] = ClientSetting.define_client_settings(current_user) unless current_user.admin
      session[:role_permissions] = Permission.define_permissions(current_user)
      flash[:notice] = APP_MSG["payment"]["payment_success"]
      redirect_to edit_user_registration_path(:status => decrypt_response["order_status"],:order_id => decrypt_response["order_id"],:t_id =>decrypt_response["tracking_id"])
    else
      plan_id = PricingPlan.find_by_plan_name("Trial")
      current_user.account_cancel(plan_id)
      User.change_role(current_user)
      transactiondetail.update_transaction_details(transactiondetail.request_plan_id,decrypt_response)
      #flash[:notice] = "#{decrypt_response["order_status"]}"
      flash[:notice] = APP_MSG["payment"]["payment_failure"] if decrypt_response["order_status"] == "Failure"
      flash[:notice] = APP_MSG["payment"]["payment_abort"] if decrypt_response["order_status"] == "Aborted"
      flash[:notice] = APP_MSG["payment"]["payment_cancel"] if decrypt_response["order_status"] == "Incomplete"
      redirect_to dashboard_index_path(:status => decrypt_response["order_status"])
    end
  end

  def payment_notify_mail_non_subscribe
    users = User.where("(subscribe = ? and is_active = ? ) and (parent_id = ? or parent_id is NULL)",false,true,0)
    #~ users = User.where(:subscribe => false,:is_active => true)
    users.each do |user|
      expired_at,mail_day = user.get_mail_date
      if mail_day <= Time.now
        remaining_days = get_total_remaining_days(expired_at)
        InviteUser.subscription_notification(user.email,user.first_name,true,remaining_days).deliver if remaining_days != 0
      end
    end
  end

  def payment_notify_mail_subscribe
    users = User.where("(subscribe = ?) and (parent_id = ? or parent_id is NULL)",true,0)
    #~ users = User.where(:subscribe => true)
    users.each do |user|
      if user.email != "admin@inquirly.com"
         expired_at,mail_day = user.get_mail_date
         remaining_days = get_total_remaining_days(expired_at)
        if mail_day  <= Time.now
          InviteUser.subscription_notification(user.email,user.first_name,false,remaining_days).deliver
        end
    end
  end
end

  def check_subscribed_user_acc_status
    @bitly_url=Bitly_url["url"]
    sbscribed_expire_user = User.fetch_subscribed_expire_user
    sbscribed_expire_user.each do |user|
      user.is_active = false
      user.subscribe = false
      user.save(:validate => false)
      InviteUser.subscription_expired(user.email,user.first_name,@bitly_url).deliver if user.email
    end
  end

  def send_cancel_email
   if !params[:message].blank?
      InviteUser.send_cancel_feed_back(current_user,params).deliver
    end
    redirect_to '/dashboard'
  end

  def download_success
    respond_to do |format|
      format.pdf do
        render :pdf => "Report",
               :template => "payments/download_success.pdf.erb",
               :margin => {
                   :top => 10,
                   :bottom => 10
               },
               :layout =>'application',
               :header => {:spacing => 5, :content => render_to_string({ :template => 'downloads/header'})
               },
               :footer => {:content => render_to_string({
                                                            :template => 'downloads/footer'})
               }
      end

    end
  end

  private

   #~ def check_sbscribe_status_and_invite_user
     #~ if current_user
       #~ @user = current_user
       #~ if current_user.parent_id.present?
         #~ redirect_to "/dashboard"
         #~ flash[:non_fade_notice] = "You are not authorized to access"
       #~ end
     #~ end
   #~ end
   
   # CCavenue Response params build
   def request_params_builder(plan_id)
    @pricing_plan = PricingPlan.find_by_id(plan_id)
    params["merchant_id"] =  ENV["CCAVENUE_MERCHANT_ID"]
    params["order_id"] = @random_token
    params["amount"] = ((@pricing_plan.amount) * (1 + APP_MSG["payment"]["payment_tax"].to_f / 100.to_f)).to_s
    params["currency"] = "INR"
    params["redirect_url"] = ENV["CCAVENUE_REDIRECT_URL"]
    params["cancel_url"] = ENV["CCAVENUE_CANCEL_URL"]
    params["language"] = "EN"
    params["billing_ name"] = current_user.first_name

   end
   
   #unique order id generation
   def generate_orderid
     @random_token = "I"+current_user.id.to_s+current_user.business_type_id.to_s+Time.now.strftime("%d%m%H%M%S").to_s+current_user.email.slice(0...1)
     @token = TransactionDetail.all.map(&:order_id).include?(@random_token)
   end

   # Temp method to redirect
   def redirect_to_dashboard
     redirect_to '/'
   end

   def plan_details
     @plans = PricingPlan.order_by_amount_asc
   end
end