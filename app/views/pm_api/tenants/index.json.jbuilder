json.data do
  json.array! @tenants.each do |data|
    json.user_id data.id
    json.email data.email
    json.first_name data.first_name
    json.last_name data.last_name
    json.complete_name data.complete_name
    json.avatar data.avatar
    json.status data.ref_user_status.display

    json.tenant_applications do
      json.array! data.tenant_applications.each do |data|
        json.id data.id
        json.lease_length_id data.ref_lease_length.display
        json.lease_start_date data.lease_start_date
        json.status data.ref_status.display
        json.created_at data.created_at
        json.property do
          if data.property
            json.property_id data.property.id
            json.applicants data.property.tenant_applications.count
            json.details data.property.details.eql?('{}') ? nil : data.property.details
          else
            json.null!
          end
        end
      end
    end
  end
end

json.pagy do
  json.merge! @pagination
end