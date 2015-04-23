require "spec_helper"

describe QuestionViewLog do
  before(:each) do
    @user = FactoryGirl.create(:user, :default_user)
    @biz_user = FactoryGirl.create(:user, :default_biz_user)
    @category = CategoryType.first
    @question = FactoryGirl.create(:question, :year_wise_expire, user: @biz_user,
    category_type_id: @category.id)
    @cookie_token = FactoryGirl.create(:cookie_token)
    @question_view_log = FactoryGirl.create(:question_view_log, user_id: @user.id,
    question: @question, cookie_token: @cookie_token, provider: "Twitter")
  end

   describe "#Association" do
    it { should belong_to(:cookie_token) }
    it { should belong_to(:question) }
  end

  it "must create a new record" do
    QuestionViewLog.delete_all
    QuestionViewLog.create_new_record(@question, "Twitter", nil)
    expect(QuestionViewLog.count).to eq(1)
  end

  it "should update biz customer info if question view log" do
    @biz_customer_info = FactoryGirl.create(:business_customer_info, user: @biz_user,:status => nil)
    QuestionViewLog.update_biz_cus_id(@question_view_log.id,@biz_customer_info.id)
    QuestionViewLog.last.business_customer_info_id.should eql(@biz_customer_info.id)
  end
end