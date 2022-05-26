# frozen_string_literal: true

json.data do
  json.array! @tenant_applications.each do |data|
    json.id data.id
    json.lease_length_id data.ref_lease_length.display
    json.lease_start_date data.lease_start_date
    json.income data.income
    json.status data.ref_status.display
    json.flatmate data.flatmate.nil? ? nil : data.flatmate.flatmate_members.count

    json.user do
      if data.user
        json.user_id data.user.id
        json.complete_name data.user.complete_name
        json.avatar data.user.avatar
      else
        json.null!
      end
    end

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