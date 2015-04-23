FactoryGirl.define do
  factory :answer do
  	provider "email"
    option "Nassau"
    is_business_user false
    is_deactivated false
    is_other false
  end
end