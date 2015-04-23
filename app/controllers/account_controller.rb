class AccountController < ApplicationController
  before_filter :check_admin_user , :except => [:change_plan]
  before_filter :authenticate_user_web_api, :except => [:social_login,:valid_email]
  before_filter :check_role_level_permissions,:only => [:transaction_history,:account_attachment]
  #before_filter :check_role_level_permissions_api,:only => [:social_login,:valid_email,:add_social_account,:user_account,:get_customer_info]
  include AccountSettings

  # def update_company_info
  #   is_company_info_update = @current_user.update_attributes(:company_name => params[:company_name], :step => "4")
  #   if is_company_info_update
  #     flash[:notice] = "Company name updated successfully."
  #   else
  #     @errors = @user.errors
  #     company_infos(@user)
  #     error = params[:company_name].blank? ? "Please enter the company name." : @errors
  #   end
  #   respond_to do |format|
  #       format.html { is_company_info_update ? (redirect_to "/account/company_settings") : (render :company_settings)}
  #       format.json { render :json => is_company_info_update ? success({:success => 'Company Name successfully updated'}) : failure({:errors => error})}
  #   end
  # end

  # def upgrade
  #   if current_user.business_type_id == 2 && current_user.subscribe == true
  #     flash[:non_fade_notice] = APP_MSG["account"]["upgrade"]
  #     redirect_to :back
  #   else
  #     redirect_to "/payments/merchant_test"
  #   end
  # end

  #~ def downgrade
    #~ if current_user.subscribe == false
      #~ redirect_to "/payments/merchant_test"
    #~ else
      #~ flash[:non_fade_notice] = APP_MSG["account"]["downgrade"] + " #{current_user.exp_date.strftime("%d-%b-%Y")}."
      #~ redirect_to :back
    #~ end
  #~ end
  
  # Compare the new plan value with current plan value for downgrade and upgrade the plan.
 def change_plan
  plan_message = PricingPlan.change_plan_check(current_user.business_type_id,params["new_plan_id"])
  if !current_user.subscribe  || current_user.get_mail_date[1]  <= Time.now #&& current_user.is_active
    render :json => {:message => APP_MSG["account"]["allow_to_pay"], :plan_action => plan_message}
  else
    if plan_message == "current_plan"
        render :json => {:message => APP_MSG["account"]["current_plan"]}
    elsif plan_message == "upgrade"
        render :json => {:message => APP_MSG["account"]["allow_to_pay"], :plan_action => plan_message}
    else
       render :json => {:message => APP_MSG["account"]["downgrade_exp_date"] + " #{current_user.exp_date.strftime("%d-%b-%Y")}."}
    end
  end 
end

  def account_attachment
      res = params[:account_id].present?
      user = User.find_user(params[:account_id].to_i).first  if res
      user_photo_attachment(user,params)
      flash[:notice]= res ? APP_MSG["account"]["upload_logo_sucess"] :  APP_MSG["account"]["invalid_account"]
      redirect_to :back
  end

  def social_login
    condition_status = social_login_access_status(params)
    @user = User.where('uid =?',params[:uid]).first
    u_res = current_user_social_login_status(params)  if !@user.present?
    u_res = user_social_login_status(@user)  if @user.present?
    hash_res = User.hash_result_for_social_login(u_res)
    render json: success(hash_res) if condition_status
    render json: failure( {errors: 'Invalid Parameters'}) if !condition_status
  end

#check user having this email is present or not
def valid_email
  user = User.find_by_authentication_token(params[:authentication_token]) if params[:authentication_token].present?
  if user.present?
    email = user.email
    reg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.([a-z]{1,3}\.[a-z]{1,2}|[a-z]{1,3}))+$/
    status = (reg.match(email))? true : false
    render :json => (status == true) ? success({:success => 'true'}) : failure({:errors => 'please update your email'})
  else
    render :json => failure_authentication()
  end
end

# share Question create from api request
def add_social_account
  if (params[:email].blank? || params[:provider].blank?)
    return_hash =  {:status => 400, :status_text => 'Please enter the valid details'}
  elsif @current_user.share_questions.where("email_address =? and user_id =?", params[:email], params[:user_id]).first
    return_hash =  {error: 'Already user account added', status: 200}
  else
    ShareQuestion.api_share_question_create(params)
    return_hash =  {success: 'Success', status: 200}
  end
  render :json => return_hash
end

  def profile_header
    render :layout => false
  end
end