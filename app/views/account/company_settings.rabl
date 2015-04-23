object false
node :header do
  {:status=>"200"}
end
node :body do
 {:fb_shared_question =>partial("account/_fb_shared_question",:object=>@share_info[:facebook]),:linked_in_shared_question => partial("account/_linked_in_shared_question",:object=>@share_info[:linkedin]),:twitter_shared_question => partial("account/_twitter_shared_question",:object=>@share_info[:twitter]),:report_generation=>@report_generation,:fb_status => @status[:fb],:linkedin_status=>@status[:linkedin],:twitter_status=>@status[:twitter]}
end