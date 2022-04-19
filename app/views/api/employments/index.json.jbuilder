json.data do
  json.profile_completion do
    json.employment @employment_completion_percentage
  end
  json.employments do
    json.array! @employments.each do |data|
      json.id data.id
      json.status data.ref_employment_status.display
      json.type data.ref_employment_type.display
      json.company_name data.company_name
      json.position data.position
      json.tenure data.tenure
      json.net_income data.net_income
      json.state data.state
      json.suburb data.suburb
      json.address data.address
      json.post_code data.post_code
      json.reference do
        if data.reference
          json.id data.reference.id
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
        if data.emp_documents
          json.array! data.emp_documents.each do |data|
            json.id data.id
            json.employment_id data.employment_id
            json.file data.file
          end
        else
          json.null!
        end
      end
    end
  end
end
