json.domain_references do
  json.array! @domain.domain_references.each do |data|
    json.domain_number @domain.domain_number
    json.domain_name @domain.name
    json.domain_def @domain.domain_def
    json.domain_reference_id data.id
    json.sort_order data.sort_order
    json.display data.display
    json.value_str data.value_str
    json.status data.status
    json.metadata data.metadata.eql?('{}') ? nil : data.metadata
  end
end

# Version 3
# json.domains do
#   @dom = @domain.first
#   json.domain_number @dom.domain.domain_number
#   json.domain_name @dom.domain.name
#   json.domain_def @dom.domain.domain_def
# end

# json.domain_references do
#   json.array! @domain.each do |data|
#     json.domain_reference_id data.id
#     json.domain_control_level_id data.domain_control_level_id
#     json.sort_order data.sort_order
#     json.display data.display
#     json.value_str data.value_str
#     json.status data.status
#     json.metadata data.metadata.eql?('{}') ? nil : data.metadata
#   end
# end

# # Version 4
# json.domain_references do
#   json.array! @domain.each do |data|
#     json.domain_number data.domain_number
#     json.domain_name data.name
#     json.domain_def data.domain_def
#     json.domain_reference_id data.id
#     json.sort_order data.sort_order
#     json.display data.display
#     json.value_str data.value_str
#     json.status data.status
#     json.metadata data.metadata.eql?('{}') ? nil : data.metadata
#   end
# end

