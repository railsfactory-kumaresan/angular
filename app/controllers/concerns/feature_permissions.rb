module FeaturePermissions
  extend ActiveSupport::Concern
  included do

def edit
  @parent_features = Feature.get_parent_features
end

def update
params["feature"].each do |key,value|
  key_split =   key.split("-")
  controller_name = key_split[0]
  action_name = key_split[1]
  role_id = key_split[2]
  attrs = {controller_name: controller_name, action_name: action_name, role_id: role_id}
  Permission.update_or_create(attrs,value)
end
flash[:notice] = 'Permissions were successfully updated.'
redirect_to :action => "index"
end


end
end