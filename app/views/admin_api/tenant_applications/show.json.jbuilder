# frozen_string_literal: true

json.id @tenant_application.id
json.lease_length_id @tenant_application.ref_lease_length.display
json.lease_start_date @tenant_application.lease_start_date
json.status @tenant_application.ref_status.display
json.created_at @tenant_application.created_at
json.updated_at @tenant_application.updated_at
json.property do
  if @tenant_application.property
    json.property_id @tenant_application.property.id
    json.agency_id  @tenant_application.property.agency_id
    json.details @tenant_application.property.details.eql?('{}') ? nil : @tenant_application.property.details
  else
    json.null!
  end
end