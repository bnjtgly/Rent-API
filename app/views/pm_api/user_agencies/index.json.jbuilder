# frozen_string_literal: true

json.id @user_agency.id
json.user_id @user_agency.user_id
json.name @user_agency.agency.name
json.email @user_agency.agency.email
json.mobile_country_code @user_agency.agency.ref_mobile_country_code.display
json.mobile @user_agency.agency.mobile
json.phone @user_agency.agency.phone
json.addresses @user_agency.agency.addresses
json.links @user_agency.agency.links