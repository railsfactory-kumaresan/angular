class VoiceJob< Struct.new(:phone_number,:question_id,:content,:is_demo_call)
	def perform
    phone_number.each do |phone|
			 ShareQuestion.voice_call("+#{phone}",question_id,content,is_demo_call)
		end
	end
end