json.data do
  json.id @pet.id
  json.user_id @pet.user_id
  json.pet_type @pet.ref_pet_type.display
  json.pet_gender @pet.ref_pet_gender.display
  json.pet_weight @pet.ref_pet_weight.display
  json.name @pet.name
  json.breed @pet.breed
  json.color @pet.color
  # json.vaccination do
  #   json.pet_vaccination_id @pet.pet_vaccination.id
  #   json.pet_vaccine_type @pet.pet_vaccination.ref_pet_vaccine_type.display
  #   json.vaccination_date @pet.pet_vaccination.vaccination_date
  #   json.proof @pet.pet_vaccination.proof
  # end
  json.pets_progress @profile_completion_percentage
end



