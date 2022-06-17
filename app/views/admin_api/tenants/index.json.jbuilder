# frozen_string_literal: true
#
json.data do
  json.array! @tenants.each do |data|
    json.id data.id
    json.complete_name data.complete_name
    json.profile_progress data.profile_progress
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end
