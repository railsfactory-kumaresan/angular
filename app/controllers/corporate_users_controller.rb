class CorporateUsersController < ApplicationController
  before_filter :authenticate_user_web_api
  before_filter :check_role_level_permissions, :only => [:index, :edit, :new, :change_user_status, :reset_password, :mapping_tenant]
  before_action :set_corporate_user, only: [:show, :edit, :update, :destroy]
  before_action :tenant_details
  before_action :check_tenant, only: [:new, :index]
  before_filter :check_edit_permission, only: :edit

  # GET /corporate_users
  # GET /corporate_users.json
  def index
    @corporate_users = User.get_all_users(current_user).where.not(id: current_user.id)
    @corporate_users = @corporate_users.paginate(:page => params[:page],:per_page => 10).order('id DESC')
  end

  # GET /corporate_users/1
  # GET /corporate_users/1.json
  def show
  end

  # GET /corporate_users/new
  def new
    @corporate_user = User.new
  end

  # GET /corporate_users/1/edit
  def edit
  end

  # POST /corporate_users
  # POST /corporate_users.json
  def create
    @corporate_user, password = User.create_corp_user(corporate_user_params)
    respond_to do |format|
        if @corporate_user.save
          admin_email = User.where(id: @corporate_user.parent_id).first.email
          InviteUser.corporate_user_confirmation(@corporate_user,admin_email,password).deliver
          format.html { redirect_to corporate_users_path, notice: "#{APP_MSG['corporate_user']['create']}" }
          format.json { render :show, status: :created, location: corporate_user_path }
        else
          format.html { render :new }
          format.json { render json: @corporate_user.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /corporate_users/1
  # PATCH/PUT /corporate_users/1.json
  def update
    respond_to do |format|
      if User.update_corp_user(@corporate_user,corporate_user_params)
        format.html { redirect_to corporate_users_path, notice: "#{APP_MSG['corporate_user']['update']}" }
        format.json { render :show, status: :ok, location: @corporate_user }
      else
        format.html { render :edit }
        format.json { render json: @corporate_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corporate_users/1
  # DELETE /corporate_users/1.json
  def destroy
    @corporate_user.destroy
    respond_to do |format|
      format.html { redirect_to corporate_users_url }
      format.json { head :no_content }
    end
  end

  def change_user_status
    user_status = User.change_status(params)
    render :json => {status: 200, message: "Success", is_active: user_status}
  end

  def reset_password
    user = User.reset_user_password(params)
    render :json => {status: 200, message: user.is_active? ? "New password emailed to user #{user.first_name}" : "#{user.first_name} password has been changed"}
  end
  
  #users map to tenant
  def mapping_tenant
    @tenants = Tenant.where(:client_id => current_user.id, :is_active => true)
    @users = current_user.corporate_user
  end

  #search users by email
  def search_user_by_email
    @users = User.get_all_users(current_user).where(email:params[:email], is_active: true).first
    get_tenants_user(@users)
  end

  def get_tenants_user(users)
    if !users.blank?
    @mapped_details = ExecutiveTenantMapping.already_mapped_user(users.id)
    tenant = @mapped_details.blank? ? Tenant.where(client_id: current_user.id, is_active: true) : Tenant.where(client_id: current_user.id, is_active: true).where("id NOT in (?)", @mapped_details)
    @mapped_tenant = Tenant.where(id:@mapped_details)
    @tenants = @mapped_tenant + tenant
    end
  end

  #autocomplete users
  def search_user
    result = []
    users = User.get_all_users(current_user).where("email LIKE ? AND is_active is TRUE", "%#{params[:term]}%")
    users.collect{|i|result << {'label' => i.email}}
    render :json => result
  end

  def get_all_user
    user = User.where("email NOT IN (?) AND (parent_id is NULL OR parent_id =(?))", DEFAULTS["internal_emails"], 0).map(&:email)
    render :json => user
  end
  
  #update the tenant name to user
  def update_tenant_users
  respond_to do |format|
    if params["user_ids"].present?
      ExecutiveTenantMapping.map_tenant(params)
    else
      ExecutiveTenantMapping.mapped_user_active_status(params[:user_id],params[:user_ids])
    end
    @users = User.where(id:params[:user_id]).first
    get_tenants_user(@users)
    InviteUser.manage_executive_tenants(@users, @mapped_tenant).deliver if @mapped_tenant.count > 0
    format.js
   end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_corporate_user
    @corporate_user = User.find_by(id: params[:id])
    redirect_to corporate_users_path, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" } if @corporate_user.blank?
  end

  def tenant_details
    @tenants = Tenant.get_tenant_list(current_user).collect{|a| [a.name,a.id] if a.is_active}.compact
    @roles = Role.default_roles_with_custom_roles(current_user).collect {|b| [b.name, b.id]}.compact
  end

  def check_tenant
    tenant = Tenant.where(client_id: (current_user.parent_id != 0 && current_user.parent_id != nil ? current_user.parent_id : current_user.id))
    redirect_to tenants_url, notice: "#{APP_MSG["tenant"]["present"]}" if tenant.blank?
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def corporate_user_params
    params.require(:user).permit!
  end
  
  def check_edit_permission
    user = current_user.parent_id.to_i == 0 ? current_user : User.find_by(id: current_user.parent_id)
    if !(User.get_all_users(user).include?(@corporate_user))
      redirect_to corporate_users_path, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
    end      
  end    
    
end
