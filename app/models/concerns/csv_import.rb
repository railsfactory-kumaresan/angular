require 'csv'
require 'fileutils'
module CsvImport
  extend ActiveSupport::Concern
  included do
    def self.csv_insert(file,user)
      total_record = total_count(file)
      valid_input_file,invalid_format_file = csv_process(file,user)
      final_processed_csv,duplicate_csv_list,duplicate_db_list,db_deleted_list = get_valid_list(user,valid_input_file)
      error_list = combine_error_list(invalid_format_file,duplicate_csv_list,duplicate_db_list,user)
      success_count = total_count(final_processed_csv)
      @e_message = ""
      if success_count > 0
        final_csv = add_user_id(final_processed_csv,user)
        conn = ActiveRecord::Base.connection
        rc = conn.raw_connection
        rc.exec("COPY business_customer_infos (customer_name, email, age, gender, mobile,country, state, city, area, custom_field, user_id, created_at, updated_at) FROM STDIN WITH CSV  DELIMITER ','  ESCAPE '\n' NULL ''  ENCODING 'SQL_ASCII'")
        # Add row to copy data
        file = File.open(final_csv, 'r')
        while !file.eof?
          rc.put_copy_data(file.readline)
        end
        rc.put_copy_end
        while res = rc.get_result
          if @e_message = res.error_message
            Rails.env == "development" ? (p @e_message) : (Rails.logger.info @e_message)
          end
        end
     end
      update_deleted_records(db_deleted_list,user)
      error_count = total_count(error_list)
      unless @e_message.blank?
        InviteUser.delay.csv_file_error_mail(user, csv_file_status = false)
      else
        InviteUser.delay.import_company_data_status(user, success_count, error_count, total_record, true, current_user_total_records(user),error_list)
        ShareDetail.update_share_count(user,success_count,'customer_records_count') if success_count > 0
      end
      user.update_csv_process(true)
      system("rm -rf #{db_deleted_list} #{duplicate_csv_list} #{duplicate_db_list}")
    end

    def self.combine_error_list(invalid_format_file,file_dup,db_dup,user)
      invalid_file = "#{ Rails.root }/tmp/customer_del_records/invalid_format_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      dup_in_file = "#{ Rails.root }/tmp/customer_del_records/repeat_content_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      removed_type_file = "#{ Rails.root }/tmp/customer_del_records/removed_type_file_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      removed_type_db = "#{ Rails.root }/tmp/customer_del_records/removed_type_db_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      file_format_list = "#{ Rails.root }/tmp/customer_del_records/file_format_list_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      final_error_list = "#{ Rails.root }/tmp/customer_del_records/final_error_list_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      only_file_error = "#{ Rails.root }/tmp/customer_del_records/non_db_duplicates_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      system("awk '{if (NR!=1) {print}}' #{invalid_format_file} > #{invalid_file}")
      system("awk '{if (NR!=1) {print}}' #{file_dup} > #{dup_in_file}")
      system("awk -F , '{if ($11!=\"db\") print}' OFS=, #{db_dup} > #{only_file_error}") # Remove Db duplicate if exists
      system("cut -d\",\" -f1,2,3,4,5,6,7,8,9,10,12 #{dup_in_file} > #{removed_type_file} ") # Remove type column from file duplicate
      system("cut -d\",\" -f1,2,3,4,5,6,7,8,9,10,12 #{only_file_error} > #{removed_type_db} ") # Remove type column from db duplicate
      system("cat #{removed_type_file} #{invalid_file} > #{file_format_list}")
      system("cat #{removed_type_db} #{file_format_list} > #{final_error_list}")
      system("rm -rf #{invalid_file} #{dup_in_file} #{removed_type_file} #{removed_type_db} #{file_format_list} #{only_file_error}")
      final_error_list
    end

    def self.update_deleted_records(file,user)
      deleted_records = "#{ Rails.root }/tmp/customer_del_records/deleted_records_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      system("cut -d\",\" -f1,2,3,4,5,6,7,8,9,10 #{file} > #{deleted_records} ")
      CSV.foreach(deleted_records, :headers => true, :header_converters => :symbol, :skip_blanks => true, :encoding => 'ISO-8859-1', :converters => :all) do |row|
        hash_val = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
        if hash_val.count > 0
          hash_val[:is_deleted] = nil
          BusinessCustomerInfo.where("email ='#{hash_val[:email]}' or mobile = '#{hash_val[:mobile]}' and user_id = #{user.id}").update_all(hash_val)
        end
      end
      File.delete(deleted_records) if File.exist?(deleted_records)
    end

    def self.add_user_id(file,user)
      added_user_id = "#{ Rails.root }/tmp/biz_customer_records/final_file_user_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      added_created_at = "#{ Rails.root }/tmp/biz_customer_records/final_file_created_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      added_updated_at = "#{ Rails.root }/tmp/biz_customer_records/final_file_updated_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      success_hash_val = "#{ Rails.root }/tmp/biz_customer_records/success_input_file_#{user.id}_#{Time.now.strftime('%H:%M:%S')}.csv"
      system("awk -F, '{$(NF+1) = NR==1 ? \"user_id\" : \"#{user.id}\"}1'  OFS=,  #{file} > #{added_user_id}")
      system("awk -F, '{$(NF+1) = NR==1 ? \"created_at\" : \"#{Time.now}\"}1'  OFS=,  #{added_user_id} > #{added_created_at}")
      system("awk -F, '{$(NF+1) = NR==1 ? \"updated_at\" : \"#{Time.now}\"}1'  OFS=,  #{added_created_at} > #{added_updated_at}")
      system("awk '{if (NR!=1) {print}}' #{added_updated_at} > #{success_hash_val}")
      system("rm -rf #{added_user_id} #{added_created_at} #{added_updated_at}")
      success_hash_val
    end

    def self.total_count(file)
      check_file = File.new(file)
      check_file.readlines.size - 1
    end
  end
end