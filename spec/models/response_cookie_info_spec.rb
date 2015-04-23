require "spec_helper"

describe ResponseCookieInfo do
  before(:each) do
    @response_cookie_info = FactoryGirl.create(:response_cookie_info)
  end
 
 describe "#Association" do
  it { should belong_to(:response_token) }
end

  context "self.find_user_info" do
    it "must return its response token" do
      biz_user = FactoryGirl.create(:user, :default_biz_user)
      cookie_token = FactoryGirl.create(:cookie_token)
      biz_customer_info = FactoryGirl.create(:business_customer_info, :user_id => biz_user.id)
      response_cookie_infos = FactoryGirl.create(:response_cookie_info,
        cookie_token_id: cookie_token.id, response_token_type: "BusinessCustomerInfo",
        response_token_id: biz_customer_info.id)
      expected_result = ResponseCookieInfo.find_user_info(response_cookie_infos.id)
      expect(expected_result).to eq(response_cookie_infos.response_token)
    end
  end

  context "self.check_country_and_age" do
    it "must return country, age and gender of an user" do
      biz_user = FactoryGirl.create(:user, :default_biz_user)
      cookie_token = FactoryGirl.create(:cookie_token)
      biz_customer_info = FactoryGirl.create(:business_customer_info, :user_id => biz_user.id)
      response_cookie_infos = FactoryGirl.create(:response_cookie_info,
        cookie_token_id: cookie_token.id, response_token_type: "BusinessCustomerInfo",
        response_token_id: biz_customer_info.id)
      expected_result = ResponseCookieInfo.check_country_and_age(cookie_token.uuid)
      expect(expected_result).to eq([biz_customer_info.country, biz_customer_info.age, biz_customer_info.gender])
    end
  end

  context "self.find_user_age_gender" do
    it "must return age and gender of an user" do
      biz_user = FactoryGirl.create(:user, :default_biz_user)
      cookie_token = FactoryGirl.create(:cookie_token)
      biz_customer_info = FactoryGirl.create(:business_customer_info, :user_id => biz_user.id)
      response_cookie_infos = FactoryGirl.create(:response_cookie_info,
        cookie_token_id: cookie_token.id, response_token_type: "BusinessCustomerInfo",
        response_token_id: biz_customer_info.id)
      expected_result = ResponseCookieInfo.find_user_age_gender(cookie_token.uuid)
      expect(expected_result).to eq([biz_customer_info.age, biz_customer_info.gender])
    end
  end

  context "self.create_new_record" do
    it "must create a cookie" do
      ResponseCookieInfo.delete_all
      biz_user = FactoryGirl.create(:user, :default_biz_user)
      cookie_token = FactoryGirl.create(:cookie_token)
      ResponseCookieInfo.create_new_record(biz_user.id, cookie_token.id)
      expect(ResponseCookieInfo.count).to eq(1)
    end
  end
end