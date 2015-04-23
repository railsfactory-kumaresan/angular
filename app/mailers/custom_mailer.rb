require 'mandrill'
class CustomMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  def confirmation_instructions(record, token, opts={})
    user_email = !record.provider.blank? ? record.unconfirmed_email : record.email
    mandrill = Mandrill::API.new "#{ENV["MANDRILL_API_KEY"]}"
    template_name = "Inquirly-custom-template"
    plan_name = PricingPlan.where(id: record.business_type_id).first.plan_name
    pay_status = plan_name == 'Trial'? '' : true
    template_content = [{ :name => 'header', :content => "Dear #{record.first_name}, <br><br> You can confirm your account email through the link below: <br><br> <a href='#{confirmation_url(record, :confirmation_token => record.confirmation_token, :pay => pay_status)}'>Confirm my Account</a> <br><br><br> Regards,<br>Inquirly Admin" }]
    message = {
            :subject => "Welcome to Inquirly",
            :from_email => "admin@inquirly.com",
            :to => [{:email => user_email}],
            :important => true,
            :global_merge_vars => [{ :name => "IMAGE", :content => "<img src='http://signin.inquirly.com/assets/login/header-login-logo.png' mc:label='header_image' mc:edit='header_image' style='max-width:540px; text-align:centre;'>" }]
      }
     mandrill.messages.send_template template_name, template_content, message
  end

  def reset_password_instructions(record, token, opts={})
    mandrill = Mandrill::API.new "#{ENV["MANDRILL_API_KEY"]}"
    template_name = "Inquirly-custom-template"
    template_content = [{ :name => 'header', :content => "Dear #{record.first_name}, <br><br> Please click on the link below to reset your password: <br><br> <a href='#{edit_password_url(record, :reset_password_token => record.reset_password_token)}'>Change my password</a> <br><br><br>If you had not requested for the password change, please ignore this email.<br> Regards,<br>Inquirly Admin" }]
    message = {
        :subject => "Inquirly - Reset Password instruction",
        :from_email => "admin@inquirly.com",
        :to => [{:email => record.email}],
        :important => true,
        :global_merge_vars => [{ :name => "IMAGE", :content => "<img src='http://signin.inquirly.com/assets/login/header-login-logo.png' mc:label='header_image' mc:edit='header_image' style='max-width:540px; text-align:centre;'>" }]
    }
    mandrill.messages.send_template template_name, template_content, message
  end

  def unlock_instructions(record, token, opts={})
    mandrill = Mandrill::API.new "#{ENV["MANDRILL_API_KEY"]}"
    template_name = "Inquirly-custom-template"
    template_content = [{ :name => 'header', :content => "Dear #{record.first_name}, <br><br> Your account has been locked due to maximum number of unsuccessful sign in attempts.<br> Please click the link below to unlock your account: <br><br> <a href='#{unlock_url(record, :unlock_token => record.unlock_token)}'>Unlock my account</a> <br><br><br> Regards,<br>Inquirly Admin" }]
    message = {
        :subject => "Inquirly - Unlock instruction",
        :from_email => "admin@inquirly.com",
        :to => [{:email => record.email}],
        :important => true,
        :global_merge_vars => [{ :name => "IMAGE", :content => "<img src='http://signin.inquirly.com/assets/login/header-login-logo.png' mc:label='header_image' mc:edit='header_image' style='max-width:540px; text-align:centre;'>" }]
    }
    mandrill.messages.send_template template_name, template_content, message
  end
end