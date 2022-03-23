json.data do
  json.flatmate_member do
    json.id @flatmate_member.id
    json.flatmate @flatmate_member.flatmate.group_name
    json.user @flatmate_member.user.complete_name
  end
end