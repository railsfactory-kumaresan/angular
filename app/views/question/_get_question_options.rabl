object @question
attributes :id, :category_type_id, :expiration_id, :question, :include_text, :include_other, :question_type_id, :include_comment, :status, :thanks_response, :expired_at, :qrcode_status, :embed_url, :video_type, :video_url
child :question_options do |s|
   attributes :question_id,:option,:order,:is_other , :if => lambda { |m| m.is_other == false }
end