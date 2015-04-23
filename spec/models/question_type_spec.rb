require "spec_helper"

describe QuestionType do

 # it { should have_many(:questions) }
 # it { should validate_presence_of(:name) }

  it "must exist" do
    expect(QuestionType.new.class).to eq(QuestionType)
  end

  # it "should not be saved without a name" do
  #   expect(QuestionType.new.save).to eq(false)
  # end

  it "should have a record named Single Answer" do
    question_type = QuestionType.find_by_name "Single Answer"
    expect(question_type.name).to eq("Single Answer")
  end

  it "should have a record named Multiple Answer" do
    question_type = QuestionType.find_by_name "Multiple Answer"
    expect(question_type.name).to eq("Multiple Answer")
  end

  it "should have a record named Yes/no" do
    question_type = QuestionType.find_by_name "Yes/no"
    expect(question_type.name).to eq("Yes/no")
  end

  it "should have a record named Comments" do
    question_type = QuestionType.find_by_name "Comments"
    expect(question_type.name).to eq("Comments")
  end


end