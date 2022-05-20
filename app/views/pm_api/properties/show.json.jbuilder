# frozen_string_literal: true

json.id @property.id
json.applicants @property.tenant_applications.count
json.user_agency_id @property.user_agency_id
json.details @property.details
json.created_at @property.created_at
json.updated_at @property.updated_at
json.tenant_applications do
  json.array! @property.tenant_applications.each do |data|
    json.tenant_application_id data.id
    json.lease_length data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.status data.ref_status.display
    json.user do
      json.user_id data.user.id
      json.email data.user.email
      json.complete_name data.user.complete_name
      json.avatar data.user.avatar
    end
    json.application_data data.application_data
  end
end
