class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :check_role_level_permissions,:only => [:facebook,:twitter,:linkedin]
  include ApplicationHelper
  # Facebook authentication
  def facebook
    if current_user.nil?
      facebook_without_current_user
    else
      re = request.env["omniauth.auth"]
      share_question = ShareQuestion.find_user_email(current_user.id, re.uid,re.provider, re.info.email)
      facebook_with_current_user(share_question)
    end
  end

  def facebook_without_current_user
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    get_social_profiles(@user)
    @user.persisted? ? social_network_flash(@user, 'Facebook') : (redirect_to dashboard_index_path @user, :flash => {:notice => "Successfully logged in"})
  end

  def facebook_with_current_user(share_question)
    if share_question != true
      re = request.env["omniauth.auth"]
      #Facebook Graph API changed for image
      type_change = re.info.image.split("type")
      normal_image = type_change.first + "type=normal"
    @add_user = ShareQuestion.create(:user_id => current_user.id, :provider =>re.provider,:email_address => re.info.email, :social_id => re.uid,
                            :social_token => re.credentials.token, :user_name => re.info.name,:user_profile_image => normal_image, :active => true)
    if @add_user
      update_user("facebook")
      success_msg("/users/edit", "facebook", 1)
    else
      success_msg("/users/edit", "facebook", 2)
    end
  else
    success_msg("/users/edit", "facebook", 3)
  end
  end

  def redirect_to_edit_method(provider,re)
    share_question = find_share_question
    if share_question != true
      @add_user = twitter_linked_in_add_user
      if @add_user
        update_user("#{provider}")
        success_msg("#{re}", "#{provider}", 1)
      else
        success_msg("#{re}", "#{provider}", 2)
      end
    else
      success_msg("#{re}", "#{provider}", 3)
    end
  end

  # Twitter authentication
  def twitter
    twitter_and_linked_in_oauth("twitter","edit",'Twitter')
  end

  def twitter_and_linked_in_oauth(provider,re,p_name)
    if current_user.nil?
      @user = provider == "twitter" ? User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user) : User.find_for_linkedin_oauth(request.env["omniauth.auth"], current_user)
      get_social_profiles(@user)
      social_network_flash(@user,"#{p_name}") if @user.persisted?
    else
      redirect_to_edit_method("#{provider}","#{re}")
    end
  end

  def twitter_linked_in_add_user
    re = request.env["omniauth.auth"]
    ShareQuestion.create(:user_id => current_user.id, :provider => re.provider,:email_address => re.info.name, :social_id => re.credentials.secret,
                      :social_token => re.credentials.token, :user_name => re.info.nickname,:user_profile_image => re.info.image, :active => true)
  end

  # Linkedin authentication
  def linkedin
    twitter_and_linked_in_oauth("linkedin","users/edit",'Linkedin')
  end

  # Google authentication
  def google
    @user = User.find_for_google_oauth(request.env["omniauth.auth"], current_user)
    get_social_profiles(@user)
    social_network_flash(@user, 'Google') if @user.persisted?
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def failure
    redirect_to root_url, alert: "Your social media account authentication has failed."
  end

  def get_social_profiles(user)
    image_url = request.env["omniauth.auth"]["info"]["image"]
    if !image_url.blank?
    begin
    image = image_url.gsub("http","https").split("type")[0]
    Attachment.attach_user_profile(user,image)
    rescue Exception => e
      image = image_url.gsub("https","http").split("type")[0]
      Attachment.attach_user_profile(user,image)
    end
  end
  end

  private

  def social_network_flash(user, provider)
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "#{provider}"
    flash[:after_logged_in] = user.is_valid_email(user.email) ? (user.is_trail_in_period? ? "Your trial period expires in #{get_total_remaining_days(user.exp_date)} days, do you want to pay now?" : "") : "Your trial period expires in #{get_total_remaining_days(user.exp_date)} days"
    session[:user] = user.attributes
    sign_in_and_redirect user, event: :authentication
  end

    def success_msg(re, provider_name, res)
    provider_name = provider_name.capitalize
    msg = res == 1 ? "#{provider_name} account added successfully." : res == 2 ? "User not added" : "This #{provider_name} account already exists."
    if session[:referrer] && session[:referrer].include?("#{re}")
      redirect_to edit_user_registration_path, :flash => {:notice => msg}
    else
      redirect_to share_path(:id => session[:question_id]), :flash => {:notice => msg}
    end
  end

    def find_share_question
    re = request.env["omniauth.auth"]
    ShareQuestion.find_user_email(current_user.id, re.credentials.secret,re.provider, re.info.name)
  end

  def update_user(provider_name)
    user=current_user
    provider_name == "twitter" ? user.twitter_status="true" : provider_name == "linkedin" ? user.linkedin_status="true" : user.fb_status="true"
    user.authentication_token = Devise.friendly_token
    user.save(:validate => false)
  end
end