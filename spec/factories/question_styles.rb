FactoryGirl.define do
  factory :question_style do   
		background "#171717" 
		page_header "#858585"
		submit_button "#d5d5d7"
		question_text  "#30A4AC"
		button_text  "#FFFFFF"
		answers  "#636363"
		font_style "sans"
		created_at Time.now	  
		updated_at Time.now
  end
end