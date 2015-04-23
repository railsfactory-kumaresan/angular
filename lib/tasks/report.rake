require 'rubygems'
desc "Creating a Email activity dump data's"
task :email_activity, [:question_id,:user_email,:customer_count] => [:environment]  do |t,params|
    columns = [:question_id, :business_customer_info_id, :user_id, :opens, :clicks]
    values = []
    user_id = User.where(email: params[:user_email]).first
    biz_customers = BusinessCustomerInfo.where(user_id: user_id).first(params[:customer_count]).map(&:id)
    biz_customers.each do |cus|
      values.push [params[:question_id], cus, user_id, rand(1..10), rand(1..8)]
    end
    EmailActivity.import columns, values
end