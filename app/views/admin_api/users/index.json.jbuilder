# frozen_string_literal: true
json.data do
  json.array! @users.each do |data|
    json.id data.id
    json.role data.user_role.role.role_name
    json.email data.email
    json.is_email_verified data.is_email_verified
    json.is_mobile_verified data.is_mobile_verified
    json.first_name data.first_name
    json.last_name data.last_name
    json.complete_name data.complete_name
    json.date_of_birth data.date_of_birth_format
    json.gender data.ref_gender.display
    json.mobile_country_code data.ref_mobile_country_code.display
    json.mobile data.mobile
    json.phone data.phone
    json.mobile_number data.mobile_number
    json.sign_up_with data.ref_sign_up_with.display
    json.date_of_birth data.date_of_birth_format
    json.sign_up_with data.ref_sign_up_with.display
    json.avatar data.avatar
    json.status data.ref_user_status.display
    json.created_at data.created_at
    json.updated_at data.updated_at

    if data.user_agency
      json.agency do
        json.id data.user_agency.agency.id
        json.name data.user_agency.agency.name
      end
    else
      json.agency nil
    end

    if data.api_client
      json.api_client do
        json.id data.api_client.id
        json.name data.api_client.name
      end
    else
      json.api_client nil
    end
  end
end

json.pagy do
  json.merge! @pagination
end
