class AnswerOption < ActiveRecord::Base
 belongs_to :question
 store_accessor :options

 def self.get_answer_option(question_id)
   where("question_id =?",question_id)
 end

end
