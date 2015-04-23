#~ require "spec_helper"

#~ describe ReportMailer do
  #~ before(:each) do
    #~ ActionMailer::Base.delivery_method = :test
    #~ ActionMailer::Base.perform_deliveries = true
    #~ ActionMailer::Base.deliveries = []
    #~ @user = FactoryGirl.create(:user, :default_biz_user)
    #~ @question = FactoryGirl.create(:question, :year_wise_expire)
  #~ end

  #~ after(:each) do
    #~ ActionMailer::Base.deliveries.clear
  #~ end

  #~ # describe "#weekly_reports" do
  #~ #   it "must send weekly reports" do
  #~ #     email = "kumaresan@railsfactory.org"
  #~ #     top_three_questions = []
  #~ #     3.times do
  #~ #       top_three_questions << FactoryGirl.create(:question, :year_wise_expire)
  #~ #     end
  #~ #     feedback_count = 0
  #~ #     marketting_count = 0
  #~ #     innovation_count = 0
  #~ #     ReportMailer.weekly_reports(email,top_three_questions,feedback_count,marketting_count,innovation_count).deliver
  #~ #     ActionMailer::Base.deliveries.count.should == 1
  #~ #   end
  #~ # end

  #~ # describe "#daily_reports" do
  #~ #   it "must send daily reports" do
  #~ #     email = "kumaresan@railsfactory.org"
  #~ #     todays_sign_ins = 50
  #~ #     users_sign_ups = 5
  #~ #     active_questions = 7
  #~ #     transactions = 12
  #~ #     ReportMailer.daily_reports(email,todays_sign_ins,users_sign_ups,active_questions,transactions).deliver
  #~ #     ActionMailer::Base.deliveries.count.should == 1
  #~ #   end
  #~ # end

#~ end