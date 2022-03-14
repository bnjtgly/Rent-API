module Api
  class CreateIncome
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.income&.destroy
    end

    private

    def build
      @income = Income.new(payload)
      Income.transaction do
        @income.save
      end

      context.income = @income
    end

    def validate!
      verify = Api::CreateIncomeValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Income',
        user_id: current_user.id,
        income_source_id: data[:income][:income_source_id],
        income_frequency_id: data[:income][:income_frequency_id],
        currency_id: data[:income][:currency_id],
        amount: data[:income][:amount],
        proof: data[:income][:proof]
      }
    end
  end
end
