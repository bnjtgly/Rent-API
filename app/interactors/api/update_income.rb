# frozen_string_literal: true

module Api
  class UpdateIncome
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback; end

    private

    def init
      @income = Income.where(id: payload[:income_id]).first

      context.fail!(error: { income_id: ['Not found.'] }) unless @income
      context.fail!(error: { user: ['You do not have access to edit this record.'] }) unless @income.user_id.eql?(payload[:user_id])
    end

    def build
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
