# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.status data.ref_status.display
    json.property do
      if data.property
        json.property_id data.property.id
        json.applicants data.property.tenant_applications.count
        json.details data.property.details.eql?('{}') ? nil : data.property.details
      else
        json.null!
      end
    end
    json.application_data data.application_data
  end
end