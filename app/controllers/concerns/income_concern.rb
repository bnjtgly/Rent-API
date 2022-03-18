# frozen_string_literal: true

module IncomeConcern
  def income_summary(incomes)
    income_ref = incomes.joins("INNER JOIN domain_references ON domain_references.id = incomes.income_frequency_id")
    categorized_income = income_ref.group(:value_str).sum(:amount)

    weekly = categorized_income['weekly'] ? categorized_income['weekly'].to_f : 0
    fortnightly = categorized_income['fortnightly'] ? categorized_income['fortnightly'].to_f : 0
    monthly = categorized_income['monthly'] ? categorized_income['monthly'].to_f : 0
    yearly = categorized_income['yearly'] ? categorized_income['yearly'].to_f : 0

    return {
      weekly: weekly(weekly, fortnightly, monthly, yearly),
      monthly: monthly(weekly, fortnightly, monthly, yearly),
      yearly: yearly(weekly, fortnightly, monthly, yearly)
    }
  end

  def weekly(weekly, fortnightly, monthly, yearly)
    weekly_total = weekly * (1.week/1.week)
    fortnightly_total = fortnightly / (2.weeks/1.week)
    monthly_total = monthly / (1.month/1.week)
    yearly_total = yearly / (1.year/1.week)

    [weekly_total, fortnightly_total, monthly_total, yearly_total].sum.round(2)
  end

  def monthly(weekly, fortnightly, monthly, yearly)
    weekly_total = weekly * (1.month/1.week)
    fortnightly_total = fortnightly * (1.month/2.weeks)
    monthly_total = monthly * (1.month/1.month)
    yearly_total = yearly * (1.year/1.month)

    [weekly_total, fortnightly_total, monthly_total, yearly_total].sum.round(2)
  end

  def yearly(weekly, fortnightly, monthly, yearly)
    weekly_total = weekly * (1.year/1.week)
    fortnightly_total = fortnightly * (1.year/2.weeks)
    monthly_total = monthly * (1.year/1.month)
    yearly_total = yearly * (1.year/1.year)

    [weekly_total, fortnightly_total, monthly_total, yearly_total].sum.round(2)
  end
end