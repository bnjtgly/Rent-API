# frozen_string_literal: true

json.data do
  json.array! @agencies.each do |data|
    json.id data.id
    json.name data.name
    json.email data.email
    json.addresses data.addresses
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end
