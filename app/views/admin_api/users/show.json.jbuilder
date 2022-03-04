# frozen_string_literal: true

json.id @user.id
json.email @user.email
json.is_email_verified @user.is_email_verified
json.is_mobile_verified @user.is_mobile_verified
json.first_name @user.first_name
json.last_name @user.last_name
json.complete_name @user.complete_name
json.date_of_birth @user.date_of_birth_format
json.gender @user.ref_gender.display
json.mobile_country_code @user.ref_mobile_country_code.display
json.mobile @user.mobile
json.mobile_number @user.mobile_number
json.phone @user.phone

json.sign_up_with @user.ref_sign_up_with.display
json.date_of_birth @user.date_of_birth_format
json.sign_up_with @user.ref_sign_up_with.display
json.avatar @user.avatar
json.status @user.ref_user_status.display
json.created_at @user.created_at
json.updated_at @user.updated_at

if @user.api_client
  json.api_client do
    json.id @user.api_client.id
    json.name @user.api_client.name
  end
else
  json.api_client nil
end
