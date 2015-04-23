  class ListenerMailer < MassMandrill::MandrillMailer
  def activate_listener_email(listener,subject,current_user_email,first_name)
    global_merge_vars = [{ :name => "COMPANYNAME", :content => 'Inquirly Listen Module Activation
'}]
            message = "<div class='email-body-content'>
                            <p>Hi #{first_name}<span mc:edit='main' style='color:#0191a9;' id='email_add'></span>,</p>
                              <p>Listen module for your Inquirly account has been activated. <a href=#{Bitly_url['url']}>Start Listening</a></p>
                          </div>Regards,<br/>Inquirly Admin"
            merge_vars = {:rcpt => [listener.email], :vars => [{ :name => 'first_name', :content => "testing first name" }]}
            template_content = [{ :name => 'header', :content => message }]
            mail(to: [listener.email],
                 from: current_user_email,
                 subject: subject,
                 template:"Inquirly_Listener_activation",
                 template_content: template_content,
                 global_merge_vars: global_merge_vars,
                 merge_vars: merge_vars).deliver
  end
end


