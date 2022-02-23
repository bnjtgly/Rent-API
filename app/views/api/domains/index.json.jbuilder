json.data do
  json.array! @domains.each do |data|
    json.domain_id data.id
    json.domain_number data.domain_number
    json.name data.name
    json.domain_def data.domain_def
    json.domain_references data.domain_references
  end
end