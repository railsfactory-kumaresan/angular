Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Omniauth_keys["google_token"], Omniauth_keys["google_secret"], { access_type: "offline", approval_prompt: "force" }
  provider :linkedin,Omniauth_keys["linkedin_token"] ,Omniauth_keys["linkedin_secret"] , :scope => 'r_basicprofile,w_messages,rw_nus,r_contactinfo'
  provider :twitter, Omniauth_keys["tw_client_id"], Omniauth_keys["tw_client_secret"]
  provider :facebook, Omniauth_keys["fb_client_id"], Omniauth_keys["fb_client_secret"],
                {:scope => 'publish_stream,offline_access,email,user_birthday,user_location,user_status,user_photos,manage_notifications,read_stream', :display => 'page', :image_size => "600x400",:client_options => {:ssl => {:ca_path => "/usr/lib/ssl/certs/ca-certificates.crt"}}}
end

OmniAuth.config.on_failure do |env|
  message_key = env['omniauth.error.type']
  error = env['omniauth.error'].error
  error_reason = env['omniauth.error'].error_reason
  new_path = '/'
  [302, {'Location' => new_path, 'Content-Type'=> 'text/html'}, []]
end



OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}