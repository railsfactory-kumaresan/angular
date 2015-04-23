json.array!(@corporate_users) do |corporate_user|
  json.extract! corporate_user, :id
  json.url corporate_user_url(corporate_user, format: :json)
end
