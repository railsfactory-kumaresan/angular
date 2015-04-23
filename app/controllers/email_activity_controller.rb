class EmailActivityController < ApplicationController

  def show
    head(:ok)
  end

  def email_track
    Delayed::Job.enqueue(EmailAnalytics.new(JSON.parse(params['mandrill_events'])), 1)
    render :json => {status:200, message: "success"}
  end

end
