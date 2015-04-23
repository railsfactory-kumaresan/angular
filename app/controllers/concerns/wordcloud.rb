module Wordcloud
  extend ActiveSupport::Concern
  included do

  def show_dashboard_wordcloud
    questions,question_ids = Question.get_question_ids(current_user,params)
    ques_details = get_question_vr_details(question_ids,params,questions,'view')
    question_view_details =  Hash[ques_details.values.map{|i| [get_simplified_question(i["question"]),(i["view"] + '_' + i["slug"])] if i["view"]}]
    render :json => {:response => question_view_details}
  end

  def show_question_wordcloud
      question = Question.get_question(params[:slug])
      answer_option = AnswerOption.get_answer_option(question.id)
      options = answer_option.present? ? answer_option[0].options : []
      render :json => {:response => options}
  end


private

def get_simplified_question(question)
 question.split.delete_if{|x| DEFAULTS["wordcloud_excludes"].include?(x.downcase)}.join(' ')
end

end
end
