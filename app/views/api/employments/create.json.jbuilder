json.data do
  json.id @employment.id
  json.company_name @employment.company_name
  json.position @employment.position
  json.tenure @employment.tenure
  json.state @employment.state
  json.suburb @employment.suburb
  json.address @employment.address
  json.post_code @employment.post_code
  json.documents do
    if @employment.emp_documents
      json.array! @employment.emp_documents.each do |data|
        json.document_id data.id
        json.employment_id data.employment_id
        json.document_type_id data.document_type_id
        json.file data.file
      end
    else
      json.null!
    end
  end
  json.profile_completion do
    json.employment @employment_completion_percentage
  end
end
