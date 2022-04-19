# frozen_string_literal: true

module Api
  class IncomesController < ApplicationController
    include IncomeConcern
    include ProfileConcern

    before_action :authenticate_user!
    authorize_resource class: Api::IncomesController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/incomes
    def index
      pagy, @incomes = pagy(Income.all)

      @incomes = @incomes.where(user_id: current_user.id)
      @profile_completion_percentage = get_profile_completion_percentage[:incomes]
      @total_income = get_income_summary(@incomes)

      pagy_headers_merge(pagy)
    end

    # POST /api/incomes
    def create
      interact = Api::CreateIncome.call(data: params, current_user: current_user)

      if interact.success?
        @income = interact.income
        @profile_completion_percentage = get_profile_completion_percentage[:incomes]
        @total_income = get_income_summary(Income.where(user_id: current_user.id))
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
