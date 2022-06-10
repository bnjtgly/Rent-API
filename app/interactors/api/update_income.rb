# frozen_string_literal: true

module Api
  class UpdateIncome
    include Interactor

    delegate :data, :current_user, to: :context

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
        proof: payload[:proof]
      )
    end

    def validate!
      verify = Api::UpdateIncomeValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        income_id: data[:income_id],
        user_id: current_user.id,
        proof: data[:income][:proof]
      }
    end
  end
end
