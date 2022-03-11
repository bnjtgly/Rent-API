json.data do
  json.identities do
    json.array! @identities.each do |data|
      json.identity_id data.id
      json.user_id data.user_id
      json.identity_type data.ref_identity_type.display
      json.filename data.filename
    end
  end
end