require "spec_helper"

describe BillingInfoDetail do
 
	it { should belong_to(:user) }
	
	describe "find user billing info" do 
		it "User billing info record is found" do
			user = FactoryGirl.create(:user,:default_user,:role_id => Role.last.id)		
			billing_info_detail = FactoryGirl.create(:billing_info_detail, :user_id => user.id)		
			expect(BillingInfoDetail.find_user_billing_info(user)).to eq(billing_info_detail)
		end
	end

	describe "create billing info details" do 
		it "User billing info record is found" do
			user = FactoryGirl.create(:user,:default_user,:role_id => Role.last.id)		
params =  { "plan_id"=>PricingPlan.last.id, "plan_action"=>"upgrade", "billing_name"=>"test Test",
                    "billing_email"=>"muthuselvam@railsfactory.org", "billing_address"=>"chennai India",
                    "billing_city"=>"Chennai", "billing_state"=>"Tamilnadu", "billing_country"=>"IN", "billing_zip"=>"600002",
                    "billing_tel"=>"9874561230", "bus_type"=>""}
 result = BillingInfoDetail.create_billing_info_details(user, params)										
			expect(result).to eq(BillingInfoDetail.last)
		end
		it "User billing info record is found" do
			user = FactoryGirl.create(:user,:default_user,:role_id => Role.last.id)		
			billing_info_detail = FactoryGirl.create(:billing_info_detail, :user_id => user.id)	
params =  { "plan_id"=>PricingPlan.last.id, "plan_action"=>"upgrade", "billing_name"=>"test Test",
                    "billing_email"=>"muthuselvam@railsfactory.org", "billing_address"=>"chennai India",
                    "billing_city"=>"Chennai", "billing_state"=>"Tamilnadu", "billing_country"=>"IN", "billing_zip"=>"600002",
                    "billing_tel"=>"9874561230", "bus_type"=>""}
 result = BillingInfoDetail.create_billing_info_details(user, params)										
			expect(result).to eq(true)
		end		
	end	
end	