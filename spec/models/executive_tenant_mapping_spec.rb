require "spec_helper"

describe ExecutiveTenantMapping do
  before(:each) {
    @user = FactoryGirl.create(:user,:default_biz_user)
    @tenant = FactoryGirl.create(:tenant)
    @executive_tenant = FactoryGirl.create(:executive_tenant_mapping, user_id: @user.id, tenant_id: @tenant.id)
  }

	describe "#get_tenant_ids" do
		 it "should get tenant ids" do
			tenant_ids = ExecutiveTenantMapping.get_tenant_ids(@user.id)
			expect(tenant_ids).to eq([@tenant.id])
		end
	end

	describe "#map_tenant" do
		it "map the tenant for existing user" do
			params = {:user_id => @user.id, :user_ids => [@tenant.id]}
			id = ExecutiveTenantMapping.map_tenant(params)
		end
		it "map the tenant for new user" do
			user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
			params = {:user_id => user.id, :user_ids => [@tenant.id]}
			id = ExecutiveTenantMapping.map_tenant(params)
		end
		it "map the tenant for existing user with status false" do
			user = FactoryGirl.create(:user,:facebook_user, :uid => "1234")
			executive_tenant = FactoryGirl.create(:executive_tenant_mapping, user_id: user.id, tenant_id: @tenant.id, is_active: false)
			params = {:user_id => user.id, :user_ids => [@tenant.id]}
			id = ExecutiveTenantMapping.map_tenant(params)
		end		
	end
	
	describe "#is_already_mapped" do
		 it "check is already mapped as true" do
			executive_tenants = ExecutiveTenantMapping.is_already_mapped?(@tenant.id, @user.id)
			expect(executive_tenants.last).to eq(@executive_tenant)
		end
		 it "check is already mapped as false" do
			executive_tenants = ExecutiveTenantMapping.is_already_mapped?(@tenant.id, nil)
			expect(executive_tenants.last).to eq(nil)
		end		
	end

	describe "#already_mapped_user" do
		 it "check is already mapped user" do
			tenant_ids = ExecutiveTenantMapping.already_mapped_user(@user.id)
			expect(tenant_ids.last).to eq(@tenant.id)
		end
		 it "check is already mapped user when user id is nil" do
			tenant_ids = ExecutiveTenantMapping.already_mapped_user(nil)
			expect(tenant_ids.last).to eq(nil)
		end		
	end

	describe "#mapped_user_active_status" do
		 it "change mapped user active status" do
			id = ExecutiveTenantMapping.mapped_user_active_status(@user.id, nil).last
			active_status = ExecutiveTenantMapping.find(id).is_active
			expect(active_status).to eq(false)
		end
	end
	
end