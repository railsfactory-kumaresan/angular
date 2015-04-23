namespace :load do
  desc "Create answers and question view count, Run rake like this rake load:create_auto_answers[1]"
  task :create_auto_answers, [:id] => :environment do |t, params|
    question = Question.where("id =?", params[:id]).first
    if question
      from_dat = question.created_at.to_date
      if Date.today > question.expired_at
        to_dat = question.expired_at
      else
        to_dat = Time.now.to_date
      end
      (from_dat..to_dat).each do |date_val|
        rand_val = rand(1..4)
        (1..rand_val).each do |x|
         ans = Answer.new
         ans.question_id = question.id
         ans.question_type_id = 2
         ans.option = "Question_#{params[:id]} answer"
         ans.provider = "Email"
         ans.created_at = date_val.to_datetime
         ans.save!
         p ans
        end
        question_view_cnt = QuestionViewCount.new
        question_view_cnt.question_id = question.id
        question_view_cnt.view_count = rand_val
        question_view_cnt.created_at = date_val.to_datetime
        question_view_cnt.save!
        p question_view_cnt
      end
    end
  end

  desc "Create the question and share it through test email."
  task :create_and_share_question, [:email, :total_count, :expiration_type] => :environment do |t, params|
    user = User.where("email =?", params[:email]).first
    expiration_type = params[:expiration_type].nil? ? "1 Week" : "#{params[:expiration_type]}"
    if user && params[:total_count] && params[:total_count].to_i > 0
      (1..params[:total_count].to_i).each do |x|
        question_params = {"question"=> {"category_type_id"=>"3", "expiration_id"=>"#{expiration_type}", "question"=>"Test Question_#{x}","video_type"=>"1", "embed_url"=>"", "include_other"=>"0", "include_text"=>"0", "question_type_id"=>3,"thanks_response"=>"Thanks for responding!","user_id" => "#{user.id}", "include_other" => nil, "include_text" => nil}}
        question = Question.new(question_params["question"])
        question.save
        logger.info "You have created the #{question.question} question."
        question.update_status_with_expired_at
        user.share_questions.create(:provider => "Email", :email_address => user.email)
        logger.info "#{question.question} got shared via email."
      end
    else
      logger.info "Please provide the valid parameters"
    end
  end

  desc "Manually expire the question, Run command like rake load:question_expiration['1,2,3']"
  task :question_expiration, [:id] => :environment do |t, params|
    questions = Question.where("id in (?)", params[:id].split(","))
    questions.each do |question|
      question.status ="Closed"
      question.save!
    end
  end
end