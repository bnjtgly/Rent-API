# frozen_string_literal: true

json.properties do
  json.total_properties @properties.count
  json.property_views @property_views.total_views
  json.data do
    json.array! @properties.each do |data|
      json.property_id data.id
      json.agency_id data.agency_id
      json.details data.details
    end
  end
end

json.applicants do
  json.total_applicants @applicants.count
  json.top_applicants do
    json.array! @tenant_applications.each do |data|
      json.user do
        json.user_id data[:user_id]
        json.email data[:email]
        json.complete_name data[:complete_name]
        json.avatar data[:avatar]
      end
    end
  end
end