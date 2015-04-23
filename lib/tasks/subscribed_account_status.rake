namespace :subscribed_user do
	task :status => [:environment]  do
    payment=PaymentsController.new
		payment.check_subscribed_user_acc_status
	end
end