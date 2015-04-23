namespace :question do
  desc "Question expiry started....."
  task :expiry => [:environment] do
    Rails.logger.info "Question expiry started....."
    Rails.logger.info "Processing....."
    question = InviteUserController.new
    question.question_expiry
    Rails.logger.info "Completed"
  end
end