# frozen_string_literal: true

json.id @domain.id
json.domain_number @domain.domain_number
json.name @domain.name
json.domain_def @domain.domain_def

if @domain.domain_references
  json.domain_references do
    json.array! @domain.domain_references.each do |data|
      json.domain_reference_id data.id
      json.sort_order data.sort_order
      json.display data.display
      json.value_str data.value_str
      json.status data.status
      json.is_deleted data.is_deleted
      json.role data.role
      json.metadata data.metadata
    end
  end
end
