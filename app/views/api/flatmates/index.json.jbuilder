json.data do
  json.flatmates do
    json.array! @flatmates.each do |data|
      json.flatmate_id data.id
      json.group_name data.group_name
      json.members do
        json.array! data.flatmate_members.each do |data|
          json.user_id data.user.id
          json.complete_name data.user.complete_name
        end
      end
    end
  end
end