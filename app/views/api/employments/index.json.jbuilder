json.data do
  json.profile_completion do
    json.employment @employment_completion_percentage
  end
  json.employments do
    json.array! @employments.each do |data|
      json.id data.id
      json.income_id data.income_id
      json.company_name data.company_name
      json.position data.position
      json.tenure data.tenure
      json.state data.state
      json.suburb data.suburb
      json.address data.address
      json.post_code data.post_code
      json.documents do
        if data.emp_documents
          json.array! data.emp_documents.each do |data|
            json.id data.id
            json.employment_id data.employment_id
            json.document_type_id data.document_type_id
            json.file data.file
          end
        else
          json.null!
        end
      end
    end
  end
end
