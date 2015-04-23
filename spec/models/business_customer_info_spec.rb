require "spec_helper"
include ActionDispatch::TestProcess
describe BusinessCustomerInfo do

  before(:each) do
    @biz_user = FactoryGirl.create(:user, :default_biz_user)
    @cookie_token = CookieToken.create(uuid: "somegenerateduuid")
    @biz_customer_info = FactoryGirl.create(:business_customer_info, user: @biz_user,
      cookie_token_id: @cookie_token.id, :status => nil)
    @cookie_token_for_response = CookieToken.create(uuid: "somegenerate#{Random.rand(114444444)}d1")
    @response_cookie_info = FactoryGirl.create(:response_cookie_info,
      cookie_token_id: @cookie_token_for_response.id, response_token_id: @biz_user.id,
      response_token_type: @biz_user.class.to_s )
    end

 describe "#Association" do
  it { should belong_to(:user) }
  it { should have_many(:answers) }
  it { should have_many(:response_cookie_info) }
  it { should belong_to(:cookie_token) }
end

describe "#validation" do
  #~ it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).scoped_to(:user_id) }
  #~ it { should validate_presence_of(:mobile) }
  #it { should validate_uniqueness_of(:mobile).scoped_to(:user_id).with_message("This phone number already exist") }
end
  describe "self.check_user_already_exist" do
    it "must return true for already existing business customer info" do
      info_present = BusinessCustomerInfo.check_user_already_exist(@biz_customer_info.email,
        @biz_customer_info.customer_name,
        @biz_user.id)
      expect(info_present).to eq(true)
    end

    it "must return false for unknown email" do
      info_present = BusinessCustomerInfo.check_user_already_exist("unknown@gmail.com",
        @biz_customer_info.customer_name,
        @biz_user.id)
      expect(info_present).to eq(false)
    end

    it "must return false for unknown customer name" do
      info_present = BusinessCustomerInfo.check_user_already_exist(@biz_customer_info.email,
        "unknon name",
        @biz_user.id)
      expect(info_present).to eq(false)
    end

    it "must return false for unown business user id" do
      unknown_id = BusinessCustomerInfo.maximum(:id) + 1
      info_present = BusinessCustomerInfo.check_user_already_exist(@biz_customer_info.email,
        @biz_customer_info.customer_name,
        unknown_id)
      expect(info_present).to eq(false)
    end
  end

  describe "self.find_business_customer_info" do
    it "must return business customer info if right information is given" do
      email = @biz_customer_info.email
      user_id = @biz_user.id
      info_found = BusinessCustomerInfo.find_business_customer_info(email, user_id)
      expect(info_found).to eq(@biz_customer_info)
    end

    it "must not return business customer info if wrong email is given" do
      email = "somewrong@email.com"
      user_id = @biz_user.id
      info_found = BusinessCustomerInfo.find_business_customer_info(email, user_id)
      expect(info_found).to eq(nil)
    end

    it "must not return business customer info if wrong user_id is given" do
      email = @biz_customer_info.email
      user_id = @biz_user.id+1
      info_found = BusinessCustomerInfo.find_business_customer_info(email, user_id)
      expect(info_found).to eq(nil)
    end
  end

  describe "create_response_cookie_info" do
    it "must create response cookie info" do
      ResponseCookieInfo.delete_all
      response_cookie_info = @biz_customer_info.create_response_cookie_info(@cookie_token_for_response.uuid, nil)
      expect(response_cookie_info.response_token).to eq(@biz_customer_info)
    end
  end

  describe "self.get_customer_info_by_uuid" do
    it "must get right business customer info when right cookie token uuid is suplied" do
      cus_id = Base64.encode64( ActiveSupport::JSON.encode(@biz_customer_info.id))
      business_customer_info = BusinessCustomerInfo.get_customer_info(cus_id)
      expect(business_customer_info).to eq(@biz_customer_info)
    end

    it "must not return business customer info when wrong cookie token uuid is suplied" do
      business_customer_info = BusinessCustomerInfo.get_customer_info('')
      expect(business_customer_info).to eq(nil)
    end
  end

  describe "change_cookie_token_id" do
    it "must not have old cookie token when cookie token is changed" do
      old_cookie_token_id = @biz_customer_info.cookie_token_id
      @biz_customer_info.change_cookie_token_id(CookieToken.create(uuid: "anewcookietoken").id)
      expect(old_cookie_token_id).not_to eq(@biz_customer_info.cookie_token_id)
    end
  end

  # Should be discussed with implementers before writing these tests
  describe "self.insert_customer_info" do
    it "must add business customer info if right array is passed" do
      BusinessCustomerInfo.delete_all
      csv_file = fixture_file_upload('/business_customer_info.csv')
      FactoryGirl.create(:client_setting, :client_feature_settings, pricing_plan_id: PricingPlan.where(plan_name: "Enterprise").first.id, user_id: @biz_user.id)
      FactoryGirl.create(:share_detail, user_id: @biz_user.id)
      FactoryGirl.create(:share_question, user_id: @biz_user.id)
      BusinessCustomerInfo.insert_customer_info( csv_file, @biz_user)
      expect(BusinessCustomerInfo.count).to eq(1)
    end
    it "must add business customer info if wrong array is passed" do
      BusinessCustomerInfo.last.update_attributes(:is_deleted => false)
      FactoryGirl.create(:business_customer_info, email: "inquirlytest@gmail.com", mobile: "9876543211", user: @biz_user, cookie_token_id: @cookie_token.id, is_deleted: true)
      csv_file = fixture_file_upload('/business_customer_info_with_wrongdetails.csv')
      FactoryGirl.create(:client_setting, :client_feature_settings, pricing_plan_id: PricingPlan.where(plan_name: "Enterprise").first.id, user_id: @biz_user.id)
      FactoryGirl.create(:share_detail, user_id: @biz_user.id)
      FactoryGirl.create(:share_question, user_id: @biz_user.id)
      BusinessCustomerInfo.insert_customer_info( csv_file, @biz_user)
      expect(BusinessCustomerInfo.count).to eq(4)
    end    
  end
  
  describe "self.build_business_customer_json" do
    it "business customer records as json if the data passed" do
      params = {:share_type => nil,:filter => nil,:logic => nil }
      result = BusinessCustomerInfo.build_business_customer_json([@biz_customer_info],@biz_user.id,nil,params)
      expect(result).not_to be_blank
    end
    it "business customer records as json if the data not passed" do
      params = {:share_type => nil,:filter => nil,:logic => nil }
      result = BusinessCustomerInfo.build_business_customer_json([],@biz_user.id,nil,params)
      expect(result["value"]).to be_blank
    end    
  end
  
  #~ describe "self.get_customer_records" do
    #~ it "get customer records when the type is email count" do
      #~ result = BusinessCustomerInfo.get_customer_records(@biz_customer_info.user_id, "email_count")
      #~ expect(result.last).to eq(@biz_customer_info)
    #~ end
    #~ it "get customer records when the type is call or sms count" do
      #~ result = BusinessCustomerInfo.get_customer_records(@biz_customer_info.user_id, "call_count")
      #~ expect(result.last).to eq(@biz_customer_info)
    #~ end
    #~ it "get customer records when the type is call or sms count" do
      #~ result = BusinessCustomerInfo.get_customer_records(@biz_customer_info.user_id, "sms_count")
      #~ expect(result.last).to eq(@biz_customer_info)
    #~ end    
    #~ it "get customer records when the type is other count" do
      #~ result = BusinessCustomerInfo.get_customer_records(@biz_customer_info.user_id, "")
      #~ expect(result.last).to eq(@biz_customer_info)
    #~ end    
  #~ end
  
end