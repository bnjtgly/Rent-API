# frozen_string_literal: true

json.id @tenant_application.id
json.lease_length_id @tenant_application.ref_lease_length.display
json.lease_start_date @tenant_application.lease_start_date
json.income @tenant_application.income
json.status @tenant_application.ref_status.display
json.flatmate @tenant_application.flatmate.nil? ? nil : @tenant_application.flatmate.flatmate_members.count
json.user do
  if @tenant_application.user
    json.user_id @tenant_application.user.id
    json.complete_name @tenant_application.user.complete_name
    json.avatar @tenant_application.user.avatar
  else
    json.null!
  end
end
json.application_data @tenant_application.application_data