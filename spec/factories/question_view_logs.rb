FactoryGirl.define do
  factory :question_view_log do  

    trait :provider_fb do
      provider "Facebook"
      cookie_token_id 1392577879
    end
    trait :provider_twitter do
      provider "Twitter"
      cookie_token_id 2345678901
    end
  end
end
