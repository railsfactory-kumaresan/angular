class ChangeVideoType < ActiveRecord::Migration
  def up
    rename_column :questions, :video_type, :video_type_new
    add_column :questions, :video_type, :integer
    Question.all.each do |a|
    	a.update_attributes(:video_type=>a[:video_type_new].to_i)
    end
    remove_column :questions, :video_type_new
  end

  def down
  end
end
