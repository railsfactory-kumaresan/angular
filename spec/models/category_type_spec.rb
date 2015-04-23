# Please run
# bundle exec rake db:seed RAILS_ENV=test
# Before testing

require "spec_helper"

describe CategoryType do
  it { should have_many(:questions) }

  # it "should not be saved empty" do
  # 	expect(CategoryType.new.save).to eq(false)
  # end

  # it "should not be saved if category_name is empty" do
  # 	expect(CategoryType.create({category_name: ""}).save).to eq(false)
  # end

  it "should be creatable" do
  	expect(CategoryType.create({category_name: "Some category name"}).save).to eq(true)
  end

  it "must return single category type if user is individual" do
    categories = CategoryType.find_categories 1
    expect(categories.count).to eq(1)
  end

  it "must return feedback category if user is individual" do
    categories = CategoryType.find_categories 1
    expect(categories.first.category_name).to eq("Feedback")
  end

  it "must return all category types if user is business" do
    categories = CategoryType.find_categories nil
    expect(categories.first).to eq(nil)
  end

  it "must return category matching the specified id" do
    id = 3
    categories = CategoryType.find_category id
    expect(categories.first.id).to eq(id)
  end
end