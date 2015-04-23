require 'spec_helper'
require 'factory_girl_rails'

##
# Since payments stuff are not truly defined,
# we are just seeing if certain actions exists
describe TenantsController do
  # include Devise::TestHelpers
  before(:each){
    User.delete_all
    Role.delete_all
    @role = FactoryGirl.create(:role,:first_plan)
    @pricing_plan = PricingPlan.where(plan_name: "Solo").first
    @user = FactoryGirl.create(:user,:default_user,:role_id => @role.id,:authentication_token => "8982jd9sjdskd02ejskdsdoj",:business_type_id => @pricing_plan.business_type_id.to_i )
    @tenant = FactoryGirl.create(:tenant, :client_id => @user.id)
    @tenant_build = FactoryGirl.build(:valid_tenant)
    controller.stub(:check_admin_user).and_return(@user)
    controller.stub(:check_listener_module).and_return(true)
    controller.stub(:verified_request?).and_return(true)
    controller.stub(:catch_exceptions).and_yield
    controller.stub(:verify_session).and_return(true)
    controller.stub(:check_role_level_permissions).and_return(true)
    controller.stub(:check_tenant_limit).and_return(true)
    @controller.stub(:current_user) { @user }
  }
	
	describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    
    it "renders the index template for check valid user" do
    @user.company_name = nil
    @user.save(:validate => false)
    expect(controller).to receive(:check_valid_user).and_call_original
      get :index
      response.should redirect_to "/users/edit"
    end    
  end
  
  
  describe "GET #show" do 
    it "assigns the requested tenant to @tenant" do 
      get :show, id: @tenant 
      assigns(:tenant).should eq(@tenant) 
    end 
    it "renders the #show view" do
      get :show, id: @tenant
      response.should render_template :show 
    end
  end 
	

describe "GET #new" do 
  it "build new object for tenant" do 
    get :new
      assigns(:tenant).class.should eq(Tenant)
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  it "build new object for tenant as false" do 
    FactoryGirl.create(:client_setting, :client_feature_settings, user_id: @user.id, pricing_plan_id: @pricing_plan.id)
    expect(controller).to receive(:check_tenant_limit).and_call_original
    get :new
    response.should redirect_to "/tenants"
  end    
end

describe 'POST #create' do
context "Tenant Creation in valid" do
  it 'create a new tenant ' do
    post :create, tenant: @tenant_build.attributes
    expect(Tenant.count).to eq(2)
  end
  it 'create a new tenant and redirect_to to show ' do
    post :create, tenant: @tenant_build.attributes
    response.should redirect_to "/tenants"
  end
end
context "Tenant with invalid parameter" do
   it "re-render the new action" do
    post :create, tenant: @tenant.attributes
  end
end
end


describe 'PUT #updare' do
  context "valid attributes" do
    it "located the requested @tenant" do 
      put :update, id: @tenant, tenant: @tenant_build.attributes
      assigns(:tenant).should eq(@tenant) 
    end
  end
  it "changes the @tenant" do
    put :update, id: @tenant, tenant: { name: "kfc", address: "thavarakere"}
    @tenant.reload 
    @tenant.name.should eq("kfc") 
    @tenant.address.should eq("thavarakere") 
  end
    it "located the requested @tenant" do 
      put :update, id: @tenant.id, tenant: { name: "", address: "thavarakere"}
    end  
end
  
describe "DELETE #destroy" do
  it "delete the tenant record" do 
    delete :destroy, id: @tenant.id
    response.should redirect_to "/tenants"
  end
end

describe "GET #check_caller_id" do
  it "To check the caller id" do 
    params = {from_number: "919994587002"}
    get :check_caller_id, params
    expect(JSON.parse(response.body)["code"]).to eq("Authenticate")
  end
end

describe "GET #check_verify_caller_ids" do
  it "To check the verify caller ids" do 
    params = {from_number: "919994587002", tenant: "true"}
    get :check_verify_caller_ids, params
  end
end

describe 'Active the tenant' do
  it "sholud active the teanant" do
    post :change_tenant_status, tenant_id: @tenant.id, is_active: "false"
    parsed_body = JSON.parse(response.body)
    parsed_body["is_active"].should == true
    expect(response.status).to eq(200)
  end
   it "sholud not active the teanant" do
    post :change_tenant_status, tenant_id: @tenant.id, is_active: "true"
    parsed_body = JSON.parse(response.body)
    parsed_body["is_active"].should == false
    expect(response.status).to eq(200)
  end
end

end


