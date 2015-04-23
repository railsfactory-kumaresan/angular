require 'spec_helper'

describe DistributeController do

	describe "#check_business_customer" do 
		before(:each){
			@user = FactoryGirl.create(:user,:default_biz_user)
			@business_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id)		
		}		
		it "check business customer record as true" do
			params = {email: @business_customer_info.email, user_id: @user.id}
			@request.env["HTTP_ACCEPT"] = 'application/json'
			post :check_business_customer, params
			expect(JSON.parse(response.body)["is_record"]).to eq(true)
		end
		it "check business customer record as false" do
			params = {email: @business_customer_info.email, user_id: nil}
			@request.env["HTTP_ACCEPT"] = 'application/json'
			post :check_business_customer, params
			expect(JSON.parse(response.body)["is_record"]).to eq(false)
		end		
	end
	
	describe "#create_business_customer" do 
		it "create business customer record as true" do
			user = FactoryGirl.create(:user,:default_biz_user)
			customer_params = FactoryGirl.build(:business_customer_info).attributes.except("id", "created_at", "updated_at").merge(user_id: user.id)
			params = {customer: customer_params}
			@request.env["HTTP_ACCEPT"] = 'application/json'
			post :create_business_customer, params
			expect(JSON.parse(response.body)["customer"]["customer_name"]).to eq(customer_params["customer_name"])
		end
		it "create business customer bulk records with failures" do
			user = FactoryGirl.create(:user,:default_biz_user)
			customer_params = [FactoryGirl.build(:business_customer_info).attributes.except("id", "created_at", "updated_at").merge(user_id: user.id), FactoryGirl.build(:business_customer_info).attributes.except("id", "created_at", "updated_at").merge(user_id: user.id)]
			params = {customer: customer_params}
			@request.env["HTTP_ACCEPT"] = 'application/json'
			post :create_business_customer, params
			expect(JSON.parse(response.body)["result"][1]["errors"]["email"][0]).to eq("has already been taken")
			expect(JSON.parse(response.body)["successfull"]).to eq(1)
			expect(JSON.parse(response.body)["failed"]).to eq(1)
		end		
		it "create business customer bulk records with all success" do
			user = FactoryGirl.create(:user,:default_biz_user)
			customer_params = [FactoryGirl.build(:business_customer_info).attributes.except("id", "created_at", "updated_at").merge(user_id: user.id), FactoryGirl.build(:business_customer_info, email: "test12@gmail.com", mobile: "9876556789").attributes.except("id", "created_at", "updated_at").merge(user_id: user.id)]
			params = {customer: customer_params}
			@request.env["HTTP_ACCEPT"] = 'application/json'
			post :create_business_customer, params
			expect(JSON.parse(response.body)["errors"]).to eq(nil)
			expect(JSON.parse(response.body)["successfull"]).to eq(2)
			expect(JSON.parse(response.body)["failed"]).to eq(0)
		end			
	end		
end	