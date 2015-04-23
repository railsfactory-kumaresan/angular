module Admin::ReportsHelper
    def response_count(question_id)
    Answer.where(:question_id => question_id ).count
    end
end
