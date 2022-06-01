# frozen_string_literal: true

json.data do
  json.array! @roles.each do |data|
    json.id data.id
    json.role_name data.role_name
    json.role_def data.role_def
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end
