# frozen_string_literal: true

json.id @property.id
json.applicants @property.tenant_applications.count
json.user_agency_id @property.user_agency_id
json.details @property.details
json.created_at @property.created_at
json.updated_at @property.updated_at
json.applications do
  json.array! @property.tenant_applications.each do |data|
    json.tenant_application_id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.status data.ref_status.display
    json.user do
      json.complete_name data.user.complete_name
      json.avatar data.user.avatar
    end
    json.flatmates do
      if data.flatmate
        json.flatmate_members data.flatmate.flatmate_members.count
      else
        json.null!
      end
    end
  end
end
