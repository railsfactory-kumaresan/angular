# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150401093303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "sslinfo"

  create_table "answer_analyses", force: true do |t|
    t.integer  "answer_id",       null: false
    t.integer  "question_id",     null: false
    t.integer  "sentiment_score", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_analyses", ["answer_id"], name: "index_answer_analyses_on_answer_id", using: :btree
  add_index "answer_analyses", ["question_id"], name: "analyses_question_id", using: :btree

  create_table "answer_options", force: true do |t|
    t.integer  "question_id", null: false
    t.hstore   "options",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_options", ["question_id"], name: "index_answer_options_on_question_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "customers_info_id"
    t.integer  "question_id"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comments"
    t.text     "free_text"
    t.integer  "question_option_id"
    t.integer  "question_type_id"
    t.string   "option"
    t.integer  "date"
    t.integer  "month"
    t.integer  "year"
    t.integer  "hour"
    t.boolean  "is_business_user"
    t.boolean  "is_deactivated"
    t.boolean  "is_other",           default: false
    t.integer  "uuid"
  end

  add_index "answers", ["customers_info_id"], name: "index_answers_on_customers_info_id", using: :btree
  add_index "answers", ["question_id"], name: "answers_index", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["question_option_id"], name: "index_answers_on_question_option_id", using: :btree
  add_index "answers", ["question_type_id"], name: "index_answers_on_question_type_id", using: :btree

  create_table "attachments", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], name: "index_attachments_on_attachable_id_and_attachable_type", using: :btree
  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree

  create_table "backlog_email_lists", force: true do |t|
    t.text     "email_array",    default: "{}"
    t.string   "bitly_url"
    t.text     "subject"
    t.text     "message"
    t.string   "sender_email"
    t.string   "question_image"
    t.string   "ref_message_id"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_type"
    t.string   "attach_path"
    t.string   "attach_type"
    t.string   "attach_name"
    t.boolean  "is_html"
    t.integer  "question_id"
  end

  create_table "billing_info_details", force: true do |t|
    t.integer  "user_id"
    t.string   "billing_name"
    t.string   "billing_email"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_country"
    t.integer  "billing_zip",     limit: 8
    t.string   "billing_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "billing_info_details", ["user_id"], name: "index_billing_info_details_on_user_id", using: :btree

  create_table "business_customer_infos", force: true do |t|
    t.string   "mobile"
    t.string   "customer_name"
    t.string   "email"
    t.boolean  "response_status"
    t.boolean  "view_status"
    t.string   "gender"
    t.string   "question_id"
    t.string   "provider"
    t.date     "date_of_birth"
    t.integer  "age"
    t.integer  "user_id"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cookie_token_id"
    t.boolean  "is_deleted"
    t.string   "custom_field"
    t.string   "status",          default: false
  end

  add_index "business_customer_infos", ["cookie_token_id"], name: "index_business_customer_infos_on_cookie_token_id", using: :btree
  add_index "business_customer_infos", ["country"], name: "index_business_customer_infos_on_country", using: :btree
  add_index "business_customer_infos", ["email"], name: "index_business_customer_infos_on_email", using: :btree
  add_index "business_customer_infos", ["question_id"], name: "index_business_customer_infos_on_question_id", using: :btree
  add_index "business_customer_infos", ["user_id"], name: "index_business_customer_infos_on_user_id", using: :btree

  create_table "category_types", force: true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_languages", force: true do |t|
    t.integer  "client_setting_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_languages", ["client_setting_id"], name: "index_client_languages_on_client_setting_id", using: :btree
  add_index "client_languages", ["language_id"], name: "index_client_languages_on_language_id", using: :btree

  create_table "client_settings", force: true do |t|
    t.integer  "user_id",                          null: false
    t.integer  "pricing_plan_id",                  null: false
    t.integer  "tenant_count"
    t.integer  "customer_records_count"
    t.integer  "language_count"
    t.integer  "business_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_hourly_quota",     limit: 8
    t.integer  "questions_count"
    t.integer  "video_photo_count"
    t.integer  "sms_count"
    t.integer  "call_count"
    t.integer  "email_count"
  end

  add_index "client_settings", ["pricing_plan_id"], name: "index_client_settings_on_pricing_plan_id", using: :btree
  add_index "client_settings", ["user_id"], name: "index_client_settings_on_user_id", using: :btree

  create_table "cookie_tokens", force: true do |t|
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counts_stores", force: true do |t|
    t.integer  "question_id",                                                                                                                                                                                                                                                                                                                                                            null: false
    t.string   "vrtype",                                                                                                                                                                                                                                                                                                                                                                 null: false
    t.integer  "norm_date",                                                                                                                                                                                                                                                                                                                                                              null: false
    t.string   "country"
    t.hstore   "counts_key",  default: {"f"=>"0", "m"=>"0", "fb"=>"0", "lk"=>"0", "qr"=>"0", "tw"=>"0", "sms"=>"0", "tkc"=>"0", "af00"=>"0", "af17"=>"0", "af25"=>"0", "af30"=>"0", "af35"=>"0", "af40"=>"0", "af45"=>"0", "af50"=>"0", "am00"=>"0", "am17"=>"0", "am25"=>"0", "am30"=>"0", "am35"=>"0", "am40"=>"0", "am45"=>"0", "am50"=>"0", "call"=>"0", "mail"=>"0", "embed"=>"0"}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counts_stores", ["counts_key"], name: "index_counts_stores_on_counts_key", using: :gin
  add_index "counts_stores", ["question_id"], name: "index_counts_stores_on_question_id", using: :btree

  create_table "cron_logs", force: true do |t|
    t.integer  "last_run_id"
    t.string   "log_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "distribute_pricing_plans", force: true do |t|
    t.string   "plan_name",             null: false
    t.boolean  "form_builder"
    t.boolean  "offline_mode"
    t.boolean  "nrts_results"
    t.integer  "surveys_count"
    t.integer  "responses_count"
    t.boolean  "tell_the_world"
    t.boolean  "multilingual"
    t.boolean  "professional_template"
    t.boolean  "multitenant_structure"
    t.boolean  "download_reports"
    t.boolean  "sentiment_analysis"
    t.string   "media_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_activities", force: true do |t|
    t.integer  "opens"
    t.integer  "clicks"
    t.string   "subject"
    t.string   "campaign_name"
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "business_customer_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enterprise_api_endpoints", force: true do |t|
    t.string  "subdomain"
    t.string  "login_path"
    t.string  "logout_path"
    t.string  "forgot_pw_path"
    t.string  "change_pw_path"
    t.integer "user_id"
  end

  create_table "enterprise_contacts", force: true do |t|
    t.string  "name"
    t.string  "path"
    t.integer "enterprise_api_endpoint_id"
    t.boolean "tenant_can_access"
    t.text    "params"
  end

  create_table "executive_tenant_mappings", force: true do |t|
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.integer  "client_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "executive_tenant_mappings", ["tenant_id"], name: "index_executive_tenant_mappings_on_tenant_id", using: :btree
  add_index "executive_tenant_mappings", ["user_id"], name: "index_executive_tenant_mappings_on_user_id", using: :btree

  create_table "features", force: true do |t|
    t.integer  "parent_id",       null: false
    t.string   "controller_name", null: false
    t.string   "action_name"
    t.string   "title",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listeners", force: true do |t|
    t.string   "client_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "status"
    t.boolean  "is_active",    default: false
    t.boolean  "is_requested", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
  end

  add_index "listeners", ["user_id"], name: "index_listeners_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "role_id",         null: false
    t.string   "controller_name", null: false
    t.string   "action_name",     null: false
    t.boolean  "access_level",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], name: "index_permissions_on_role_id", using: :btree

  create_table "pricing_category_types", force: true do |t|
    t.integer  "category_type_id"
    t.integer  "pricing_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pricing_category_types", ["category_type_id"], name: "index_pricing_category_types_on_category_type_id", using: :btree
  add_index "pricing_category_types", ["pricing_plan_id"], name: "index_pricing_category_types_on_pricing_plan_id", using: :btree

  create_table "pricing_plans", force: true do |t|
    t.string   "plan_name",                                        null: false
    t.integer  "business_type_id",                                 null: false
    t.integer  "tenant_count",                                     null: false
    t.integer  "customer_records_count",                           null: false
    t.integer  "language_count",                                   null: false
    t.string   "country",                          default: "IN",  null: false
    t.datetime "expired_date"
    t.boolean  "question_suggestions",                             null: false
    t.integer  "questions_count",        limit: 8,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_photo_count"
    t.boolean  "qr_share"
    t.integer  "sms_count"
    t.integer  "call_count"
    t.integer  "email_count"
    t.boolean  "social_share"
    t.boolean  "embed_share"
    t.boolean  "listener"
    t.float    "amount"
    t.boolean  "redirect_url",                     default: false
    t.boolean  "from_number",                      default: false
    t.integer  "listener_slots"
    t.integer  "crawler_slots"
    t.boolean  "email_alerts"
  end

  create_table "question_options", force: true do |t|
    t.integer  "question_id"
    t.string   "option"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.boolean  "is_other"
    t.boolean  "is_deactivated"
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id", using: :btree

  create_table "question_response_logs", force: true do |t|
    t.integer  "question_id"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "cookie_token_id"
    t.boolean  "is_processed",              default: true
    t.integer  "business_customer_info_id"
  end

  add_index "question_response_logs", ["cookie_token_id"], name: "index_question_response_logs_on_cookie_token_id", using: :btree
  add_index "question_response_logs", ["question_id"], name: "index_question_response_logs_on_question_id", using: :btree
  add_index "question_response_logs", ["user_id"], name: "index_question_response_logs_on_user_id", using: :btree

  create_table "question_styles", force: true do |t|
    t.integer  "question_id"
    t.string   "background"
    t.string   "page_header"
    t.string   "submit_button"
    t.string   "question_text"
    t.string   "button_text"
    t.string   "answers"
    t.string   "font_style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_styles", ["question_id"], name: "index_question_styles_on_question_id", using: :btree

  create_table "question_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_view_logs", force: true do |t|
    t.integer  "question_id"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "cookie_token_id"
    t.boolean  "is_processed",              default: true
    t.integer  "business_customer_info_id"
  end

  add_index "question_view_logs", ["cookie_token_id"], name: "index_question_view_logs_on_cookie_token_id", using: :btree
  add_index "question_view_logs", ["question_id"], name: "index_question_view_logs_on_question_id", using: :btree
  add_index "question_view_logs", ["user_id"], name: "index_question_view_logs_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_type_id"
    t.string   "expiration_id"
    t.string   "question"
    t.boolean  "include_other"
    t.boolean  "include_text"
    t.boolean  "include_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",             default: "Inactive"
    t.text     "thanks_response"
    t.datetime "expired_at"
    t.string   "qrcode_status"
    t.string   "embed_url"
    t.string   "video_url"
    t.integer  "question_type_id"
    t.integer  "video_type"
    t.string   "slug"
    t.string   "language",           default: "English"
    t.boolean  "private_access",     default: false
    t.string   "short_url"
    t.string   "twitter_short_url"
    t.string   "linkedin_short_url"
    t.string   "qrcode_short_url"
    t.string   "sms_short_url"
    t.integer  "view_count",         default: 0
    t.integer  "response_count",     default: 0
    t.string   "video_url_thumb"
    t.integer  "tenant_id"
    t.boolean  "embed_status",       default: false
  end

  add_index "questions", ["category_type_id"], name: "index_questions_on_category_type_id", using: :btree
  add_index "questions", ["expiration_id"], name: "index_questions_on_expiration_id", using: :btree
  add_index "questions", ["question_type_id"], name: "index_questions_on_question_type_id", using: :btree
  add_index "questions", ["slug"], name: "index_questions_on_slug", unique: true, using: :btree
  add_index "questions", ["tenant_id"], name: "qs_tenant_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "response_cookie_infos", force: true do |t|
    t.integer  "response_token_id"
    t.string   "response_token_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cookie_token_id"
  end

  add_index "response_cookie_infos", ["cookie_token_id"], name: "res_cookie_token_id", using: :btree
  add_index "response_cookie_infos", ["response_token_id"], name: "index_response_cookie_infos_on_response_token_id", using: :btree
  add_index "response_cookie_infos", ["response_token_type"], name: "res_response_token_type", using: :btree

  create_table "response_customer_infos", force: true do |t|
    t.string   "mobile"
    t.string   "customer_name"
    t.string   "email"
    t.boolean  "response_status"
    t.boolean  "view_status"
    t.string   "gender"
    t.string   "question_id"
    t.string   "provider"
    t.date     "date_of_birth"
    t.integer  "age"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cookie_token_id"
    t.integer  "user_id"
    t.boolean  "is_deleted"
  end

  add_index "response_customer_infos", ["cookie_token_id"], name: "index_response_customer_infos_on_cookie_token_id", using: :btree
  add_index "response_customer_infos", ["question_id"], name: "index_response_customer_infos_on_question_id", using: :btree
  add_index "response_customer_infos", ["user_id"], name: "index_response_customer_infos_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",                       null: false
    t.boolean  "is_default", default: false, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "share_details", force: true do |t|
    t.integer  "customer_records_count", default: 0, null: false
    t.integer  "questions_count",        default: 0, null: false
    t.integer  "video_photo_count",      default: 0, null: false
    t.integer  "sms_count",              default: 0, null: false
    t.integer  "call_count",             default: 0, null: false
    t.integer  "email_count",            default: 0, null: false
    t.integer  "user_id",                default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "share_details", ["user_id"], name: "index_share_details_on_user_id", using: :btree

  create_table "share_questions", force: true do |t|
    t.string   "email_address"
    t.string   "provider"
    t.string   "social_id"
    t.string   "social_token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             default: false
    t.string   "user_name"
    t.string   "user_profile_image"
  end

  add_index "share_questions", ["social_id"], name: "index_share_questions_on_social_id", using: :btree
  add_index "share_questions", ["user_id"], name: "index_share_questions_on_user_id", using: :btree

  create_table "share_summaries", force: true do |t|
    t.integer  "customer_records_count", default: 0, null: false
    t.integer  "questions_count",        default: 0, null: false
    t.integer  "video_photo_count",      default: 0, null: false
    t.integer  "sms_count",              default: 0, null: false
    t.integer  "call_count",             default: 0, null: false
    t.integer  "email_count",            default: 0, null: false
    t.integer  "user_id",                default: 0, null: false
    t.datetime "last_shared_date",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "share_summaries", ["user_id"], name: "index_share_summaries_on_user_id", using: :btree

  create_table "tenants", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",    default: true
    t.string   "redirect_url"
    t.string   "from_number"
  end

  create_table "transaction_details", force: true do |t|
    t.integer  "user_id"
    t.integer  "business_type_id"
    t.float    "amount"
    t.string   "transaction_id"
    t.string   "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiry_date"
    t.string   "order_id"
    t.boolean  "active",           default: false
    t.string   "action"
    t.string   "payment_status"
    t.text     "zaakpay_response"
    t.string   "response_dec"
    t.integer  "response_code"
    t.string   "tracking_id"
    t.string   "bank_ref_no"
    t.string   "failure_message"
    t.string   "payment_mode"
    t.string   "card_name"
    t.integer  "status_code"
    t.string   "status_message"
    t.string   "currency"
    t.integer  "request_plan_id"
  end

  add_index "transaction_details", ["business_type_id"], name: "index_transaction_details_on_business_type_id", using: :btree
  add_index "transaction_details", ["order_id"], name: "index_transaction_details_on_order_id", using: :btree
  add_index "transaction_details", ["profile_id"], name: "index_transaction_details_on_profile_id", using: :btree
  add_index "transaction_details", ["transaction_id"], name: "index_transaction_details_on_transaction_id", using: :btree
  add_index "transaction_details", ["user_id"], name: "index_transaction_details_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.integer  "business_type_id"
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "provider"
    t.text     "uid"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_secret"
    t.string   "linkedin_token"
    t.string   "linkedin_secret_token"
    t.boolean  "admin",                      default: false
    t.boolean  "subscribe",                  default: false
    t.string   "role"
    t.datetime "exp_date"
    t.boolean  "is_active"
    t.string   "fb_status"
    t.string   "twitter_status"
    t.string   "linkedin_status"
    t.text     "email_content"
    t.integer  "failed_attempts"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "sms_content"
    t.string   "call_content"
    t.integer  "role_id"
    t.integer  "tenant_id"
    t.string   "redirect_url"
    t.string   "from_number"
    t.integer  "distribute_pricing_plan_id"
    t.boolean  "is_csv_processed",           default: true
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["business_type_id"], name: "index_users_on_business_type_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["parent_id"], name: "index_users_on_parent_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["tenant_id"], name: "index_users_on_tenant_id", using: :btree

end
