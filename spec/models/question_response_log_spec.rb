require "spec_helper"

describe QuestionResponseLog do
  before(:each) do
    @biz_user = FactoryGirl.create(:user, :default_biz_user)
    @category = CategoryType.first
    @question = FactoryGirl.create(:question, :year_wise_expire, user: @biz_user,category_type_id: @category.id)
    @question_response_log = FactoryGirl.create(:question_response_log, user_id: @biz_user.id,question: @question,provider: "Twitter")
    @question_view_log = FactoryGirl.create(:question_view_log, user_id: @biz_user.id,question: @question, provider: "Twitter")
  end
  it { should belong_to(:cookie_token)}
  it { should belong_to(:question)}

  context "self.create_new_record" do
    it "must create new QuestionResponseLog" do
      QuestionResponseLog.delete_all
      QuestionResponseLog.create_new_record(@question,"Twitter",nil,nil)
      expect(QuestionResponseLog.count).to eq(1)
    end
  end

  it "should change the process status to false" do
    @biz_customer_info = FactoryGirl.create(:business_customer_info, user: @biz_user,:status => nil)
    QuestionResponseLog.change_process_status(nil,@question.id, @biz_customer_info.id)
    QuestionResponseLog.last.is_processed.should == false
  end

  it "should update biz customer info if question response log" do
    @biz_customer_info = FactoryGirl.create(:business_customer_info, user: @biz_user,:status => nil)
    QuestionResponseLog.update_biz_cus_id(@question_response_log.id,@biz_customer_info.id)
    QuestionResponseLog.last.business_customer_info_id.should eql(@biz_customer_info.id)
  end
end