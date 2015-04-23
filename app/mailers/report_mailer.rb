#~ class ReportMailer < ActionMailer::Base
  #~ default from: "from@example.com"

  #~ def weekly_reports(email,top_three_questions,feedback_count,marketting_count,innovation_count)
    #~ @email = email
    #~ emails = ([ email,'shivareddy@railsfactory.org'])
    #~ @top_three_questions = top_three_questions
    #~ @Feedback_qustions = feedback_count
    #~ @marketting_qustions = marketting_count
    #~ @Innovation_qustions = innovation_count
    #~ mail(:to =>emails , :subject => "Weekly Reports mail", content_type => "multipart/alternative")
  #~ end

  #~ def daily_reports(email,todays_sign_ins,users_sign_ups,active_questions,transactions)
    #~ @email = email
    #~ emails = ([ email,'shivareddy@railsfactory.org'])
    #~ @todays_sign_ins = todays_sign_ins
    #~ @users_sign_ups = users_sign_ups
    #~ @active_questions = active_questions
    #~ @transactions = transactions
    #~ mail(:to =>emails , :subject => "Daily Reports mail")
  #~ end

#~ end
