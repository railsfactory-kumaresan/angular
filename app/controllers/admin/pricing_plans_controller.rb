class Admin::PricingPlansController < InheritedResources::Base
  #before_filter :check_admin,:except => ["request_listener"]
  before_filter :check_role_level_permissions
  before_filter :authenticate_user_web_api
  layout 'pricing_plan'

  # GET /pricing_plans
  # GET /pricing_plans.json
  def index
    @pricing_plans = PricingPlan.list_all_plans.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pricing_plans }
    end
  end

  # GET /pricing_plans/1
  # GET /pricing_plans/1.json
  def show
    @pricing_plan = PricingPlan.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pricing_plan }
    end
  end

  # GET /pricing_plans/new
  # GET /pricing_plans/new.json
  def new
    @pricing_plan = PricingPlan.new
    @category_types = CategoryType.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pricing_plan }
    end
  end

  # GET /pricing_plans/1/edit
  def edit
    @category_types = CategoryType.all
    @pricing_plan = PricingPlan.find(params[:id])
  end

  # POST /pricing_plans
  # POST /pricing_plans.json
  def create
    @pricing_plan = PricingPlan.new(pricing_params)
    respond_to do |format|
      if @pricing_plan.save
        format.html { redirect_to [:admin, @pricing_plan], notice: 'Pricing plan was successfully created.' }
        format.json { render json: @pricing_plan, status: :created, location: @pricing_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @pricing_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pricing_plans/1
  # PUT /pricing_plans/1.json
  def update
    @pricing_plan = PricingPlan.find(params[:id])
    respond_to do |format|
      if @pricing_plan.update_attributes(pricing_params)
        format.html { redirect_to [:admin, @pricing_plan], notice: 'Pricing plan successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pricing_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pricing_plans/1
  # DELETE /pricing_plans/1.json

  # def destroy
  #   @pricing_plan = PricingPlan.find(params[:id])
  #   @pricing_plan.destroy

  #   respond_to do |format|
  #     format.html { redirect_to pricing_plans_url }
  #     format.json { head :no_content }
  #   end
  # end


private

def pricing_params
  params.require(:pricing_plan).permit(:listener,:expired_date,:questions_count,:video_photo_count,:email_count,:sms_count,:call_count,:question_suggestions,:qr_share,:social_share,:embed_share,:plan_name, :business_type_id,:tenant_count,:customer_records_count,:language_count,:redirect_url,:from_number, :crawler_slots, :listener_slots, :email_alerts, :amount,category_type_ids: [])
end

  def check_admin
    if !current_user.blank?
    admin_true = User.where(id: current_user.id, admin: true)
    if admin_true.blank?
      flash[:notice] = "#{APP_MSG['authorization']['failure']}"
      redirect_to "/"
    end
    else
      flash[:notice] = "#{APP_MSG['authorization']['failure']}"
      redirect_to "/"
    end
  end

end