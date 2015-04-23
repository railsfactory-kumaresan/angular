require "spec_helper"

describe AnswerOption do
 
	it { should belong_to(:question) }

	describe "get answer option" do
		before(:each) do
			@user = FactoryGirl.create(:user,:default_biz_user, :role_id => Role.first.id)
			@question = FactoryGirl.create(:question, :year_wise_expire, user: @user, category_type: CategoryType.first, question_type_id: QuestionType.first.id)
		end
		it "get answer option if question id passed" do
			answer_option = FactoryGirl.create(:answer_option, question_id: @question.id)
			result = AnswerOption.get_answer_option(@question.id)
			expect(result.last).to eq(answer_option)
		end
		it "get answer option if question id passed" do
			result = AnswerOption.get_answer_option(@question.id)
			expect(result.last).to eq(nil)
		end		
	end
	
end