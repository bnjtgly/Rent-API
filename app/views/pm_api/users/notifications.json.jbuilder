# frozen_string_literal: true

json.data do
  json.array! @notifications.each do |data|
    json.id data.id
    json.recipient_type data.recipient_type
    json.recipient_id data.recipient_id
    json.type data.type
    json.read_at data.read_at
    json.created_at data.created_at
    json.updated_at data.updated_at
    json.tenant_application do
      json.tenant_application_id data.params[:tenant_application][:id]
      json.lease_length_id data.params[:tenant_application][:lease_length_id]
      json.lease_start_date data.params[:tenant_application][:lease_start_date]
      json.flatmate data.params[:tenant_application][:flatmate]
      json.status data.params[:tenant_application][:status]
      json.user data.params[:tenant_application][:user]
      json.property data.params[:tenant_application][:property]
    end
  end
end

json.count do
  json.read @notifications.read.count
  json.unread @notifications.unread.count
end

json.pagy do
  json.merge! @pagination
end
