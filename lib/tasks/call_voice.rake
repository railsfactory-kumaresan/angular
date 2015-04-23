	namespace :call_voice do
		task :start_workers => [:environment]  do
			job=QuestionController.new.check_status_delayed_job
			if job.count > 0
				system "cd /var/www/apps/inquirlydev/current && RAILS_ENV=production script/delayed_job start"
			else
				system "cd /var/www/apps/inquirlydev/current && RAILS_ENV=production script/delayed_job stop"
			end
		end
	end