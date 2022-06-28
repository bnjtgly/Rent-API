json.user do
  json.id @user.id
  json.role @user.user_role.role.role_name
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.complete_name @user.complete_name
  json.date_of_birth @user.date_of_birth_format
  json.gender @user.ref_gender.display
  json.mobile_country_code @user.ref_mobile_country_code.display
  json.mobile @user.mobile
  json.phone @user.phone
  json.sign_up_with @user.ref_sign_up_with.display
  json.avatar @user.avatar
  json.status @user.ref_user_status.display
end