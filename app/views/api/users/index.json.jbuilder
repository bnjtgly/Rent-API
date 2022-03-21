json.user do
  json.user_id @user.id
  json.role @user.user_role.role.role_name
  json.email @user.email
  json.is_mobile_verified @user.is_mobile_verified
  json.is_email_verified @user.is_email_verified
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.complete_name @user.complete_name
  json.date_of_birth @user.date_of_birth_format
  json.gender @user.ref_gender.display
  json.mobile_country_code @user.ref_mobile_country_code.display
  json.mobile @user.mobile
  json.phone @user.phone
  json.mobile_number @user.mobile_number
  json.sign_up_with @user.ref_sign_up_with.display
  json.avatar @user.avatar
  json.status @user.ref_user_status.display
end

json.addresses do
  json.array! @user.addresses.each do |data|
    json.address_id data.id
    json.user_id data.user_id
    json.state data.state
    json.suburb data.suburb
    json.address data.address
    json.post_code data.post_code
    json.move_in_date data.move_in_date
    json.move_out_date data.move_out_date

    json.reference do
      if data.reference
        json.reference_id data.reference.id
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

json.identities do
  json.array! @user.identities.each do |data|
    json.identity_id data.id
    json.user_id data.user_id
    json.identity_type data.ref_identity_type.display
    json.filename data.filename
  end
end

json.incomes do
  json.array! @user.incomes.each do |data|
    json.income_id data.id
    json.user_id data.user_id
    json.source data.ref_income_frequency.display
    json.frequency data.ref_income_frequency.display
    json.currency data.ref_currency.display
    json.amount data.amount
    json.proof data.proof
    json.total_income_summary @total_income
    # json.income_summary do
    #   json.total_income @user.incomes.sum(:amount)
    # end
    json.employment do
      if data.employment
        json.employment_id data.employment.id
        json.status data.employment.ref_employment_status.display
        json.type data.employment.ref_employment_type.display
        json.company_name data.employment.company_name
        json.position data.employment.position
        json.tenure data.employment.tenure
        json.net_income data.employment.net_income
        json.state data.employment.state
        json.suburb data.employment.suburb
        json.address data.employment.address
        json.post_code data.employment.post_code
        json.reference do
          if data.employment.reference
            json.reference_id data.employment.reference.id
            json.employment_id data.reference.employment_id
            json.full_name data.reference.full_name
            json.email data.reference.email
            json.position data.reference.ref_ref_position.display
            json.mobile_country_code data.reference.ref_mobile_country_code.display
            json.mobile data.reference.mobile
          else
            json.null!
          end
        end
        json.documents do
          if data.employment.emp_documents
            json.array! data.employment.emp_documents.each do |data|
              json.document_id data.id
              json.employment_id data.employment_id
              json.filename data.filename
            end
          else
            json.null!
          end
        end
      else
        json.null!
      end
    end
  end
end

json.flatmates do
  json.array! @user.flatmates.each do |data|
    json.flatmate_id data.id
    json.user_id data.user_id
    json.full_name data.full_name
  end
end

json.pets do
  json.array! @user.pets.each do |data|
    json.pet_id data.id
    json.user_id data.user_id
    json.type data.ref_pet_type.display
    json.gender data.ref_pet_gender.display
    json.weight data.ref_pet_weight.display
    json.name data.name
    json.breed data.breed
    json.color data.color
  end
end

json.api_client do
  if @user.api_client
    json.name @user.api_client.name
  else
    json.null!
  end
end