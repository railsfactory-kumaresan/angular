class DistributeController < PrivilegeController
	respond_to :json
	
	def check_business_customer
    customer = BusinessCustomerInfo.find_business_customer_info(params[:email], params[:user_id], params[:mobile])
    render :json => {:is_record => customer.present?, :business_customer => customer}
	end
	
	def create_business_customer
		result = BusinessCustomerInfo.create_survey_customers(params[:customer])
		render :json => result.is_a?(Array) ? {:result => result, :successfull => result.select{|a| a[:customer]}.count, :failed => result.select{|a| a[:errors]}.count} : result
	end
	
end