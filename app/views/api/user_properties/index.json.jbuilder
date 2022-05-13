# frozen_string_literal: true

json.data do
    json.array! @user_properties.each do |data|
      json.user_property_id data.id
      json.property_id data.property_id
      json.applicants data.property.tenant_applications.count
    json.properties do
      json.details data.property.details.eql?('{}') ? nil : data.property.details
    end
  end
end