object false
node :header do
  {:status=>"200"}
end
node :body do
{:questions=>partial("question/get_question_options",:object=>@question),:company_logo=>@company_logo}
end