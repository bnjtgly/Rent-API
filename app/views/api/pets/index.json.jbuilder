json.data do
  json.pets do
    json.array! @pets.each do |data|
      json.pet_id data.id
      json.user_id data.user_id
      json.pet_type data.ref_pet_type.display
      json.pet_gender data.ref_pet_gender.display
      json.pet_weight data.ref_pet_weight.display
      json.name data.name
      json.breed data.breed
      json.color data.color
    end
  end
end