require "spec_helper"

describe CookieToken do
  
  it { should have_many(:response_cookie_infos) }
  it { should have_many(:question_view_logs) }
  it { should have_many(:question_response_logs) }
  it { should have_one(:business_customer_info) }
  # it { should validate_uniqueness_of(:uuid) }


  # Testing self.create_new_record

  it "should create a cookie" do
    CookieToken.delete_all
  	uuid = "#{Random.rand(11444445444)}"
    CookieToken.create(uuid: uuid)
    expect(CookieToken.count).to eq(1)
  end



  it "must return right cookie when uuid is given" do
    # not implemented, should put response token
    CookieToken.delete_all
    uuid = "#{Random.rand(114444444)}"
    cookie = CookieToken.create(uuid:uuid)
    cookie_found_id = CookieToken.find_cookie_token_id uuid
    expect(cookie_found_id).to eq(cookie.id)
  end

  describe "self.create_new_record" do
    it "must creat new cookie token record" do
      CookieToken.delete_all
      cokkie_uuid = "#{Random.rand(114444444)}"
      CookieToken.create_new_record(cokkie_uuid)
      expect(CookieToken.first.uuid).to eq(cokkie_uuid)
    end

    # it "must not create cookie token record if uuid is just space" do
    #   CookieToken.delete_all
    #   CookieToken.create_new_record(" ")
    #   expect(CookieToken.count).to eq(0)
    # end
  end

  describe "self.find_cookie_token_id" do
    it "must get cookie token id when UUID is provided" do
      cookie_token = CookieToken.create_new_record("cookieabc")
      expect(CookieToken.find_cookie_token_id(cookie_token.uuid)).to eq(cookie_token.id)
    end
  end

  describe "self.find_cookie_customer_info" do
    it "must return the righ business customer info" do
      cookie_token = CookieToken.create_new_record("randrand")
      @user = FactoryGirl.create(:user, :default_biz_user)
      biz_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id)
      response_cookie_infos = FactoryGirl.create(:response_cookie_info,
        cookie_token_id: cookie_token.id, response_token_type: "BusinessCustomerInfo",
        response_token_id: biz_customer_info.id)
      expect(CookieToken.find_cookie_customer_info(cookie_token.uuid)).to eq(biz_customer_info)
    end
  end

  describe "self.find_customer_informations" do
    it "must return the right business customer info wghen cookie id is passed" do
      CookieToken.delete_all
      cookie_token = CookieToken.create_new_record("randrand")
      @user = FactoryGirl.create(:user, :default_biz_user)
      biz_customer_info = FactoryGirl.create(:business_customer_info, user_id: @user.id)
      response_cookie_infos = FactoryGirl.create(:response_cookie_info,
        cookie_token_id: cookie_token.id, response_token_type: "BusinessCustomerInfo",
        response_token_id: biz_customer_info.id)
      expect(CookieToken.find_customer_informations(cookie_token.id)).to eq(biz_customer_info)
    end
  end


end
