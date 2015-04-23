module SocialService
  extend ActiveSupport::Concern
  included do
  def self.fb_params_hash(auth,key,confirmed_at)
   hash_param = {provider: auth.provider, uid: auth.uid, email: key, password: Devise.friendly_token[0, 20],
        authentication_token: Devise.friendly_token, confirmed_at: confirmed_at, first_name: auth.info.first_name, last_name: auth.info.last_name,
        step: "2", is_active: true, exp_date: Time.now + 14.days , subscribe: false}
    return hash_param
  end
  def self.twitter_params_hash(auth)
    hash_param = {email: auth.info.nickname, twitter_oauth_token: auth["credentials"]["token"],
                 authentication_token: Devise.friendly_token, twitter_oauth_secret: auth["credentials"]["secret"],
                 password: Devise.friendly_token[0, 20], first_name: auth.info.name, last_name: auth.info.name,
                 provider: auth.provider,confirmed_at: Time.now, is_active: true,
                 exp_date: Time.now + 14.days, subscribe: false}
    return hash_param
  end

  def self.linkedin_params_hash(access_token,key)
    hash_param = {linkedin_token: access_token["credentials"]["token"], authentication_token: Devise.friendly_token,
                 linkedin_secret_token: access_token["credentials"]["secret"], email: key,password: Devise.friendly_token[0, 20],
                 first_name: access_token.info["first_name"], last_name: access_token.info["last_name"],provider: access_token.provider, confirmed_at: Time.now, is_active: true, exp_date: Time.now + 14.days, subscribe: false}
    return hash_param
  end
  end

  def share_my_question_fb(fb_acc_count,question,facebook_credentials,attachment,se,params)
    if fb_acc_count > 0
      custom_url = @question.custom_url("Facebook",nil,nil)
      message = "<a href='#{custom_url}'>#{@question.short_url} </a>."
      @fb_failure_user = []
      facebook_credentials.each do |credential|
        page = FbGraph::User.me(credential.social_token)
        begin
	        url = get_url(question,attachment)
          page.feed!(:message => params[:message],:picture => "#{url}", :link => custom_url, :name => params[:fb_name], :caption => params[:fb_caption])
        rescue => e
          @fb_failure_user = User.social_error_messages(e,DEFAULTS["facebook_error_response"],credential.social_id)
        end
      end
    end
  end

  def share_my_question_tw(twitter_acc_count,question,twitter_credentials,attachment,params)
    if twitter_acc_count > 0
      custom_url = question.custom_url("Twitter",nil,nil)
       message = params[:message] + " " + custom_url
      @twitter_failure_user = []
      twitter_credentials.each do |credential|
        Twitter.configure do |config|
          config.consumer_key = Omniauth_keys["tw_client_id"]
          config.consumer_secret = Omniauth_keys["tw_client_secret"]
          config.oauth_token = credential.social_token
          config.oauth_token_secret = credential.social_id
        end
        begin
         url = get_url(question,attachment)
        #url = attachment.present? ? attachment.image : "https://pbs.twimg.com/media/BotbJiLCcAA-jZA.jpg:large"
         if !url.blank?
         uri = URI.parse("#{url}")        
         media = uri.open
         class_name = File.basename(uri.path).class
         if class_name != String
         media.instance_eval("def original_filename; '#{File.basename(uri.path)}'; end")
         Twitter.update_with_media(message, media)
         else
         urii = icon_from_url "#{url}"
         sleep(50)
         Twitter.update_with_media(message, File.open(urii))
         end
         else
           Twitter.update("#{message}")
         end
        rescue => e
          @twitter_failure_user = User.social_error_messages(e,DEFAULTS["twitter_error_response"],credential.social_id)
        end
      end
    end
  end

  def share_my_question_lin(linkedin_acc_count,question,linkedin_credentials,attachment,params)
    if  linkedin_acc_count > 0
      message = "#{question.custom_url("Linkedin",nil,nil)}"
      @linkedin_failure_user = []
      linkedin_credentials.each do |credential|
        begin
	        url = get_url(question,attachment)
          client = LinkedIn::Client.new(Omniauth_keys["linkedin_token"], Omniauth_keys["linkedin_secret"])
          client.authorize_from_access(credential.social_token, credential.social_id)
          if url.blank?
           client.add_share(:comment => params[:message], :content => {"title"=>  params[:ln_title], "submitted-url" => message})
          else
           client.add_share(:comment => params[:message], :content => {"title"=>  params[:ln_title], "submitted-url" => message,"submitted-image-url" => url})
          end
        rescue => e
          @linkedin_failure_user = User.social_error_messages(e,DEFAULTS["linked_error_response"],credential.social_id)
        end
      end
    end
  end
  
   def get_url(question,attachment)
     url = " "
    #url = attachment.present? ? attachment.image.url(:large) : "#{Bitly_url['url']}/images/default_ques.jpeg"  if question.video_url.blank? && question.embed_url.blank?
    url = attachment.present? ? attachment.image.url(:large) : " " if question.video_url.blank? && question.embed_url.blank?
    url = question.video_url_thumb if !question.video_url.blank? && !question.video_url_thumb.blank?
    url = question.video_url if !question.video_url.blank? && question.video_url_thumb.blank?
    if !question.embed_url.blank?
       response = VideoInfo.new(("#{question.embed_url}"))
       url = response.thumbnail_large
     end
    return url
   end

  def icon_from_url(url)
    extname = File.extname(url)
    basename = File.basename(url, extname)
    file = Tempfile.new([basename, extname])
    @urii = file.binmode
    open(URI.parse(url)) do |data|
      file.write data.read
    end
    file.rewind
  return @urii
  end
end