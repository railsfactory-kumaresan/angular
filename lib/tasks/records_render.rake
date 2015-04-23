desc "Insert records in response_customer_info table and answer table"
  task :insert_sample => [:environment] do
	first_names = %w(James Kirk Swetha Ram Krishnan John Harry Sally Sita Ganapathi Vagmi)
	last_names = %w(Gupta Mehta Jain Singh Menon Krishan)
	domains = ['gmail.com','yahoo.com','msn.com','hotmail.com','sify.com']
  countries = ['IN','US','CN','UK']
  values = ['yes','no']
  sports = %w('tennis','footbal','Throwball','Volleyball','Basketball','Korfball','Netball','Baseball','Cricket','Kickball')
	question_type_id = [1,2,3,4]
	user_id = 2
ActiveRecord::Base.transaction do |tx|
		 for i in 1..10 do

				question = {"question"=> {"category_type_id"=>"3", "expiration_id"=>"1 Day", "question"=>"Do you like #{sports.sample}","video_type"=>"1", "embed_url"=>"", "include_other"=>"0", "include_text"=>"0", "question_type_id"=>3,"thanks_response"=>"Thanks for responding!","user_id" => "#{user_id}", "include_other" => nil, "include_text" => nil}}
        question = Question.new(question_params["question"])
        question.save
        logger.info "You have created the #{question.question} question."
        question.update_status_with_expired_at
        user.share_questions.create(:provider => "Email", :email_address => user.email)

    end

      #~ (1..10).each do |x|
	#~ option_id = (rand*2).to_i + 1
        #~ age = (rand*50).to_i + 1
        #~ first_name = first_names.sample
        #~ last_name = last_names.sample
	#~ email = first_name + "." + last_name + '@' + domains.sample

       #~ answer = Answer.create(:is_business_user=>false,:question_type_id =>1,:question_option_id =>option_id,:question_id=>10,:provider=>"Email",:option=>values[option_id -1],:is_deactivated=>false)

	#~ customer_info = ResponseCustomerInfo.create(customer_name: "#{first_name} #{last_name}",email: email,age: age,country: countries.sample)
      #~ answer.update_attributes(:multiple_response_id => answer.id,:customers_info_id=>customer_info.id)
        #~ CustomerInfoQuestion.create(:question_id=>10, :customers_info_id=>customer_info.id,:is_business_user=>false)
	#~ print "done with #{x}\r"
	#~ #tx.commit if x%1000==0
      #~ end
	#tx.commit
end



  end
