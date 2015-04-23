class MailerJob < Struct.new(:email_array,:subject, :message,:question_image,:user, :question_id, :is_html)
	def perform
    EmailShare.email_share(email_array,subject,message,user.email,question_image,user.company_name,user,question_id, is_html)
	end
end