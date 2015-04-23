module UserMultitenant
  extend ActiveSupport::Concern
  included do

	 def self.create_corp_user(params)
		user_details = where(id: params[:parent_id]).first
		rand_pwd = generate_pwd
		user = User.new(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], is_active: true,exp_date: user_details.exp_date,tenant_id: params[:tenant_id],role_id: params[:role_id],
					company_name: user_details.company_name,business_type_id: user_details.business_type_id, password: rand_pwd, password_confirmation: rand_pwd, parent_id: user_details.id, confirmed_at: Time.now, step: "Multitenant")
   	return user,rand_pwd
	 end

	def self.generate_pwd
		chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
		return (0...8).collect { chars[Kernel.rand(chars.length)] }.join + "!"
	end

	def self.reset_user_password(params)
		user = where(id: params[:user_id]).first
		admin_email = where(id: user.parent_id).first.email
		new_password = generate_pwd
		user.update_attributes(password: new_password, password_confirmation: new_password)
		user.save(:validate => false)
		InviteUser.reset_user_password(user,admin_email,new_password).deliver if user.is_active
    return user
	end

  def self.change_status(params)
    user = where(id: params[:user_id]).first
    admin_email = where(id: user.parent_id).first.email
    status = params[:is_active] == "true" ? 0 : 1
    user.is_active = status
    user.save(:validate => false)
    active_and_deactive_mail(user,admin_email, status)
    return user.is_active
  end

  def self. active_and_deactive_mail(user,admin_email,status)
     password = User.generate_pwd
     if status == 1
       user.update_attributes(:password => password, :password_confirmation => password)
       user.save(:validate => false )
       InviteUser.user_deactivation(user,admin_email,password).deliver
     elsif status == 0
       InviteUser.user_deactivation(user,admin_email).deliver
     end
  end

  def self.update_corp_user(user,params)
    is_updated = user.is_active && (user.tenant_id != params[:tenant_id].to_i || user.role_id != params[:role_id].to_i || user.email != params[:email] || user.first_name != params[:first_name] || user.last_name != params[:last_name])
    user.first_name = params[:first_name]
    user.last_name  = params[:last_name]
    user.email = params[:email]
    user.tenant_id = params[:tenant_id].to_i
    user.role_id = params[:role_id].to_i
    user.step = 2
    user.skip_reconfirmation!
    user.save
    if user.errors.messages.blank?
      InviteUser.updated_user_details(user).deliver if is_updated
      return true
    end
  end

  def self.update_company_name(user, params)
     all_users = User.get_all_users(user)
     update_admin_company_name(user,params[:user][:company_name]) if user.parent_id != 0
     all_users.each do |u|
       u.company_name = params[:user][:company_name]
       u.save(:validate => false)
       InviteUser.delay.updated_user_details(u) if u.is_active
     end
  end

  def self.update_admin_company_name(user,company_name)
    admin = where(id: user.parent_id).first
    admin.company_name = company_name
    admin.save(:validate => false)
    InviteUser.admin_company_details(admin, user).deliver if admin.is_active
  end
end
 
 def fetch_tenant_users
   User.where(parent_id: self.id)
 end

 def same_url_update_user(user,tenant_url,params)
   tenant_url.each do|i|
     i.redirect_url = params[:user][:redirect_url]
     i.save(:validate => false)
     user_ten = User.where(tenant_id: i.id)
     user_ten.each do|o|
       o.redirect_url = params[:user][:redirect_url]
       o.save(:validate => false)
     end
   end
 end

  def same_number_update_user(user,tenant_no,params)
    tenant_no.each do|i|
      i.from_number = params[:user][:from_number]
      i.save(:validate => false)
      user_ten = User.where(tenant_id: i.id)
      user_ten.each do|o|
        o.from_number = params[:user][:from_number]
        o.save(:validate => false)
      end
    end
  end
end
