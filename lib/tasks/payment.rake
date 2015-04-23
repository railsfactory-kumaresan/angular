namespace :payment do
	task :user_notify_before => [:environment]  do
    payment=PaymentsController.new
		payment.payment_notify_mail_non_subscribe
		payment.payment_notify_mail_subscribe
	end
end