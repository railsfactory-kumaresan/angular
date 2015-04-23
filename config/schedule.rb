 # Use this file to easily define all of your cron jobs.
 #
 # It's helpful, but not entirely necessary to understand cron before proceeding.
 # http://en.wikipedia.org/wiki/Cron

 # Example:
 #
 # set :output, "/path/to/my/cron_log.log"
 #
 # every 2.hours do
 #   command "/usr/bin/some_great_command"
 #   runner "MyModel.some_method"
 #   rake "some:great:rake:task"
 # end
 #
 # every 4.days do
 #   runner "AnotherModel.prune_old_records"
 # end

 # Learn more: http://github.com/javan/whenever

 # set :output, "/home/user/Desktop/projects/inquirly/cron_log.log"
 # set :environment, 'development'
 # env :PATH, ENV['PATH']

 #view and response count increment
 every 3.minutes do
   rake "increment_view_count"
   rake "increment_response_count"
   rake "process_response_log"
   rake "update_sentiment_score"
 end

 #Question closed status updated
 every 2.hours do
   rake "question:question_status"
 end

 # #Subscribe user - Expiration mail - subcribed -  change status
  every 2.hours do
    rake "subscribed_user:status"
  end

 # #trial user - Expiration mail - trial- change status
  every 2.hours do
    rake "acc_status:trial_acc_status"
  end

  every :day, :at => '12:00am' do
    rake "payment:user_notify_before"
    rake "email_customers:reject_list"
  end

  #every 1.hour do
  #  rake "email_customers:sub_account_list"
  #end

  #every 1.hour do
  #  rake "email_customers:backlog_process"
  #  rake "email_customers:backlog_process_api"
  #end
 #run one time per day
  every 12.hours do
     rake "question:expiry"
  end

 # every :reboot do
 #   rake "jobs:work"
 #   rake "sunspot:solr:start"
 # end

