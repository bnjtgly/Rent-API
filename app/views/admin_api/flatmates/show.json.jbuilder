# frozen_string_literal: true

json.id @flatmate.id
json.user_id @flatmate.user_id
json.group_name @flatmate.group_name
json.members do
  json.array! @flatmate.flatmate_members.each do |data|
    json.id data.id
    json.user_id data.user.id
    json.role data.user.user_role.role.role_name
    json.email data.user.email
    json.is_mobile_verified data.user.is_mobile_verified
    json.is_email_verified data.user.is_email_verified
    json.first_name data.user.first_name
    json.last_name data.user.last_name
    json.complete_name data.user.complete_name
    json.date_of_birth data.user.date_of_birth_format
    json.gender data.user.ref_gender.display
    json.mobile_country_code data.user.ref_mobile_country_code.display
    json.mobile data.user.mobile
    json.phone data.user.phone
    json.mobile_number data.user.mobile_number
    json.sign_up_with data.user.ref_sign_up_with.display
    json.avatar data.user.avatar
    json.status data.user.ref_user_status.display

    json.profile_progress do
      json.null!
    end
  end
end