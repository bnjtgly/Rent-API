json.data do
  json.array! @incomes.each do |data|
    json.id data.id
    json.user_id data.user_id
    json.income_source data.ref_income_source.display
    json.income_frequency data.ref_income_frequency.display
    json.currency data.ref_currency.display
    json.amount data.amount
    json.proof data.proof
  end
end

json.pagy do
  json.merge! @pagination
end
