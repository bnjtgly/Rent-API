json.data do
  json.array! @flatmates.each do |data|
    json.id data.id
    json.group_name data.group_name
    json.members do
      json.array! data.flatmate_members.each do |data|
        json.id data.user.id
        json.user_id data.user.id
        json.complete_name data.user.complete_name
        json.avatar data.user.avatar
        json.profile_progress do
          json.null!
        end
      end
    end
  end
end