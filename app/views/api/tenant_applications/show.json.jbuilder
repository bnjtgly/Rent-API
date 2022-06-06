# frozen_string_literal: true

json.id @tenant_application.id
json.lease_length_id @tenant_application.ref_lease_length.display
json.lease_start_date @tenant_application.lease_start_date
json.status @tenant_application.ref_status.display
json.property do
    if @tenant_application.property
      json.property_id @tenant_application.property.id
      json.applicants @tenant_application.property.tenant_applications.count
      json.details @tenant_application.property.details.eql?('{}') ? nil : @tenant_application.property.details
    else
      json.null!
    end
end

json.application_data do
  if @tenant_application.application_data
    json.scores do
      json.overall_score "#{@user_overall_score}%"
      json.score_details do
        json.array! @tenant_application.user.user_scores.each do |data|
          json.user_score_id data.id
          json.user_id data.user_id
          json.score_category_type data.ref_score_category_type.display
          json.desc data.desc
          json.score "#{data.score}%"
          json.remark data.remark
        end
      end
    end
    json.cover_letter @tenant_application.application_data['cover_letter']
    json.personal_info @tenant_application.application_data['personal_info']
    json.addresses @tenant_application.application_data['addresses']
    json.identities @tenant_application.application_data['identities']
    json.incomes do
      if @tenant_application.application_data['incomes']
        json.total_income_summary @tenant_application.application_data['incomes']['total_income_summary']
        json.data @tenant_application.application_data['incomes']['data']
      else
        json.null!
      end
    end
    json.employment @tenant_application.application_data['employment']
    json.pets @tenant_application.application_data['pets']
    json.flatmates @tenant_application.application_data['flatmates']
  else
    json.null!
  end
end