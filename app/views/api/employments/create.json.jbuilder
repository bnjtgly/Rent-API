json.data do
  json.id @employment.id
  json.status @employment.ref_employment_status.display
  json.type @employment.ref_employment_type.display
  json.company_name @employment.company_name
  json.position @employment.position
  json.tenure @employment.tenure
  json.net_income @employment.net_income
  json.state @employment.state
  json.suburb @employment.suburb
  json.address @employment.address
  json.post_code @employment.post_code
  json.reference do
    if @employment.reference
      json.reference_id @employment.reference.id
      json.employment_id @employment.reference.employment_id
      json.full_name @employment.reference.full_name
      json.email @employment.reference.email
      json.position @employment.reference.ref_ref_position.display
      json.mobile_country_code @employment.reference.ref_mobile_country_code.display
      json.mobile @employment.reference.mobile
      json.mobile_number @employment.reference.mobile_number
    else
      json.null!
    end
  end
  json.documents do
    if @employment.emp_documents
      json.array! @employment.emp_documents.each do |data|
        json.document_id data.id
        json.employment_id data.employment_id
        json.file data.file
      end
    else
      json.null!
    end
  end
end
