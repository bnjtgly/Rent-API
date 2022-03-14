json.data do
  json.identity do
    json.identity_id @identity.id
    json.user_id @identity.user_id
    json.identity_type @identity.ref_identity_type.display
    json.filename @identity.filename
  end
end