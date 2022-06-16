# frozen_string_literal: true

json.tenants do
  json.count @tenants
end

json.agencies do
  json.count @agencies
end

json.properties do
  json.count @properties.count
  json.views @property_views.total_views
  json.data do
    json.array! @properties.each do |data|
      json.property_id data.id
      json.agency_id data.agency_id
      json.details data.details
    end
  end
end