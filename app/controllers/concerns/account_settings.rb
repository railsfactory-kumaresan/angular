module AccountSettings
  extend ActiveSupport::Concern
  included do
    # def self.manage_user
    #   @user = @current_user
    #   @mangeuser = User.where("parent_id=?", @user.id)
    #   @mange_user = User.where("parent_id=?", @user.id).paginate(:page => params[:page], :per_page => 5)
    # end


    def company_settings
      session[:referrer]="/account/company_settings"
      company_infos(current_user)
    end

    def user_photo_attachment(user,params)
      u_res = user.present?
      user.attachment.destroy if u_res && user.attachment.present?
      user.create_attachment(:image => params[:image]) if u_res
    end

    def transaction_history
      @business_type = current_user.business_type_id
      @trasactionhistory = TransactionDetail.where("user_id = ?",current_user.id).paginate(:page => params[:page], :per_page => 5)
    end

    def social_login_access_status(params)
      f_l = params[:first_name].present? && params[:last_name].present?
      pro_uui = params[:uid].present? && params[:provider].present?
      prov = (params[:provider]=="facebook" || params[:provider]=="twitter"|| params[:provider] == "linkedin")
      condition_status = f_l && pro_uui && prov
      return condition_status
    end

    def company_infos(user)
      unless user.company_name.blank?
       @status = user.social_setting_info
       @user_business_id = user.business_type_id
       @share_info  = ShareQuestion.user_social_setting_info(user)
       @subscribe = user.subscribe
      else
        flash[:non_fade_notice] =  "Please enter company name and email address."
        redirect_to "/users/edit"
      end
    end

    def check_trial_user_account_status
      @bitly_url=Bitly_url["url"]
      trail_user_expired = User.fetch_trial_expire_user
      trail_user_expired.each do |user|
        user.is_active=false
        user.save(:validate => false)
        InviteUser.trial_expired(user.email,user.first_name,@bitly_url).deliver if user.email
      end
    end

    def user_account
      @user = @current_user
    end

    def get_customer_info
      business_customer_infos = BusinessCustomerInfo.collection_of_business_users(@current_user.id)
      @customer_info_details = business_customer_infos.paginate(:page => params[:page], :per_page => BusinessCustomerInfo.count) unless business_customer_infos.empty?
    end

    def current_user_social_login_status(params)
      key = SecureRandom.hex(13)
      params_val ={:first_name => params[:first_name], :last_name => params[:last_name], :email =>key, :uid => params[:uid], :provider => params[:provider], :business_type_id => 1, :is_active => true, :exp_date => Time.now + 1.month, :authentication_token => key, :confirmed_at => Time.now}
      @current_user = User.new(params_val)
      @current_user.save(:validate => false)
      return  @current_user
    end

    def user_social_login_status(user)
      user.authentication_token = SecureRandom.hex(13)
      user.save(:validate => false)
      return  user
    end
  end
end