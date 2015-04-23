class Users::SessionsController < Devise::SessionsController
  respond_to :html, :xml, :json
  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  prepend_before_filter :allow_params_authentication!, :only => :create
  skip_before_filter :verify_session, :only => [:create]
  layout 'home_page'
  include ErpSessionData
  prepend_before_filter { request.env["devise.skip_timeout"] = true }
  #after_action :set_access_control_headers
  #
  #def set_access_control_headers
  #  headers['Access-Control-Allow-Origin'] = '*'
  #  headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
  #  headers['Access-Control-Request-Method'] = '*'
  #  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  #end
  # GET /resource/sign_in
  def new
    self.resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    resource = User.find_by_email(params[:user][:email])
    resource,params[:user][:password] = create_enterprise_user(params[:user]) if resource.blank? && params[:user][:is_sso] == 'true'
    respond_to do |format|
      check_valid_user = params[:user][:is_sso] == 'true' ? resource.present? : (resource.present? && resource.valid_password?(params[:user][:password]))
      if check_valid_user
        if resource.confirmed? &&  !resource.locked_at
          set_flash_message(:notice, :signed_in) if is_navigational_format?
          sign_in(resource_name, resource)
          resource.ensure_authentication_token!
          $_SESSION[:client_settings] = ClientSetting.define_client_settings(resource) unless resource.admin
          session[:role_permissions] = Permission.define_permissions(resource)
          erp_session_data(resource) if params[:user][:is_sso] == 'true'
          if params[:user][:remember_me].to_i == 1
            cookies.permanent[:auth_token] =  Base64.encode64(resource.email)
            cookies.permanent[:user_token] = Base64.encode64(params[:user][:password])
          else
            cookies.delete(:auth_token)
            cookies.delete(:user_token)
          end
          format.json { render :json => success({:success => true,:user_id => resource.id, :auth_token => resource.authentication_token, :email => resource.email, :first_name => resource.first_name, :last_name => resource.last_name, :business_role => resource.business_type_id, :role => resource.admin, :company_name => resource.company_name, :_session_id => session.id })}
          flash[:after_logged_in] = after_logged_trail_msg
          format.html {redirect_to dashboard_index_path(:auth_token => resource.authentication_token,:notice => flash[:notice],:after_logged_in => after_logged_trail_msg)} if resource.parent_id.to_i == 0
          format.html {redirect_to dashboard_index_path(:auth_token => resource.authentication_token,:notice => flash[:notice])} if resource.parent_id.to_i > 0
          format.html {admin_pricing_plans_path(:auth_token => resource.authentication_token,:notice => flash[:notice])} if resource.email == 'admin@inquirly.com'
        else
          error_message = resource.present? &&  resource.locked_at ? "Your account is locked. Please check your email." : "Your email address is either incorrect or not yet confirmed. Please update or confirm your e-mail address."
          format.json { render :json => failure({:errors => error_message})}
        end
      else
        error_message = resource.present? &&  resource.locked_at ? "Your account is locked. Please check your email." : "Invalid email or password."
        format.json { render :json => failure({:errors => error_message }) }
        format.html {redirect_to "#{ENV["INQUIRLY_LIVE"]}&error=#{error_message}"}
      end
    end
  end
  #
  def create_enterprise_user(params)
    client_details = User.where(email: params[:client_email]).first
    resource, password = nil, nil
    if client_details
      tenant = Tenant.create(name: params[:tenant_name], address: params[:tenant_address], client_id: client_details.id, redirect_url: client_details.redirect_url, from_number: client_details.from_number)
      params[:tenant_id] = tenant.id
      params[:parent_id] = client_details.id
      params[:role_id] = 5 #Default Executive Role
      resource, password = User.create_corp_user(params)
      resource.save
    end
    [resource,password]
  end

  def validate_user_data
    endpoint = EnterpriseApiEndpoint.subdomain params[:subdomain]
    data = RestClient.post(endpoint.login_path, :username => params[:username], :password => params[:password])
    session[:subdomain] = params[:subdomain] if data
    render :json =>  JSON.parse(data)
  end

  # DELETE /resource/sign_out
  def destroy
    resource = ""
    session[:role_permissions] ={}
    $_SESSION[:client_settings] = {}
    if current_user.present?
      resource = current_user
      current_user.update_attribute(:authentication_token,nil)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    else
      if !params[:authentication_token].nil?
       resource = User.find_by_authentication_token(params[:authentication_token])
       resource.update_attribute(:authentication_token,nil) if resource
      end
    end
    respond_to do |format|
      if resource.present?
        format.js {render :js => "window.location = '#{ENV['INQUIRLY_LIVE']}'"}
        format.html { redirect_to ENV["INQUIRLY_LIVE"], :notice => signed_out && is_navigational_format? && !params[:time_out] ? "Signed out successfully." : params[:notice]}
        format.json {render :json => success({:success => "successfully logout."})}
      else
        format.html { redirect_to ENV["INQUIRLY_LIVE"] }
        format.json {render :json => { :header => {:status => "error"}, :body => {:message => "session does not exist"} }}
      end
    end
  end
  
  #after logged in trails peroid flash message
  def after_logged_trail_msg
    if current_user.is_trail_in_period?
    "Your trial period expires in #{get_total_remaining_days(current_user.exp_date)} days, do you want to pay now?"
    else
      ""
    end
  end
  

  protected

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    {:methods => methods, :only => [:password]}
  end

  def auth_options
    {:scope => resource_name, :recall => "#{controller_path}#new"}
  end
end

