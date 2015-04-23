FactoryGirl.define do
  factory :share_question do
    email_address "ibm@ibm.com"
    provider "twitter"
    social_id "Twitter"
    social_token "someToken"
    # user_id # this will be taken from user model
    active true
    user_name "International Business Machines"
    user_profile_image "/images/profile.png"
  end

  factory :existing_social_user, :class => ShareQuestion do
    email_address "ibm@ibm.com"
    provider "twitter"
    social_id "Twitter"
    social_token "someToken"
    # user_id # this will be taken from user model
    active true
    user_name "International Business Machines"
    user_profile_image "/images/profile.png"
  end

  factory :existing_social_user_fb, :class => ShareQuestion do
    email_address "ibm1@ibm.com"
    provider "facebook"
    social_id "Facebook"
    social_token "someToken"
    # user_id # this will be taken from user model
    active true
    user_name "International Business Machines"
    user_profile_image "/images/profile.png"
  end
  
  factory :share_social_account, :class => ShareQuestion do
    email_address "naga.test001@gmail.com"
    provider "facebook"
    social_id "100003372186341"
    social_token "CAAGNU4ZB42ZBYBAIuwDOVP5VOt4LpmVZCyV6hcro7zH2YQ5WoayhyulxEWwwiRFXh6XZBLBjdYNjiRVNBBGZCswXg6KeCfgjOQumZAZBKykmk3QBMxYGxUszqjZA3xZBhuaDsRndSjY0rFttKIr5UtZBsJxvsrVATOE9vI9ziCnjjbQGv7nYWhEddR5tvsrZBSkOLmxeD93zWDIaNMHSM7iP89C"
    active true
    user_name "Naga Tester"
    user_profile_image "/images/profile.png"    
  end
  
  factory :existing_social_user_linkedin, :class => ShareQuestion do
    email_address "ibm1@ibm.com"
    provider "linkedin"
    social_id "Linkedin"
    social_token "someToken"
    # user_id # this will be taken from user model
    active true
    user_name "International Business Machines"
    user_profile_image "/images/profile.png"
  end


  factory :share_question_new, :class => ShareQuestion do
    active true
    user_profile_image "/images/profile.png"

    trait :provider_email do
      email_address "test@gmail.com "
      provider "Email"
    end

    trait :provider_sms do
      email_address "test@gmail.com "
      provider "Sms"
    end

    trait :provider_facebook do
      email_address "test@gmail.com "
      provider "facebook"
    end

    trait :provider_twitter do
      email_address "test@gmail.com "
      provider "twitter"
    end

    trait :provider_linkedin do
      email_address "test@gmail.com "
      provider "linkedin"
    end
  end
end