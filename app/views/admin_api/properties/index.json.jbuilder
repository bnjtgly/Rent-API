# frozen_string_literal: true
#
json.data do
  json.array! @properties.each do |data|
    json.id data.id
    json.user_agency data.user_agency.agency
    json.details data.details
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end
