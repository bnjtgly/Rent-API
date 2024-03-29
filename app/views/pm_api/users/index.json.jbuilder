json.user do
  json.user_id @user.id
  json.role @user.user_role.role.role_name
  json.email @user.email
  json.is_mobile_verified @user.is_mobile_verified
  json.is_email_verified @user.is_email_verified
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.complete_name @user.complete_name
  json.date_of_birth @user.date_of_birth_format
  json.gender @user.ref_gender.display
  json.mobile_country_code @user.ref_mobile_country_code.display
  json.mobile @user.mobile
  json.phone @user.phone
  json.mobile_number @user.mobile_number
  json.sign_up_with @user.ref_sign_up_with.display
  json.avatar @user.avatar
  json.status @user.ref_user_status.display

  json.agency do
    json.agency @user.user_agency.agency
  end

  json.applications do
    json.array! @tenant_applications.each do |data|
      json.tenant_application_id data.id
      json.lease_length_id data.ref_lease_length.display
      json.lease_start_date data.lease_start_date
      json.status data.ref_status.display
      json.flatmate data.flatmate.nil? ? nil : data.flatmate.flatmate_members.count
      json.user do
        if data.user
          json.user_id data.user.id
          json.complete_name data.user.complete_name
          json.avatar data.user.avatar
        else
          json.null!
        end
      end
      json.property do
        json.property_id data.property.id
        json.name data.property.details['name']
        json.img data.property.details['img']
      end
    end
  end
end