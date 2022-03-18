# frozen_string_literal: true

module Api
  class IncomesController < ApplicationController
    include IncomeConcern

    before_action :authenticate_user!
    authorize_resource class: Api::IncomesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/incomes
    def index
      pagy, @incomes = pagy(Income.all)

      @incomes = @incomes.where(user_id: current_user.id)

      @total_income = income_summary @incomes

      pagy_headers_merge(pagy)
    end

    # POST /api/incomes
    def create
      interact = Api::CreateIncome.call(data: params, current_user: current_user)

      if interact.success?
        @income = interact.income
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
