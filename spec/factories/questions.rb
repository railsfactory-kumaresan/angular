FactoryGirl.define do
  factory :question do
    include_text false
    include_other false
    include_comment false
    status "Active"
    qrcode_status false
    language "English"
    #question_type_id QuestionType.pluck(:id).first
    #category_type_id CategoryType.pluck(:id).first
    question_type_id 1
    category_type_id 1
    thanks_response "Testing Response"
    question "Whats the capital of bahamas?"
    slug "sa23424#{Random.rand(114444444)}d44dfsd"

    trait :year_wise_expire do
      expiration_id  "1 Year"
    end

    trait :category_type_feedback do
     category_type_id 1
   end
   trait :category_type_marketing do
     category_type_id 3
   end
   trait :category_type_innovation do
     category_type_id 2
   end
   trait :month_wise_expire do
    expiration_id  "1 Month"
  end
  trait :week_wise_expire do
    expiration_id  "1 Week"
  end

  trait :without_expired_at do
    expired_at nil
  end

  trait :expired_at_set_to_365_days do
    expiration_id  "1 Year"
    expired_at Time.now + 365.days
  end

  trait :expired_at_in_past do
    expiration_id  "1 Year"
      expired_at Time.now - 4.days # Some expiration id in the past
    end
  end
  factory :questions, :class => Question do
    sequence(:question) { |n| "Whats the #{n} Question name?" }
    include_text false
    include_other false
    include_comment false
    status "Active"
    qrcode_status false
    language "English"
    #~ question_type_id QuestionType.select(:id).map(&:id).first
    #~ category_type_id CategoryType.select(:id).map(&:id).first
    question_type_id "1"
    category_type_id "1"
    thanks_response "Testing Response"
    expiration_id  "1 Year"
    expired_at Time.now - 4.days
  end

  factory :video_question, class: Question do
    question "Which city do you like?"
    category_type_id 1
    expiration_id "1 Day"
    language "English"
    private_access 0
    video_url "http://localhost:3000/data/00.Please Check this.6_.jpg"
    video_type 2
    question_type_id 3
    thanks_response "Thanks for response"
    slug "19b4ace056d9e04d6ae7c52a3f70a558"
  end
end
