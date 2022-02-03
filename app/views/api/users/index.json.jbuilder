# frozen_string_literal: true

json.user do
  json.user_id @user.id
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.complete_name @user.complete_name
  json.date_of_birth @user.date_of_birth_format
  json.mobile_number @user.mobile_number
  json.avatar @user.avatar

  json.gender do
    if @user.ref_gender
      json.gender_id @user.ref_gender.id
      json.display @user.ref_gender.display
      json.value_str @user.ref_gender.value_str
    else
      json.null!
    end
  end

  json.mobile_country_code do
    if @user.ref_mobile_country_code
      json.mobile_country_code_id @user.ref_mobile_country_code.id
      json.display @user.ref_mobile_country_code.display
      json.value_str @user.ref_mobile_country_code.value_str
    else
      json.null!
    end
  end

  json.sign_up_with do
    if @user.ref_sign_up_with
      json.sign_up_with_id @user.ref_sign_up_with.id
      json.display @user.ref_sign_up_with.display
      json.value_str @user.ref_sign_up_with.value_str
    else
      json.null!
    end
  end
end

json.api_client do
  if @user.api_client
    json.name @user.api_client.name
  else
    json.null!
  end
end
