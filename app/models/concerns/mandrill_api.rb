module MandrillApi
  extend ActiveSupport::Concern
  included do
    def self.email_reject_calls
      begin
        mandrill = Mandrill::API.new ENV["MANDRILL_API_KEY"]
        notify_email = "help@inquirly.com"
        reject_list = mandrill.exports.rejects notify_email
      rescue Mandrill::Error => e
        MANDRILL_LOGGER.info("A mandrill error occurred(reject list): #{e.class} - #{e.message}")
      end

      unless reject_list.blank?
        sleep(1.minute)
        current_state = 'waiting'
        expected_state = 'complete'
        until current_state == expected_state  do
          begin
            mandrill = Mandrill::API.new ENV["MANDRILL_API_KEY"]
            id = reject_list["id"]
            export_result = mandrill.exports.info id
          rescue Mandrill::Error => e
            MANDRILL_LOGGER.info("A mandrill error occurred(reject list): #{e.class} - #{e.message}")
          end
          current_state = export_result["state"]
        end
        path = Rails.root.join('tmp')
        system("wget -P #{path} '#{export_result['result_url']}' -O #{path}/rejects.zip")
        system("unzip -d #{path} #{path}/rejects.zip")
        name = "rejects.csv"
        directory = "#{ Rails.root }/tmp"
        csv_path = File.join(directory, name)
        final_list = "rejects_list.csv"
        final_list_path = File.join(directory, final_list)
        total_record = []
        un_sub_emails = []
        CSV.foreach(csv_path, :headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1', :col_sep => ",") do |row|
          total_record <<  Hash[row.headers[0..-1].zip(row.fields[0..-1])]
        end

        CSV.open(final_list_path, "wb") do |csv|
          if total_record.present?
            csv << total_record.first.keys
            total_record.each do |hash|
              csv << hash.values
            end
          end
        end
        CSV.foreach(final_list_path, :headers => true, :header_converters => :symbol, :skip_blanks => true, :encoding => 'ISO-8859-1', :converters => :all) do |row|
          hash_val = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
          email_list = {"email" => hash_val[:email], "reason" => hash_val[:reason]}
          un_sub_emails << email_list
        end

        un_sub_emails.each do |customer|
          biz = BusinessCustomerInfo.where(email: customer["email"])
          biz.each do |cus|
            cus.update_attribute("status", customer["reason"])
          end
        end
        system("cd #{ Rails.root }/tmp; rm -rf #{name} #{final_list} rejects.zip")
      end
    end

    def self.create_mandrill_sub_account(user)
      user = User.where(id: user.id)
      user.each do |u|
        begin
          mandrill = Mandrill::API.new ENV["MANDRILL_API_KEY"]
          id = "cust-#{u.id}"
          name = u.company_name
          notes = "#{User.plan_name(u)} user, signed up on #{u.created_at}"
          mandrill.subaccounts.add id, name, notes
        rescue Mandrill::Error => e
          MANDRILL_LOGGER.info("A mandrill error occurred(sub_account add): #{e.class} - #{e.message}")
        end
      end
    end

    def self.message_info(message_id)
      begin
        mandrill = Mandrill::API.new ENV["MANDRILL_API_KEY"]
        id = message_id
        output_new = mandrill.messages.info id
      rescue Mandrill::Error => e
        MANDRILL_LOGGER.info("A mandrill error occurred(message info): #{e.class} - #{e.message}")
      end
      return output_new
    end

    def self.sub_account_info(sub_id)
      begin
        mandrill = Mandrill::API.new ENV["MANDRILL_API_KEY"]
        id = sub_id
        sub_account_output = mandrill.subaccounts.info id
      rescue Mandrill::Error => e
        MANDRILL_LOGGER.info("A mandrill error occurred(sub_account info): #{e.class} - #{e.message}")
      end
      return sub_account_output
    end
  end
end