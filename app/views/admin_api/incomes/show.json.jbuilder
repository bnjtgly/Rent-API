# frozen_string_literal: true

json.id @income.id
json.user_id @income.user_id
json.income_source @income.ref_income_source.display
json.income_frequency @income.ref_income_frequency.display
json.currency @income.ref_currency.display
json.amount @income.amount
json.proof @income.proof