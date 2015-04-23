desc :update_sentimental_analysis_score
task :update_sentiment_score => [:environment]  do
cron_log = CronLog.where("log_type=?","AnswerAnalysis").first
last_run_id = cron_log.last_run_id.nil? ? 0 : cron_log.last_run_id
answers = Answer.where("id > ?",last_run_id)

unless answers.empty?
	answers.each do |answer|
		update_score(answer)
    update_answer_option_score(answer)
    @last_run_id = answer.id
	end
  cron_log.update_attribute("last_run_id",@last_run_id)
end
end

private

def update_score(answer)
  text = "#{answer.option}" + "#{answer.comments}" + "#{answer.free_text}"
  response = HTTParty.post("#{ENV['LISTENER_URL'].to_str}sentiment/score",:body => {"text"=>"#{text}" }).parsed_response
  score = response["status"] != 'success' ? 2 : response["score"]
  AnswerAnalysis.create(answer_id: answer.id,question_id: answer.question_id ,sentiment_score: score)
end

def update_answer_option_score(answer)
 unless answer.option.blank?
 answer_option = AnswerOption.where(question_id: answer.question_id)[0]
 if answer_option.blank?
   AnswerOption.create(question_id: answer.question_id,options: {"#{answer.option}" => 1})
 elsif answer_option
  count = answer_option.options["#{answer.option}"] ? answer_option.options["#{answer.option}"].to_i : 0
  answer_option.options_will_change!
  answer_option.options["#{answer.option}"] = count + 1
  answer_option.save!
 end
end
end
