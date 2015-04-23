require "spec_helper"

describe ResponseCustomerInfo do
  before(:each) do
    @biz_user = FactoryGirl.create(:user, :default_biz_user)
    @question = FactoryGirl.create(:question, :year_wise_expire, user: @biz_user,
      category_type: CategoryType.first, question_type_id: QuestionType.first.id)
    @response_customer_info = FactoryGirl.create(:response_customer_info, question_id: @question.id)
  end

 describe "#Association" do
  it { should have_many(:answers) }
  it { should have_many(:response_cookie_info) }
end

  describe "create_response_user_info" do

  end

  describe "create_response_user_info" do
    it "must create a response user info" do
      @response_customer_info.response_cookie_info.delete_all
      cookie_token = CookieToken.create(uuid: "sdf#{Random.rand(114444444)}")
      @response_customer_info.create_response_user_info(nil, cookie_token.uuid, @question.id)
      expect(@response_customer_info.response_cookie_info.count).to eq(1)
    end
  end

  describe "create_response_cookie_info" do
    it "must create a response cookie info" do
      @response_customer_info.response_cookie_info.delete_all
      cookie_token = CookieToken.create(uuid: "sdf#{Random.rand(114444444)}")
      @response_customer_info.create_response_cookie_info(cookie_token.uuid, @question.id)
      expect(@response_customer_info.response_cookie_info.count).to eq(1)
    end
  end
  
  describe "self.find_response_customer_info" do
    it "should find response customer info with its email" do
      record_found = ResponseCustomerInfo.find_response_customer_info(@response_customer_info.email)
      expect(record_found).to eq(@response_customer_info)
    end

    it "should find response customer info with wrong email" do
      record_found = ResponseCustomerInfo.find_response_customer_info("someemail@abc.com")
      expect(record_found).to eq(nil)
    end
  end

  describe "change_cookie_token_id" do
    it "should change cookie token id if the cookie token is real" do
      CookieToken.delete_all
      cookie_token = CookieToken.create(uuid: "someranduuid")
      @response_customer_info.create_response_user_info(nil, cookie_token.uuid, @question.id)
      @response_customer_info.change_cookie_token_id(CookieToken.create(uuid: "newcookie").id)
      expect(cookie_token.uuid).not_to eq(CookieToken.last.uuid)
    end

    it "should not change cookie token id if the cookie token is real" do
      CookieToken.delete_all
      cookie_token = CookieToken.create(uuid: "someranduuid")
      @response_customer_info.create_response_user_info(nil, cookie_token.uuid, @question.id)
      @response_customer_info.change_cookie_token_id(CookieToken.maximum(:id) + 1) # the cookie with such id dies not exist
      expect(cookie_token.uuid).to eq(CookieToken.last.uuid)
    end
  end
  
end
