class ExecutiveTenantMapping < ActiveRecord::Base

  def self.get_tenant_ids(user_id)
    tenant_ids = where(user_id: user_id, is_active: true).map(&:tenant_id)
  end

  def self.map_tenant(params)
    params[:user_ids].each do |id|
      check_exist = is_already_mapped?(id,params[:user_id])
      if check_exist.blank?
       self.create(:user_id => params[:user_id],:tenant_id => id,:is_active => true)
      else
        if check_exist.first.is_active == false
          check_exist.first.update_attributes(is_active: true)
       end
     end
    end
    mapped_user_active_status(params[:user_id],params[:user_ids])
  end

  def self.is_already_mapped?(id,user_id)
     return where(user_id:user_id,tenant_id: id)
  end

  def self.already_mapped_user(user)
    where(user_id:user,is_active: true).pluck(:tenant_id)
  end

  def self.mapped_user_active_status(user_id,t_ids)
     ids = t_ids.blank? ? where(user_id:user_id).pluck(:id) : where(user_id:user_id).where("tenant_id NOT in(#{t_ids.join(",")})").pluck(:id)
     ids.each do |i|
       self.find(i).update_attributes(is_active: false)
     end
  end
end
