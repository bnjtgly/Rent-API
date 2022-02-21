# frozen_string_literal: true

json.id @domain_reference.id
json.domain_id @domain_reference.domain_id
json.role @domain_reference.role
json.sort_order @domain_reference.sort_order
json.display @domain_reference.display
json.value_str @domain_reference.value_str
json.status @domain_reference.status
json.is_deleted @domain_reference.is_deleted
json.metadata @domain_reference.metadata
json.created_at @domain_reference.created_at
json.updated_at @domain_reference.updated_at

json.domain do
  json.id @domain_reference.domain.id
  json.domain_number @domain_reference.domain.domain_number
  json.name @domain_reference.domain.name
  json.domain_def @domain_reference.domain.domain_def
  json.created_at @domain_reference.domain.created_at
  json.updated_at @domain_reference.domain.updated_at
end
