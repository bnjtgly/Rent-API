# frozen_string_literal: true

json.id @tenant_application.id
json.lease_length_id @tenant_application.ref_lease_length.display
json.lease_start_date @tenant_application.lease_start_date
json.status @tenant_application.ref_status.display
json.created_at @tenant_application.created_at
json.updated_at @tenant_application.updated_at

json.property do
  if @tenant_application.property
    json.property_id @tenant_application.property.id
    json.agency_id  @tenant_application.property.agency_id
    json.details @tenant_application.property.details.eql?('{}') ? nil : @tenant_application.property.details
  else
    json.null!
  end
end

json.application_data do
  if @tenant_application.application_data
    json.cover_letter @tenant_application.application_data['cover_letter']
    json.personal_info @tenant_application.application_data['personal_info']

    json.addresses do
      if @tenant_application.application_data['addresses']
        json.array! @tenant_application.application_data['addresses'].each do |data|
          json.address_id data['id']
          json.state data['state']
          json.suburb data['suburb']
          json.post_code data['post_code']
          json.address data['address']
          json.valid_from data['valid_from']
          json.valid_thru data['valid_thru']
          json.created_at data['created_at']
          json.updated_at data['updated_at']
          json.reference do
            if data['reference']
              json.reference_id data['reference']['id']
              json.address_id data['reference']['address_id']
              json.full_name data['reference']['full_name']
              json.email data['reference']['email']
              json.position data['reference']['position']
              json.mobile_country_code data['reference']['mobile_country_code']
              json.mobile data['reference']['mobile']
               json.created_at data['reference']['created_at']
              json.updated_at data['reference']['updated_at']
            else
              json.null!
            end
          end
        end
      else
        json.null!
      end
    end

    json.identities do
      if @tenant_application.application_data['identities']
        json.array! @tenant_application.application_data['identities'].each do |data|
          json.identity_id data['id']
          json.identity_type data['identity_type']
          json.id_number data['id_number']
          json.file data['file']
          json.created_at data['created_at']
          json.updated_at data['updated_at']
        end
      else
        json.null!
      end
    end

    json.incomes do
      if @tenant_application.application_data['incomes']['data']
        json.array! @tenant_application.application_data['incomes']['data'].each do |data|
          json.income_id data['id']
          json.income_source data['income_source']
          json.income_frequency data['income_frequency']
          json.currency data['currency']
          json.amount data['amount']
          json.proof data['proof']
          json.created_at data['created_at']
          json.updated_at data['updated_at']
        end
      else
        json.null!
      end
    end

    json.employments do
      if @tenant_application.application_data['employment']
        json.employment_id @tenant_application.application_data['employment']['id']
        json.income_id @tenant_application.application_data['employment']['income_id']
        json.company_name @tenant_application.application_data['employment']['company_name']
        json.position @tenant_application.application_data['employment']['position']
        json.tenure @tenant_application.application_data['employment']['tenure']
        json.state @tenant_application.application_data['employment']['state']
        json.suburb @tenant_application.application_data['employment']['suburb']
        json.post_code @tenant_application.application_data['employment']['post_code']
        json.address @tenant_application.application_data['employment']['address']
        json.documents do
          if @tenant_application.application_data['employment']['documents']
            json.array! @tenant_application.application_data['employment']['documents'].each do |data|
              json.document_id data['id']
              json.employment_id data['employment_id']
              json.document_type_id data['document_type_id']
              json.file data['file']
              json.created_at data['created_at']
              json.updated_at data['updated_at']
            end
          else
            json.null!
          end
        end
        json.created_at @tenant_application.application_data['employment']['created_at']
        json.updated_at @tenant_application.application_data['employment']['updated_at']
      else
        json.null!
      end
    end

    json.pets do
      if @tenant_application.application_data['pets']
        json.array! @tenant_application.application_data['pets'].each do |data|
          json.pet_id data['id']
          json.name data['name']
          json.pet_type data['pet_type']
          json.breed data['breed']
          json.color data['color']
          json.pet_gender data['pet_gender']
          json.pet_weight data['pet_weight']
          json.vaccination data['vaccination']
          json.created_at data['created_at']
          json.updated_at data['updated_at']
        end
      else
        json.null!
      end
    end

    json.flatmates do
      if @tenant_application.application_data['flatmates']
        json.array! @tenant_application.application_data['flatmates'].each do |data|
          json.flatmate_id data['id']
          json.group_name data['group_name']
          json.created_at data['created_at']
          json.updated_at data['updated_at']
          json.members data['members']
        end
      end
    end
  else
    json.null!
  end
end