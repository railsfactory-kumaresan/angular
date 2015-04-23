class AnswerAnalysis < ActiveRecord::Base

belongs_to :question
belongs_to :answer

def self.get_sentiment_score(question_id)
   where("question_id =?",question_id).select("sentiment_score,count(sentiment_score) as score_count").group("sentiment_score")
end

end
