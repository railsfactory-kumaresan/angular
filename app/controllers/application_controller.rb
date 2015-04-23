class ApplicationController < ActionController::Base
  include AbstractController::Helpers::ClassMethods
  include ActionView::Helpers::DateHelper
  require 'active_admin_views_pages_base.rb'
  # before_filter :authenticate_user_web_api, :except => [:invalid_url,:view_count_update_embed]
  #around_filter :catch_exceptions
  before_filter :verified_request?
  #skip_before_filter :check_listener_module!, if: :sessions_controller?
  #~ before_filter :check_listener_module
  before_filter :verify_session
  protect_from_forgery :except => :show_embed_survey
  before_filter :set_session
  respond_to :xml

  def verify_session
    if !session[:expire].nil? && session[:expire] < Time.now
      # Session has expired. Clear or reset session
      redirect_to destroy_user_session_path(:time_out => true, :notice => "Your session has expired")
    end
    # Assign a new expiry time, whether the session has expired or not.
    session[:expire] = Time.now + 1800.seconds
    return true
  end

  def check_role_level_permissions
  session[:user_permissions] = Permission.define_permissions(current_user) if current_user && current_user.role && session[:user_permissions].blank?
  if current_user && current_user.role && !Permission.check_user_role_permissions(params[:controller],params[:action],current_user,session[:user_permissions])
   if request.content_type =~ /json/
       render json: {error: "#{APP_MSG['authorization']['failure']}", status: 200}
   else
       begin
        redirect_to :back, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
       rescue ActionController::RedirectBackError
        redirect_to "/", :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
       end
    end
   end
  end

  # def check_role_level_permissions_api
  #  render json: {error: "#{APP_MSG['authorization']['failure']}", status: 200} unless Permission.check_user_role_permissions(params[:controller],params[:action],current_user,request.method)
  # end

  # def find_filter_question
  #   @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ?", @from_date, @to_date, @user_id)
  #   @question_ids = @question.pluck(:id) if @question.present?
  # end

  def check_listener_module
    @is_listener_activated = Listener.fetch_listener(current_user.id) if current_user
  end

  def after_sign_in_path_for(resource,pay_status='false')
     tenant_count(resource)
     return "/?pay=#{pay_status}" if pay_status == 'true'
     return "/"
  end

  def tenant_count(user)
    ClientSetting.get_column_value("tenant_count", (user.parent_id != 0 && user.parent_id != nil) ? User.where(id: user.parent_id).first : user)
  end
  #~ To handle routing errors
  def invalid_url
    redirect_to "#{request.protocol}#{request.host_with_port}/404.html"
  end

  ######################
  #Faliure response
  ######################
  def failure(body = nil)
    api_header("400", "Sorry,Record not found", body)
  end

  ######################
  #Success response
  ######################
  def success(body = nil)
    api_header("200", "Successfully completed", body)
  end

  ######################
  #API Authentication Faliure response
  ######################
  def failure_authentication(body = nil)
    api_header("1005", "Invalid token", body)
  end

  def failure_token_missing(body = nil)
    api_header("1020", "Authentication token missing", body)
  end

  ############
  # un authrozied
  ############
  def unauthrized(body = nil)
    api_header("401", "unauthorized access", body)
  end

  def api_header(status=nil, message=nil, body=nil)
    @body = body.present? ? body : {:errors => "#{message}"}
    {:header => {:status => status.to_i}, :body => @body}
  end

  #Helper method for json
  def json_request?
    request.format.json?
  end

  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies
    authenticated = if no_input.present?
                      args = no_input.dup.push :scope => resource_name
                      warden.authenticate?(*args)
                    else
                      warden.authenticated?(resource_name)
                    end

    if authenticated && resource == warden.user(resource_name)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

  def all_categories
   @categories = CategoryType.get_categories(current_user)
  end

  def get_tenant_list
    tenant = ExecutiveTenantMapping.get_tenant_ids(current_user.id)
    tenants = Tenant.where("id IN (?)",tenant).sort_by(&:name)
    @tenants = tenants.collect {|t| [t['name'], t['id']]}
    return @tenants << ['Own Question',0]
  end

  def get_total_remaining_days(expired_at)
    if Date.parse(Time.now.utc.strftime("%d/%m/%Y")) <=  Date.parse((expired_at).strftime("%d/%m/%Y"))
       remaining_days =(Date.parse((expired_at).strftime("%d/%m/%Y")) - Date.parse(Time.now.utc.strftime("%d/%m/%Y"))).to_i
    else
       remaining_days = 0
    end
  end

  def category
    cat = CategoryType.get_categories(current_user).collect { |a| [a.category_name, a.id] }
    cat << ["Active", "Active"]
    cat << ["Closed", "Closed"]
    @category = cat
  end

