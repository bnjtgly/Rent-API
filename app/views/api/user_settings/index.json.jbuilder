# frozen_string_literal: true

json.data do
  json.array! @user_settings.each do |data|
    json.id data.id
    json.user_id data.user_id
    json.setting_id data.setting_id
    json.setting data.ref_setting.display
    json.value data.value
  end
end