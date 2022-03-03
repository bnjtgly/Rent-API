# frozen_string_literal: true

json.tenant_applications do
  json.array! @tenant_applications.each do |data|
    json.tenant_application_id data.id
    json.status data.ref_status.display
    json.user do
      if data.user
        json.user_id data.user.id
        json.email data.user.email
        json.complete_name data.user.complete_name
        json.gender data.user.ref_gender.display
        json.mobile_number data.user.mobile_number
        json.date_of_birth data.user.date_of_birth_format
      else
        json.null!
      end
    end

    json.property do
      if data.property
        json.property_id data.property.id
        json.details data.property.details.eql?('{}') ? nil : data.property.details
      else
        json.null!
      end
    end
  end
end