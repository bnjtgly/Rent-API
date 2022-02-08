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