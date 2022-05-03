class Api::IncomeService
  attr_accessor :income

  def initialize(income)
    @income = income
  end

  def get_income_summary
    categorized_income = categorize_income

    {
      weekly: weekly(categorized_income[:weekly], categorized_income[:fortnightly], categorized_income[:monthly], categorized_income[:yearly]),
      monthly: monthly(categorized_income[:weekly], categorized_income[:fortnightly], categorized_income[:monthly], categorized_income[:yearly]),
      yearly: yearly(categorized_income[:weekly], categorized_income[:fortnightly], categorized_income[:monthly], categorized_income[:yearly])
    }
  end

  private
  def categorize_income
    categorized = {}
    frequency = @income.joins('INNER JOIN domain_references ON domain_references.id = incomes.income_frequency_id').group(:value_str).sum(:amount)

    categorized[:weekly] = frequency['weekly'] ? frequency['weekly'].to_f : 0
    categorized[:fortnightly] = frequency['fortnightly'] ? frequency['fortnightly'].to_f : 0
    categorized[:monthly] = frequency['monthly'] ? frequency['monthly'].to_f : 0
    categorized[:yearly] = frequency['yearly'] ? frequency['yearly'].to_f : 0

    categorized
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
    yearly_total = yearly / (1.year/1.month)

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
