require "spec_helper"

describe QuestionOption do

  before(:each) do

    # Create user
    User.delete_all
    @user = User.new
    @user.first_name = "John"
    @user.last_name = "Taylor"
    @user.company_name = "Sedin Technologies"
    @user.business_type_id =  2 # setting it as business user
    @user.email = "karthikeyan@railsfactory.com"
    @user.confirmed_at = Time.now - 1.hour
    @user.confirmation_sent_at = Time.now - 2.hour
    @user.is_active = true
    @user.admin = false
    @user.password = "12345678aA!"
    @user.password_confirmation = "12345678aA!"
    @user.save

    # Create question
    Question.delete_all
    @question = Question.new
    @question.user_id = @user.id
    @question.question_type_id = QuestionType.pluck(:id).first
    @question.category_type_id = CategoryType.pluck(:id).first
    @question.include_comment = false
    @question.question = "Who am I?"
    @question.thanks_response = "A movie fan!"
    @question.language = "English"
    @question.expiration_id = "1 Year"
    @question.expired_at = Time.now + 1.year
    @question.status = "Active"
    @question.save
  end

 it { should belong_to(:question) }
  #~ it { should have_many(:answers) }

  it "should be creatable" do
    # Create question option and try to save it
    QuestionOption.delete_all
    question_option = QuestionOption.new
    question_option.question_id = @question.id
    question_option.option = "Some option statement"
    question_option.order = 1
    question_option.is_other = false
    question_option.is_deactivated = false
    expect(question_option.save).to eq(true)
  end

  # it "should not be creatable without option" do
  #   # Create question option and try to save it
  #   QuestionOption.delete_all
  #   question_option = QuestionOption.new
  #   question_option.question_id = @question.id
  #   question_option.option = nil
  #   question_option.order = 1
  #   question_option.is_other = false
  #   question_option.is_deactivated = false
  #   expect(question_option.save).to eq(false)
  # end

  # it "should not be creatable when option is empty string" do
  #   # Create question option and try to save it
  #   QuestionOption.delete_all
  #   question_option = QuestionOption.new
  #   question_option.question_id = @question.id
  #   question_option.option = ""
  #   question_option.order = 1
  #   question_option.is_other = false
  #   question_option.is_deactivated = false
  #   expect(question_option.save).to eq(false)
  # end

  # it "should not be creatable when option has only spaces" do
  #   # Create question option and try to save it
  #   QuestionOption.delete_all
  #   question_option = QuestionOption.new
  #   question_option.question_id = @question.id
  #   question_option.option = " "*10
  #   question_option.order = 1
  #   question_option.is_other = false
  #   question_option.is_deactivated = false
  #   expect(question_option.save).to eq(false)
  # end

  # it "should not be creatable without question id" do
  #   # Create question option and try to save it
  #   QuestionOption.delete_all
  #   question_option = QuestionOption.new
  #   question_option.question_id = nil
  #   question_option.option = "Some option statement"
  #   question_option.order = 1
  #   question_option.is_other = false
  #   question_option.is_deactivated = false
  #   expect(question_option.save).to eq(false)
  # end


  # Testing self.add_question_options

  it "should add question options for a question" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    expect(QuestionOption.count).to eq(4)
  end

  # Testing self.update_options

  it "should update options for a question" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    QuestionOption.update_options(%w(A B C D E), @question.id, false)
    expect(QuestionOption.count).to eq(5)
  end

  # Testing self.deactivate_options

  it "should deactivate some options" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    QuestionOption.deactivate_options(%w(A B), @question.id)
    expect(QuestionOption.where(is_deactivated: true).count).to eq(2)
  end

  # Testing self.find_max_option_order

  it "max question order should increment accordingly" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    expect(QuestionOption.find_max_option_order @question.id).to eq(5)
  end

  # Testing self.create_new_other_option

  it "should create new options" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    QuestionOption.create_new_other_option("E", @question.id)
    expect(QuestionOption.count).to eq(5)
  end

  it "should add question options" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    QuestionOption.add_question_options(%w(E F G), @question.id, 4, true)
    expect(QuestionOption.count).to eq(7)
  end

  it "should find question option depending on the id" do
    QuestionOption.delete_all
    QuestionOption.add_question_options(%w(A B C D), @question.id, 1, false)
    question_option = QuestionOption.first
    question_option_name = question_option.option
    question_option_2_name = QuestionOption.find_question_option question_option.id
    expect(question_option_name).to eq(question_option_2_name)
  end

end