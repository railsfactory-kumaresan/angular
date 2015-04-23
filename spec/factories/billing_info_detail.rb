FactoryGirl.define do
  factory :billing_info_detail do
  	billing_name "Test Billing"
    billing_email "testbilling@gmail.com"
    billing_address "No.1, East coast road"
    billing_city "Bangalore"
    billing_state "Karnataga"
    billing_country "India"
    billing_zip "560089"
    billing_phone "9876543210"
  end
end