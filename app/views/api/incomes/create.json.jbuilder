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
      if data.employment
        json.employment_id data.employment.id
        json.status data.employment.ref_employment_status.display
        json.type data.employment.ref_employment_type.display
        json.company_name data.employment.company_name
        json.position data.employment.position
        json.tenure data.employment.tenure
        json.net_income data.employment.net_income
        json.state data.employment.state
        json.suburb data.employment.suburb
        json.address data.employment.address
        json.post_code data.employment.post_code
        json.reference do
          if data.employment.reference
            json.reference_id data.employment.reference.id
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
          if data.employment.emp_documents
            json.array! data.employment.emp_documents.each do |data|
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
