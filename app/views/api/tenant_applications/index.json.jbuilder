# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.status data.ref_status.display
    json.property do
      if data.property
        json.property_id data.property.id
        json.applicants data.property.tenant_applications.count
        json.details data.property.details.eql?('{}') ? nil : data.property.details
      else
        json.null!
      end
    end

    json.application_data do
      if data.application_data
        json.cover_letter data.application_data['cover_letter']
        json.personal_info data.application_data['personal_info']
        json.addresses data.application_data['addresses']
        json.identities data.application_data['identities']
        json.incomes do
          if data.application_data['incomes']
            json.total_income_summary data.application_data['incomes']['total_income_summary']
            json.data data.application_data['incomes']['data']
          else
            json.null!
          end
        end
        json.employment data.application_data['employment']
        json.pets data.application_data['pets']
        json.flatmates data.application_data['flatmates']
      else
        json.null!
      end
    end
  end
end