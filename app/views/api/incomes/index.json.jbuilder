json.data do
  json.incomes do
    json.array! @incomes.each do |data|
      json.income_id data.id
      json.user_id data.user_id
      json.income_source data.ref_income_source.display
      json.income_frequency data.ref_income_frequency.display
      json.amount data.amount
      json.proof data.proof
    end
  end
end