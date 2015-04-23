class Admin::PermissionsController < ApplicationController
before_filter :check_role_level_permissions
before_filter :authenticate_user_web_api
layout 'admin_layout'
include FeaturePermissions

def index
  @roles = Role.get_all_roles.paginate(:page => params[:page], :per_page => 10)
end


end


