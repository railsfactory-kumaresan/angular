class BillingInfoDetail < ActiveRecord::Base
  belongs_to :user

  def self.create_billing_info_details(current_user,params)
    user_exist = BillingInfoDetail.where(user_id: current_user.id).first
    if user_exist.blank?
    self.create(user_id: current_user.id,billing_name: params[:billing_name],billing_email: params[:billing_email],billing_address:
        params[:billing_address],billing_city: params[:billing_city],billing_state: params[:billing_state],billing_country: params[:billing_country],
                billing_zip: params[:billing_zip],billing_phone:params[:billing_tel])
    else
      user_exist.update_attributes(user_id: current_user.id,billing_name: params[:billing_name],billing_email: params[:billing_email],billing_address:
          params[:billing_address],billing_city: params[:billing_city],billing_state: params[:billing_state],billing_country: params[:billing_country],
                             billing_zip: params[:billing_zip],billing_phone:params[:billing_tel])
    end
  end

  def self.find_user_billing_info(current_user)
   where(user_id:current_user.id).first
  end

end
