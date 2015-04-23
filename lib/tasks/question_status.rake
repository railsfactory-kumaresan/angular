namespace :question do
	task :question_status => [:environment]  do
    Rails.logger.info "##############################################"
    Rails.logger.info "###Question status expiry#"
    Rails.logger.info "##############################################"
	question = InviteUserController.new
    question.question_status
    Rails.logger.info "Process completed"
	end
end