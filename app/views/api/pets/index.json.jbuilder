json.data do
  json.profile_completion do
    json.pets @profile_completion_percentage
  end
  json.pets do
    json.array! @pets.each do |data|
      json.id data.id
      json.user_id data.user_id
      json.pet_type data.ref_pet_type.display
      json.pet_gender data.ref_pet_gender.display
      json.pet_weight data.ref_pet_weight.display
      json.name data.name
      json.breed data.breed
      json.color data.color
      json.vaccination do
        json.array! data.pet_vaccinations.each do |data|
          json.pet_vaccination_id data.id
          json.pet_id data.pet_id
          json.pet_vaccine_type data.ref_pet_vaccine_type.display
          json.vaccination_date data.vaccination_date
          json.proof data.proof
        end
      end
    end
  end
end