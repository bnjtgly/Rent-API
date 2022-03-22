# frozen_string_literal: true

json.data do
  json.tenant_applications do
    json.array! @tenant_applications.each do |data|
      json.tenant_application_id data.id
      json.lease_length_id data.ref_lease_length.display
      json.lease_start_date data.lease_start_date
      json.status data.ref_status.display
      json.flatmate do
        json.group_name data.flatmate.group_name
        json.members do
          json.array! data.flatmate.flatmate_members.each do |data|
            json.user_id data.user.id
            json.complete_name data.user.complete_name
          end
        end
      end

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
end