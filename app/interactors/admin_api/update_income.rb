module AdminApi
  class UpdateIncome
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @income = Income.where(id: payload[:income_id]).first

      @income&.update(
        audit_comment: 'Update Income',
        user_id: payload[:user_id],
        income_source_id: payload[:income_source_id],
        income_frequency_id: payload[:income_frequency_id],
        currency_id: payload[:currency_id],
        amount: payload[:amount],
        proof: payload[:proof]
      )
    end

    def validate!
      verify = AdminApi::UpdateIncomeValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        income_id: data[:income_id],
        user_id: data[:income][:user_id],
        income_source_id: data[:income][:income_source_id],
        income_frequency_id: data[:income][:income_frequency_id],
        currency_id: data[:income][:currency_id],
        amount: data[:income][:amount],
        proof: data[:income][:proof]
      }
    end
  end
end
