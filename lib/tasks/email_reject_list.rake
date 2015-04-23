namespace :email_customers do
    task :reject_list => [:environment]  do
     BusinessCustomerInfo.email_reject_list
    end
    #task :sub_account_list => [:environment] do
    #  BusinessCustomerInfo.sub_account_list
    #end

   task :backlog_process => [:environment] do
     BacklogEmailList.backlog_process_internal
   end

   task :backlog_process_api => [:environment] do
      BacklogEmailList.backlog_process_api
   end
end