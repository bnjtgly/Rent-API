json.data do
  json.profile_completion do
    json.incomes @profile_completion_percentage
  end
  json.incomes do
    json.array! @incomes.each do |data|
      json.id data.id
      json.user_id data.user_id
      json.income_source data.ref_income_source.display
      json.income_frequency data.ref_income_frequency.display
      json.currency data.ref_currency.display
      json.amount data.amount
      json.proof data.proof
      json.total_income_summary @total_income
      json.employment do
        if data.employment
          json.id data.employment.id
          json.company_name data.employment.company_name
          json.position data.employment.position
          json.tenure data.employment.tenure
          json.state data.employment.state
          json.suburb data.employment.suburb
          json.address data.employment.address
          json.post_code data.employment.post_code
          json.documents do
            if data.employment.emp_documents
              json.array! data.employment.emp_documents.each do |data|
                json.id data.id
                json.employment_id data.employment_id
                json.document_type_id data.document_type_id
                json.file data.file
              end
            else
              json.null!
            end
          end
        else
          json.null!
        end
      end
    end
  end
end