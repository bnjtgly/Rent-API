# frozen_string_literal: true
json.data do
  json.array! @api_clients.each do |data|
    json.id data.id
    json.name data.name
    json.api_key data.api_key
    json.secret_key data.secret_key
    json.is_deleted data.is_deleted
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end
