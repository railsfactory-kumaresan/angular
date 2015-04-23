#~ require 'csv'
#~ class Admin::ReportsController < ApplicationController
  #~ layout 'admin_layout'
  #~ before_filter :check_user

  #~ def dashboard
  #~ end

  #~ def weekly_report
    #~ report_weekly_daily
    #~ if (params[:csv] == "true" && params[:top_three_questions_csv])
      #~ csv_string = CSV.generate do |csv|
        #~ csv << ["Question", "Views", "Responses"]
        #~ @questions.each do |q|
          #~ csv << [q.question, q.question_view_counts.count, q.answers.count]
        #~ end
      #~ end
      #~ send_data csv_string,
        #~ :type => 'text/csv; charset=iso-8859-1; header=present',
        #~ :disposition => "attachment; filename=top_three_questions_report.csv"
    #~ end
  #~ end

  #~ def daily_report
    #~ report_daily_report
    #~ csv_file_name = ''
    #~ array_of_questions = ''
    #~ if (params[:csv] == "true" && params[:questions_csv])
      #~ header = ["Question", "Views", "Responses"]
      #~ array_of_questions = @questions
      #~ csv_file_name = "questions_report.csv"
    #~ elsif  (params[:csv] == "true" && params[:todays_sign_ins_csv])
      #~ header = ["CompanyName", "Firstname", "LastName", "Email"]
      #~ array_of_questions = @todays_sign_ins
      #~ csv_file_name = "todays_signins_report.csv"
    #~ elsif  (params[:csv] == "true" && params[:users_sign_ups])
      #~ header = ["Companyname", "Username", "Email"]
      #~ array_of_questions = @users_sign_ups
      #~ csv_file_name = "todays_signups_report.csv"
    #~ elsif  (params[:csv] == "true" && params[:active_questions])
      #~ header = ["Question", "Views", "Responses"]
      #~ array_of_questions =  @active_questions
      #~ csv_file_name = "active_questions_report.csv"
    #~ end
    #~ csv_string = generete_csv(array_of_questions,header,params)
    #~ send_data csv_string,
      #~ :type => 'text/csv; charset=iso-8859-1; header=present',
      #~ :disposition => "attachment; filename=#{csv_file_name}"
  #~ end

  #~ def generete_csv(array_of_questions,header,params)
    #~ csv_string = CSV.generate do |csv|
      #~ csv << header
      #~ array_of_questions.each do |t|
        #~ csv << [t["company_name"], t["first_name"], t["last_name"], t["email"]] if params[:todays_sign_ins_csv].present?
        #~ csv << [t.question, t.question_view_counts.count, t.answers.count] if params[:questions_csv].present? || params[:active_questions].present?
        #~ csv << [t["company_name"], [t["first_name"]+t["last_name"]], t["email"]] if params[:users_sign_ups].present?        
      #~ end
    #~ end
    #~ return csv_string
  #~ end

  #~ #Cron job for weekly reports
  #~ def weekly_reports
    #~ report_weekly_daily
    #~ @email = 'shiva.r547@gmail.com'
    #~ ReportMailer.weekly_reports(@email, @top_three_questions, @Feedback_qustions, @Marketing_qustions, @Innovation_qustions).deliver
  #~ end

  #~ #Cron job for daily reports
  #~ def daily_reports
    #~ report_daily_report
    #~ @email = 'shiva.r547@gmail.com'
    #~ ReportMailer.daily_reports(@email, @todays_sign_ins, @users_sign_ups, @active_questions, @transactions).deliver
  #~ end

  #~ def report_weekly_daily
    #~ # Top 3 questions which are have more responces.
    #~ @top_three_questions = []
    #~ @top_three_questions_hash = []
    #~ @questions = Question.all
    #~ @questions = @questions.sort! { |a, b| b.answers.count <=> a.answers.count }
    #~ @questions = @questions[0..2].each do |q|
      #~ @top_three_questions << q
      #~ @User_details = User.find_by_id(q.user_id)
      #~ @top_three_questions_hash << {"user_name" => (@User_details&&@User_details.first_name.present?) ? @User_details.first_name : "", "question" => q.question, "view_count" => q.question_view_counts.count, "responce_count" => q.answers.count}
    #~ end
    #~ # Top 3 companies which are have more responces.
    #~ @top_companies= []
    #~ @top_three_questions.each do |t|
      #~ @User_detail = User.find_by_id(t.user_id)
      #~ @top_companies << {"company_name" => (@User_detail && @User_detail.company_name.present?) ? @User_detail.company_name : "", "question" => t.question, "view_count" => t.question_view_counts.count, "responce_count" => t.question_options.count}
    #~ end
    #~ # Percentage breack down based on Category Type.
    #~ @category = CategoryType.all.uniq_by{|x| x.category_name}
    #~ @percentage_breack_down_users = Question.joins(:user).where("users.business_type_id = ?", 2).all
    #~ @Feedback_qustions = @percentage_breack_down_users.select { |question| question.category_type_id == @category[0].id }.count
    #~ @Marketing_qustions = @percentage_breack_down_users.select { |question| question.category_type_id == @category[1].id }.count
    #~ @Innovation_qustions = @percentage_breack_down_users.select { |question| question.category_type_id == @category[2].id }.count
  #~ end

  #~ def report_daily_report
    #~ today = Date.today
    #~ @questions = Question.where("created_at >= ?", today)
    #~ @questions_array = []
    #~ @active_questions_array =[]
    #~ @questions = @questions.each do |q|
      #~ @User_details = User.find_by_id(q.user_id)
      #~ @questions_array << {"user_name" => (@User_details && @User_details.first_name.present?) ? @User_details.first_name : "", "question" => q.question, "view_count" => q.question_view_counts.count, "responce_count" => q.answers.count}
    #~ end
    #~ @todays_sign_ins = User.where("current_sign_in_at >= ?", today)
    #~ @users_sign_ups = User.where("created_at >= ?", today)
    #~ @active_questions = Question.where("status == Active" && "updated_at >= ?", today)
    #~ @active_questions.each do |q1|
      #~ @User_detail = User.find_by_id(q1.user_id)
      #~ @active_questions_array << {"user_name" => (@User_detail && @User_detail.first_name.present?) ? @User_detail.first_name : "", "question" => q1.question, "view_count" => q1.question_view_counts.count, "responce_count" => q1.answers.count}
    #~ end
    #~ @transactions = TransactionDetail.where("created_at >= ?", today)
  #~ end

  #~ def check_user
    #~ if current_user && current_user.admin == false
      #~ flash[:non_fade_notice] = "You are not authorized to access admin details."
      #~ redirect_to '/dashboard'
    #~ end
  #~ end
#~ end