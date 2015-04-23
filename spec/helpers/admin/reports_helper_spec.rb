require "spec_helper"

describe Admin::ReportsHelper do
	
  describe "#response_count" do
    it "get the response count" do
			user = FactoryGirl.create(:user, :default_biz_user)
			question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id)
			FactoryGirl.create(:answer, :question_id => question.id)
      helper.response_count(question.id).should eql(1)
    end
  end
	
end