InquirlyNew::Application.routes.draw do

  ActiveAdmin.routes(self)
  match '/about' => "static#about", via: :get
  match '/help' => "static#help", via: :get
  post "/transaction" => "payments#handler"
  post "/response_handler" => "payments#response_handler"
  resources :tenants do
    collection do
      post 'change_tenant_status'
      get 'check_caller_id'
      get 'check_verify_caller_ids'
    end
  end
  resources :corporate_users do
    collection do
     get 'mapping_roles'
     post 'update_user_roles'
     post 'reset_password'
     get 'mapping_tenant'
     put 'update_tenant_users'
     get 'search_tenant_name'
     get 'search_user'
     get 'search_user_by_email'
     post 'change_user_status'
     get 'get_all_user'
    end
  end

  match '/', to: 'home#enterprise_login', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]
devise_scope :user do
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
    end

    unauthenticated :user do
      root  'home#index'
    end
  end
  devise_for :users, :controllers => {sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks", confirmations: "users/confirmations", unlocks: "users/unlocks"}, :path_names => {sign_in: "login", sign_up: "register"}

  # devise_scope :user do
  #   match "/users/auth/facebook/callback", :to => "users/omniauth_callbacks#facebook", via: :get
  #   match '/users/auth/twitter/callback' => "users/omniauth_callbacks#twitter", via: :get
  #   match '/users/auth/google_oauth2/callback' => "users/omniauth_callbacks#google", via: :get
  #   match '/users/auth/linkedin/callback' => "users/omniauth_callbacks#linkedin", via: :get
  # end

  devise_scope :user do
    match "/users/auth/facebook/callback", :to => "users/omniauth_callbacks#facebook", via: :get
    match '/users/auth/twitter/callback' => "users/omniauth_callbacks#twitter", via: :get
    match '/users/auth/google_oauth2/callback' => "users/omniauth_callbacks#google", via: :get
    match '/users/auth/linkedin/callback' => "users/omniauth_callbacks#linkedin", via: :get
    match 'auth/:provider/failure', :to => "users/omniauth_callbacks#failure", via: :get
    match '/users/confirmation', :to => "users/confirmations#create", :via => :post
    match '/users/confirmation/new', :to => "users/confirmations#new", :via => :get
    match '/users/confirmation', :to => "users/confirmations#show", :via => :get
    match '/users/validate_user', :to => "users/sessions#validate_user_data", :via => :post
  end

  # Import
  resources :imports do
    collection do
    post 'create_customer_info'
    get 'csv_template'
    get 'customer_data'
    end
  end

  resources :payments do
    collection do
    get 'merchant_test'
    post 'post_to_zaakpay'
    post 'z_response'
    post 'send_cancel_email'
    get 'download_success'
    post 'update_billing'
    post 'update_payment_details'
    get 'get_user_plan_details'
    get 'get_user_emails'
    end
  end

#  match "/import_data", :to => "imports#import_data", via: :post
  match "/user_info_list" => "question#user_info_list", via: :get
  # Account
  resources :account do
    collection do
      #get 'upgrade'
      #get 'downgrade'
      get 'change_plan'
      post 'social_login'
      get 'company_settings'
      #put 'update_company_info'
      get 'transaction_history'
      post 'valid_email'
      get 'user_account'
      get 'get_customer_info'
      post 'add_social_account'
      post 'account_attachment'
      get 'profile_header'
    end
  end

#api calls
 get '/transaction_history' => 'account#transaction_history'
 post '/valid_email' => 'account#valid_email'
 get '/get_inquirly_user' => 'home#get_inquirly_user'

  resources :question do
    match '/answer' => "question#answer", via: :get
    member { post 'upload_logo'}
    member { post 'customize'}
    member { post 'generate_bity_url'}
    member { get 'get_style'}
    member { get 'get_image'}
    member { get 'get_detail'}
    member { get 'view_response_by_provider'}
    member { get 'view_response_by_location'}
    member { post 'update_question_status'}
    member { get 'default_settings'}
    get :deactivate
    get :preview
    get :search, :on => :collection
    get :share_question, :on => :collection

    collection do
      get 'index'
      get 'single_question'
      get 'multiple_question'
      get 'yes_no_question'
      get 'comment_question'
      get 'qrcode_active_inactive'
      #get 'default_settings'
      post 'question_status_change'
      post 'question_video_upload', :as => "video_upload"
      get 'sentiment_analyze'
      post 'show_question_wordcloud'
     end
  end

# in web its in get request but in api post
post '/qst_deactivate', :to => 'question#deactivate'
get '/home/signup' => 'home#signup_form'
get '/home/signin' => 'home#signin_form'
get '/home/forgot_password' => 'home#forgot_password_form'
post '/share/filter_converted_leads/:remainder', :to => "share#filter_converted_leads"

  resources :share do
   collection { get 'show' }
   member do
     get 'share_to_social_nw'
     get 'show_sms'
     post 'share_sms'
     get 'show_qr'
     get 'show_embed_code'
     post 'share_email'
     post 'activate_qr'
     get 'show_call_list'
     post 'share_call'
     post 'make_demo_call'
     get 'show_email'
   end
   collection do
   post 'make_call'
   post 'api_qrcode_url'
   get 'social_status_change'
   post 'call_handle'
   get 'handle_gather'
   get 'qrcode_url'
   get 'customers_data_grid'
   get 'qrdownload'
   get 'listeners_page'
   post 'check_customer_limit'
   post 'mandril_report'
   post 'twillo_call_report'
   post 'share_facebook'
   get 'customer_data_collection'
    end
  end


  resources :surveys do
   collection do
     get 'show'
     get 'states'
     post 'show_question'
     get 'update_embed_status'
   end
   member do
     post 'response_save'
     post 'response_email_verify'
     post 'create_user_info'
     get 'embed_survey'
     post 'show_embed_survey'
     post 'save_embed_response'
   end
  end

 resources :downloads do
   collection do
     #get 'download_pdf'
     get 'download_csv'
   end
 end

 resources :customers do
    collection do
    get 'get_customer_email'
    # get 'index'
    # post 'create'
    # put 'update'
    # delete 'destroy'
    get 'email_duplication_check'
    get 'mobile_duplication_check'
    post 'delete_selected'
    post 'remove_social_account'
    end
 end

 resources :answers do
  collection do
    #get 'sentiment_analyze'
    get 'report'
  end
 end


  get 'fill_sugg_qst' => 'question#fill_sugg_qst'

  resources :dashboard, :only => [:index] do
    collection do
      get 'social_media_analytics'
      get 'get_customers_by_location'
      get 'total_gender_view_response'
      get 'datewise_question_analytics'
      get 'share_active'
      post 'response_user_info'
      post 'location'
      post 'show_dashboard_wordcloud'
      get 'shift_to_trial_period'
    end
  end

  #admin routes
  namespace :admin do
    resources :pricing_plans
    resources :permissions
    resources :client_settings do
      collection do
        get 'user_client_settings'
      end
    end
    resources :reports do
     collection do
       get 'weekly_report'
       get 'daily_report'
    end
  end
    resources :listeners do
     collection do
       get 'list_listeners'
       get 'request_listner'
       post 'share_listener'
     end
     member do
       get 'activate_listener'
     end
    end
  end

  namespace :api do
    resources :campaigns do
      collection do
       post 'email_blast'
       post 'sms_blast'
      end
    end
  end

  resources :email_activity do
    collection do
      post 'email_track'
    end
  end

  resources :manage_roles 
  #business_customer_infos
  #resources :business_customer_infos
  post "check_business_customer" => "distribute#check_business_customer"
  post "create_business_customer" => "distribute#create_business_customer"

  #~ get '*path' => 'application#invalid_url'
end
