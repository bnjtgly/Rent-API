# frozen_string_literal: true

json.data do
  json.array! @tenant_application_history.each do |data|
    json.id data.id
    json.tenant_application_id data.tenant_application_id
    json.version data.version
    json.valid_from data.valid_from
    json.valid_thru data.valid_thru
    json.application_status data.ref_application_status.display

    json.application_data do
      if data.application_data
        json.cover_letter data.application_data['cover_letter']
        json.personal_info data.application_data['personal_info']
        json.addresses data.application_data['addresses']
        json.identities data.application_data['identities']
        json.incomes data.application_data['incomes']['data']
        json.employment data.application_data['employment']
        json.pets data.application_data['pets']
        json.flatmates data.application_data['flatmates']
      else
        json.null!
      end
    end
  end
end