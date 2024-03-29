json.data do
  json.profile_completion do
    json.addresses @profile_completion_percentage
  end
  json.addresses do
    json.array! @addresses.each do |data|
      json.id data.id
      json.user_id data.user_id
      json.state data.state
      json.suburb data.suburb
      json.address data.address
      json.post_code data.post_code
      json.current_address data.current_address
      json.valid_from data.valid_from
      json.valid_thru data.valid_thru
      json.reference do
        if data.reference
          json.id data.reference.id
          json.address_id data.reference.address_id
          json.full_name data.reference.full_name
          json.email data.reference.email
          json.position data.reference.ref_ref_position.display
          json.mobile_country_code data.reference.ref_mobile_country_code.display
          json.mobile data.reference.mobile
        else
          json.null!
        end
      end
    end
  end
end