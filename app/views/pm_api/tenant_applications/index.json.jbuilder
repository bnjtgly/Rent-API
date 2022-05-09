# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.income data.income
    json.flatmate data.flatmate.nil? ? nil : data.flatmate.flatmate_members.count
    json.status data.ref_status.display
  end
end