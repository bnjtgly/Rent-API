json.data do
  json.array! @identities.each do |data|
    json.id data.id
    json.user_id data.user_id
    json.identity_type data.ref_identity_type.display
    json.id_number data.id_number
    json.file data.file
  end
end