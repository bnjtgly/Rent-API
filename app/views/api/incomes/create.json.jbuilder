json.data do
  json.income do
    json.income_id @income.id
    json.user_id @income.user_id
    json.income_source @income.ref_income_source.display
    json.income_frequency @income.ref_income_frequency.display
    json.currency @income.ref_currency.display
    json.amount @income.amount
    json.proof @income.proof

    json.employment do
      if @income.employment
        json.employment_id @income.employment.id
        json.status @income.employment.ref_employment_status.display
        json.type @income.employment.ref_employment_type.display
        json.company_name @income.employment.company_name
        json.position @income.employment.position
        json.tenure @income.employment.tenure
        json.net_income @income.employment.net_income
        json.state @income.employment.state
        json.suburb @income.employment.suburb
        json.address @income.employment.address
        json.post_code @income.employment.post_code
        json.reference do
          if @income.employment.reference
            json.reference_id @income.employment.reference.id
            json.employment_id @income.reference.employment_id
            json.full_name @income.reference.full_name
            json.email @income.reference.email
            json.position @income.reference.ref_ref_position.display
            json.mobile_country_code @income.reference.ref_mobile_country_code.display
            json.mobile @income.reference.mobile
          else
            json.null!
          end
        end
        json.documents do
          if @income.employment.emp_documents
            json.array! @income.employment.emp_documents.each do |data|
              json.document_id data.id
              json.employment_id data.employment_id
              json.filename data.filename
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
