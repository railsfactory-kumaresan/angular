# require 'active_support/concern'
# class Answer
#   module SentimentAnalyze

#     extend ActiveSupport::Concern
#     included do
#       # commented and moved to answer model method name "sentimental_analyze_dashboard"
#       # def self.collection_of_responses(current_user,id,params)
#       #   from_date = params && params["from_date"].present? ? params["from_date"].to_date.strftime("%Y-%m-%d") : nil
#       #   to_date = params && params["to_date"].present? ? params["to_date"].to_date.strftime("%Y-%m-%d") : nil
#       #   category_id = params && params["category"].present? && params["category"].to_i != 0 ? params["category"] : nil
#       #   @search = collection_of_responses_solr(current_user,id,category_id,from_date,to_date,"ar")
#       #   @search.results.map(&:option).compact
#       # end


#       # def self.collection_of_responses_solr(current_user,id,category_id,from_date,to_date,res)
#       #   Answer.search do
#       #     all_of do
#       #       with(:question_owner_id, current_user.id) if current_user.present?
#       #       with(:question_id, [id]) if id.present? && res == "ar"
#       #       with(:question_id, id) if id.present? && res != "ar"
#       #       without(:question_option_id, nil)
#       #       without(:option, nil)
#       #       without(:option, " ")
#       #       with(:question_category_type_id, category_id) if category_id.present?
#       #       with(:created_at, "#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") if from_date.present? && to_date.present?
#       #     end
#       #     facet(:option)
#       #   end
#       # end

#       # def self.collection_of_responses_wordcloud(current_user,params)
#       #   from_date = params && params["from_date"].present? ? params["from_date"].to_date.strftime("%Y-%m-%d") : nil
#       #   to_date = params && params["to_date"].present? ? params["to_date"].to_date.strftime("%Y-%m-%d") : nil
#       #   category_id = params && params["category"].present? && params["category"].to_i != 0 ? params["category"] : nil
#       #   find_question_question_ids(params,current_user,category_id)
#       #   question_id = @question_id
#       #   @search = collection_of_responses_wordcloud_solr(question_id,current_user,params,from_date,to_date,category_id)
#       #   option_ids = @search.results.map(&:question_option_id).compact
#       #   options = @search.results.map(&:option).compact
#       #   return options,option_ids
#       # end

#       # def self.find_question_question_ids(params,current_user,category_id)
#       #   if params[:from_date].present? && params[:to_date].present?
#       #     @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ? AND category_type_id =?",params[:from_date],params[:to_date],current_user.id,category_id) if category_id != 0
#       #     @question = Question.where("DATE(created_at) >= ? AND DATE(created_at) <= ? AND user_id = ?",params[:from_date],params[:to_date],current_user.id) if category_id == 0
#       #     @question_ids = @question.pluck(:id) if @question.present?
#       #     @question_id = @question_ids.present? ? @question_ids : ''
#       #   end
#       # end

#       # def self.collection_of_responses_wordcloud_solr(question_id,current_user,params,from_date,to_date,category_id)
#       #    Answer.search do
#       #     with(:question_owner_id, current_user.id) if current_user.present?
#       #     with(:question_id,question_id) if params[:from_date].present? && params[:to_date].present?
#       #     with(:question_category_type_id, category_id) if category_id.present?
#       #     with(:created_at, "#{from_date}T00:00:00Z".."#{to_date}T23:59:59Z") if from_date.present? && to_date.present?
#       #     paginate :page => 1, :per_page => Answer.count if Answer.count > 30
#       #   end
#       # end

#       # def self.collection_of_options(current_user,id,params)
#       #   frm,to_da,cat = params[:from_date],params[:to_date],params[:category]
#       #   from_date = params && frm.present? ? frm.to_date.strftime("%Y-%m-%d") : nil
#       #   to_date = params && to_da.present? ? to_da.to_date.strftime("%Y-%m-%d") : nil
#       #   category_id = params && cat.present? && cat.to_i != 0 ? cat : nil
#       #   @search = collection_of_responses_solr(current_user,id,category_id,from_date,to_date,"a")
#       #   options = @search.results.map(&:option).uniq.compact
#       #   option_ids = @search.results.map(&:question_option_id).compact
#       #   return options,option_ids
#       # end
#     end
#   end
# end