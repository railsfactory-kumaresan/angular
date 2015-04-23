task :payment_details => [:environment]  do
	puts "Please enter existing user email:"
	email = STDIN.gets.strip
	puts "Please enter user amount(eg: 100.00):"
	amount = STDIN.gets.strip
	puts "Please enter user action(Upgraded,Downgraded,Renewed):"
	action = STDIN.gets.strip

  if(email.present? && amount.present? && action.present?)
  	begin
		  exp_date = Time.now + 1.month # Default 1 month
		  user_detail = User.find_by_email(email) # Find the user

		  case (action.downcase)
		  when "upgraded"
		  	modified_bussiness_type = 2
		  when "downgraded"
		  	modified_bussiness_type = 1
		  when "renewed"
		  	modified_bussiness_type = user_detail.business_type_id
		  else
		  	raise "error - Please enter valid action name"
  		end
		  transaction_id = SecureRandom.hex(10) # Random generate transaction id
      order_id = SecureRandom.hex(32) # Random generate order id

		  # Update the details in the user table
		  user_detail.subscribe = true
		  user_detail.business_type_id = modified_bussiness_type
		  user_detail.exp_date = exp_date
		  user_detail.is_active = true
		  user_detail.save(:validate => false)

		  # Record create in the transaction_details table
		  TransactionDetail.create(:user_id => user_detail.id, :amount => amount, :business_type_id => modified_bussiness_type, :transaction_id => transaction_id, :expiry_date => exp_date, :active => true, :action => action, :payment_status => "completed", :order_id => order_id)
		  InviteUser.payment_success(user_detail.email,user_detail.first_name).deliver
		  puts "Payment details updated in the system."
		rescue => e
			puts "Please enter valid inputs"
		end
	else
		puts "please enter all the values"
	end
end
