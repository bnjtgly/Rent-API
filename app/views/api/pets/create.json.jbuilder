json.data do
  json.id @pet.id
  json.user_id @pet.user_id
  json.pet_type @pet.ref_pet_type.display
  json.pet_gender @pet.ref_pet_gender.display
  json.pet_weight @pet.ref_pet_weight.display
  json.pet_vaccine_type @pet.ref_pet_vaccine_type.display
  json.name @pet.name
  json.breed @pet.breed
  json.color @pet.color
  json.vaccination_date @pet.vaccination_date
  json.proof @pet.proof
  json.pets_progress @profile_completion_percentage
end



