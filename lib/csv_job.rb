class CsvJob <  Struct.new(:file_path,:current_user)

  def perform
    BusinessCustomerInfo.insert_customer_info(file_path, current_user)
  end

  # Hook for when the job finished successfully
  #def after(job)
  #  created_at = job.created_at.strftime("%Y-%m-%d %H:%M:%S")
  #  end_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  #  biz_customer = BusinessCustomerInfo.where("created_at BETWEEN '#{created_at}' AND '#{end_at}'")
  #  user_collection = biz_customer.map(&:user_id)
  #  user = User.where(id: user_collection)
  #  user.each do |u|
  #      biz_customers = BusinessCustomerInfo.where("created_at BETWEEN '#{created_at}' AND '#{end_at}' AND user_id = #{u.id}")
  #      counter = biz_customers.count
  #      biz_customers && biz_customers.each do |customer|
  #        email = Rack::Utils.escape("#{customer.email}")
  #        response = Unirest.get "https://verifyemail.p.mashape.com/verify/#{email}",headers:{"X-Mashape-Key" => ENV["EMAIL_MASHAPE_KEY"]}
  #        if response.body["valid"] == nil && response.body["verified_address"] == nil
  #          customer.update_attribute('status', "invalid")
  #        end
  #        counter -= 1
  #      end
  #      u.update_attribute("is_csv_processed", true) if counter == 0
  #  end
  #end
end
