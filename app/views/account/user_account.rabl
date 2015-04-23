object false

if @user
	node :header do
		{ :status => 200 }
	end

	node :body do
		{ :user => partial("/account/user_account_show", :object => @user) }
	end
else
  node :header do
		{ :status => 400 }
	end

	node :body do
		{ :error => "User not found" }
	end
end