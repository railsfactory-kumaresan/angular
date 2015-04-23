class SmsJob < Struct.new(:phone_number,:msg)
def perform
    ShareQuestion.share_message(phone_number, msg)
end
end
