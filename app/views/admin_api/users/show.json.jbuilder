# frozen_string_literal: true

json.id @user.id
json.role @user.user_role.role.role_name
json.email @user.email
json.is_email_verified @user.is_email_verified
json.is_mobile_verified @user.is_mobile_verified
json.first_name @user.first_name
json.last_name @user.last_name
json.complete_name @user.complete_name
json.date_of_birth @user.date_of_birth_format
json.gender @user.ref_gender.display
json.mobile_country_code @user.ref_mobile_country_code.display
json.mobile @user.mobile
json.mobile_number @user.mobile_number
json.phone @user.phone
json.sign_up_with @user.ref_sign_up_with.display
json.date_of_birth @user.date_of_birth_format
json.sign_up_with @user.ref_sign_up_with.display
json.avatar @user.avatar
json.status @user.ref_user_status.display
json.created_at @user.created_at
json.updated_at @user.updated_at

if @user.user_agency
  json.agency do
    json.id @user.user_agency.agency.id
    json.name @user.user_agency.agency.name
  end
else
  json.user_agency nil
end

if @user.api_client
  json.api_client do
    json.id @user.api_client.id
    json.name @user.api_client.name
  end
else
  json.api_client nil
end

unless @user.account_setup.eql?("{}")
  json.account_setup @user.account_setup
else
  json.account_setup nil
end

unless @user.addresses.blank?
  json.addresses do
    json.array! @user.addresses.each do |data|
      json.address_id data.id
      json.user_id data.user_id
      json.state data.state
      json.suburb data.suburb
      json.address data.address
      json.post_code data.post_code
      json.current_address data.current_address
      json.valid_from data.valid_from
      json.valid_thru data.valid_thru
      json.created_at data.created_at
      json.updated_at data.updated_at

      json.reference do
        if data.reference
          json.reference_id data.reference.id
          json.address_id data.reference.address_id
          json.full_name data.reference.full_name
          json.email data.reference.email
          json.position data.reference.ref_ref_position.display
          json.mobile_country_code data.reference.ref_mobile_country_code.display
          json.mobile data.reference.mobile
          json.mobile_number data.reference.mobile_number
          json.created_at data.reference.created_at
          json.updated_at data.reference.updated_at
        else
          json.null!
        end
      end
    end
  end
else
  json.addresses nil
end

unless @user.identities.blank?
  json.identities do
    json.array! @user.identities.each do |data|
      json.identity_id data.id
      json.user_id data.user_id
      json.identity_type data.ref_identity_type.display
      json.id_number data.id_number
      json.file data.file
      json.created_at data.created_at
      json.updated_at data.updated_at
    end
  end
else
  json.identities nil
end

unless @user.incomes.blank?
  json.incomes do
    json.array! @user.incomes.each do |data|
      json.income_id data.id
      json.user_id data.user_id
      json.source data.ref_income_frequency.display
      json.frequency data.ref_income_frequency.display
      json.currency data.ref_currency.display
      json.amount data.amount
      json.proof data.proof
      json.created_at data.created_at
      json.updated_at data.updated_at
      json.total_income_summary @total_income
      json.employment do
        if data.employment
          json.employment_id data.employment.id
          json.income_id data.employment.income_id
          json.company_name data.employment.company_name
          json.position data.employment.position
          json.tenure data.employment.tenure
          json.state data.employment.state
          json.suburb data.employment.suburb
          json.address data.employment.address
          json.post_code data.employment.post_code
          json.created_at data.employment.created_at
          json.updated_at data.employment.updated_at
          json.documents do
            if data.employment.emp_documents
              json.array! data.employment.emp_documents.each do |data|
                json.document_id data.id
                json.employment_id data.employment_id
                json.document_type_id data.document_type_id
                json.file data.file
                json.created_at data.created_at
                json.updated_at data.updated_at
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
else
  json.incomes nil
end

unless @user.flatmates.blank?
  json.flatmates do
    json.array! @user.flatmates.each do |data|
      json.flatmate_id data.id
      json.user_id data.user_id
      json.group_name data.group_name
      json.created_at data.created_at
      json.updated_at data.updated_at
      json.members do
        json.array! data.flatmate_members.each do |data|
          json.user_id data.user.id
          json.complete_name data.user.complete_name
          json.created_at data.created_at
          json.updated_at data.updated_at
        end
      end
    end
  end
else
  json.flatmates nil
end

unless @user.pets.blank?
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
      json.created_at data.created_at
      json.updated_at data.updated_at
      json.vaccination do
        json.array! data.pet_vaccinations.each do |data|
          json.pet_vaccination_id data.id
          json.pet_id data.pet_id
          json.pet_vaccine_type data.ref_pet_vaccine_type.display
          json.vaccination_date data.vaccination_date
          json.proof data.proof
          json.created_at data.created_at
          json.updated_at data.updated_at
        end
      end
    end
  end
else
  json.pets nil
end