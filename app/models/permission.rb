class Permission < ActiveRecord::Base
 belongs_to :role
 validates :role_id, :uniqueness => {:scope => [:controller_name, :action_name]}

 def self.get_user_permissions(user)
  user.role.permissions
 end

 def self.define_permissions(user)
  @permission_hash = {}
  permissions = self.get_user_permissions(user)
  permissions.each do |permission|
   @permission_hash["#{permission.controller_name}"] = {} if @permission_hash["#{permission.controller_name}"].nil?
   @permission_hash["#{permission.controller_name}"].merge!({"#{permission.action_name}" => permission.access_level})
  end
  @permission_hash
 end

 def self.check_controller_permission(controller,user,permissions)
  permissions.keys.include?(controller) ? true : false
 end

 def self.check_action_permission(action,controller,permissions)
  permissions[controller][action]
 end

 def self.check_user_role_permissions(controller,action,current_user,permissions)
   if Permission.check_controller_permission(controller,current_user,permissions)
      Permission.check_action_permission(action,controller,permissions)
    else
     false
   end
  end

def self.check_feature_permission(sub_feature,role_id)
  permission = where("role_id =? and controller_name =? and action_name =?",role_id,sub_feature.controller_name,sub_feature.action_name)
  permission.blank? ? false : permission[0].access_level
end

def self.update_or_create(args,access_level)
  permission = where(args)[0]
  if permission.blank? && access_level != '0'
    args.merge!({access_level: access_level})
    permission = self.create(args)
  elsif permission && (permission.access_level != access_level)
   permission.update(access_level: access_level)
  end
end

end
