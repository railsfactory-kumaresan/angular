require "spec_helper"

describe DashboardHelper do
	
  describe "Get Question" do
    it "To get the question" do
      user = FactoryGirl.create(:user, :default_biz_user)
      question = FactoryGirl.create(:question, :year_wise_expire, :user_id => user.id)
      question_text = helper.get_question(question.id)
      question_text.should eql question.question
    end
  end
	
end