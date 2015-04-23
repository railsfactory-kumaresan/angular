object false
node :header do
  {:status=>"200"}
end
node :body do
 {:user =>partial("api/account/user_account",:object=>@user),:mangeuser => partial("api/account/manage_users",:object=>@mangeuser)}
end