class AddExpiredAtToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions,:expired_at,:date
    questions=Question.where('status = ?',"Active")
    if questions.present?
      questions.each do |ques|
       exp=ques.expiration_id.split(" ")[1]
       case exp
        when "Day"
         ques.expired_at=ques.created_at.to_date+1.day
         ques.save(:validate=>false)
        when "Week"
         ques.expired_at=ques.created_at.to_date+1.week
         ques.save(:validate=>false)
        when "Month"
         ques.expired_at=ques.created_at.to_date+1.month
         ques.save(:validate=>false)
        when "Year"
         ques.expired_at=ques.created_at.to_date+1.year
         ques.save(:validate=>false)
        end
      end
    end
  end
  def self.down
    remove_column :questions,:expired_at
  end
end
