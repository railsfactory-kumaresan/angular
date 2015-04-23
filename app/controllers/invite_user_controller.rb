class InviteUserController < ApplicationController
  def question_status
    question = Question.question_status
  end

  def question_expiry
    monthly_questions, yearly_questions = User.question_expiry
    if !monthly_questions.blank? || !yearly_questions.blank?
    [monthly_questions, yearly_questions].each do |i|
      i.each do |ques|
        user = User.find_by_id(ques.user_id)
        if ques.expired_at.present?
          mail_day = ques.expired_at - 7.day
         if mail_day  <= Time.now.utc
           remaining_days = get_total_remaining_days(ques.expired_at)
           InviteUser.question_expired(user,ques,remaining_days).deliver if remaining_days != 0
        end
       end
      end
    end
   end
  end
end