# json.domain_references do
#   json.array! @domain.domain_references.each do |data|
#     json.domain_number @domain.domain_number
#     json.domain_name @domain.name
#     json.domain_def @domain.domain_def
#     json.domain_reference_id data.id
#     json.domain_control_level_id data.domain_control_level_id
#     json.sort_order data.sort_order
#     json.display data.display
#     json.value_str data.value_str
#     json.status data.status
#     json.metadata data.metadata.eql?('{}') ? nil : data.metadata
#   end
# end

json.domain_references do
  json.domain_number @domain.domain.domain_number
  json.domain_name @domain.domain.name
  json.domain_def @domain.domain.domain_def
  json.domain_reference_id @domain.id
  json.domain_control_level_id @domain.domain_control_level_id
  json.sort_order @domain.sort_order
  json.display @domain.display
  json.value_str @domain.value_str
  json.status @domain.status
  json.metadata @domain.metadata.eql?('{}') ? nil : @domain.metadata
end