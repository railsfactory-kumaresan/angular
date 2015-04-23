class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  before_filter :check_role_level_permissions,:only => [:update]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :destroy]
  before_filter :check_subscription_expire, :only => [:edit,:update]
  respond_to :html, :xml, :json

  # GET /resource/sign_up
  def new
    resource = build_resource({})
    respond_with resource
  end

  # POST /resource
  def create
    build_resource
    if resource.valid?
      if resource.save
        active_for_authentications
        respond_to do |format|
          format.html { respond_with resource, :location => resource.active_for_authentication? ? after_sign_up_path_for(resource) : after_inactive_sign_up_path_for(resource) }
          format.json { render :json => success({:user => resource, :confirmation_token => resource.confirmation_token,:message => "Welcome! You have signed up successfully."}) }
        end
      end
    else
      respond_to do |format|
        format.html { respond_with resource }
        format.json { render :json => failure({:resource => resource.errors}) }
      end
    end
  end

  # GET /resource/edit
  def edit
    session[:referrer]="/users/edit"
    @transaction_details = TransactionDetail.where("user_id = ? AND active is TRUE", current_user.id)
    @plans = PricingPlan.all
    @subscribe = current_user.subscribe
    @business_type = current_user.business_type_id
    @email = valid_email?(current_user.email)
    @languages = Language.get_all_languages
    client_setting = current_user.client_setting
    @selected_languages = client_setting ? client_setting.languages : []
    @maximum_limit = current_user.get_allocated_count('language_count') if client_setting
    user_status_business_id_share_info
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    session[:referrer]="/users/edit"
    @plans = PricingPlan.all
    @languages = Language.get_all_languages
    params[:user][:from_number] = params[:user][:from_number].blank? ? ENV["CALL_NUM"].gsub("+","") : params[:user][:from_number]
    params[:user][:redirect_url] = params[:user][:redirect_url].blank? ? ENV["DEFAULT_REDIRECT_URL"] : params[:user][:redirect_url]
    client_setting = current_user.client_setting
    @selected_languages = client_setting ? client_setting.languages : []
    user_status_business_id_share_info
    unless request.format.json?
      result, prev_unconfirmed_email = valid_email_and_confirmed_mail(params,current_user)
      update_and_redirect(result, prev_unconfirmed_email)
    else
      update_user_json
    end
  end

  # DELETE /resource
  # def destroy
  #   resource.destroy
  #   Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
  #   set_flash_message :notice, :destroyed if is_navigational_format?
  #   respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  # end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.

  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected


  def update_and_redirect(result, prev_unconfirmed_email)
    tenant_url = Tenant.where("redirect_url is null or redirect_url=?",current_user.redirect_url).where(client_id:current_user.id)
    tenant_no = Tenant.where("from_number is null or from_number=?", current_user.from_number).where(client_id:current_user.id)
    if result
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        ClientLanguage.create_new_record(current_user,params[:client_setting][:language_ids]) if params[:client_setting] && !params[:client_setting][:language_ids].blank?
        User.update_company_name(current_user, params) if !params[:user][:company_name].blank? && current_user.company_name != params[:user][:company_name] && current_user.provider == nil && current_user.parent_id != nil
        User.new.same_url_update_user(current_user,tenant_url,params) if current_user.parent_id.to_i == 0
        User.new.same_number_update_user(current_user,tenant_no,params) if current_user.parent_id.to_i == 0
        ShareQuestion.update_sub_account_friendly_name("#{params[:user][:company_name]}_#{current_user.parent_id == 0 ? current_user.id : current_user.parent_id}".strip,"#{current_user.company_name}_#{current_user.parent_id == 0 ? current_user.id : current_user.parent_id}".strip)
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      redirect_to '/users/edit'
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def user_status_business_id_share_info
    @status = current_user.social_setting_info
    @user_business_id = current_user.business_type_id
    @share_info = ShareQuestion.user_social_setting_info(current_user)
  end

  def password_present(params)
    pres = params[:user][:password].present?
    result = User.user_status(pres,resource_params,current_user,params,resource)
    return result
  end


  def password_update(user, params,prev_unconfirmed_email)
    if user.valid_password?(params[:user][:current_password])
      if params[:user][:password].length < 8
        render json: failure({errors: "Password should be 8-16 characters."})
      else
        valid_confirmation_password(user, params,prev_unconfirmed_email)
      end
    else
      render json: failure({errors: 'Invalid Current Password'})
    end
  end

 def active_for_authentications
    if resource.active_for_authentication?
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
    else
      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      expire_session_data_after_sign_in!
    end
  end


  def user_details_updated(params, user, prev_unconfirmed_email, up_params)
    if up_params == true
      resoure_params={}
      user_params = params[:user]
      resoure_params = user_params.merge(:step => "3")
    end
    if user.update_without_password(resoure_params)
      flash_key = update_needs_confirmation?(user, prev_unconfirmed_email) ? "Your email address has been updated successfully. Please check your email and click on the confirmation link to confirm your new email address." : "Your account was updated successfully."
      render json: success({success: flash_key})
    else
      render json: failure({errors: user.errors})
    end
  end

  def update_user_json
    if params[:authentication_token].present?
      user = User.find_by_authentication_token(params[:authentication_token])
      prev_unconfirmed_email = user.unconfirmed_email if user.respond_to?(:unconfirmed_email)
      update_user_details(user,prev_unconfirmed_email,params)
    else
      render json: failure_token_missing()
    end
  end


  def update_user_details(user,prev_unconfirmed_email,params)
    if user.nil? || !user.present?
      render json: failure_authentication()
    else
      if params[:user][:current_password]
        password_update(user, params,prev_unconfirmed_email)
      else
        if valid_email?(params[:user][:email])
          user_details_updated(params, user, prev_unconfirmed_email, true)
        else
          render json: failure({errors: 'Invalid Email'})
        end
      end
    end
  end


  def valid_confirmation_password(user, params,prev_unconfirmed_email)
    if params[:user][:password] == params[:user][:password_confirmation]
      if valid_email?(params[:user][:email])
        user_details_updated(params, user, prev_unconfirmed_email, false)
      else
        render json: failure({errors: "Invalid Email"})
      end
    else
      render json: failure({errors: 'Password Confirmation is Mismatch'})
    end
  end


 def valid_email_and_confirmed_mail(params,current_user)
    @email = valid_email?(current_user.email)
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    result =  password_present(params)
    return result, prev_unconfirmed_email
  end


  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
        resource.pending_reconfirmation? &&
        previous != resource.unconfirmed_email
  end

# Build a devise resource passing in the session. Useful to move
# temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash ||= resource_params || {}
    hash["distribute_pricing_plan_id"] = 3 if hash["business_type_id"].to_i == 3  #Temp hardcoded plan for enterprise plan
    self.resource = resource_class.new_with_session(hash.merge(:exp_date => Time.now + 14.days, :is_active => true, :step => "5"), session)
  end

# Signs in a user on sign up. You can overwrite this method in your own
# RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

# The path used after sign up. You need to overwrite this method
# in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

# The path used after sign up for inactive accounts. You need to overwrite
# this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

# The default url to be used after updating a resource. You need to overwrite
# this method in your own RegistrationsController.
# for rails_best_parctise the below method is commented.
# def after_update_path_for(resource)
#   signed_in_root_path(resource)
# end

# Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def valid_email?(email)
    reg = /\A[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]{2,3}+\.){1,2}[A-Za-z]{2,4}\Z/i
    return (reg.match(email)) ? true : false
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password,:company_name,:first_name,:last_name,:business_type_id,:parent_id, :role_id,:step,:redirect_url,:from_number)
  end

  private :resource_params
end
