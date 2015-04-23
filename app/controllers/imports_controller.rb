require "#{Rails.root}/lib/csv_job.rb"
class ImportsController < ApplicationController
  require 'aws/s3'
  require 'csv'
  require 'fileutils'

  before_filter :authenticate_user_web_api
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_role_level_permissions, :except => [:customer_data]
  before_filter :check_admin_user

  CSV_HEADER = ["customer_name", "email", "age", "gender", "mobile(*Add mobile number without country code)", "country", "state", "city", "area", "custom_field"]

  def create_customer_info
    file_path = request.format.json? ? move_file_to_tmp(params[:datafile], current_user) : move_file_to_tmp(params[:business_customer_info][:datafile],current_user)
    file = CSV.read(file_path)
    if file_path.present? && file.first == CSV_HEADER
      current_user.update_csv_process(false)
      Delayed::Job.enqueue(CsvJob.new(file_path, current_user), 3)
      flash[:notice] = APP_MSG['csv']['success_upload']
    else
      flash[:notice] = APP_MSG['csv']['invalid_file']
    end
    respond_to do |format|
      format.html { redirect_to '/account/company_settings'}
      format.json {render json: success({ message: "Customer details added successfully."})}
    end
  end

  def csv_template
    @header = ["customer_name", "email", "age", "gender", "mobile(*Add mobile number without country code)", "country", "state", "city", "area", "custom_field"]
    respond_to do |format|
      format.csv { send_data @header.to_csv }
    end
  end

  def customer_data
    @customer = BusinessCustomerInfo.where("user_id =? and is_deleted is NULL",current_user.id).select(:customer_name, :email, :age, :gender, :mobile, :country, :state, :city, :area, :custom_field)
    respond_to do |format|
      format.csv { send_data @customer.to_csv }
    end
  end

  private

  def move_file_to_tmp(datafile, user)
    file_name_without_extension = datafile.original_filename.gsub( /.{3}$/, '' )
    Dir.mkdir("#{ Rails.root }/tmp/csv_inputs") unless File.exists?("#{ Rails.root }/tmp/csv_inputs")
    name = "#{ file_name_without_extension }_#{ user.id }.csv"
    directory = "#{ Rails.root }/tmp/csv_inputs/"
    file_path = File.join(directory, name)
    FileUtils.mv datafile.path, file_path
    file_path
  end
end