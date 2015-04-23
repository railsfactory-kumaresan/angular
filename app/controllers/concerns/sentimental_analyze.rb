module SentimentalAnalyze
  extend ActiveSupport::Concern
  included do

   def sentiment_analyze
    answers = AnswerAnalysis.get_sentiment_score(params[:id])
    @sentiment_analyses,total ={},0
    answers.each do |answer|
     #type = DEFAULTS["sentiment_scores"].key(answer.sentiment_score)
     type = "Negative" if answer.sentiment_score <= 1
     type = "Neutral" if answer.sentiment_score == 2
     type = "Positive" if answer.sentiment_score >=3
     @sentiment_analyses["#{type}"] = {} if @sentiment_analyses["#{type}"].nil?
     @sentiment_analyses["#{type}"].merge!({"count"=> answer.score_count})
     total += answer.score_count
    end
    sentiment_percentage ={}
    DEFAULTS["sentiment_scores"].keys.each do |type|
    @sentiment_analyses["#{type}"] = {} if @sentiment_analyses["#{type}"].nil?
    count = @sentiment_analyses["#{type}"]["count"] ? @sentiment_analyses["#{type}"]["count"] : 0
    percentage = ((total !=0 && count != 0) ? ((count.to_f/total) * 100) : 0)
    percentage = "#{sprintf '%.2f', percentage}"
    sentiment_percentage["#{type.gsub(" ","_")}"] = percentage
    end
    render :json => sentiment_percentage
   end

  end
end