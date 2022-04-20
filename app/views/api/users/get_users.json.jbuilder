json.data do
  json.array! @user.each do |data|
    json.user_id data.id
    json.email data.email
    json.first_name data.first_name
    json.last_name data.last_name
    json.complete_name data.complete_name
  end
end