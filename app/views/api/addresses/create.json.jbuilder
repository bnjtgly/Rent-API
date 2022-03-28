json.data do
  json.id @address.id
  json.user_id @address.user_id
  json.state @address.state
  json.suburb @address.suburb
  json.address @address.address
  json.post_code @address.post_code
  json.valid_from @address.valid_from
  json.valid_thru @address.valid_thru
  json.reference do
    if @address.reference
      json.reference_id @address.reference.id
      json.address_id @address.reference.address_id
      json.full_name @address.reference.full_name
      json.email @address.reference.email
      json.position @address.reference.ref_ref_position.display
      json.mobile_country_code @address.reference.ref_mobile_country_code.display
      json.mobile @address.reference.mobile
    else
      json.null!
    end
  end
end