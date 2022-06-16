# frozen_string_literal: true

json.id @agency.id
json.name @agency.name
json.email @agency.email
json.mobile_country_code @agency.ref_mobile_country_code.display
json.mobile @agency.mobile
json.phone @agency.phone
json.addresses @agency.addresses
json.links @agency.links
json.created_at @agency.created_at
json.updated_at @agency.updated_at
