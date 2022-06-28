json.data do
  json.array! @references.each do |data|
    json.id data.id
    json.address_id data.address_id
    json.full_name data.full_name
    json.email data.email
    json.position data.ref_ref_position.display
    json.mobile_country_code data.ref_mobile_country_code.display
    json.mobile data.mobile
  end
end

json.pagy do
  json.merge! @pagination
end