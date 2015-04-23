class ManageRolesController < ApplicationController
include FeaturePermissions
before_filter :check_role_level_permissions, :except =>[:create, :update]
before_filter :check_edit_permission, only: :edit

    def index
  @roles = Role.get_tenant_roles(current_user)
    end


def new
 @role = Role.new
  respond_to do |format|
   format.html
  end
end


def create
	user_id = current_user.parent_id == 0 ? current_user.id : current_user.parent_id
@role = Role.new(:name=>params["role"]["name"],:user_id=>user_id)
if @role.save
   flash[:notice] = 'Role was created successfully'
   render js: %(window.location.href='/manage_roles')
else
	render :new
end

end

private

  
  def check_edit_permission
    @role = Role.get_role_by_id(params[:id])
    user = current_user.parent_id.to_i == 0 ? current_user : User.find_by(id: current_user.parent_id)
    if @role.blank? || !(["Super-Admin", "Executive"].include?(@role.name) || @role.user_id == user.id)
      redirect_to manage_roles_path, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
    end      
  end    


end