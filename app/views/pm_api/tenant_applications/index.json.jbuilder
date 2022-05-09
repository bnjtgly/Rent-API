# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.income data.income
    json.status data.ref_status.display
    json.flatmate data.flatmate.nil? ? nil : data.flatmate.flatmate_members.count
    json.user do
      if data.user
        json.user_id data.user.id
        json.complete_name data.user.complete_name
        json.avatar data.user.avatar
      else
        json.null!
      end
    end
  end
end