module PmApi
  class IncomeService
    attr_accessor :resources

    def initialize(resources)
      @resources = resources
    end

    def call
      add_details
    end

    private
    def add_details
      @resources.each do |resource|
        resource[:income] = get_income_summary(resource.user.incomes)[:yearly]
      end
    end

    def get_income_summary(income)
      categorized_income = categorize_income(income)

      {
        yearly: yearly(categorized_income[:weekly], categorized_income[:fortnightly], categorized_income[:monthly], categorized_income[:yearly])
      }
    end

    def categorize_income(income)
      categorized = {}
      frequency = income.joins('INNER JOIN domain_references ON domain_references.id = incomes.income_frequency_id').group(:value_str).sum(:amount)

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
end