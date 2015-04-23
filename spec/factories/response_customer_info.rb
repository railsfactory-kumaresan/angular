FactoryGirl.define do
  factory :response_customer_info do
    customer_name "IBM"
    email "ibm@ibm.com"
    response_status true
    view_status true
    gender "male"
    # question_id # will be defined by taking a question id
    provider "Twiytter"
    date_of_birth (Date.today - 20.years)
    age 20
    country "IN"
    state "TN"
    city "Chennai"
    area "Sithalapakkam"
  end
end