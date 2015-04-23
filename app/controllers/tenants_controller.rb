class TenantsController < ApplicationController
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  before_filter :check_role_level_permissions,:except => [:show, :index, :create, :update,:check_caller_id,:check_verify_caller_ids]
  before_action :check_tenant_limit, only: [:new, :create]
  before_action :check_valid_user
  before_filter :check_edit_permission, only: :edit

  # GET /tenants
  # GET /tenants.json
  def index
    @tenants = Tenant.get_tenant_list(current_user)
    @tenants = @tenants.paginate(:page => params[:page],:per_page => 10).order('id DESC')
  end

  # GET /tenants/1
  # GET /tenants/1.json
  def show
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants
  # POST /tenants.json
  def create
    assign_if_empty
    @tenant = Tenant.new(tenant_params)
    respond_to do |format|
      if @tenant.save
        format.html { redirect_to tenants_url, notice: 'Tenant was successfully created.' }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.html { render :new }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenants/1
  # PATCH/PUT /tenants/1.json
  def update
    respond_to do |format|
      assign_if_empty
      if @tenant.update(tenant_params)
        format.html { redirect_to tenants_url, notice: 'Tenant was successfully updated.' }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenants/1
  # DELETE /tenants/1.json
  def destroy
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to tenants_url }
      format.json { head :no_content }
    end
  end

  def change_tenant_status
    tenant_status = Tenant.change_tenant_status(params)
    render :json => {status: 200, message: "Success", is_active: tenant_status}
  end

  def check_caller_id
    result = ShareQuestion.check_outgoing_caller_ids(params[:from_number],current_user)
    render :json =>{code: result }
  end

  def check_verify_caller_ids
    resp = ShareQuestion.check_verified_caller_ids(current_user,params)
    render :json =>{message: resp }
  end

  def assign_if_empty
    current = current_user.parent_id.to_i.blank? || current_user.parent_id.to_i == 0 ? current_user : User.where(parent_id: current_user.parent_id)
    params[:tenant][:from_number] = params[:tenant][:from_number].blank? ? (current.from_number.blank? ? ENV["CALL_NUM"].gsub("+","") : current.from_number) : params[:tenant][:from_number]
    params[:tenant][:redirect_url] = params[:tenant][:redirect_url].blank? ? (current.redirect_url.blank? ? ENV["DEFAULT_REDIRECT_URL"] :current.redirect_url) : params[:tenant][:redirect_url]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find_by(id: params[:id])
      redirect_to tenants_path, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" } if @tenant.blank?
    end

    def check_tenant_limit
      redirect_to tenants_url, notice: "#{APP_MSG["authorization"]["limit"]}" unless current_user.get_tenant_count_limit
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:name, :address, :client_id, :redirect_url,:from_number)
    end

    def check_valid_user
      if current_user && current_user.company_name.blank?
        flash[:non_fade_notice] =  "Please enter company name and email address."
        redirect_to "/users/edit"
      end
    end
    
    def check_edit_permission
      user = current_user.parent_id.to_i == 0 ? current_user : User.find_by(id: current_user.parent_id)
      if !(@tenant.client_id == current_user.id || Tenant.get_tenant_list(user).include?(@tenant))
        redirect_to tenants_path, :flash => { :notice => "#{APP_MSG['authorization']['failure']}" }
      end      
    end
end
