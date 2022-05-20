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
      json.property data.params[:tenant_application][:application_data]['property']['details']['name']
      json.user do
        json.user_id data.params[:user][:id]
        json.complete_name data.params[:user][:complete_name]
        json.avatar data.params[:user][:avatar]
      end
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
