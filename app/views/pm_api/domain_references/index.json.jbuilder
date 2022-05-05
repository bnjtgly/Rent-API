# frozen_string_literal: true

json.data do
  json.array! @domain_references.each do |data|
    json.domain do
      json.id data.domain.id
      json.domain_number data.domain.domain_number
      json.name data.domain.name
      json.domain_def data.domain.domain_def
      json.created_at data.domain.created_at
      json.updated_at data.domain.updated_at
    end

    json.id data.id
    json.domain_id data.domain_id
    json.role data.role
    json.sort_order data.sort_order
    json.display data.display
    json.value_str data.value_str
    json.status data.status
    json.is_deleted data.is_deleted
    json.metadata data.metadata
    json.created_at data.created_at
    json.updated_at data.updated_at
  end
end

json.pagy do
  json.merge! @pagination
end