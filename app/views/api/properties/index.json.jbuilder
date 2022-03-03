# frozen_string_literal: true

json.properties do
  json.array! @properties.each do |data|
    json.property_id data.id
    json.applicants data.applicants
    json.details data.details.eql?('{}') ? nil : data.details
  end
end