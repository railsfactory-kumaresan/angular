namespace :acc_status do
	task :trial_acc_status => [:environment]  do
    account = AccountController.new
		account.check_trial_user_account_status
	end
end