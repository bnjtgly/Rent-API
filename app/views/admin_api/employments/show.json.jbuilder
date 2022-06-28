# frozen_string_literal: true

json.id @employment.id
json.income_id @employment.income_id
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
      json.id data.id
      json.employment_id data.employment_id
      json.document_type_id data.document_type_id
      json.file data.file
    end
  else
    json.null!
  end
end