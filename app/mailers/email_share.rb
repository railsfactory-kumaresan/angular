class EmailShare < MassMandrill::MandrillMailer
  include CustomersHelper

    def email_share(email_array,subject,message_content,current_user_email, question_image,company_name,user,question_id, is_html)
        addresses = []
        merge_vars = []
        sub_id = (user.parent_id == 0 || user.parent_id == nil) ? "cust-#{user.id}" : "cust-#{user.parent_id}"
        in_process_emails = email_array
        global_merge_vars = [{ :name => "IMAGE", :content => "<img src='#{ question_image }' mc:label='header_image' mc:edit='header_image' style='max-width:540px; text-align:centre;'>" } ,{ :name => "COMPANYNAME", :content => company_name}]
        in_process_emails.each do |customer|
          addresses << {"email" => customer["email"]}
          body_message = email_message_content(is_html,message_content,customer)
          merge_vars << { "rcpt" => customer["email"], "vars" => [{ "name" => 'merge2', "content" => body_message }]}
        end
        begin
          mandrill = Mandrill::API.new "#{ENV["MANDRILL_API_KEY"]}"
          message = {
              "merge"=> true,
              "merge_vars"=> merge_vars,
              "global_merge_vars" => global_merge_vars,
              "from_email"=> current_user_email,
              "from_name" => user.company_name,
              "subject" => subject,
              "html"=> is_html ? "*|MERGE2|*" : email_campaign_template,
              "to"=> addresses,
              "subaccount"=>sub_id,
              "async" => true,
              "metadata" => {
               "question_id" => "#{question_id}","campaign_name" => "#{subject}", "user_id" => "#{user.id}"
              }
          }
          mandrill.messages.send message
        rescue Mandrill::Error => e
          MANDRILL_LOGGER.info("A mandrill error occurred(email): #{e.class} - #{e.message}")
        end
    end

    def email_message_content(is_html,message_content,customer)
      if is_html
        message_content.include?("<survey_link>") ? message_content.gsub("<survey_link>","#{customer['bitly_url']}") : message_content
      else
        message_content.present? ? (message_content.include?('&lt;survey link inserted here automatically&gt;') ? "#{message_content.gsub('&lt;survey link inserted here automatically&gt;',"<a href=#{customer["bitly_url"]}>Click here to respond</a>")}" : message_content + "<a href=#{customer["bitly_url"]}>Click here to respond</a>" )  : "<a href=#{customer["bitly_url"]}>Click here to respond</a>"
      end
    end
end
