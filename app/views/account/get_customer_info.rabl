object false

if @customer_info_details.present?
	node :header do
		{ :status => 200 }
	end

	node :body do
		{ :customer_info_details => partial("account/get_customer_info_show", :object => @customer_info_details) }
	end
else
  node :header do
		{ :status => 400 }
	end

	node :body do
		{ :error => "User doesn't have customer informations" }
	end
end