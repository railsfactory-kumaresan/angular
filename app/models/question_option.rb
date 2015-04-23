# Stores the options that are provided for a Question
class QuestionOption < ActiveRecord::Base
  #attr_accessible :question_id,:option,:order,:is_other,:is_deactivated,:created_at,:updated_at
  belongs_to :question
  scope :options_without_other,lambda { |question_id| where('question_id=? and is_deactivated =? and is_other !=?',question_id,false,true).order("question_options.order ASC")}

  # Add new options for the question
  # options - An array of options like ["A", "C", "E"]
  # question_id - id of questions for which options must be added
  # max_order - The offset of order where the options must be inserted
  # is_other - A boolean value, set to true , if the option is not given by the question creator
  def self.add_question_options(options,question_id,max_order,is_other)
    options && options.each_with_index do |option,index|
      max_order = max_order.nil? ? 0 : max_order
      index = max_order + 1 + index
      @question_option = QuestionOption.create(:question_id=>question_id,:option=>option,:order=>index,:is_other=>is_other,:is_deactivated=>false)
   end
   return @question_option
  end

  # To update options, you can rember it as the old option gets removed
  # and new option gets added
  # options - An array of options like ["A", "C", "E"]
  # question_id - id of questions for which options must be updated
  def self.update_options(options,question_id,include_other)
      question = Question.where(id: question_id)[0]
      existing_options = question.question_options.pluck(:option)
      new_options = options - existing_options
      max_order = find_max_option_order(question_id)
      self.add_question_options(new_options,question_id,max_order,false) unless new_options.blank?
      deleted_options = existing_options - options
      self.deactivate_options(deleted_options,question_id) unless deleted_options.blank?
  end

  # To deactivate options
  # delete_options - Array of options that must be de acivated like ["A", "B", "c"]
  def self.deactivate_options(deleted_options,question_id)
    where("question_id=? and option in (?)",question_id,deleted_options).update_all(is_deactivated: true)
  end

  # Finds the QuestionOption which has maximum order
  # question_id - id of the question whos maximum order must be found
  # returns maximum order of the question options
  def self.find_max_option_order(question_id)
    where("question_id=?",question_id).maximum(:order)
  end

  # Creates options that are not added by Question creator
  # options - An array of options like ["A", "C", "E"]
  # question_id - id of questions for whose options must be added
  def self.create_new_other_option(option,question_id)
    max_order = find_max_option_order(question_id)
    question_option = self.add_question_options([option],question_id,max_order,true) unless option.blank?
    return question_option.id
  end

  # Gets the option of question, given its id
  # option_id - id (integer) of he option
  def self.find_question_option(option_id)
    where('id=?',option_id)[0].option
  end

end
