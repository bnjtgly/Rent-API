# frozen_string_literal: true

json.data do
  json.array! @user_securities.each do |data|
    json.id data.id
    json.user_id data.user_id
    json.sms_notification data.sms_notification
  end
end