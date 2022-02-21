# frozen_string_literal: true

json.data do
  json.array! @domains.each do |data|
    json.id data.id
    json.domain_number data.domain_number
    json.name data.name
    json.domain_def data.domain_def
    json.created_at data.created_at
    json.updated_at data.updated_at
    json.domain_references data.domain_references
  end
end

json.pagy do
  json.merge! @pagination
end