def check_admin_user
  user = User.find_by_authentication_token(params[:authentication_token]) if !params[:authentication_token].blank?
  user = current_user if !user.present?
  @current_user = user
  if @current_user
    @user = current_user
    if @current_user.is_active == false
      flash[:notice] = "#{APP_MSG['account']['expire']}"
      redirect_to "/dashboard"
    end
  end
end

# comment as per the sudha suggestions
  #~ def check_admin_user
    #~ user = User.find_by_authentication_token(params[:authentication_token]) if !params[:authentication_token].blank?
    #~ user = current_user if !user.present?
    #~ @current_user = user
    #~ if @current_user
      #~ @user = current_user
      #~ if @current_user.admin == true
        #~ flash[:notice] = "#{APP_MSG['authorization']['failure']}"
        #~ redirect_to '/admin/listeners/list_listeners'
      #~ elsif @current_user.is_active == false
        #~ flash[:notice] = "#{APP_MSG['account']['expire']}"
        #~ redirect_to "/dashboard"
      #~ end
    #~ end
  #~ end

  def check_subscription_expire
    if current_user
      if current_user.is_active == false
        flash[:notice] = "#{APP_MSG['account']['expire']}"
        redirect_to "/dashboard"
      end
    end
  end

# def question_url(slug)
#   bitly_url
#   url = "#{Bitly_url["url"]}/surveys/#{slug}"
#   @custom_url = @bitly.shorten(url)
# end


  def get_gender_wise_count_xls(id, params)
    id = current_user.id
    age_limits = ["0_to_17", "18_to_25", "26_to_30", "31_to_35", "36_to_40", "41_to_45", "46_to_50", "51_to_300"]
    age_wise_view_count = {}
    age_wise_response_count = {}
    age_limits.each_with_index do |age_limit, index|
      #age_wise_view_count[index]  =  RedisCount::GetViewCount.new(nil,nil,id,age_limit,nil,nil,params[:category],params[:from_date],params[:to_date]).get_total_view_count_by_age
      age_wise_response_count[index] = RedisCount::GetResponseCount.new(nil, nil, id, age_limit, nil, nil, params[:from_date], params[:to_date], params[:category], nil).get_total_response_count_by_age
    end
    demo_graphics = age_wise_response_count
    return demo_graphics
  end

  def verified_request?
    if request.content_type == "application/json"
      true
    else
      super()
    end
  end

  def valid_email?(email)
    reg = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    return (reg.match(email)) ? true : false
  end

  def current_user_email_format
    unless valid_email?(current_user.email)
      flash[:non_fade_notice] = "Please update or confirm the email address to access this feature."
      redirect_to "/users/edit"
    end
  end

  protected

  def set_session
      $_SESSION = session
  end

  private

  def bitly_url
    @bitly = Bitly.client
  end

  def set_cookie_and_uuid(cookie_info, question,provider)
    if !cookie_info.blank?
      customer_id = ActiveSupport::JSON.decode( Base64.decode64(cookie_info))
      biz_details = BusinessCustomerInfo.where(id: customer_id).first
      if biz_details.user_id != question.user_id
        exist_biz_details = check_existing_customer(biz_details,question,provider)
        unless exist_biz_details
           biz_customer = biz_details.dup
           biz_customer.user_id = question.user_id
           biz_customer.save
           cookie_id = biz_customer.id
        else
          cookie_id = exist_biz_details.id
        end
      else
        cookie_id = biz_details.id
      end
      cookies.permanent.signed[:customer_details] = Base64.encode64( ActiveSupport::JSON.encode(cookie_id))
    end
      create_question_view_cookie(question.id,provider)
  end

  def check_existing_customer(biz_details,question,provider)
    if provider.downcase == "sms"
      BusinessCustomerInfo.where(email: biz_details.email, user_id: question.user_id, mobile: biz_details.mobile).first
    else
      BusinessCustomerInfo.where(email: biz_details.email, user_id: question.user_id).first
    end
  end

  def check_cookie_already_set
    @new_user = @cookie_uuid.blank? ? true : false
  end

  def create_cookie_token
    SecureRandom.hex(10)
  end

  def check_cookie_already_viewed(question_id,provider)
    cookie_already_viewed_or_answered(question_id,"v",provider)
  end

  def create_question_view_cookie(question_id, provider)
    provider = get_provider(provider)
    if cookies.signed["question_v_#{question_id}"].nil?
      cookies.permanent.signed["question_v_#{question_id}"] = ['view' => [provider]]
    else
      viewed_cookie = cookies.signed["question_v_#{question_id}"].first['view']
      updated_cookie = viewed_cookie << provider  unless viewed_cookie.include?(provider)
      cookies.permanent.signed["question_v_#{question_id}"] = ['view' => updated_cookie]
    end
  end

  def create_question_response_cookie(question_id,provider)
    provider = get_provider(provider)
    if cookies.signed["question_r_#{question_id}"].nil?
      cookies.permanent.signed["question_r_#{question_id}"] = ['response' => [provider]]
    else
      response_cookie = cookies.signed["question_r_#{question_id}"].first['response']
      updated_cookie = response_cookie << provider  unless response_cookie.include?(provider)
      cookies.permanent.signed["question_r_#{question_id}"] = ['response' => updated_cookie]
    end
  end

  def check_cookie_already_answered(question_id, provider)
    cookie_already_viewed_or_answered(question_id,"r",provider)
  end

  def cookie_already_viewed_or_answered(question_id,klass,provider)
    provider = get_provider(provider)
    h_key = klass == "v" ? 'view' : 'response'
    cookie_details = cookies.signed["question_#{klass}_#{question_id}"]
    !cookie_details.nil? && cookie_details.first[h_key].include?(provider) ? true : false
  end

  def get_provider(provider)
    provider_options = { "email" => 1, "facebook" => 2, "twitter" => 3, "linkedin" => 4, "sms" => 5, "qr" => 6 }
    return provider_options["#{provider.downcase}"]
  end

  def authenticate_user_web_api
    params[:authentication_token] = params[:authenticity_token] if params[:authenticity_token].present?
    @current_user = User.check_user_auth_confirmed(params[:authentication_token]) if !params[:authentication_token].blank?
    @current_user = current_user if !@current_user.present?
    if !@current_user.present? && @current_user.blank?
      respond_to do |format|
        format.html { redirect_to "/", :notice => "You are not logged in. Please log in" }
        format.json { render :json => unauthrized() }
      end
    end
  end

  def check_acc_exp
    if current_user
      @user = current_user
      if current_user.is_active == false
        flash[:notice] = "Your account has expired. Please upgrade your account."
      end
    end
  end

  def catch_exceptions
    yield
  rescue => exception
    ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    if exception.is_a?(ActiveRecord::RecordNotFound)
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
    else
      render :file => "#{Rails.root}/public/500.html", :layout => false, :status => :not_found
    end
  end

end