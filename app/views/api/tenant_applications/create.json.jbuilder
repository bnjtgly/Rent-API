json.data do
  json.id @tenant_application.id
  json.lease_length_id @tenant_application.ref_lease_length.display
  json.lease_start_date @tenant_application.lease_start_date
  json.status @tenant_application.ref_status.display
  json.property @tenant_application.property
  json.application_data @tenant_application.application_data
end