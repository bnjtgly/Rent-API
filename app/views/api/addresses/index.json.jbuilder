json.data do
  json.address do
    json.array! @addresses.each do |data|
      json.address_id data.id
      json.user_id data.user_id
      json.state data.state
      json.suburb data.suburb
      json.address data.address
      json.post_code data.post_code
      json.move_in_date data.move_in_date
      json.move_out_date data.move_out_date
    end
  end
end