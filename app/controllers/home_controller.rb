class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_session
  layout 'home_page'
  before_filter :remember_me_retained, :only=>[:index]
  skip_before_action :verify_authenticity_token,:only => [:signup_form], if: :json_request?
  def index
  end

#Opinify API Call. this action is used in opinify application..
  def get_inquirly_user
    if request.env['HTTP_OPINIFY_AUTH_TOKEN'] == "2f17c4ef2f51d91694724e88063af8"
      user = User.find_by_email(params["email"])
      user.present? ? (render json:  { status: 200, email: user.email ,first_name: user.first_name,last_name: user.last_name } ) : (render json: {status: 400})
    else
      render json: {status: 500}
    end
  end

  def signup_form
    @plans = PricingPlan.get_all_plans
  respond_to do |format|
      format.js
      format.html
  end
  end

  def enterprise_login
    @subdomain = request.subdomain
    if current_user
      redirect_to "#{ENV['CUSTOM_URL']}dashboard"
    end
  end

  def signin_form
  respond_to do |format|
      format.js
  end
  end

  def forgot_password_form
  respond_to do |format|
      format.js
  end
  end

  def remember_me_retained
    @email = Base64.decode64(cookies[:auth_token]) if cookies[:auth_token]
    @pass =  Base64.decode64(cookies[:user_token]) if cookies[:user_token]
  end


end
